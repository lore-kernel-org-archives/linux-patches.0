Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A7022333D;
	Thu, 17 Apr 2025 18:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915288; cv=none; b=SfClf5f/CngFAPnzSKmBd/rLV8rTHZ9q9QKwEy5xYjDTwmuJm5XBpcopDFdKpES/cwICGUEye3knVoNuDS5VGDP3KEC7aae4wEoJ40LeU28bGEFp8ypd43WidyVYaBs9v/j4tjgU5NOiQObNbEbu8shTStfRC1M8N2BYcK9e26I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915288; c=relaxed/simple;
	bh=+i6BJPVFPXAddF07UORwZWWqYImXR19lUUdyFqTk9ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cl/XXOjS7DHyJNcMF+X//MdpIYsRqNOzW3lHUYVj9D4FPkCkt0zP8/KqaPpLbcgVgEahD4PsONPs30AGoAn+OU/kq2js5Ob+uFX8Ax1iHBy7gd/PnaCauzcP/KSp20X7rjPsTqekPmNGT63ZAPFJ814MuXL0iAcxhBrsiq/bV1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x38w3teb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x38w3teb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7559BC4CEE4;
	Thu, 17 Apr 2025 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915287;
	bh=+i6BJPVFPXAddF07UORwZWWqYImXR19lUUdyFqTk9ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x38w3tebz0uSh/EYdsGDwCnqZKCug6QZlVOAoD93QM8zRmSkTUJly1fYJjTebeTDE
	 V3BTWdKYs1P8yhnDfAQIPPCVxglfj8B0sceZ4RZYh33jnYyINuQ51JV3esv7Pz/+xb
	 0hepQeXCwsSzCfWR9it2OWLUImHVGq/IMl+bnXbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	keenplify <keenplify@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/393] ASoC: amd: Add DMI quirk for ACP6X mic support
Date: Thu, 17 Apr 2025 19:48:08 +0200
Message-ID: <20250417175110.779449326@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: keenplify <keenplify@gmail.com>

[ Upstream commit 309b367eafc8e162603cd29189da6db770411fea ]

Some AMD laptops with ACP6X do not expose the DMIC properly on Linux.
Adding a DMI quirk enables mic functionality.

Similar to Bugzilla #218402, this issue affects multiple users.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219853
Signed-off-by: keenplify <keenplify@gmail.com>
Link: https://patch.msgid.link/20250315111617.12194-1-keenplify@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index a7637056972aa..bd3808f98ec9e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -584,6 +584,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "pang13"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 15 C7UCX"),
+		}
+	},
 	{}
 };
 
-- 
2.39.5



