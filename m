Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF868F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C82C433EF;
	Mon, 13 Feb 2023 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300119;
	bh=yorRmegcEMjxtvp0OBxTkwb3JmgPG9YaDHnqfeB7w54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOFUAVqwOOsB8odfa2aspViO2wXqEYBGYpGmrf9DFyL+k2XQI8HhLDMg+hlFBPF9C
	 ktALoZ1ZPmwD+sFdx18p0nsA99wuiOwU4eeBBBSD+m11pYmG4quvQMErt3S9Fzbjov
	 /intWLqeiK+u/gQiqT6KTHDXb1tA1DcOFzdbJGNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guodong Liu <Guodong.Liu@mediatek.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/114] pinctrl: mediatek: Fix the drive register definition of some Pins
Date: Mon, 13 Feb 2023 15:48:26 +0100
Message-Id: <20230213144745.886882975@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guodong Liu <Guodong.Liu@mediatek.com>

[ Upstream commit 5754a1c98b18009cb3030dc391aa37b77428a0bd ]

The drive adjustment register definition of gpio13 and gpio81 is wrong:
"the start address for the range" of gpio18 is corrected to 0x000,
"the start bit for the first register within the range" of gpio81 is
corrected to 24.

Fixes: 6cf5e9ef362a ("pinctrl: add pinctrl driver on mt8195")
Signed-off-by: Guodong Liu <Guodong.Liu@mediatek.com>
Link: https://lore.kernel.org/r/20230118062116.26315-1-Guodong.Liu@mediatek.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt8195.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8195.c b/drivers/pinctrl/mediatek/pinctrl-mt8195.c
index 89557c7ed2ab0..09c4dcef93383 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8195.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8195.c
@@ -659,7 +659,7 @@ static const struct mtk_pin_field_calc mt8195_pin_drv_range[] = {
 	PIN_FIELD_BASE(10, 10, 4, 0x010, 0x10, 9, 3),
 	PIN_FIELD_BASE(11, 11, 4, 0x000, 0x10, 24, 3),
 	PIN_FIELD_BASE(12, 12, 4, 0x010, 0x10, 12, 3),
-	PIN_FIELD_BASE(13, 13, 4, 0x010, 0x10, 27, 3),
+	PIN_FIELD_BASE(13, 13, 4, 0x000, 0x10, 27, 3),
 	PIN_FIELD_BASE(14, 14, 4, 0x010, 0x10, 15, 3),
 	PIN_FIELD_BASE(15, 15, 4, 0x010, 0x10, 0, 3),
 	PIN_FIELD_BASE(16, 16, 4, 0x010, 0x10, 18, 3),
@@ -708,7 +708,7 @@ static const struct mtk_pin_field_calc mt8195_pin_drv_range[] = {
 	PIN_FIELD_BASE(78, 78, 3, 0x000, 0x10, 15, 3),
 	PIN_FIELD_BASE(79, 79, 3, 0x000, 0x10, 18, 3),
 	PIN_FIELD_BASE(80, 80, 3, 0x000, 0x10, 21, 3),
-	PIN_FIELD_BASE(81, 81, 3, 0x000, 0x10, 28, 3),
+	PIN_FIELD_BASE(81, 81, 3, 0x000, 0x10, 24, 3),
 	PIN_FIELD_BASE(82, 82, 3, 0x000, 0x10, 27, 3),
 	PIN_FIELD_BASE(83, 83, 3, 0x010, 0x10, 0, 3),
 	PIN_FIELD_BASE(84, 84, 3, 0x010, 0x10, 3, 3),
-- 
2.39.0



