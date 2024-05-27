Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F7415FD01;
	Mon, 27 May 2024 19:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837590; cv=none; b=j7lYM4IWUD/Hm7D9dKpfMdDeFj5mGjBsykN2h7o+2urVB8yS+mUAt3lUxvK5qXRzh/+/XC3K0mAtjUOIRb8T7HECwOpQwOQOV7HjbWPyDnmGXtmB09T7DRPziDOI73NCHw4vJjepeCqgMmAuvv8u774dlsPzFnNvlhrYnt+AfwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837590; c=relaxed/simple;
	bh=ppeYnelNaTmPnTBAyWObMexOfCFubFwA3ZrVcQE24P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJjKLjy6JdbSjXTdN8dp9TSLDtMmry5/woKIvgqN2k18Z7Ok9f29+ccG6ifFfWIG8sLgyvCgZvUEERayeG5M2BQfcD7j7J7xN+8eotKmDpd5OlE4f51IpSM4JnAmMp9v+EmSlYVDeji3wZmdf9drpBQ3ctlqJpOO4rS57rnmT4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wj+sMCms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wj+sMCms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B195BC32781;
	Mon, 27 May 2024 19:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837590;
	bh=ppeYnelNaTmPnTBAyWObMexOfCFubFwA3ZrVcQE24P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wj+sMCmsVm/ypOygH47fvZccYDkI52fJ3voHu9gk1hXEbFGdhfprihe7VOz6Yv0IS
	 E0PUrNAcekD4kzdzfLo6fpRCRyqhnEda6ooRpVY0en+eLNrXU7mvlFF7fZt54r5AmI
	 q8Uyyz9WvaAdAkMTQasvgqRp+EluB3k/SPw+UOOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"end.to.start" <end.to.start@mail.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 069/493] ASoC: acp: Support microphone from device Acer 315-24p
Date: Mon, 27 May 2024 20:51:11 +0200
Message-ID: <20240527185632.042742611@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: end.to.start <end.to.start@mail.ru>

[ Upstream commit 4b9a474c7c820391c0913d64431ae9e1f52a5143 ]

This patch adds microphone detection for the Acer 315-24p, after which a microphone appears on the device and starts working

Signed-off-by: end.to.start <end.to.start@mail.ru>
Link: https://msgid.link/r/20240408152454.45532-1-end.to.start@mail.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 69c68d8e7a6b5..1760b5d42460a 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -430,6 +430,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "MRID6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "MDC"),
+			DMI_MATCH(DMI_BOARD_NAME, "Herbag_MDU"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



