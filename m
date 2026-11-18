Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022461;
	b=rsIhlOeojFKpSx/Rxfem+lbw84maxIo/erp8v0bmF4es9+LIg87wbFd2gr7l1pDpzaMD
	 yiYBpRI62m3TtT9ZOCNxS8oHsINYBPQYsyQCXLKCQA6U5iDmtjsWVaH5Pkzuvq6NLJSZy
	 uPzUzOgoEuIHuLRZbHqsHoYuW3zBLjUVEOSh+tD6acit/jiX2LLtW8fu5PS5P4+eyd74f
	 JZSjrze3T2G5aB6j0P5IP/1ZPLwbx1Ax0JMc47SZU4MuLSwEHLcdmCobSDa2trkANPKKT
	 8zUekRhbIKzCISXUZ7s+8eWwI1/+vCy4909CPCVQ3IAJ1MWHKU4hNhZuZ+WxUYv4gqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A8dczPzrHUYEK+wcWvK1xkd8QIoA+H2IyGDOkdD+zv4=;
	b=H7YaHq6qE7bL5Xayn0vjV9dmsghg24CIIAo3QBYjzErKyKRRTL57rLGkxkkZJ5CC15hI
	 OoDPtoplOygsX2+NFtLAqTvOsdcoSO+ZFWuCnX8xJKN0CeiJ37QAbPL8LbSETr9+/pBvE
	 XcbyDZD17hSLyAEH1um8xPHW1bSfM+5JB6C5L4ub+TjHcyhgCNuClxdR0YPJDJk6qHzGX
	 yi6RGzn4LYyhbgNvIm0e2VL7xVbppdtWMac7ofdE2Stg0AOI9U3643J+mr7I5WsQe1rTQ
	 9ULBRxluidIZDDAp4IFfhiQ746qLv1qgEZ2h8MiNsu7qjFvUoeiqlyRRoCNYymtn6vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zK9sZcsv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723DA606A330;
	Wed, 18 Nov 2026 17:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zK9sZcsv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45831F000C4;
	Wed, 18 Nov 2026 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022461;
	bh=A8dczPzrHUYEK+wcWvK1xkd8QIoA+H2IyGDOkdD+zv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zK9sZcsvtxwII6etnrkoRPwaTpUOLNibRMlFrh9RCgrjGHlYVydYgFCdFkZxDlAwH
	 mofdjnalEdAr+fC0pesaKwU+mZbZGGPjBx7Tbhf7cn8Fzso++ehvrQ3bmTSZmK7VMw
	 L4TrE2Az2zBT8x3j1cjZS8iRKsRjCptLi8ZcDiUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Hothi <ravi.hothi@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0022/2151] ASoC: qcom: audioreach: fix module cfg blob size handling
Date: Wed, 18 Nov 2026 15:29:17 +0100
Message-ID: <20261118150122.460773841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Ravi Hothi <ravi.hothi@oss.qualcomm.com>

[ Upstream commit e21fb64a8c4aecae31ec63f994423ac944705c3e ]

audioreach_get_module_priv_data() passes mod_array->size, a byte count,
as the element count of the __le32 data[] flex array. The allocation and
the copy are four times too large, and the memcpy() can read past the end
of the topology firmware buffer. The size is also never checked against
the private data it must lie within, and a zero size makes the loop spin
forever.

Convert the size to a word count, bound the blob by the remaining private
data and reject a zero size. Also check the returned pointer before
storing it in mod->data, as an error pointer there is dereferenced when
the graph is opened.

Fixes: c7ed4c2debfd ("ASoC: qcom: audioreach: add support for static calibration")
Cc: stable@vger.kernel.org
Signed-off-by: Ravi Hothi <ravi.hothi@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261023171316.819857-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: Adjusted declaration context to retain the existing non-const mod_array pointer. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/topology.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/topology.c b/sound/soc/qcom/qdsp6/topology.c
index f8d3bb83e3b0d..93e40a05920f7 100644
--- a/sound/soc/qcom/qdsp6/topology.c
+++ b/sound/soc/qcom/qdsp6/topology.c
@@ -312,22 +312,37 @@ static struct audioreach_module_priv_data *audioreach_get_module_priv_data(
 
 	for (sz = 0; sz < le32_to_cpu(private->size); ) {
 		struct snd_soc_tplg_vendor_array *mod_array;
+		u32 array_size;
 
 		mod_array = (struct snd_soc_tplg_vendor_array *)((u8 *)private->array + sz);
+		array_size = le32_to_cpu(mod_array->size);
+
 		if (le32_to_cpu(mod_array->type) == SND_SOC_AR_TPLG_MODULE_CFG_TYPE) {
 			struct audioreach_module_priv_data *pdata;
+			u32 nwords;
+
+			/* size is the byte count of the __le32 data[] */
+			nwords = array_size / sizeof(__le32);
+
+			/* the blob must lie within the private data */
+			if (sizeof(*pdata) + (u64)array_size >
+			    le32_to_cpu(private->size) - sz)
+				return ERR_PTR(-EINVAL);
 
-			pdata = kzalloc(struct_size(pdata, data, le32_to_cpu(mod_array->size)),
-				       GFP_KERNEL);
+			pdata = kzalloc_flex(*pdata, data, nwords);
 			if (!pdata)
 				return ERR_PTR(-ENOMEM);
 
-			memcpy(pdata, ((u8 *)private->data + sz), struct_size(pdata, data,
-						le32_to_cpu(mod_array->size)));
+			memcpy(pdata, ((u8 *)private->data + sz),
+			       struct_size(pdata, data, nwords));
 			return pdata;
 		}
 
-		sz = sz + le32_to_cpu(mod_array->size);
+		/* a zero size would never advance the walk */
+		if (!array_size)
+			return ERR_PTR(-EINVAL);
+
+		sz = sz + array_size;
 	}
 
 	return NULL;
@@ -611,6 +626,12 @@ static int audioreach_widget_load_module_common(struct snd_soc_component *compon
 		return mod ? PTR_ERR(mod) : -ENODEV;
 
 	mod->data = audioreach_get_module_priv_data(&tplg_w->priv);
+	if (IS_ERR(mod->data)) {
+		int rc = PTR_ERR(mod->data);
+
+		mod->data = NULL;
+		return rc;
+	}
 
 	dobj = &w->dobj;
 	dobj->private = mod;
-- 
2.53.0



