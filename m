Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015423;
	b=JQDp4Ph6TrxwyDXjsgsXb7H7cQpMhPZsOqsBxEEgIDK3nY8UKVjAysweR20Lb+Q5P+SZ
	 70rr8WJ2Ng1ODyWKzIxvFz8lvPlxdXbaSdq0ICOv/oVAZC1H7Si3eMBUqmbQLrb3aRgyC
	 K1rtQg0tdSpyLq5egJdnHT7b445FI+fyAr7huykjpsxL6NXqmXRVySF/msd14PZPqdSU7
	 jLveqY6GzEQPWeeyZc7B+zh2I2zP5mulFQa2Wy2UhvpBzw/C7lq77qn34r2Y9uEEZTKMN
	 fAxuNlJovXI5zEggrfwHa0VYHtEa/hS0iErCOx1+eMB/g/z5azgl9UXuERF/nlPZ5WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nDeZZrgHxQqOxhf6aW6eRY5mb05hjwoeiWk7K5f6VBw=;
	b=r0XPRJsJMdASlWrwYoQUXGR2VbbHcVEAYPueQF/Yxn2qxZhyq24Hihp2cWNJmjUoh2S9
	 7T2b0GELkCVU15qC8mELcdluHkF94l6gmEEgFLPwj277mOKFimADdlXCnnvDNRdx61Iiv
	 4mS/BDEDK+JS7CBTESRmrQOzWmsESWIINqfSK5vnHvB5Ztumzxqmx54hEQ+w7yRQMbvYm
	 VunFnslB8TUQ5PmyvpRo5KovhYG1jukjclT6YrhZ0hZifDYQMIqIiWjkaSQa4d6P1oAY/
	 IWUPvAnWLBNsHlRE52t1RNhz87JYIXo0LLG32zqNsv/iwH4NOXwtEmXVYq1J7EJoGDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H9w6cxkV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731F060A2603;
	Wed, 18 Nov 2026 15:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H9w6cxkV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B4F1F000C7;
	Wed, 18 Nov 2026 15:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015423;
	bh=nDeZZrgHxQqOxhf6aW6eRY5mb05hjwoeiWk7K5f6VBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9w6cxkVMhfMkiJjDwgcr1QvGdzBq/OFnSW64IZErNWOIqQfzRe+QnFWtC3l1ymop
	 d8mZOHI41mdfBRLBd1xrVVcta4xd8QenkIErSA3X1UJDdnaUxjCjQ9fFeWkcMlAK4R
	 ZXBPuwLkolShHjF4E3LH1pQwZym/biEyVl4r3SlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0169/2651] dlm: fix variable key length lookup
Date: Wed, 18 Nov 2026 15:23:29 +0100
Message-ID: <20261118150253.941738170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 53cd332930423..6c5c3f049b33a 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -64,11 +64,37 @@ static void release_node(struct config_item *);
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
index 9df842421ae06..74c2e77d1b553 100644
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
index d73c4aed1f8ac..2609e4fdeba84 100644
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



