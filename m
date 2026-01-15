Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740272BD5AF;
	Thu, 15 Jan 2026 17:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496422; cv=none; b=m6KWFaSgo+0qUnGg/eZAQ7bCZ5FbnL9AOPVLFlZVQF63bZV+yTy3yAXQkFbYKwmlZyFLJ11G4ZT5aOKqx+PcPmzLPJklL9uwX1HlAow/6IJFtrAydGuC7ca8Wz7tU9ubWu8eI/YLB8bBMSL3Z7Puf1LL6dwzKxiBCS6ZffgsxP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496422; c=relaxed/simple;
	bh=KCSNYpos81sKN6nNn6dztANMnTge/ilspQTI5LaHSm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Av/FCF6bMwbCHn32FunUhEFqrztoa283T58oqJajhomo4b3AXSohjw66vmRG1ErhnNYwOzyZDrX17kVmx5CqPzygaPFOWdA2EnrYlT53T0cu094eSIVCgfK63/O2EvOOr21QoyIpr+dkMziPcvCWJS8KKXWiJx+Z2k17QunRBTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f80t2sYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f80t2sYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C31C116D0;
	Thu, 15 Jan 2026 17:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496422;
	bh=KCSNYpos81sKN6nNn6dztANMnTge/ilspQTI5LaHSm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f80t2sYUS41fyLJM4sBJk+I2EI9ywGmrGqbbSGgbvGvkFNCoqK/RH+p0jc0ZOEyw9
	 PYPlq3K/RoX8ad3Xa3FpgdfzTB24ZR6uyxfwqcyhsCcGQCaVAc2VV7RhLl5CjU3/I9
	 0xiJdW5JpmTv9OwmtsV1SR6ig8e65Cz/ycOFl8aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Elantsev <elantsew.andrew@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 177/181] ASoC: amd: yc: Add quirk for Honor MagicBook X16 2025
Date: Thu, 15 Jan 2026 17:48:34 +0100
Message-ID: <20260115164208.703984109@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Elantsev <elantsew.andrew@gmail.com>

[ Upstream commit e2cb8ef0372665854fca6fa7b30b20dd35acffeb ]

Add a DMI quirk for the Honor MagicBook X16 2025 laptop
fixing the issue where the internal microphone was
not detected.

Signed-off-by: Andrew Elantsev <elantsew.andrew@gmail.com>
Link: https://patch.msgid.link/20251210203800.142822-1-elantsew.andrew@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index f210a253da9f5..bf4d9d3365617 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -661,6 +661,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 15 C7UCX"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HONOR"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GOH-X"),
+		}
+	},
 	{}
 };
 
-- 
2.51.0



