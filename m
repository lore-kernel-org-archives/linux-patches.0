Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CFE18F2FD;
	Mon, 28 Oct 2024 06:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097321; cv=none; b=DqoRGYNxJbiNMUdI6WR1ETr1yU9uTxYozrHQHThYF3OWlTVIS/ph0fXxQAXEz/+Ysg6CZtzHy3n82Ved/8XzIUVFfdKQu/LQ+Qrj8Gy8dkwYnBBJRNATVIOyfFCdW+xKhyxkiQpwhjTeivVZoJgOTYFCm7IW5MErDjWH4+Ip8nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097321; c=relaxed/simple;
	bh=OYFdzZx4/ZP/yHGgvnMFUa0qmoosMKihqVpRQXKixjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hcqm655P9CLB1PkA9pusB2/FSXQ3Tsa0e2mI54LsDtJp8bcgEZ/e6EbirL/WQutT2b4bUSzaaSXx/axR6XGU9LPgss8vco1scIr8mSfSZBxJUQvJvkBJHpJ0ENnd+CUINBM1D9EQ/1uWDJcJRH1fynXOEkovRTAkgqlnXUEkRxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkzY0O2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkzY0O2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB80BC4CEC3;
	Mon, 28 Oct 2024 06:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097321;
	bh=OYFdzZx4/ZP/yHGgvnMFUa0qmoosMKihqVpRQXKixjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkzY0O2R9yhQmbHtfvzrTfSlAEp32nYLHAIh+s+GoCOhFRetKTnxk7CDz8PIMA8gL
	 U7bsPTXcXvFy/A+JCiwW5/O6MkQ5FwXXe66H+H3KHKNC7ReyJtZcbpH2dp2OiRkrH4
	 v0+yONv8Vw396p3NMaXIxboy4v3tKqvYCRtLT6Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/137] ASoC: qcom: sm8250: add qrb4210-rb2-sndcard compatible string
Date: Mon, 28 Oct 2024 07:25:17 +0100
Message-ID: <20241028062300.971125231@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9626a9ef78c23..41be09a07ca71 100644
--- a/sound/soc/qcom/sm8250.c
+++ b/sound/soc/qcom/sm8250.c
@@ -153,6 +153,7 @@ static int sm8250_platform_probe(struct platform_device *pdev)
 
 static const struct of_device_id snd_sm8250_dt_match[] = {
 	{.compatible = "qcom,sm8250-sndcard"},
+	{.compatible = "qcom,qrb4210-rb2-sndcard"},
 	{.compatible = "qcom,qrb5165-rb5-sndcard"},
 	{}
 };
-- 
2.43.0



