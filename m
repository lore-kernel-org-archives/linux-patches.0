Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF088BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6224BC433EF;
	Tue, 28 Mar 2023 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014990;
	bh=ioD3xUhnDD/kN66mIEPreBlmwTQml2JuCHXZJ35GMJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzfTpUD3k20vWeucEYeCKbCw5zW0GDcCI4/+AeGi8lpRiv0a7bjr7gpHZj4VFbCwJ
	 nwGO8uJPvZv8Cn1WgMtHEaOWVBJZa67wB34ffrn/8MgX0Yug2rCeFOMS25pYcK16Br
	 Z9On8VpmYILEgL43pMG4ZuVJza46k9kr2zIvMgpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Hunkeler <jhunkeler@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 126/240] ASoC: amd: yp: Add OMEN by HP Gaming Laptop 16z-n000 to quirks
Date: Tue, 28 Mar 2023 16:41:29 +0200
Message-Id: <20230328142625.040865270@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joseph Hunkeler <jhunkeler@gmail.com>

[ Upstream commit 22ce6843abec19270bf69b176d7ee0a4ef781da5 ]

Enables display microphone on the HP OMEN 16z-n000 (8A42) laptop

Signed-off-by: Joseph Hunkeler <jhunkeler@gmail.com>
Link: https://lore.kernel.org/r/20230216155007.26143-1-jhunkeler@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 36314753923b8..4e681e9c08fe5 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -255,6 +255,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "15NBC1011"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
+		}
+	},
 	{}
 };
 
-- 
2.39.2



