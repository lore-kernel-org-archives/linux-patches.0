Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E8C4AA038;
	Mon, 31 Aug 2026 13:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184002; cv=none; b=DxAw4Iv2g2KxxFD+Jm7Yxo3ZCzNXYo09RU4DkXAiovE6H4XTOvit6COYLU02JgeKBko1PZsCT8nDq/LEPOboFISiHDkN81Sp1kKGQj12M2dL6uYv2rvGWdih7iH0mb0Vp250r8U6bDsHVkAQ1U+Y2pkjb/l5avE2mn+Vcl0uNrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184002; c=relaxed/simple;
	bh=lQ2ms6oxAzmpx+c1DfE469D4Wxy107nfn4ccdZRFfJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T9uFVE7ZPciEbQgCC4eEwGmwv5zW+a/99p2tMgBeO8iYDy3sSKSx9b71Qy9fVTq9BjpG+7FspoELg7NuIuYS26YkBeNz0T78dp8QeWBcQUZb9C+3ZdleDyDIu32FAppJkkfPh1QEHyj5NnRdlF+MdcwdosbABvpJugIi9CsrSq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUYxHbPX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUYxHbPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED75B1F0155B;
	Mon, 31 Aug 2026 13:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183999;
	bh=oJvFoIVyuv97aCFAQZ1t5wvbEYyXgILXj90aBzU77XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUYxHbPXR+Pzmy0hXER8ZD9xTzmrzXypX3XjN8GRcPrpxTMtWd/iWa/5cba79tu+f
	 gfyiATwL/6c3uYkC5QDLN/fgnFcqpFwkGzGv1jWRDtaaD2u2YCuK/kblNsVAxx1ae2
	 bnW2X6p+jfr0NJM5wmZ7RGpNwjkvqut8GRbjJX2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 09/83] selinux: use u16 for security classes
Date: Mon, 31 Aug 2026 15:33:45 +0200
Message-ID: <20260831133359.648617096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

[ Upstream commit fa79a596848fe38c55ccab8832ac35dac07fb00c ]

Security class identifiers are limited to 2^16, thus use the appropriate
type u16 consistently.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
(cherry picked from commit fa79a596848fe38c55ccab8832ac35dac07fb00c)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/policydb.c |  5 +++--
 security/selinux/ss/policydb.h | 10 +++++-----
 security/selinux/ss/services.c |  2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 69c19ef4b8817..4c3cc98f87752 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -951,7 +951,7 @@ int policydb_load_isids(struct policydb *p, struct sidtab *s)
 	return 0;
 }
 
-int policydb_class_isvalid(struct policydb *p, unsigned int class)
+int policydb_class_isvalid(struct policydb *p, u16 class)
 {
 	if (!class || class > p->p_classes.nprim)
 		return 0;
@@ -2039,7 +2039,8 @@ static int filename_trans_read_helper(struct policydb *p, struct policy_file *fp
 	struct filename_trans_key *ft = NULL;
 	struct filename_trans_datum **dst, *datum, *first = NULL;
 	char *name = NULL;
-	u32 len, ttype, tclass, ndatum, i;
+	u32 len, ttype, ndatum, i;
+	u16 tclass;
 	__le32 buf[3];
 	int rc;
 
diff --git a/security/selinux/ss/policydb.h b/security/selinux/ss/policydb.h
index 89a180b1742fb..a49275d1168d8 100644
--- a/security/selinux/ss/policydb.h
+++ b/security/selinux/ss/policydb.h
@@ -48,7 +48,7 @@ struct common_datum {
 
 /* Class attributes */
 struct class_datum {
-	u32 value; /* class value */
+	u16 value; /* class value */
 	char *comkey; /* common name */
 	struct common_datum *comdatum; /* common datum */
 	struct symtab permissions; /* class-specific permission symbol table */
@@ -82,7 +82,7 @@ struct role_datum {
 struct role_trans_key {
 	u32 role; /* current role */
 	u32 type; /* program executable type, or new object type */
-	u32 tclass; /* process class, or new object class */
+	u16 tclass; /* process class, or new object class */
 };
 
 struct role_trans_datum {
@@ -139,7 +139,7 @@ struct cat_datum {
 struct range_trans {
 	u32 source_type;
 	u32 target_type;
-	u32 target_class;
+	u16 target_class;
 };
 
 /* Boolean data type */
@@ -195,7 +195,7 @@ struct ocontext {
 		} ibendport;
 	} u;
 	union {
-		u32 sclass; /* security class for genfs */
+		u16 sclass; /* security class for genfs */
 		u32 behavior; /* labeling behavior for fs_use */
 	} v;
 	struct context context[2]; /* security context(s) */
@@ -322,7 +322,7 @@ struct policy_file {
 extern void policydb_destroy(struct policydb *p);
 extern int policydb_load_isids(struct policydb *p, struct sidtab *s);
 extern int policydb_context_isvalid(struct policydb *p, struct context *c);
-extern int policydb_class_isvalid(struct policydb *p, unsigned int class);
+extern int policydb_class_isvalid(struct policydb *p, u16 class);
 extern int policydb_type_isvalid(struct policydb *p, unsigned int type);
 extern int policydb_role_isvalid(struct policydb *p, unsigned int role);
 extern int policydb_read(struct policydb *p, struct policy_file *fp);
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 82608b34260fd..cbc101b095a30 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -3290,7 +3290,7 @@ static int get_classes_callback(void *k, void *d, void *args)
 {
 	struct class_datum *datum = d;
 	char *name = k, **classes = args;
-	u32 value = datum->value - 1;
+	u16 value = datum->value - 1;
 
 	classes[value] = kstrdup(name, GFP_ATOMIC);
 	if (!classes[value])
-- 
2.53.0



