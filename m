Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7525D3D994;
	Wed,  2 Oct 2024 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880419; cv=none; b=VtC+OzIzadGAVt6v2F6nNmTyYJ4LY4Xx7kIkuVZ/DDWXdc08uToejZs6n6/HOu3RGLCT5e6QNgwjFWga1tz2A3mHlxqA7tg2tGAP+E6WNu/X0+JlNvjvk9PvEQAVrQZZyT+wErGgslGDsbwqT9Sis8BRz0eXFKafJ+uk7jELCcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880419; c=relaxed/simple;
	bh=CXISafnoSFD/YZIG7oK9CNKHgPcgbDoCkyjmBFqb7Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smQcb+cbqqXcIO8jr5emZ0ldIhzBZX9hFnnR5Wsu1tUP19C6Q9EECbsbFY7/n3qtgrC5fNXGtQQ2Eac+N7vwaX2YVue2prQRJzst38KNrJO7jQgGslkpHtF2LEujbGXHaUqtvzXHnqI2Zc7Oo70FvafHA71epGTsEbS37DjPxRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxomoHqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxomoHqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C9BC4CEC2;
	Wed,  2 Oct 2024 14:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880419;
	bh=CXISafnoSFD/YZIG7oK9CNKHgPcgbDoCkyjmBFqb7Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxomoHqsYPgFEKf/j2oqVG4u4/jj2TzIazBYfFUeKSlKnb+bX175T8b1MMTOXboOF
	 wLRO3mBUDz0u2j6HhQ54rW/VqDRgHJXmVZzIHIW8ULyJKemsjtHsxDIXBNOl6LvN3N
	 5XR8BjXUeSp8vJcUne19jVVbAU3A/+22NIdIuZo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 6.6 452/538] wifi: mt76: mt7921: Check devm_kasprintf() returned value
Date: Wed,  2 Oct 2024 15:01:31 +0200
Message-ID: <20241002125810.282629073@linuxfoundation.org>
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

commit 1ccc9e476ce76e8577ba4fdbd1f63cb3e3499d38 upstream.

devm_kasprintf() can return a NULL pointer on failure but this returned
value is not checked. Fix this lack and check the returned value.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 6ae39b7c7ed4 ("wifi: mt76: mt7921: Support temp sensor")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviwed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://patch.msgid.link/20240903014455.4144536-1-make24@iscas.ac.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 57672c69150e..d1d64fa7d35d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -52,6 +52,8 @@ static int mt7921_thermal_init(struct mt792x_phy *phy)
 
 	name = devm_kasprintf(&wiphy->dev, GFP_KERNEL, "mt7921_%s",
 			      wiphy_name(wiphy));
+	if (!name)
+		return -ENOMEM;
 
 	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev, name, phy,
 						       mt7921_hwmon_groups);
-- 
2.46.2



