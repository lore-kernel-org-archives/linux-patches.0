Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C553B9D9D;
	Tue, 21 Jul 2026 22:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671632; cv=none; b=KTNsuVnjekX4Vac9u3abm85edAJUwJ+0JCPbDgv9jVVOoVyujj/SgRw1xW4Fuh0pVjwbjE3MRdNOXvpTT0qkaHwgGif0msIpBc1MTu/kru1biG+OnYkI3ppBLOTaB59eKfcppcP8Gmgnzr3G5yayvx+0yYaR0n/QZi1r63n570Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671632; c=relaxed/simple;
	bh=Nli2zTpxbmxZ8HNI4NoWiazPcfLecYryZ05R0Ix8Q3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIDL0joyfUyi8cixRNvkwL3adeX6CCSxxOyVzezr2dqZCj93v2A+5Gkn7enhLoRr3whMV0KAvH3JUt2+X9ttZ5+XBQi5v7qE3zFQRVqwACwdYaLh3qeJB6xv7k8U2vQ2mI2T3PQgNQZ+5Tv4WzCbhY6QUBfMuXCzL28RqjcJN5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUujs/Lp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUujs/Lp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0B01F000E9;
	Tue, 21 Jul 2026 22:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671630;
	bh=EqDc10bdugANvcC0qZ6eEYmMsSMg4HLeBta2NeQZv18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUujs/Lp9UOcOyAol2KPcWx24gGobeS8eXD17pg4m+yv4CsEqcHdkyDH9522jXnTZ
	 KayKQxWkw7D7hWGl8CufdhK8wNlQ5npxHM8KPHRnK4eBAy+WtNP/HWaBJvDhRRjvW1
	 /nif4OthnpVy+Vz2b6TC4szfsZnqYEHIVz8P10pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 320/843] pinctrl: mediatek: mt8516: Fix Schmitt trigger register offset of pins 34-39
Date: Tue, 21 Jul 2026 17:19:15 +0200
Message-ID: <20260721152413.218246353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Leonardo Scorcia <l.scorcia@gmail.com>

[ Upstream commit 1c3044cab23a056ea28da47da1cdd667a39df0b8 ]

The correct Schmitt trigger register offset for pins 34-39 is 0xA00.

Signed-off-by: Luca Leonardo Scorcia <l.scorcia@gmail.com>
Fixes: 264667112ef0 ("pinctrl: mediatek: Add MT8516 Pinctrl driver")
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt8516.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8516.c b/drivers/pinctrl/mediatek/pinctrl-mt8516.c
index 219fb4bc341f25..f94f9e08cd9869 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8516.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8516.c
@@ -252,7 +252,7 @@ static const struct mtk_pin_ies_smt_set mt8516_smt_set[] = {
 	MTK_PIN_IES_SMT_SPEC(24, 25, 0xA00, 12),
 	MTK_PIN_IES_SMT_SPEC(26, 30, 0xA00, 0),
 	MTK_PIN_IES_SMT_SPEC(31, 33, 0xA00, 1),
-	MTK_PIN_IES_SMT_SPEC(34, 39, 0xA900, 2),
+	MTK_PIN_IES_SMT_SPEC(34, 39, 0xA00, 2),
 	MTK_PIN_IES_SMT_SPEC(40, 40, 0xA10, 11),
 	MTK_PIN_IES_SMT_SPEC(41, 43, 0xA00, 10),
 	MTK_PIN_IES_SMT_SPEC(44, 47, 0xA00, 11),
-- 
2.53.0



