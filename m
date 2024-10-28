Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1BB18E74D;
	Mon, 28 Oct 2024 06:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097734; cv=none; b=JdL84zgEwpoXgXfAiBtYahw4QeUXFRFRmZUukRJkzY3qR6W6Ojf6it25O1uNrdK1nKG4ughktTTKV4b9mucRsgZfQstZRd8OV+K9a5x0avpgWUfwMKfXCAOeeZkQ7jqKOC3MyULIS62y7ofYqR+Qc7Y3iXlkL0JLtwMl4sXE65c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097734; c=relaxed/simple;
	bh=f6suFdAIv4tFWv/da7AwsgXLCiS27Zfx/2SSsspn2Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udBnfS91vn/gQZf/iWPa1Y3sOgRo0jiyrmdFz7eEeH5yhxftrLWzc55By9bKI/sfWkqHQ9FAfPb6YiGOgQ9uGpUmyw+G9kOH31hr9bpBo5LyeflHko3CSXY0IX6CfavQaqBFMxNOomb1ziOEXPRTj0adq04WGwiQtxqj9eSplK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJQVSqSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJQVSqSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2EAC4CEC3;
	Mon, 28 Oct 2024 06:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097734;
	bh=f6suFdAIv4tFWv/da7AwsgXLCiS27Zfx/2SSsspn2Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJQVSqSnMLJaijWulaj/8DMOHC5JuVFbo6+B+dw8d8LA3BVQXe323lbXioZVECFd1
	 xE/KGLL3RuKOkZEPgq2IPgR8WInZ8gxdOQHDvAdKsALUZmgHdhLJ2O+6ELFQW9K37v
	 RMwByv8mmLpeCboiB4JvrQH6wc6AcQB+0y/tuRjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/208] ASoC: qcom: sm8250: add qrb4210-rb2-sndcard compatible string
Date: Mon, 28 Oct 2024 07:25:04 +0100
Message-ID: <20241028062309.700149484@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6558bf2e14e83..9eb8ae0196d91 100644
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



