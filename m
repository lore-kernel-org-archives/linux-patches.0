Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12122882CE;
	Tue, 12 Aug 2025 19:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025335; cv=none; b=CMdSLZuEhlgN4FukejJnZLn5gEKkj7ArYo+vzuTInrTfDVC1bd2jWre5AYYPomDz5K2VhvVhm7HIFBecQerP11/bS8/q1sa87+BfypkGSLDXP70I0vLMUq0o+ACCC2H0pWtvrVQsk4UEoBC1b9AL4DS6VhKEJclXMJGX7fLHpYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025335; c=relaxed/simple;
	bh=in5Uq9ccGw1NpM//AZQGtJXe+9jFxrt8W0XuUJoKwm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYfrNsl53s35xCDoGQcj7cQSkgCK2A6wkE65g8O2gkx6OfSruV4M08YNv2gnp6DKvTW8rCkuFm9xsldbO9xTxkSnLfK+DcKPgx43ydrgvE6bX5oG6sCrc03LR8Hs34UdIYeOLiAYDjkJOnpMZrlzo3u0wYVrGFu6ZzaGyNv94bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBf9X1OL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBf9X1OL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31503C4CEF0;
	Tue, 12 Aug 2025 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025335;
	bh=in5Uq9ccGw1NpM//AZQGtJXe+9jFxrt8W0XuUJoKwm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBf9X1OLM/Pmuj20AgMpPCXco6s0pJiRCcFP6UHKycj5Tddp5dI8d5KjnUZhoqTNy
	 ScP7uKyAF++ZAFLmxGRWt2xihWNFAg5dblSlahU+m7CLxjpfRiV2LFIwGaGGcVZBUj
	 7DZibfaYrJAWRt0n3puzUVRCBUgqiZjZLvRlF9OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Queler <queler+k@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 004/480] ASoC: amd: yc: Add DMI entries to support HP 15-fb1xxx
Date: Tue, 12 Aug 2025 19:43:32 +0200
Message-ID: <20250812174357.488024523@linuxfoundation.org>
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

From: Adam Queler <queler@gmail.com>

[ Upstream commit 949ddec3728f3a793a13c1c9003028b9b159aefc ]

This model requires an additional detection quirk to
enable the internal microphone.

Signed-off-by: Adam Queler <queler+k@gmail.com>
Link: https://patch.msgid.link/20250715031434.222062-1-queler+k@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 42d123cb8b4c..4bde41663f42 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -528,6 +528,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Victus by HP Gaming Laptop 15-fb1xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



