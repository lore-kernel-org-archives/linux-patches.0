Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7429C1774B;
	Thu, 18 Jan 2024 10:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575569; cv=none; b=Law1p9bt+riotCqzKaQIepefP4hFRTTzE3bXjoSQC98QHQGKeI+TNLYf19K/xJW4hjIbwLZh1Lsm5yxSFmB343/z8ldNKDbY7wVxZxFP2BxNZQVGlVAbUaTq54rpPUjSXA4EqaoDIk07m7ift/tRnTrpP7r1pFNv9WvomNzJ/vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575569; c=relaxed/simple;
	bh=7rFNNP8L498UVEPhwfPazYFCjJhlSvjtbedw7q3Zhww=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=gcFEAPY2RrLBm1OiqhH6uNPbLE3WvyrVMjsuvbIudWFF/uV7bhE1VDs+xGB3VlaZ9pIkjDXSVlPdSi0/SmeCugFzNBLT/4j258mkLcddfieP8G57/Y7cl9gvoF+Ocr5qnChJ1r5LGQYX/4dd7mm0962CuBCXT9Rbf7LyIh1uVgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqClfJG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqClfJG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2DCC433F1;
	Thu, 18 Jan 2024 10:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575569;
	bh=7rFNNP8L498UVEPhwfPazYFCjJhlSvjtbedw7q3Zhww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqClfJG8gde7HpSM8+DmWzN+nP5WveQV/vCtU8m1vDGu56nd52QM1qVn2hLzHIGcv
	 0zeMtMi66oXsafbsGqgMie/1LWDiBE3Ww5xIXMdL62yJCmkxO7BYCnPxwPeMDg8CP+
	 YK1135fhlNjJlXO/FzbgtExmww9FCibDZ42Wj9Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Soller <jeremy@system76.com>,
	Tim Crawford <tcrawford@system76.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/100] ASoC: amd: yc: Add DMI entry to support System76 Pangolin 13
Date: Thu, 18 Jan 2024 11:48:36 +0100
Message-ID: <20240118104312.134825516@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

From: Jeremy Soller <jeremy@system76.com>

[ Upstream commit 19650c0f402f53abe48a55a1c49c8ed9576a088c ]

Add pang13 quirk to enable the internal microphone.

Signed-off-by: Jeremy Soller <jeremy@system76.com>
Signed-off-by: Tim Crawford <tcrawford@system76.com>
Link: https://lore.kernel.org/r/20231127184237.32077-2-tcrawford@system76.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1dde1f3196ac..808d00282623 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -353,6 +353,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "pang12"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "System76"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "pang13"),
+		}
+	},
 	{}
 };
 
-- 
2.43.0



