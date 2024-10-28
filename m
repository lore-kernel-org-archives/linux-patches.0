Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1713A2AF07;
	Mon, 28 Oct 2024 06:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098225; cv=none; b=pe5Yh4eiTB8kZOCd1o9lu1Uge2bgpaK7wtuMHaWB5XRCn0wj1Kgq3Z4QNJR2M14XdzqNjINBg2Pax+0QYIQtelE0jwjz+HBkRAjy3Ml5lbvtACNKEWrYvgZevcTzcVtevBmNL3Z6U6rrN4W6WZHexFPUzaDyaGjUVHaT6pvDRNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098225; c=relaxed/simple;
	bh=j7Tww9gcGjvVlVljyZLnCnyLgZ3PREsU7rvqOd1Q3l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lD9oq10S4WCtupnMjgGMjVZ1yOm0N2d+f6q5Tu/1tmfeQyARoI1M2jZ7cZyWfgcS3w3guFIiFmyNTdh6PyEI1VkENtrjk3M++qA2AJD9ldB8mkF2RjcrNX8IalGLFvMTZqSwMzRxFLOdqYK3qj/BfddnkUHJBFC0fJC/O4XvTdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NpPU+/R5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NpPU+/R5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF56C4CEC3;
	Mon, 28 Oct 2024 06:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098225;
	bh=j7Tww9gcGjvVlVljyZLnCnyLgZ3PREsU7rvqOd1Q3l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpPU+/R53zp8oZ8ZoUseJb0Gbzl3J2cgRB58/BZ4Vn2/h+zCOHgb+av27btNnEk59
	 Vn38dyLEtFX/nt3jv3DQtBJESj0L9stKByZozG3Gdtj4fC/JgJEZMtMWZ4Px8r+5hf
	 RQGxwiFoVrrmanONe7sOhQzjPs4ZrEKMi+N+Z/IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 131/261] ASoC: qcom: sm8250: add qrb4210-rb2-sndcard compatible string
Date: Mon, 28 Oct 2024 07:24:33 +0100
Message-ID: <20241028062315.322192372@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit b97bc0656a66f89f78098d4d72dc04fa9518ab11 ]

Add "qcom,qrb4210-rb2-sndcard" to the list of recognizable
devices.

Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://patch.msgid.link/20241002022015.867031-3-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/sm8250.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/qcom/sm8250.c b/sound/soc/qcom/sm8250.c
index a15dafb99b337..50e175fd521ce 100644
--- a/sound/soc/qcom/sm8250.c
+++ b/sound/soc/qcom/sm8250.c
@@ -166,6 +166,7 @@ static int sm8250_platform_probe(struct platform_device *pdev)
 
 static const struct of_device_id snd_sm8250_dt_match[] = {
 	{.compatible = "qcom,sm8250-sndcard"},
+	{.compatible = "qcom,qrb4210-rb2-sndcard"},
 	{.compatible = "qcom,qrb5165-rb5-sndcard"},
 	{}
 };
-- 
2.43.0



