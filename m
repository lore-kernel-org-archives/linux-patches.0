Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B895381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0E7C433C0;
	Mon, 19 Jun 2023 10:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171467;
	bh=UL1wfdsUQBKlzGq2PJgrxBOWBUnxUBn/pysu3p7J4s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+vrSFyufCF1DXAWbVPUNAMJJXE52jCgCGWK+RuQkeuDf0i5ZUcat8EzKe/mfxFZi
	 2eIR05GVY+Vb3g1BsqAIPHSwlskIdxXh3vyp9cCBz1cVjpfPlFvq4nbfTCbe13aiIb
	 o4jlYk9OVRx5+2dTB9NAfi866xfAwczjHhrso7GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maya Matuszczyk <maccraft123mc@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/166] drm: panel-orientation-quirks: Change Airs quirk to support Air Plus
Date: Mon, 19 Jun 2023 12:28:21 +0200
Message-ID: <20230619102155.923808105@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maya Matuszczyk <maccraft123mc@gmail.com>

[ Upstream commit 1aa7f416175619e0286fddc5fc44e968b06bf2aa ]

It turned out that Aya Neo Air Plus had a different board name than
expected.
This patch changes Aya Neo Air's quirk to account for that, as both
devices share "Air" in DMI product name.

Tested on Air claiming to be an Air Pro, and on Air Plus.

Signed-off-by: Maya Matuszczyk <maccraft123mc@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230515184843.1552612-1-maccraft123mc@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index b1a38e6ce2f8f..0cb646cb04ee1 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -179,7 +179,7 @@ static const struct dmi_system_id orientation_data[] = {
 	}, {	/* AYA NEO AIR */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "AYANEO"),
-		  DMI_MATCH(DMI_BOARD_NAME, "AIR"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "AIR"),
 		},
 		.driver_data = (void *)&lcd1080x1920_leftside_up,
 	}, {	/* AYA NEO NEXT */
-- 
2.39.2



