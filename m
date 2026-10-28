Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208192;
	b=MOaw1doYud58EAVh6WCH2MpfndCCMD7Vm92GTm6YWMpcpeJdwmIArOxsAC5NCFvgiNm3
	 jwDmqKp9bav3cSJ3xt7E8b3BINyzwrNK5EEopkJCOdXgSNs1Oe5kbqWaHnlsylhmrRQmU
	 MjJ9H167Po2Auiob+P+nyJ7Hh+SaXjqZ3q1N9qsN55/V5X7pQPVLpMf+Yqf7AJRgGjdgd
	 EVwCj3KI45MowXNrW7iIMAJZ3MutwwHEZOiqija07FMjiLXR+lMqUAoJkSq6cZSipSJAL
	 aTrTdRc2T5qxk20Oy5B1GRCvXzSfnWfjbE4q5NhQO1N1rIabV1wXzxsgYsTmu0dg3Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K/HvvRSrv9zgpmRx6cgf3JVkDI0HnLhdPzLHlt+vgNk=;
	b=jX1pcAf8rQeYqX0tEgViE7fC6ah18T1KHp7BVO8arJB3FG8HDPYWd/4w5z4qdwkSL9s4
	 NORRss0QkNdYQw66zXsaDH65g80VWHM22J4TQv3Nt9/NIpgmcNxLX3rh3gr85jhT1a6Ln
	 bHWf/WR3kICOgvXJCw0Fy4UV24KBD8ccBuFoo7S9emJ3hfQTkYN+Hwriaf0sZMO5mp26J
	 NmqhQuANOL2kE5ERcTm1qsMDYkfyoTUr4qDpDc+qj0hMwSeuypynHd32kwmPafz6GwAjX
	 d6L21ovw4tXEjsBDttd1dlFqprhXWc9JRLeLUIq+cBFbyjq5RO+YHBWCOeU4L3eEN3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zl7jw2vK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A1B606A31E;
	Wed, 28 Oct 2026 17:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zl7jw2vK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABFE1F01825;
	Wed, 28 Oct 2026 17:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208192;
	bh=K/HvvRSrv9zgpmRx6cgf3JVkDI0HnLhdPzLHlt+vgNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zl7jw2vKME3IzmHI/E2/x7NuQnv86r95S0AUNNn20XShwPLF4TlngJJ/NG7esgP/t
	 TdAIS7V+EsQviEzM99eVCtQDOesvSfPn44PqWbKyZMFmrIeTjR9ujM5OE7cI7daQKK
	 PnRGQ/paP0sHCZosYVAJpdpQPFH/+tNrhj/B09Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/516] ceph: bound copied dentry name length in NFS export get_name
Date: Wed, 28 Oct 2026 17:52:38 +0100
Message-ID: <20261028170003.676520927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit eff8013c5a8916613c742ae5a2cc341cb605c0ae ]

ceph_get_name() copies the MDS-supplied name into the caller's
NAME_MAX-sized buffer with memcpy(name, rinfo->dname, rinfo->dname_len)
and then writes name[rinfo->dname_len] = 0, without checking dname_len
against NAME_MAX. A malicious or buggy MDS that returns a LOOKUPNAME reply
with dname_len > NAME_MAX overflows the buffer. __get_snap_name() copies
rde->name / rde->name_len the same unchecked way.

Impact: a malicious or compromised Ceph MDS overflows the NAME_MAX name
buffer in a client's NFS-export get_name path, a slab out-of-bounds write
reported by KASAN. Reachable when a CephFS mount is re-exported over NFS.

Add ceph_export_copy_name(), which rejects lengths above NAME_MAX with
-ENAMETOOLONG before the copy, and use it in both ceph_get_name() and
__get_snap_name().

Cc: stable@vger.kernel.org
Fixes: 19913b4eac4a ("ceph: add get_name() NFS export callback")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ adapted the bounds check to the older ceph_get_name() flow without encrypted-name handling. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/export.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 66d8afdd417d1..f68fbc152441f 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -421,6 +421,16 @@ static struct dentry *ceph_fh_to_parent(struct super_block *sb,
 	return dentry;
 }
 
+static int ceph_export_copy_name(char *name, const char *src, u32 len)
+{
+	if (len > NAME_MAX)
+		return -ENAMETOOLONG;
+
+	memcpy(name, src, len);
+	name[len] = '\0';
+	return 0;
+}
+
 static int __get_snap_name(struct dentry *parent, char *name,
 			   struct dentry *child)
 {
@@ -486,9 +496,8 @@ static int __get_snap_name(struct dentry *parent, char *name,
 			BUG_ON(!rde->inode.in);
 			if (ceph_snap(inode) ==
 			    le64_to_cpu(rde->inode.in->snapid)) {
-				memcpy(name, rde->name, rde->name_len);
-				name[rde->name_len] = '\0';
-				err = 0;
+				err = ceph_export_copy_name(name, rde->name,
+							    rde->name_len);
 				goto out;
 			}
 		}
@@ -549,8 +558,12 @@ static int ceph_get_name(struct dentry *parent, char *name,
 
 	if (!err) {
 		struct ceph_mds_reply_info_parsed *rinfo = &req->r_reply_info;
-		memcpy(name, rinfo->dname, rinfo->dname_len);
-		name[rinfo->dname_len] = 0;
+
+		err = ceph_export_copy_name(name, rinfo->dname,
+					    rinfo->dname_len);
+	}
+
+	if (!err) {
 		dout("get_name %p ino %llx.%llx name %s\n",
 		     child, ceph_vinop(inode), name);
 	} else {
-- 
2.53.0



