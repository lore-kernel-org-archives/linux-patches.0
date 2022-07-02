Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7214B7E
	for <patches@lists.linux.dev>; Mon,  4 Jul 2022 11:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90637C3411E
	for <patches@lists.linux.dev>; Mon,  4 Jul 2022 11:06:12 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="TNAJ2bOK"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Mon, 4 Jul 2022 12:06:08 +0100
Resent-Message-ID: <YsLJoG9kFZI22gfd@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Sat, 02 Jul 2022 03:01:37 +0100
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=ATbv=XH=126.com=windhl@kernel.org>)
	id 1o7SRy-002l2U-IR
	for broonie@sirena.co.uk; Sat, 02 Jul 2022 03:01:37 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 140FEB83275
	for <broonie@sirena.co.uk>; Sat,  2 Jul 2022 02:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id C05C3C341C7; Sat,  2 Jul 2022 02:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTP id 055E5C3411E
	for <broonie@kernel.org>; Sat,  2 Jul 2022 02:01:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 055E5C3411E
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=73lYo
	M/GkRf2iyG5M5bpJq7rPCt682C7VgcqQhhMUFo=; b=TNAJ2bOK0NTXAo9kMFAUJ
	P6SnCVvCbzhIaTEQkbt6rlz5Ir3MbIRpm+fHupTZtZgQrZr98pAgcsEOykDfS7fb
	fuTUmFOQ1qNyNvGFyA1zGj9WcZ8uq2j6405HnhzIdFrljAu9ocCb7Pefzi1qTvwA
	fqxfZNBggPfBMtbjpY0DIo=
Received: from localhost.localdomain (unknown [124.16.139.61])
	by smtp3 (Coremail) with SMTP id DcmowAAnB53lpr9iyCVeEQ--.38592S2;
	Sat, 02 Jul 2022 10:01:10 +0800 (CST)
From: Liang He <windhl@126.com>
To: srinivas.kandagatla@linaro.org,
	bgoswami@codeaurora.org,
	lgirdwood@gmail.com,
	broonie@kernel.org,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	windhl@126.com,
	linmq006@gmail.com
Date: Sat,  2 Jul 2022 10:01:09 +0800
Message-Id: <20220702020109.263980-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:DcmowAAnB53lpr9iyCVeEQ--.38592S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr47Zr1fJF1fXr47WF1rZwb_yoWfAFcEqw
	1I93s5ZF4kGFs7t3yDJrZ09r90kr4xurWUCa17ZF12yw1jyF98tw1vqrnxurn5ZrZYyFyD
	WFZ8ZrWUAay5JjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRpuWmPUUUUU==
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbizhMyF18RPal1JgABsw
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=ATbv=XH=126.com=windhl@kernel.org
Subject: [PATCH] sound: qcom: Fix missing of_node_put() in asoc_qcom_lpass_cpu_platform_probe()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: KaYGwVp+1R3+

We should call of_node_put() for the reference 'dsp_of_node' returned by
of_parse_phandle() which will increase the refcount.

Fixes: 9bae4880acee ("ASoC: qcom: move ipq806x specific bits out of lpass driver.")
Co-authored-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Liang He <windhl@126.com>
---
 sound/soc/qcom/lpass-cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index e6846ad2b5fa..964eb07f46d6 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -1090,6 +1090,7 @@ int asoc_qcom_lpass_cpu_platform_probe(struct platform_device *pdev)
 	dsp_of_node = of_parse_phandle(pdev->dev.of_node, "qcom,adsp", 0);
 	if (dsp_of_node) {
 		dev_err(dev, "DSP exists and holds audio resources\n");
+		of_node_put(dsp_of_node);
 		return -EBUSY;
 	}
 
-- 
2.25.1

