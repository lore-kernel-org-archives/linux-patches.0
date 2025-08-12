Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222362FDC59;
	Tue, 12 Aug 2025 17:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020702; cv=none; b=KOOxa+nbxXf+66wIsRTxbNkGF0EKOzHZ7TgCZh9WN1SXH+iD7Bcmrpo8UD9zMgWK56DX+RYn/sU1XYjc7QgltDy3VWBfLYTFeUfZNqjZPsL3kW4q6y4HmEdMmUETLT8TfUnn762WhO77xbgy+DcuH6Xuo0qNH8fTgSxGj4fQJng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020702; c=relaxed/simple;
	bh=MTIgNjFPPiEduwdI83X2sek5/yDIk/GVS8NfVd5vMdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0esIo801Ugs70G7epNuwyb/FNcgvwOqw9tfXb6aatdfkxJQyB8kkV0APglZ8+5HIcA3gFI5oBmbQz3fiwIDNQ2SdTCFT2l2sb/mI97UT8rIRDsed1JEQLGxnA2rOIl+0seHg1wCZs6owrA6nnx+8JTvPDR3HJA/T74uD5Hbprg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0m7ebT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0m7ebT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE25C4CEF0;
	Tue, 12 Aug 2025 17:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020702;
	bh=MTIgNjFPPiEduwdI83X2sek5/yDIk/GVS8NfVd5vMdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0m7ebT1gaJSiFLIdpVROxHswvJa9chKh4L+jgsfeRHI09tsPRTWuFrzfwDszqRH/
	 hlCglYiYHKHFcclTW3mY8cW1RiCJyu8o05eFbxUAfOUPrtCEu2wniZ/lF+l/LzC0Wt
	 LxFzBuPEcvd1zOfD1ospgOX4bKWbC9GBbmrbc/uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lane Odenbach <laodenbach@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/262] ASoC: amd: yc: Add DMI quirk for HP Laptop 17 cp-2033dx
Date: Tue, 12 Aug 2025 19:26:29 +0200
Message-ID: <20250812172953.026977270@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lane Odenbach <laodenbach@gmail.com>

[ Upstream commit 7bab1bd9fdf15b9fa7e6a4b0151deab93df3c80d ]

This fixes the internal microphone in the stated device

Signed-off-by: Lane Odenbach <laodenbach@gmail.com>
Link: https://patch.msgid.link/20250715182038.10048-1-laodenbach@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 66ef8f4fd02c..74f8e12aa710 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -577,6 +577,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8A7F"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A81"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



