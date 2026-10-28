Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212064;
	b=NSTlGuJkWc1+fAY9/0AFgwS2OlkBsMNkhC6JsyI6YzABjr2JUkApa2Wuy9Yh+lkThwQF
	 DNxUutYQSVKQRqluaCqyWL8q3gWWhwbX3YRZdzGfnyyxL+dPkV00BjpbN2qowodbXBa8S
	 Ax2Dc3Pccqi+2NYGCYTihWOYOnO4HAHqeKtxPOnlHE1/ecCqo2AYiaQmCrS5M9eRIaaOy
	 4HhlMcrhSHfz07Hn7mH3wmFbhjppNHIfnge97aVBo6GehKwgko+b6kq8W4Ju/e9MZGwkF
	 Kp3ZFcIPc1zh9Iq/r1dH85q3afY4YaUZDQIGHAOODgNk6JA4eRFEtYuLx+W0buw793w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wphXUlR+/CkGv/b0xt8hL/5FH8Z9ZgvhT4u3t4DGNsM=;
	b=HH/zuNnmrllmhg41FIelzVkr+Zfs69Ji3moiI5wxfHArcgC8WvBk70Vg+4h4NVNnM/YJ
	 zGp6zlhbTkUH8X2RLdAWHjMQXVCpMgzLyIHaYE5XelsyAR4LlGtMH0p+j0gHnW8E5/s4v
	 9SlthmGwsphaJlDBa72F3Et9XY+cO0JYUl4M9feTWFodKh+Ubafbay8lU4Mk5biRpkZXF
	 bs0fKOLQPuwctLMkoFdZWKrcQXvDEQJ2yWwZFGORXA65Nqz5qTaGbCABlxEnxuoRAltF2
	 6DHfdWZT7nUIzl+sStZ9r3b9dIUz6DJuAInAHHPBCfCAFN97km43KeW6IQTl8IEmBgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tCCR+JSW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94949606A31E;
	Wed, 28 Oct 2026 18:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tCCR+JSW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62AA1F031E3;
	Wed, 28 Oct 2026 18:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212064;
	bh=wphXUlR+/CkGv/b0xt8hL/5FH8Z9ZgvhT4u3t4DGNsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tCCR+JSWVxXzQ9MeuMLBs3CPyIBJtMURjBI++3IjoLUTYYJtLp9Ks+OpjzLd3OAIr
	 IvbKdGQynv/EG99ZA6IC7XRyHu2yIqnZ9c9e4xL97OqkN0WH2n56XXTGUBfkOIPgBC
	 vbbvMK/84H95VSqcEXk37yApl0VlWuwIruBSbkr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0026/1887] ceph: bound copied dentry name length in NFS export get_name
Date: Wed, 28 Oct 2026 17:35:22 +0100
Message-ID: <20261028170459.821531102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
index 23b945320c554..c2d3ca5417e9c 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -433,6 +433,16 @@ static struct dentry *ceph_fh_to_parent(struct super_block *sb,
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
@@ -498,9 +508,8 @@ static int __get_snap_name(struct dentry *parent, char *name,
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
@@ -562,8 +571,12 @@ static int ceph_get_name(struct dentry *parent, char *name,
 
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



