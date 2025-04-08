Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06067227BA4;
	Tue,  8 Apr 2025 12:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115389; cv=none; b=O2Y4orLMTaCdJjvdc5Ux0H2I306hD0BptR9i98uk1kqG1YSuBlwTPmNDRK0o7lS6hwXZZOLLxZ/Ha3srqi1xGuUhOqxaAY4oapXljsn/GeVxSYpUyZwjGBjtbXcflZedjuTVwc5BA2kkevhssShvBShL0yg0teUUsbUpLw1N2/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115389; c=relaxed/simple;
	bh=FUxqi1zfCwEsKm3+TI6P3UvtOBCxeuJfgIpMV6BcelU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQDRRjns9TydEXV54DApV9b+Zesr49Vh/lS2k2/vn8amBDaL2hJe0XSSYI5snN8t/3XdTCmWUQg3f20ExmYR8HsNyyO7qxoX5BHUyEy6sWTj2SxcoukKk2V5i+R6ZhnTGMmiatrs6W244yFH7XYI9QqR/zIVrpC3LReLua4jHWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/ytkdU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/ytkdU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C225C4CEE5;
	Tue,  8 Apr 2025 12:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115388;
	bh=FUxqi1zfCwEsKm3+TI6P3UvtOBCxeuJfgIpMV6BcelU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/ytkdU9jpWq/rOEMT4aEU+qfQDWIQNj5JW27L/geppwkU5ItbYGlyet2sctCfSIY
	 7s03p2myXBCzzjDm6o0mlz0JkjcU6xxuiJVEhP05dQHaXo5MO3wS/vWcuAHxgYR/l1
	 DXvHWF7RFPWlh14LYERNoQz+uI3UKcGLC61cMYtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.13 455/499] wifi: mt76: mt7925: remove unused acpi function for clc
Date: Tue,  8 Apr 2025 12:51:07 +0200
Message-ID: <20250408104902.581935078@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit b4ea6fdfc08375aae59c7e7059653b9877171fe4 upstream.

The code for handling ACPI configuration in CLC was copied from the mt7921
driver but is not utilized in the mt7925 implementation. So removes the
unused functionality to clean up the codebase.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250304113649.867387-4-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3117,7 +3117,6 @@ __mt7925_mcu_set_clc(struct mt792x_dev *
 
 		.idx = idx,
 		.env = env_cap,
-		.acpi_conf = mt792x_acpi_get_flags(&dev->phy),
 	};
 	int ret, valid_cnt = 0;
 	u8 i, *pos;


