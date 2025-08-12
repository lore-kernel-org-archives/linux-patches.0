Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901E83D994;
	Tue, 12 Aug 2025 19:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025442; cv=none; b=Uh0+E45zM10y5QECUfkFrNSKMxHijXtxec5LlvYoyrDnseEAjRKm56Jr1Z5iFHRm8N3UpdD9lxJIG22CW7Vx39l/LJ39QY7/NC2r/DQu4TyhWnYTXqwEk55YLuImOx6M0XZYmdDm30OUm2IXlS1BSm9OhT9r+9y4lpVEsKmdix4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025442; c=relaxed/simple;
	bh=jrJwiCtm2ew7SxnSEeepIFylvgwMjBofsaEUow6OA7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrvaO3m15tTrx0+BYFgD9BL1nRk5/R4L++1U8XKdYmSYm/6wI52mDJpI+SUKRaly8YG8sAcOyGJPqJhu1sUHppSpzeYRFdR1VoPPW1M5TpipjUlPyZmQLHihyGxbckRSB6Yj+w4A9DJ/CzmFk2K4Mj2lgHbAi0DsLzq40wDm0Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1gdNRqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1gdNRqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AE9C4CEF0;
	Tue, 12 Aug 2025 19:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025442;
	bh=jrJwiCtm2ew7SxnSEeepIFylvgwMjBofsaEUow6OA7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1gdNRqJhw4+CSq61u0yFVDR7gJt1imiWg9RxD5tK9ojf5dLNcnI8TKz19YEvmN3+
	 C23BG6n5eDAj0mvJJrZLqaOY06QNaFljjjAKv9faZ9kxNevOwvoPXWMd+x13DawpM1
	 hA0rk3H5/DCzVswybyJmUCv8wfBeakHcgb7klwSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Andries <alex.andries.aa@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 008/480] ASoC: amd: yc: add DMI quirk for ASUS M6501RM
Date: Tue, 12 Aug 2025 19:43:36 +0200
Message-ID: <20250812174357.652099887@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Andries <alex.andries.aa@gmail.com>

[ Upstream commit 6f80be548588429100eb1f5e25dc2a714d583ffe ]

add DMI entry for ASUS Vivobook PRO 15X (M6501RM)
to make the internal microphone function

Signed-off-by: Alexandru Andries <alex.andries.aa@gmail.com>
Link: https://patch.msgid.link/20250707220730.361290-1-alex.andries.aa@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 4bde41663f42..e362c2865ec1 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -409,6 +409,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M6500RC"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M6501RM"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



