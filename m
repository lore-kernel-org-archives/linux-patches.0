Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979A32A1BA;
	Tue,  8 Jul 2025 16:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992163; cv=none; b=D3q89rROOO35rk2A1mtRSuRojMfyj8ssMWrbTuOqrbpUCop+ZU47OGnSS6Ws1SNwrje5aDD/+dtivlw5PAkzVem/bN8q2C+ozxc9rC5SFcY5NMJkk3c+5WtUVNpGxJwHfBMXM4L/9nBRigi9vA3aOR2GzX/IPWHTT6lUHXc4Y1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992163; c=relaxed/simple;
	bh=vPUsNDrygLzYcWaIAsE9aA24WOpGu8DXDBLrH9NGXm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVhoJYXfi/sM479E1TpigTHHDGIMHODV/Uzcy9/Blbi0JBLmkobNNNY/lHk5OjBbiDTOJOJnMZmlMtNBLa71+orKysKzUNsm7szTDq1+9INyRSmnoZaqkmS/sHr2hfRxsPSlf2sFo4Uqigya1JKah7n/s6+4rshCtNZFeBNXH9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrKoQoCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrKoQoCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25422C4CEED;
	Tue,  8 Jul 2025 16:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992163;
	bh=vPUsNDrygLzYcWaIAsE9aA24WOpGu8DXDBLrH9NGXm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrKoQoCm6LjKhKwOp+8NFer9ZI4HibyWMDoBV8OfxpBN2z1FoqILa23RhGNRS7v2D
	 BBY849FaQQFn2LpOlOXA4Itr9gw243vVVy3hazBZPWWmecssPXq59g6E/50tSn4TZn
	 z5iI+DUP4b+p6vIRGuevc5uFbk7nOVFxQYl4QaFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raven Black <ravenblack@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 51/81] ASoC: amd: yc: update quirk data for HP Victus
Date: Tue,  8 Jul 2025 18:23:43 +0200
Message-ID: <20250708162226.633978831@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raven Black <ravenblack@gmail.com>

[ Upstream commit 13b86ea92ebf0fa587fbadfb8a60ca2e9993203f ]

Make the internal microphone work on HP Victus laptops.

Signed-off-by: Raven Black <ravenblack@gmail.com>
Link: https://patch.msgid.link/20250613-support-hp-victus-microphone-v1-1-bebc4c3a2041@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 30f28f33a52ca..ecf4f4c0e6967 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -451,6 +451,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Victus by HP Gaming Laptop 15-fb2xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



