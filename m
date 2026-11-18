Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047590;
	b=Zs355PKJGe7omISBwEX0NZDQKhLoYl+/RSbjE7EgY4OsFRubSWCuP18WTs4zc/0cNvcs
	 LqT+hEzL3hcQAU88p5oiT8KaB2qfDLROMOuFyRXrNcZoT2uvBC6FDYsDZaJYRLqXy6VUw
	 5FdZ92SsbLsphImR6Ocd5+7G5/R7uuRjV2vOqAKer1JMuKVr4mQsBodmw21jhrMqiudTU
	 LbLxOnBTAgfpIIFlDf2Tc/i74HrZW1qCaMt9qrd0YGmG372UsgG96BkC0eOQWnIg42Pob
	 iekso1HsMmuc1pqgqusVJWS9DNP6GTQV3nau9pHSVEPW3ll8VMm23iv8ZXP32WpftLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SrlWI4zch4POnxp1FOFUYccmDqLQDAQKytPz/loUJzQ=;
	b=ahxRg/AeQB+YIcwhG4kOkvBycut4Udde+qYa+BxJXyroudtPXqtqaNc1PCfM/cbmwMov
	 T+fysfQIuWbCtt5veEvy7Pm7w7ix0+YPjz7ewfxOhd/by7YLUS8T+yA6CBysti8DINETT
	 aDGSvUkQq2Nhriiuz2LkgDWIhDO+JZpNpcLIuol8PLid3kTSwe0+Iem2pVkGw0GT1K8DH
	 QO7m/LYtamQmFl/JkknAmazTXNVxqIBnNui1VUc2HaB+fp3HL4qh7Vls1o3TTK0dH4Ym5
	 aurxSv7oin4b2D/HVU+zQ+C4p5yWlpydOdqDji0DIp4GsW4Q1NoiqT6FNqdk/U10N/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgRSLH7x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18501606A31C;
	Thu, 19 Nov 2026 00:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgRSLH7x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7F01F000C4;
	Thu, 19 Nov 2026 00:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047590;
	bh=SrlWI4zch4POnxp1FOFUYccmDqLQDAQKytPz/loUJzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pgRSLH7xNG3QFP0RiVEYCvyy/P0zsCIVg8KuGfBMJUyZ84h/wbn/YYlbECFYpw8Qn
	 LDzc3mqOotXv2ouRGJxyX5aqfKGIRNNJT1nvGwgp4b2xhnXQbB6pUDOYmk42jMU+LO
	 GACoQtXmtdVuK7ckQtlGhkVwJPrgcnryW6sCjIDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
	Ratna Deepthi Kudaravalli <rkudarav@qti.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1694/2857] ASoC: qdsp6: audioreach: Add ADSP ready check
Date: Wed, 18 Nov 2026 15:45:28 +0100
Message-ID: <20261118150302.329584918@linuxfoundation.org>
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

From: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>

[ Upstream commit 47bc8cf60e926d1fb0c5d990bf6f5e01e9b3352e ]

Check for SPF readiness in prm driver probe to avoid race conditions
during ADSP pil loading.
This patch is to avoid, sending requests to ADSP before it's
power domains are up and ready.

Signed-off-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Tested-by: Ratna Deepthi Kudaravalli <rkudarav@qti.qualcomm.com>
Link: https://lore.kernel.org/r/1673508617-27410-1-git-send-email-quic_srivasam@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: ef7062864c05 ("ASoC: qcom: q6apm: Guard callbacks until probe data is ready")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm.c | 13 +++++++++++++
 sound/soc/qcom/qdsp6/q6apm.h |  2 ++
 sound/soc/qcom/qdsp6/q6prm.c |  4 ++++
 3 files changed, 19 insertions(+)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index 48488ba2be212..4f9143b903b31 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -27,6 +27,8 @@ struct apm_graph_mgmt_cmd {
 
 #define APM_GRAPH_MGMT_PSIZE(p, n) ALIGN(struct_size(p, sub_graph_id_list, n), 8)
 
+struct q6apm *g_apm;
+
 int q6apm_send_cmd_sync(struct q6apm *apm, struct gpr_pkt *pkt, uint32_t rsp_opcode)
 {
 	gpr_device_t *gdev = apm->gdev;
@@ -143,6 +145,15 @@ static void q6apm_put_audioreach_graph(struct kref *ref)
 	kfree(graph);
 }
 
+bool q6apm_is_adsp_ready(void)
+{
+	if (g_apm && g_apm->state)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(q6apm_is_adsp_ready);
+
 static int q6apm_get_apm_state(struct q6apm *apm)
 {
 	struct gpr_pkt *pkt;
@@ -760,6 +771,8 @@ static int apm_probe(gpr_device_t *gdev)
 
 	idr_init(&apm->modules_idr);
 
+	g_apm = apm;
+
 	q6apm_get_apm_state(apm);
 
 	ret = snd_soc_register_component(dev, &q6apm_audio_component, NULL, 0);
diff --git a/sound/soc/qcom/qdsp6/q6apm.h b/sound/soc/qcom/qdsp6/q6apm.h
index 54eadadf712cb..5b51e155282fd 100644
--- a/sound/soc/qcom/qdsp6/q6apm.h
+++ b/sound/soc/qcom/qdsp6/q6apm.h
@@ -149,4 +149,6 @@ bool q6apm_is_sub_graphs_connected(struct q6apm *apm, u32 src_sgid,
 				   u32 dst_sgid);
 int q6apm_graph_get_rx_shmem_module_iid(struct q6apm_graph *graph);
 
+bool q6apm_is_adsp_ready(void);
+
 #endif /* __APM_GRAPH_ */
diff --git a/sound/soc/qcom/qdsp6/q6prm.c b/sound/soc/qcom/qdsp6/q6prm.c
index 41a29047ff010..e3b8ddeb769eb 100644
--- a/sound/soc/qcom/qdsp6/q6prm.c
+++ b/sound/soc/qcom/qdsp6/q6prm.c
@@ -12,6 +12,7 @@
 #include <linux/soc/qcom/apr.h>
 #include <dt-bindings/soc/qcom,gpr.h>
 #include <dt-bindings/sound/qcom,q6dsp-lpass-ports.h>
+#include "q6apm.h"
 #include "q6prm.h"
 #include "audioreach.h"
 
@@ -226,6 +227,9 @@ static int prm_probe(gpr_device_t *gdev)
 	init_waitqueue_head(&cc->wait);
 	dev_set_drvdata(dev, cc);
 
+	if (!q6apm_is_adsp_ready())
+		return -EPROBE_DEFER;
+
 	return devm_of_platform_populate(dev);
 }
 
-- 
2.53.0



