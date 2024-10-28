Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A562A18E05D;
	Mon, 28 Oct 2024 06:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096927; cv=none; b=ICa7/dNBTOYhhyMCG8FN2mX6cTqa6rSpiba4quJ5pgvx9YyncKwOwoaHHD11eCE5caW9GOoswns39k7yWpn8jK0alUMghWMtQT03afp4RLeYH/EuE/dBnOjpGBm1yOUe7d2lN3dRNAaJdJrXBeN41aN6W4RdqusJ2t4c5cQpUKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096927; c=relaxed/simple;
	bh=uYUZZm2SaEgQea7FLjH+OO2GBecPGulA7E6RdLkYnj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmiKxu8TrjOSk7GeRd/yTefUuUhUjTpWKGgmNWt2lkcG0qAZclKdq7yrG9AfUw8sMBP+fslHKlV2WhIjI55AkAIYXCI9EpjfLBDFVAJ6Aykec+aTutq73jEj6U4gganEaYhe7iRBUaFsqv5aBli/t698bhnrEx+tW6ZMeeKK7Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4hlGBBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4hlGBBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F66C4CEC3;
	Mon, 28 Oct 2024 06:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096927;
	bh=uYUZZm2SaEgQea7FLjH+OO2GBecPGulA7E6RdLkYnj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4hlGBBMdQsDhQsacc4FMXTo99mE+1Ag7F2vcPqWs0Xj0FTDaFRoZ7SFLjaVDgle9
	 2yiiqlKWGfJS/yfDFgWuJzbto0BTuVCzGOqcZPLmmPwk0AbGbj+AY7tbe0rr2/jUf6
	 d/wvJiiadzHeQebrbApSSKq/aRpjAASNEvJd0U9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 48/80] ASoC: qcom: sm8250: add qrb4210-rb2-sndcard compatible string
Date: Mon, 28 Oct 2024 07:25:28 +0100
Message-ID: <20241028062253.953262972@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index feb6589171ca7..a38a741ace379 100644
--- a/sound/soc/qcom/sm8250.c
+++ b/sound/soc/qcom/sm8250.c
@@ -211,6 +211,7 @@ static int sm8250_platform_probe(struct platform_device *pdev)
 
 static const struct of_device_id snd_sm8250_dt_match[] = {
 	{.compatible = "qcom,sm8250-sndcard"},
+	{.compatible = "qcom,qrb4210-rb2-sndcard"},
 	{.compatible = "qcom,qrb5165-rb5-sndcard"},
 	{}
 };
-- 
2.43.0



