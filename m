Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029032;
	b=c6UoIayhDRq9mL5KsXg/N6nuNAulVV/G4L2K531w//hQekEUEIsJ4VFzB3OueMi+ve/H
	 7LFnW4Gtem+viX+/AHg9QO1ZYfl94D9T9ZspbGskzax/b9sZSn9jUeql42vAWxClXtyU9
	 VQMONQJMBYgf84JhB9JuwngI/KJRRffW/LtTsWRGvOrZ/fObSFzYMNvtRs4y53ysPJK4C
	 gDbFcPlQkQXKabDlVDMEWmKpxsj/2REIGrHonuw7EoKhlHZeG0WAfa8AaJgBJGPG+dZP/
	 LxpV8qUsqeWS8+R4DsGIZw1Pp5yb4vRebrzpGsXaktGBIS+j06rh/WsjJp5gYMle6UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eaQGNCHRheLMhioyV3RHB5jw9cGFpTECgIcdOq29Ef8=;
	b=L2ZZI8DtdB3tGi8xxs/Etw+A041C5wImaP07peXg2HLwA7HctszvT01af3ywA3xgO2vo
	 3ug5uTcf1ktR4nDGWscxUNWggzR8Xpnii8N5Y6gc2Gc2mzAg7TW3bW2oaw4oj4dzRB7ge
	 qFZNL31kDIhmUKTA+D7QDHg6ef+ohMSBW/+MaTztVRGBWHuNs8R5u9Kkx0P6Pzw1bR02y
	 jYr5ZzW+tBXssA0w539veuo9O2w2V/EfOAyY4jK/FSH0mZ3CPv960gwQBmdyJHXqSVo90
	 DrLGs4dijGA8ah1oYe3WjvF9jrp9hj7qgVsIyD8yBfm+QKeuUY0p9h/mQ6TySzp+z6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DSSmcm81;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31CD606A32C;
	Wed, 18 Nov 2026 19:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DSSmcm81
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184961F000C4;
	Wed, 18 Nov 2026 19:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029032;
	bh=eaQGNCHRheLMhioyV3RHB5jw9cGFpTECgIcdOq29Ef8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DSSmcm81/8CK19LqSb/NAuJnJf4YHOVhckvZz6YXBC+aPzNYQXvr5C9wu/MiDckB5
	 FvrvLxd0W4swYuLGE7yPa78AcUrhMza+vKsqJXw5Chtm1EGIJXz2fYUyhVUS0KvLjl
	 RxLlYGu9kpB49VHDOE1eXOmbd3PVifNXYHU5f4Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0204/1756] dlm: fix variable key length lookup
Date: Wed, 18 Nov 2026 15:38:51 +0100
Message-ID: <20261118150016.485288838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit b4e6ae7ba711758c38d5eb7d5a7a0712273bdf6f ]

Before commit 6c648035cbe7 ("dlm: switch to use rhashtable for rsbs")
the rsb hashtable was dynamic key length. Accidentally it was changed to
switch to static key length which can end in different results. We
fixing this back to the original behaviour by adding the necessary
functionality to rhashtable to handle the objects and lookups as dynamic
key lengths.

Fixes: 6c648035cbe7 ("dlm: switch to use rhashtable for rsbs")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/config.c       | 30 ++++++++++++++++++++++++++++--
 fs/dlm/dlm_internal.h |  5 +++++
 fs/dlm/lock.c         |  6 ++++--
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index eac96f1c1d742..a523df1a1a735 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -63,11 +63,37 @@ static void release_node(struct config_item *);
 static struct configfs_attribute *comm_attrs[];
 static struct configfs_attribute *node_attrs[];
 
+static u32 rsb_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct dlm_rsb_key *key = data;
+
+	return jhash(key->name, key->len, 0);
+}
+
+static u32 rsb_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct dlm_rsb *r = data;
+
+	return r->res_hash;
+}
+
+static int rsb_obj_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
+{
+	const struct dlm_rsb_key *key = arg->key;
+	const struct dlm_rsb *r = obj;
+
+	if (key->len != r->res_length)
+		return -1;
+
+	return memcmp(&r->res_name, key->name, key->len);
+}
+
 const struct rhashtable_params dlm_rhash_rsb_params = {
 	.nelem_hint = 3, /* start small */
-	.key_len = DLM_RESNAME_MAXLEN,
-	.key_offset = offsetof(struct dlm_rsb, res_name),
 	.head_offset = offsetof(struct dlm_rsb, res_node),
+	.hashfn = rsb_hashfn,
+	.obj_hashfn = rsb_obj_hashfn,
+	.obj_cmpfn = rsb_obj_cmpfn,
 	.automatic_shrinking = true,
 };
 
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index d534a4bc162bb..08b903fbce589 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -340,6 +340,11 @@ struct dlm_rsb {
 	char			res_name[DLM_RESNAME_MAXLEN+1];
 };
 
+struct dlm_rsb_key {
+	char name[DLM_RESNAME_MAXLEN];
+	size_t len;
+};
+
 /* dlm_master_lookup() flags */
 
 #define DLM_LU_RECOVER_DIR	1
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 431534e956f0e..74af60296e099 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -625,12 +625,14 @@ static int get_rsb_struct(struct dlm_ls *ls, const void *name, int len,
 int dlm_search_rsb_tree(struct rhashtable *rhash, const void *name,
 			unsigned int len, struct dlm_rsb **r_ret)
 {
-	char key[DLM_RESNAME_MAXLEN] = {};
+	struct dlm_rsb_key key = {
+		.len = len,
+	};
 
 	if (len > DLM_RESNAME_MAXLEN)
 		return -EINVAL;
 
-	memcpy(key, name, len);
+	memcpy(key.name, name, len);
 	*r_ret = rhashtable_lookup_fast(rhash, &key, dlm_rhash_rsb_params);
 	if (*r_ret)
 		return 0;
-- 
2.53.0



