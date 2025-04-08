Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362052192F2;
	Tue,  8 Apr 2025 11:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112126; cv=none; b=OtzVCAZPJM/4eNpiIixhCqJAk8kvdXKdsADiTW4Yh5HJyjbrGG1qlnlLSgHSg9wrlbeZVrvJox+bUKljtF2MNznGnOTJ6EoSVTY95ahgSDH1UeCv/L+c6YcNCFFxOptVuTBdjEm7vzEMooj1RJQ292Xarcq9nD8C2WGRBZ8HTC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112126; c=relaxed/simple;
	bh=mAQj+8RTAkeQktk78uYPcmjWmiB9qNNnuP0ky51tru4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaxGWWszO1shKRxQGoUfBDstz+z2bd5TZYhayhloWUs8Uzfi1pwXmB+X0YRqTUVK6cK2NerHQp2R10HsTXvxVuT4mR65e43kjYyUJZrGW7mSybGtUxyx6P/Q98KR+kNCI4jHs752NWZKicnwTH6lMEtCDeJOFVFhOBO2NgCRB0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXfI0XPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXfI0XPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577F3C4CEE5;
	Tue,  8 Apr 2025 11:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112125;
	bh=mAQj+8RTAkeQktk78uYPcmjWmiB9qNNnuP0ky51tru4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXfI0XPfPZPt+yTY2uCsM+eiHJI0tA5qq72VeGA2yGMjgB02io2dQ7uxkzvZmO6oV
	 28y2T2iSbxIB6MBLVy2llbl/JuraiJjMYR4q1Zwg4E2XW/z0hzbTVPzeceXSQBsumw
	 gdzFgbZFx/he6UDKq0COtrjtPF6alkNOH/HQB2z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.14 686/731] wifi: mt76: mt7925: remove unused acpi function for clc
Date: Tue,  8 Apr 2025 12:49:43 +0200
Message-ID: <20250408104930.223397835@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3155,7 +3155,6 @@ __mt7925_mcu_set_clc(struct mt792x_dev *
 
 		.idx = idx,
 		.env = env_cap,
-		.acpi_conf = mt792x_acpi_get_flags(&dev->phy),
 	};
 	int ret, valid_cnt = 0;
 	u8 i, *pos;


