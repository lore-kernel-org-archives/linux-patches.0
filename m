Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6533A1E92;
	Sat, 17 Oct 2026 17:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258825; cv=none; b=cxCDUcd3icznm0BEpZ7s4s4lP+huCb7oWsFZYhY5E0QnrmlbJANekbabKE1W4bpK3Kb1I9RNzk8+l8ZAG3T6ba/Np82657kwqWlR58LLFQTEOmzOrs2/kFJQ/Yaw75o3iwA6xKmTQ1jIOnVIaiOj0PDt1l3npZM8GJsiFYB8llQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258825; c=relaxed/simple;
	bh=7ONjm31v4++RkYRCamRkORUvI+WrVrSoeLGbZ4kF3e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7PPMcRAdOzMcjm77v5TMFCVcDQg5uJkAfm8tcft2eFJNfCkQKc2hX6j/N/9PKg53litoAKvRD5ju7FXH+2a3ML1CqiO/k+N8bohbaEXx7e1h9rKt7+vxqbgIcO4z51OdpXWReuh9ymbET+9PNeaumPTNiNeqnS6bGkaT/V03B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kasd3x1/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kasd3x1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FD41F000C4;
	Sat, 17 Oct 2026 17:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258824;
	bh=1Pq1HlcW0Mxywfe6QBno1SKeGbEMl/C0x5HVToFfVXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kasd3x1/iGlk0GZ6SJoXTJn+trs+5X/vfqbaskWHvysnn+u7MRI85zaqx+p8m3+bv
	 nHiR/UAxsycIFeJf7R1uZ+aaLSk0J0f+FpR6OsHGI4RCNaGb9Wt6IKJeEG67Sb3Obc
	 /I2hM43L04C6CNsSY4WRlKxfvJCGyKVO5KnO8DnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1010/1674] nvmem: Move of_nvmem_layout_get_container() in another header
Date: Sat, 17 Oct 2026 17:54:42 +0200
Message-ID: <20261017160457.056389649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 4a1a40233b4a9fc159a5c7a27dc34c5c7bc5be55 ]

nvmem-consumer.h is included by consumer devices, extracting data from
NVMEM devices whereas nvmem-provider.h is included by devices providing
NVMEM content.

The only users of of_nvmem_layout_get_container() outside of the core
are layout drivers, so better move its prototype to nvmem-provider.h.

While we do so, we also move the kdoc associated with the function to
the header rather than the .c file.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20231215111536.316972-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 5b6b6fc49189 ("nvmem: core: fix use-after-free bugs in error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c           |  8 --------
 include/linux/nvmem-consumer.h |  7 -------
 include/linux/nvmem-provider.h | 21 +++++++++++++++++++++
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 5b819bbd451af..a4ae058ea12c5 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -838,14 +838,6 @@ static int nvmem_add_cells_from_layout(struct nvmem_device *nvmem)
 }
 
 #if IS_ENABLED(CONFIG_OF)
-/**
- * of_nvmem_layout_get_container() - Get OF node to layout container.
- *
- * @nvmem: nvmem device.
- *
- * Return: a node pointer with refcount incremented or NULL if no
- * container exists. Use of_node_put() on it when done.
- */
 struct device_node *of_nvmem_layout_get_container(struct nvmem_device *nvmem)
 {
 	return of_get_child_by_name(nvmem->dev.of_node, "nvmem-layout");
diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
index 526025561df19..39959d9d4465e 100644
--- a/include/linux/nvmem-consumer.h
+++ b/include/linux/nvmem-consumer.h
@@ -242,7 +242,6 @@ struct nvmem_cell *of_nvmem_cell_get(struct device_node *np,
 				     const char *id);
 struct nvmem_device *of_nvmem_device_get(struct device_node *np,
 					 const char *name);
-struct device_node *of_nvmem_layout_get_container(struct nvmem_device *nvmem);
 #else
 static inline struct nvmem_cell *of_nvmem_cell_get(struct device_node *np,
 						   const char *id)
@@ -255,12 +254,6 @@ static inline struct nvmem_device *of_nvmem_device_get(struct device_node *np,
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
-
-static inline struct device_node *
-of_nvmem_layout_get_container(struct nvmem_device *nvmem)
-{
-	return NULL;
-}
 #endif /* CONFIG_NVMEM && CONFIG_OF */
 
 #endif  /* ifndef _LINUX_NVMEM_CONSUMER_H */
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index 9a015e4d428cc..f00fc4949abef 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -243,6 +243,27 @@ nvmem_layout_get_match_data(struct nvmem_device *nvmem,
 
 #endif /* CONFIG_NVMEM */
 
+#if IS_ENABLED(CONFIG_NVMEM) && IS_ENABLED(CONFIG_OF)
+
+/**
+ * of_nvmem_layout_get_container() - Get OF node of layout container
+ *
+ * @nvmem: nvmem device
+ *
+ * Return: a node pointer with refcount incremented or NULL if no
+ * container exists. Use of_node_put() on it when done.
+ */
+struct device_node *of_nvmem_layout_get_container(struct nvmem_device *nvmem);
+
+#else  /* CONFIG_NVMEM && CONFIG_OF */
+
+static inline struct device_node *of_nvmem_layout_get_container(struct nvmem_device *nvmem)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_NVMEM && CONFIG_OF */
+
 #define module_nvmem_layout_driver(__layout_driver)		\
 	module_driver(__layout_driver, nvmem_layout_register,	\
 		      nvmem_layout_unregister)
-- 
2.53.0



