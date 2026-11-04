Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831340;
	b=Bp9dd42eHLHGIQIKcdwdf2/MMGT7C0235YN3EfFs10jZnkXFqSvZzLr7GEEFrBRg2QbX
	 OmQGZvk5ahDbwS6p0+EpakSChZv+VMSPsv1/d4N14M5d3/d79zPNEzKkuUu8CUjRp5WMu
	 IZ1746xFaCgZl/CP7tnT459DJb1GXecbdquF9yD14Wt6jPumUCRMpLSYJ7pP4hCoRJ+B4
	 Z7+wgj/jvb7wjaSMP6ALAHKt1bq7mQQlhWXtD/c50ADSyVJ7L41pviz/p4cl3eBXs5wLG
	 hVbiQg/EnICEhJn52zMsICB4OACYxP+SAwwvKgsH+m+6LfLklGo7SOpkbaa3zR4PF2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=78FaaqSzQg+eKPBb8E+tpJ3zvQFygUeuqxSbnc0/uTw=;
	b=tFSKEIarSEBBYatlg00fYQPv9QDpvLbhmwEfq0wdsNUeRj9bKsr1+avLOgHwJ+9uWtwF
	 4wO1xv0JtA8iUzNak1QOGmwFlUe2hjfJWcSwBgWL3P57TsUnF8aokQ+K11yUvEi7G2q9k
	 jLrGMlzLBlckOeZparANUhgo3czUsOckhUuGiul3BlY+dmaKOONTpfgxUJI+4d8+1a5kc
	 +VpEpPcA04WnlEvdlrwG4jRETL6pSKF8/THvr05dqfAuUgYT15HSi3o09vC+YqL4MbHCC
	 Dj2V4HrmVQrVa4w1xw8r7W5unVMokqkMH1Lp29GcyuarYEXT+546yfPqi7g7mvAdLvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUT8Jl7s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D8B606D839;
	Wed,  4 Nov 2026 22:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUT8Jl7s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E411F000C1;
	Wed,  4 Nov 2026 22:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831339;
	bh=78FaaqSzQg+eKPBb8E+tpJ3zvQFygUeuqxSbnc0/uTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUT8Jl7sD/KE/L/OTV0SRiYMYFVEtynhKYkLg9ZbOeEMEa5O1KFhh0FasfVyHU3Ls
	 Xi6/91TNcDrsWrEGaYOviIE18fcIxG15i/gvyG8nWGMV5ZE6Y48iKLLPhn0nKAKMVn
	 UXrDwRlOsZXdpL+Nen2xauSeZxZbkZSvj050Cccs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 0645/1005] ksmbd: fix parent dentry lifetime in directory enumeration
Date: Wed,  4 Nov 2026 16:06:18 -0500
Message-ID: <20261104211101.809639556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>

commit 171df27077fb49b4af2c53ad2cedcd0e39664fe8 upstream.

ksmbd_populate_dot_dotdot_entries() builds the ".." entry from
the open directory's d_parent and passes that pointer to
ksmbd_vfs_fill_dentry_attrs() without taking a reference. That pointer
is only valid while the directory stays under this parent. If a
concurrent rename moves the directory elsewhere, the old parent loses
its last reference; a following rmdir then turns it into a negative
dentry with d_inode cleared, and after the RCU grace period the dentry
itself is freed. The worker still holds the raw pointer and
dereferences d_inode through vfs_getattr() and vfs_getxattr().

A remote SMB client, authenticated or guest, triggers this by listing
a directory while that directory is moved under a new parent and the
old parent is deleted. It can be done by the client itself with write
access or by other concurrent writers, triggering null-ptr-deref and
slab-use-after-free on a KASAN build.

  KASAN: null-ptr-deref in range
      [0x0000000000000000-0x0000000000000007]
  Workqueue: ksmbd-io handle_ksmbd_work
  RIP: 0010:xattr_permission+0x9d/0x160
  Call Trace:
   vfs_getxattr+0x9c/0x1b0
   ksmbd_vfs_getxattr+0x82/0x100
   ksmbd_vfs_get_dos_attrib_xattr+0x7f/0x130
   ksmbd_vfs_fill_dentry_attrs+0x435/0x650
   ksmbd_populate_dot_dotdot_entries+0x25e/0x630
   smb2_query_dir+0xcf9/0x1a20
   handle_ksmbd_work+0x5f1/0x1c80
   process_one_work+0x90b/0x19d0

Fix by using the dentry reference counting APIs: take the parent with
dget_parent(), take a matching dget() on ".", and dput() the dentry
once ksmbd_vfs_fill_dentry_attrs() has returned or the pattern does
not match.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Cc: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb_common.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -447,16 +447,17 @@ int ksmbd_populate_dot_dotdot_entries(st
 			if (i == 0) {
 				d_info->name = ".";
 				d_info->name_len = 1;
-				dentry = dir->filp->f_path.dentry;
+				dentry = dget(dir->filp->f_path.dentry);
 			} else {
 				d_info->name = "..";
 				d_info->name_len = 2;
-				dentry = dir->filp->f_path.dentry->d_parent;
+				dentry = dget_parent(dir->filp->f_path.dentry);
 			}
 
 			if (!match_pattern(d_info->name, d_info->name_len,
 					   search_pattern)) {
 				dir->dot_dotdot[i] = 1;
+				dput(dentry);
 				continue;
 			}
 
@@ -465,6 +466,7 @@ int ksmbd_populate_dot_dotdot_entries(st
 							 idmap,
 							 dentry,
 							 &ksmbd_kstat);
+			dput(dentry);
 			if (rc)
 				break;
 


