Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E1F748A;
	Thu, 12 Dec 2024 15:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017224; cv=none; b=PRgGBprSfjs6jF5yJUpGijIVZFX4XMnWM2Xd4ElOWBK54DnYsRAhLthbxKs84jFKjwhsFV2af5mxfoZ8sQbypHoGYdXEXK/w4OcoulgC/WsyqzNRykM8iFE7bVFP4NC30R/DYEQuHiLhb2tHz5LNZn4YBdrmqiW/aZ1vZRROKKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017224; c=relaxed/simple;
	bh=ZTJfR4Yf7gEDF4myWI1PqLy01pWS2ULkkzLZx9h6rn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEXKmpaAsCOWBzjsQjssAd3gUDeNBo1rnv1MyBOcGYNbH/5IPmqvakgnmN5S3mIpHNE7amX/hZH+BWtAVkIyhFwDl6P6PRbZv8uLhegX/S4xK1nUWS5IcuQvuyli3QtJbwPG4lczNM/DObK2Neq92cBjRegsgYFeiilDsZ54FNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFGdbTnO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFGdbTnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED94CC4CECE;
	Thu, 12 Dec 2024 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017224;
	bh=ZTJfR4Yf7gEDF4myWI1PqLy01pWS2ULkkzLZx9h6rn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFGdbTnO8YulfHs43DE3uPSkY+PnbMDHtP5cWF60qBBAEsdfhk4wUEbxYSvzHWQGg
	 CDkJDrnbnTIuSLdanE3Qssebi8D5vp54Bw5EsO+qeaFYkg9qRbUqS7CaoXE/sbeIQV
	 k0vBS5ocT5BRClrT+3TuSBAaiPKaNtewhOJ2ynqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Far <anf1980@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 417/466] ASoC: amd: yc: fix internal mic on Redmi G 2022
Date: Thu, 12 Dec 2024 15:59:46 +0100
Message-ID: <20241212144323.230826030@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Far <anf1980@gmail.com>

[ Upstream commit 67a0463d339059eeeead9cd015afa594659cfdaf ]

This laptop model requires an additional detection quirk to enable the
internal microphone

Signed-off-by: Alex Far <anf1980@gmail.com>
Link: https://patch.msgid.link/ZzjrZY3sImcqTtGx@RedmiG
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 5153a68d8c079..37820753ab09c 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -416,6 +416,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Xiaomi Book Pro 14 2022"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "TIMI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Redmi G 2022"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



