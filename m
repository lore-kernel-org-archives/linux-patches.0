Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8C730DEC7;
	Mon, 13 Oct 2025 15:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370010; cv=none; b=tuARhRVnCoUnnfRV1Jv1A7jcLj+bXhKbntAO9A4BQgTzomXKOLEZyboA+gRYsgbQSTUo0hRioIh5AqoNJ8/5xOA2Eccfyqhg/LdOz0aJJqT0DX60zsRtQqL+T4iyB20s0I5QcAEkaobThNukCRrfKGLj2l/IJoJu68WUx0UtSeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370010; c=relaxed/simple;
	bh=mbPYXTHmwkhMgENLHnMt+liYKwCm04bqzMG2JI3aWDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAI3AbW6iG85IzHkZAWI6y9wwU/1+Q6fqEM1COfaZ4QrXPDu3vJxd3ZkVXTD5N9CeN6GbMVasotya4kd7JrLD2gyxLSKg35EVZ3SsQo4Kui1TL436r3f7CnWcuB43jezKwyK8hxGURHHpeL+vpRyEPpBQLyu+glXfwA9kU99tVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iaXkho7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iaXkho7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0813C4CEFE;
	Mon, 13 Oct 2025 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370010;
	bh=mbPYXTHmwkhMgENLHnMt+liYKwCm04bqzMG2JI3aWDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iaXkho7E2ZQeC2ixS3LLWSR4rmZLee8N/QjoCxPooewatj4JTFokyk9/Pmrr2Eqkn
	 McALaioruf2iUz9o9eiGTA2KC2IFRRjK3XNJ8JF6Ba8QmNO7Ktgj1EmYNaB+5uPxnf
	 TK4Aym1S4HFrDz/e/VJHXk04tkitGYz/21ggja1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 445/563] ASoC: qcom: sc8280xp: use sa8775p/ subdir for QCS9100 / QCS9075
Date: Mon, 13 Oct 2025 16:45:06 +0200
Message-ID: <20251013144427.401819839@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit ba0c67d3c4b0ce5ec5e6de35e6433b22eecb1f6a ]

All firmware for the Lemans platform aka QCS9100 aka QCS9075 is for
historical reasons located in the qcom/sa8775p/ subdir inside
linux-firmware. The only exceptions to this rule are audio topology
files. While it's not too late, change the subdir to point to the
sa8775p/ subdir, so that all firmware for that platform is present at
the same location.

Fixes: 5b5bf5922f4c ("ASoC: qcom: sc8280xp: Add sound card support for QCS9100 and QCS9075")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20250924-lemans-evk-topo-v2-1-7d44909a5758@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/sc8280xp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/sc8280xp.c b/sound/soc/qcom/sc8280xp.c
index 288ccd7f8866a..6847ae4acbd18 100644
--- a/sound/soc/qcom/sc8280xp.c
+++ b/sound/soc/qcom/sc8280xp.c
@@ -191,8 +191,8 @@ static const struct of_device_id snd_sc8280xp_dt_match[] = {
 	{.compatible = "qcom,qcm6490-idp-sndcard", "qcm6490"},
 	{.compatible = "qcom,qcs6490-rb3gen2-sndcard", "qcs6490"},
 	{.compatible = "qcom,qcs8275-sndcard", "qcs8300"},
-	{.compatible = "qcom,qcs9075-sndcard", "qcs9075"},
-	{.compatible = "qcom,qcs9100-sndcard", "qcs9100"},
+	{.compatible = "qcom,qcs9075-sndcard", "sa8775p"},
+	{.compatible = "qcom,qcs9100-sndcard", "sa8775p"},
 	{.compatible = "qcom,sc8280xp-sndcard", "sc8280xp"},
 	{.compatible = "qcom,sm8450-sndcard", "sm8450"},
 	{.compatible = "qcom,sm8550-sndcard", "sm8550"},
-- 
2.51.0



