Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495C5223313;
	Thu, 12 Dec 2024 15:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018480; cv=none; b=Jot/AYPEHWWLzzocArWCUx4NefxQn7A5NMfB9ne4qjzfnUNq8VZG1oWV/yoaIl/qI7RADFYb3rx8lDkW6hxk20i6i8zdCFr3jmE1UlAwNSIYnku2IFD5i/HfIHAbjoq3kDP2JSuGY5LxyILwsy4FVd0yPtOzdtXIfSlxFXKYFb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018480; c=relaxed/simple;
	bh=1GezJa41UMREGKq38Z7vfv1iwJRVysGsgmoKQDUo6vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kcs0IECS5fCybrp63DBk21aH24L/W7fJv9UPmmW6JchQ2fpipv6WaQD3WWYU0ueh13c9enexKshTB4xO2HtiiT90GYCtHfw8ZZua0n+Psf2eNJp1uhghsnc6jvuMoxGEiyNjeIjBYgEIqJKifQF9tr0aWx13OdBnKHyUDiwZ9Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4pjSm7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4pjSm7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77571C4CECE;
	Thu, 12 Dec 2024 15:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018479;
	bh=1GezJa41UMREGKq38Z7vfv1iwJRVysGsgmoKQDUo6vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4pjSm7U/NEDiMliPNBFN+Xj2aHIto0OlQDNdfQnxe0k+PtAPW8Gw/toW/0JY57Am
	 GQEBuLlSlp7mQ/mO+gysdtk0GVH/TfKywRwu/CdaMUDI9310HnoZtDuODWwZgTrWjR
	 +0sYULL6IzpeoFecsKsgVIqV6wgf3HUe0MRkKg/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Far <anf1980@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 305/356] ASoC: amd: yc: fix internal mic on Redmi G 2022
Date: Thu, 12 Dec 2024 16:00:24 +0100
Message-ID: <20241212144256.612338387@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a00933df9168a..8a99ba5394b4a 100644
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



