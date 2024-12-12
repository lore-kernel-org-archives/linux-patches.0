Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F522206A5;
	Thu, 12 Dec 2024 15:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018489; cv=none; b=E+5TXc+oLC6Br4mmyx+eD/k6IPEWrpUoQyeTQiGdzq/z9gY43f6MGXv7DRoXPfXHin7QCYk1CpV8i7fJcQwTTMgImPmDbKUI7PDD35RUV3zOULAoeFd6WvpZu8KCLUMC5sGY83Vo69XvsyZqDC+B045r8Zu/nZvCcn2Mh2yOY/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018489; c=relaxed/simple;
	bh=+UXuSw8QGolWP8dVFndUCnkg3seDLb4Orinn/2Cv19Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q8kF6PMX8ZU1LMqJjiWXBVerSrEkX4+bUKdnndYp3huSgNp9rMZRyC5MaYfF0EILtcw3eAAhfOuAjVeMrcKv9d7TB4jXqnsDr4+g/Wun530haEu31Zh26Fy7QkOmOWjaZ6tozVC8Sbf1VyZsHCcoCwMRDzt4zGs6daLCB0yJFpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqxapzuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqxapzuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBAAC4CECE;
	Thu, 12 Dec 2024 15:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018489;
	bh=+UXuSw8QGolWP8dVFndUCnkg3seDLb4Orinn/2Cv19Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqxapzuT3/TajBiGmSm/cP+nSd5OwigXigOKof5uoSwT+JGh/9sLggE/9atMRefvT
	 SGsG0+lqyS101ab90EXfCc5KfD7b7bJsW5NDS6P/Xi/fKtR9DIUjRISVRPyCkSRsc9
	 qYUP27JQnfu/nOr3TtBA0PB3ow6b4CwAO/jgfls4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tova <blueaddagio@laposte.net>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 308/356] ASoC: amd: yc: Add quirk for microphone on Lenovo Thinkpad T14s Gen 6 21M1CTO1WW
Date: Thu, 12 Dec 2024 16:00:27 +0100
Message-ID: <20241212144256.729637285@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <ukleinek@debian.org>

[ Upstream commit cbc86dd0a4fe9f8c41075328c2e740b68419d639 ]

Add a quirk for Tova's Lenovo Thinkpad T14s with product name 21M1.

Suggested-by: Tova <blueaddagio@laposte.net>
Link: https://bugs.debian.org/1087673
Signed-off-by: Uwe Kleine-König <ukleinek@debian.org>
Link: https://patch.msgid.link/20241122075606.213132-2-ukleinek@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 8a99ba5394b4a..39f151d073a6c 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -220,6 +220,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21M1"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



