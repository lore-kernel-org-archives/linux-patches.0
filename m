Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065434;
	b=u6gnUaXn8eiueCSq3FoYiaR/qcq/Yfz18/RWEndwUJ0PNzuFNzBxaRAkOcpRCgj/zdwi
	 j2J9/MVN3NSuHdHXEIP4OWdiBMQSgTnnvRxRhYQVidgAtKDpC0S+AtOCWy1oFWZauDruJ
	 dcdK47/m2twxv0w/s0vGIcYtb++/99N+jVIVHC4XKM5hu7Xgp2M4U+4Qru1/GPQWYrZu4
	 p9f8gOWmU66QJat5oAylJPNvB9lmIcnP1I0VigXgJoiHezX1TJO5+xsbiH3m6kl60NfOf
	 oZpohZLRYtn6Ca1jvZN1ZZ+ENSPQhOXJfpME/IV0nqLGOQ1Z3D7pz8WhsZYDg3E+xlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=932IyNsNxdDNTkqRrRVoUzt4CxcFIaEmjkOIhEUCwj8=;
	b=br85UygKWOHauGpHCeLMcirqSMAeNIncMh6xCRql2tY4HWp/+Vod6qxhBRG+P4Dbnybg
	 kFsdQg93z1Og/8pYRhG01jUdTOqcIe0QsIXO2OwOxV+d1lxJ9pe62EOD+l8zMVW+ccIXH
	 PpFWbE68oW1FYIYNJPPPLDY95Oo6Qbn1LWpeCAGEvHpYVfMER+IHqukbo80+CQ49W56Bp
	 hxHX26+ZmXBYbTqowA0BKNQm2xNGbevtEF3Un6MPQaEiM7r2DNIbYq9fbOtiw+EncEg5Q
	 m9oChJMVDwq66LTc5Vvkz/28K3VT/Xq+EjAuv19wFlG0tk5zxq0Qck/e3SSAvbdmkEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AwYTsm6R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C27A606A33D;
	Sat,  7 Nov 2026 15:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AwYTsm6R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0321F0089F;
	Sat,  7 Nov 2026 15:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065434;
	bh=932IyNsNxdDNTkqRrRVoUzt4CxcFIaEmjkOIhEUCwj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwYTsm6Rdl2cJmBEaVjajrskG2ZkwJmvNFDPA5aIAsO2qt+2R/ruLLTcm7AASRCnI
	 EwFTklIOdZHgiJXfq1x38L+A9UtdyeE4na6GZ2D1mO+0oTIcKrUcPhqNtuY4mJyGMq
	 E+A8+ZAlzBbaO5PjW8Y4d3Cc96m+Qv9IJHyY13aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Hothi <ravi.hothi@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1142/1257] ASoC: qcom: audioreach: fix module cfg blob size handling
Date: Sat,  7 Nov 2026 08:57:18 -0500
Message-ID: <20261107135010.763825555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/topology.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/topology.c b/sound/soc/qcom/qdsp6/topology.c
index faafbc5c0ad00..612d8f03e6e98 100644
--- a/sound/soc/qcom/qdsp6/topology.c
+++ b/sound/soc/qcom/qdsp6/topology.c
@@ -312,22 +312,37 @@ audioreach_get_module_priv_data(const struct snd_soc_tplg_private *private)
 
 	for (sz = 0; sz < le32_to_cpu(private->size); ) {
 		const struct snd_soc_tplg_vendor_array *mod_array;
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
 
-			pdata = kzalloc_flex(*pdata, data,
-					     le32_to_cpu(mod_array->size));
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



