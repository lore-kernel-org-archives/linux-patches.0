Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D8E1EEE6;
	Wed,  2 Oct 2024 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880422; cv=none; b=G2/AtjduTu7sA59ZSd6n1LxFhfz7uCj/ECXWwQmR7Ymrmb+dyRjQsNjIOS3wxkSjg+Za/qCTtcvdQrj1R8jj+kJXb00Q8MT7pKLeza5vYdZyKzcA3Hj11s7G0eyi/ig6qd18HTn7iBrIFM1/FV1sl7j9OlGnlWzUU+pFye4P1Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880422; c=relaxed/simple;
	bh=yoUKgQc7HtJdSTztEUpjxi/k6s1GeR9Kvyxb4YD7qDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXsZObwQSUgwSXTHxBdMiddaQkk19Vry1OPEqXwsNOP5saFgqcp/ouHRE2+nxLzzU0fsKsCjdz9ab0+aRUKUDii4M1Dj0KbA3/Fztqw77pvYWaNmNu/rq0mvu6FRS+WnTat1rRzj35q4EJcC7tz/MJXYtVUeHcAx/gYCl3ZrFYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iu//lDW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iu//lDW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F99C4CECD;
	Wed,  2 Oct 2024 14:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880422;
	bh=yoUKgQc7HtJdSTztEUpjxi/k6s1GeR9Kvyxb4YD7qDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iu//lDW/AYHGhTb2sBL/vfn4m2mlj1u1s1Do29qt6e2nZh9umeg10KwZxn39DR3bH
	 ubkWgnHkXMlnoOXHk62TwikU94ay4dX+4UB10as2ugl+0JX6UPLAYhnmeX6T1xLXp2
	 IuOaUDDOWYeJrjkW1P1TM2OBI9peL9K/xy0IEiKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.6 453/538] wifi: mt76: mt7915: check devm_kasprintf() returned value
Date: Wed,  2 Oct 2024 15:01:32 +0200
Message-ID: <20241002125810.323790659@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 267efeda8c55f30e0e7c5b7fd03dea4efec6916c upstream.

devm_kasprintf() can return a NULL pointer on failure but this returned
value is not checked. Fix this lack and check the returned value.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 6ae39b7c7ed4 ("wifi: mt76: mt7921: Support temp sensor")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://patch.msgid.link/20240903014955.4145423-1-make24@iscas.ac.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 511e0d04eb95..6bef96e3d2a3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -194,6 +194,8 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 
 	name = devm_kasprintf(&wiphy->dev, GFP_KERNEL, "mt7915_%s",
 			      wiphy_name(wiphy));
+	if (!name)
+		return -ENOMEM;
 
 	cdev = thermal_cooling_device_register(name, phy, &mt7915_thermal_ops);
 	if (!IS_ERR(cdev)) {
-- 
2.46.2



