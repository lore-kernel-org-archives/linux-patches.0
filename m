Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044734;
	b=DpgwH7AlDn64C9jEafC0dKIYzxS6qcf8ZfU98mk2UI8Fky3pwYHwmy915vLowxWfPSHe
	 aFfUoreOoo7RBUX6T66XROeNiBknPKRoGUCWONRvbTA4ZcqKU3WOdcSlXuB8aC6vNrleA
	 RgGKn56kmebtTeZ7w2mNSeViDqrB+vDt8vVMPaleMQfD7/zotx9lbFpq1/cgkt6beT5HQ
	 /Y2fMHcRmQn+rYakOnpLtjZDYVeLP88hK9Q0Eg8I4yf8CLdbtZDW4sjtDxzVv6ze2ZDqe
	 AMXucxEE0Q6dH6YfffPWf5vNVrAMps8MPj6PJ6hM0VzsvVOXxSrPqCYVIwNqd1Aupww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tRuvkpCqFV1xbTYyyun4JZluH1bSCxwYH60mfsSbiYc=;
	b=IIz/rIF7bGJPQF5joxv70YPASof9jSMPV+YJYmocv7w9bdoZWFZY53T/AoAaFAI60mU7
	 9CbjLFfBR8ulg9SsulRGMWvoutkKlSykdeyfAGOiNDBg9+8sJqvQ4fyR+BMNxYlYsHuFg
	 /sxyy33xa7d9A0ZaqPF358Tc8vrZTgDSypxb1w1+rvUxN6SfYNLMcnwVz2+IF/pKZtpbE
	 SIU1av4KkzXaYrJtDnUw3XkYoqecI9YaP8GFr18IcFOB4Iq410+Tt8p5nsMEw4/sQQCFJ
	 IH5wdd7QZHoL1+4v1vcV1IMhLMnE7o/Kb7bXSK3IYK7LZpRbZ9Uer5st43E/XuA5EzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Np2q3mAU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89F8606A325;
	Wed, 18 Nov 2026 23:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Np2q3mAU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319FB1F000C4;
	Wed, 18 Nov 2026 23:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044734;
	bh=tRuvkpCqFV1xbTYyyun4JZluH1bSCxwYH60mfsSbiYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Np2q3mAU437Wu3xnElKKe4EJHEOkPOH1DLyfDzLZXiuo8iwDpahg6Eg5aZ2ONzeXM
	 EhVECpMrkNlWnKfaMT6qanDRSPnSQ1oC5DbCtOwmtcgwgAVRZehFmFNT91GbMB+RgP
	 CdOPszOtnx1LZrJlxLi85HgvSbLwtoN2D6mOgAK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0671/2857] ksmbd: fix parent dentry lifetime in directory enumeration
Date: Wed, 18 Nov 2026 15:28:25 +0100
Message-ID: <20261118150225.722044894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>

[ Upstream commit 171df27077fb49b4af2c53ad2cedcd0e39664fe8 ]

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
[ sashal: adjusted context for the existing ksmbd_vfs_fill_dentry_attrs() call using user_ns without a return-value check ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 0350697c9093b..d30547f656ccd 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -447,16 +447,17 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
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
 
@@ -465,6 +466,7 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 						    user_ns,
 						    dentry,
 						    &ksmbd_kstat);
+			dput(dentry);
 			rc = fn(conn, info_level, d_info, &ksmbd_kstat);
 			if (rc)
 				break;
-- 
2.53.0



