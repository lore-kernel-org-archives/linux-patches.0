Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52141F193C;
	Wed, 23 Apr 2025 15:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420450; cv=none; b=EVzSKAmThlOsW42e8sEydQHyr2hVHq6GSxa0mB7mt5+QnY21tpBznDWiwrDX52Hg3hqx4HB7YzXf2GmGeWhGnN7IxpVQ5XzvhXw/hdKCRty1+2P85fzWAachSPT0/JCWnpdECYnncyrTUTzpfl+RPXX7bM0Kv+LSti8VLCPr5Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420450; c=relaxed/simple;
	bh=lV0y9pm8wr5PR7NJQ983DB/sz/2Hk32NaBxKb47NsD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jg+9ZvUEACSyjQiJ6cMLWeRDA6yedEPRYaXlt1LHh66CzHPKPzTLVQA9OaXtk3oW3/ogQo+8s4DVNxSOgrpkzKhyqUhezQSlQFrbPl5WE/sZBUuYVNHcftbP4p7tFGePs0tfdwOUZzm+eoVFK8JUhi6MAnumtBSPtDX1AREsry4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5Evogg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5Evogg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD79C4CEE2;
	Wed, 23 Apr 2025 15:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420450;
	bh=lV0y9pm8wr5PR7NJQ983DB/sz/2Hk32NaBxKb47NsD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5Evogg+cqUcnDOvfvIF1ogL4JY8g0DT9Xoo6EwKTGgoXGNJwMk+1pYEVhffHhjDt
	 quy2q14dzb8co3aOaBICrrKqJewb9JnGL1LOi9grvoDd/pG9rr+KQyPbIWy7FDYJ/i
	 0iQz/aHF/uaCxtZbsJzAs16lEXGEyE73UrwQiMec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/291] wifi: mt76: mt76x2u: add TP-Link TL-WDN6200 ID to device table
Date: Wed, 23 Apr 2025 16:40:37 +0200
Message-ID: <20250423142626.354985165@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 06cccc2ebbe6c8a20f714f3a0ff3ff489d3004bb ]

The TP-Link TL-WDN6200 "Driverless" version cards use a MT7612U chipset.

Add the USB ID to mt76x2u driver.

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Link: https://patch.msgid.link/20250317102235.1421726-1-uwu@icenowy.me
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index 55068f3252ef3..d804309992196 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -21,6 +21,7 @@ static const struct usb_device_id mt76x2u_device_table[] = {
 	{ USB_DEVICE(0x0846, 0x9053) },	/* Netgear A6210 */
 	{ USB_DEVICE(0x045e, 0x02e6) },	/* XBox One Wireless Adapter */
 	{ USB_DEVICE(0x045e, 0x02fe) },	/* XBox One Wireless Adapter */
+	{ USB_DEVICE(0x2357, 0x0137) },	/* TP-Link TL-WDN6200 */
 	{ },
 };
 
-- 
2.39.5



