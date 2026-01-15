Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BAC3BF303;
	Thu, 15 Jan 2026 17:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496719; cv=none; b=g7nnQxqc7hqPi9boTMGwmAbyncco35bm8WqblQvo+iu/Yr6QcgLeII4814RDZEhSa8RUcJ1ox51L+i3ahBMO8jbeR9rMVkuxM8G/eZzlJqi87Dqi39IflxJTVqF+8z49CD5PhJNkkt+JWVI9lbQ+tm5q+kBfPFjap/K26Z8P5WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496719; c=relaxed/simple;
	bh=fwaOdEZr4RvL+h5n/gcT/FutY8LZ6o5yAkGjjg5/Xx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMSotmvAocDexEjhbjtduhzG7YIUtJmxr8Pnfgo8C4fM+3dxud8eVPN58KCW0szFufQS6j+SmFanlBsrfeINkSJPPGGbWsmbsJr9Haz+WI+o/dro7QgyVjFof3/JX3FKjAhpNjYimsxOIIdNg8bxz367pdGrqTC32u0ldz7i9Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j52JqovJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j52JqovJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEA3C19422;
	Thu, 15 Jan 2026 17:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496719;
	bh=fwaOdEZr4RvL+h5n/gcT/FutY8LZ6o5yAkGjjg5/Xx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j52JqovJbvIDRn7LWGsjtC5JldI0/MXBc+X+sYeKu3hB2pF9q9WMhSMM0pHlfeVpM
	 kTze4l2f4eFNlRKEi+Q58zk59liHVmQRfxm4+jIQR0ZK3FInjA6smIwjgkTHJNZZGU
	 5z2mz/IoBU1oTKk19+dq5y0HFX47O8hZo33Wmiqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Elantsev <elantsew.andrew@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/119] ASoC: amd: yc: Add quirk for Honor MagicBook X16 2025
Date: Thu, 15 Jan 2026 17:48:47 +0100
Message-ID: <20260115164156.002789962@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e362c2865ec13..3dcd29c9ad9b2 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -654,6 +654,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
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



