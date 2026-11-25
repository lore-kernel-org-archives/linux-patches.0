Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620165;
	b=j4U6g/Ul1UPoVUO2LOh+WixWOjLwI9XaeAo1AMPK2AsV62w3vwDWUyTT4pu9c9N66U/m
	 VXKkcQyOq2t+sPfx0Neerno6LLPwwAqkyOVW+F73LiRk1k91xny2wQ1qW8SJExSbm104i
	 l6IqI98NkvphAHfyvux54Xe62NpCa09HLexdXR39tdbilbtl6FylccPw6jb+gh/YWvVG0
	 Q1a7xD7GrMYB+CY4kgnOieL8Dp7eCHF2Qqkv4NyhECIlRxBdQod4w2JefBtyi7BI8ezlT
	 Q36Da9vcit+G17RmhrPyvVHb9l7F6ODeXHlOO7CRnYl+FXjpBxH5aXsJQh5TOjCzYrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EO2mtn2xc8k6OI9Mbs0oIWQ+soo7r2pkWpH9isF0P8U=;
	b=oRrOp8mHMqEYh/wpyXlf1OJSLMfUPgrLkEpeasOxoLxp+bBAddmW/LCgCho1TmFBBpcv
	 KNyIxWTPeAvbcolCjHWznIlCeN1si6a2wEBco73vKcJqNJavfMCHdP3IoWwgYPljdd8rC
	 u9wnTvL1fwvRDaNW1F3BaMvDsyqdvpHIEBCUM3DuJeh5IR09UQgzYlQxhsvVSKnQo7qwj
	 rdBRzpTnbqjQSmS2REDbnXJjcZB+at5zL5q2UgMvUxKXWnh52ekFHTX62rrRiWk7roCuO
	 3g2AUqSv64jyQp18nVWlaR8aWUBtGeb7GMQPqE8KEpBs+mdeARP4HVO6wczNaM1HY3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCfHOFWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E1C606A688;
	Wed, 25 Nov 2026 15:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCfHOFWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F68A1F000C4;
	Wed, 25 Nov 2026 15:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620165;
	bh=EO2mtn2xc8k6OI9Mbs0oIWQ+soo7r2pkWpH9isF0P8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCfHOFWibH6pIviWcv375GWL5g2FQEUg1hFpfhnt/4jiO5LcNcs3Uoz2lwZktd9nL
	 LMyCk5KuI+eMtXruRGW9lxNHFqMN3QiydYwgUKVM/rsMMWv5UYdkEyuPWC8KbJ1Qky
	 l30imRlS9orGHjHKWTP9R/IkV1akPxE7kktVXwDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Daejun Park <daejun7.park@samsung.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 0828/1005] ovl: bump the impure dir version when linking a file with origin
Date: Wed, 25 Nov 2026 15:36:06 +0100
Message-ID: <20261125143841.117736848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

commit 86e2facd8630cc2fdec6ea80c53e370b26b441d9 upstream.

Linking a file with copy up origin into a non-merge impure dir does
not bump the dir version. readdir then reuses the impure dir cache
built before the link. It reports the upper inode number as d_ino of
the new link, not st_ino.

Pass whether the linked file has an origin to ovl_dir_modified(), as
rename and unlink do.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-98f207b6-3936-48e9-a40f-88f20be4db7b
Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -368,7 +368,7 @@ static bool ovl_type_origin(struct dentr
 }
 
 static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
-			    struct ovl_cattr *attr)
+			    struct ovl_cattr *attr, bool origin)
 {
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
@@ -393,7 +393,7 @@ static int ovl_create_upper(struct dentr
 		ovl_set_opaque(dentry, newdentry);
 	}
 
-	ovl_dir_modified(dentry->d_parent, false);
+	ovl_dir_modified(dentry->d_parent, origin);
 	err = ovl_instantiate(dentry, inode, newdentry, !!attr->hardlink, NULL);
 	if (err)
 		goto out_cleanup;
@@ -491,7 +491,7 @@ static int ovl_set_upper_acl(struct ovl_
 }
 
 static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
-				    struct ovl_cattr *cattr)
+				    struct ovl_cattr *cattr, bool origin)
 {
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *workdir = ovl_workdir(dentry);
@@ -582,7 +582,7 @@ static int ovl_create_over_whiteout(stru
 		if (err)
 			goto out_cleanup_unlocked;
 	}
-	ovl_dir_modified(dentry->d_parent, false);
+	ovl_dir_modified(dentry->d_parent, origin);
 	err = ovl_instantiate(dentry, inode, newdentry, hardlink, NULL);
 	if (err) {
 		ovl_cleanup(ofs, upperdir, newdentry);
@@ -647,12 +647,12 @@ DEFINE_CLASS(ovl_override_creator_creds,
 
 static int ovl_create_handle_whiteouts(struct dentry *dentry,
 				       struct inode *inode,
-				       struct ovl_cattr *attr)
+				       struct ovl_cattr *attr, bool origin)
 {
 	if (!ovl_dentry_is_whiteout(dentry))
-		return ovl_create_upper(dentry, inode, attr);
+		return ovl_create_upper(dentry, inode, attr, origin);
 
-	return ovl_create_over_whiteout(dentry, inode, attr);
+	return ovl_create_over_whiteout(dentry, inode, attr, origin);
 }
 
 static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
@@ -687,12 +687,14 @@ static int ovl_create_or_link(struct den
 		 */
 
 		if (attr->hardlink)
-			return ovl_create_handle_whiteouts(dentry, inode, attr);
+			return ovl_create_handle_whiteouts(dentry, inode, attr,
+							   origin);
 
 		scoped_class(ovl_override_creator_creds, cred, original_creds, dentry, inode, attr->mode) {
 			if (IS_ERR(cred))
 				return PTR_ERR(cred);
-			return ovl_create_handle_whiteouts(dentry, inode, attr);
+			return ovl_create_handle_whiteouts(dentry, inode, attr,
+							   origin);
 		}
 	}
 	return err;


