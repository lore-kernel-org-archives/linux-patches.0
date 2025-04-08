Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1B327CB21;
	Tue,  8 Apr 2025 12:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117106; cv=none; b=FfkEPGml0Oy2f98I2PkAcVpI7kmkfau3LRea2n19OsL9Uo7T4TK6nFdns3cQCV6+v6pBs3IIuDK+uKjGxNMoPy14GmviIXsTY233LqP6Yw+gP5QhPp+TYVBfROSWQyEQwk5/wsEOzYVFIRFuhOSD2hVIAwwoaruHhRPNL2OiqdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117106; c=relaxed/simple;
	bh=OMKBcjZRu8RYnWbIwKjbM9gAHAhkmN2tk8IIJ1jzI3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgAIFXSM4G7liiQcgIZYJeCoF4skJmrPvphBz9IbgXKdm4IgVVaO4G2tdsppZ/ZC6/SQiTdKjBZKMzAZh5Ufn5ayADSTgqybHZDn8ZwQ2jmx8Y0Lm19xe1fBo+KAB5s9xUOpcJXNlIzg8mPloybe928rKRcfzkyzfdRe961nDxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3vA9el0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3vA9el0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E6BC4CEE5;
	Tue,  8 Apr 2025 12:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117106;
	bh=OMKBcjZRu8RYnWbIwKjbM9gAHAhkmN2tk8IIJ1jzI3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3vA9el0MMk9ojmBSwv7Mfi2dacwNG7HTQqPjst8vYfmmArLBKw++jOMpU6Y6L1AF
	 nBe+E5ZGizt9a6Rf2rfXdyDMeda7GtlJNsQcn1UZvitW4ztWBuiM+6rjcdiaxx+SxY
	 uYWOMzt1+jEmiD5Jyw/24aL7r1uomHwO/LmfBICk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 384/423] wifi: mt76: mt7925: remove unused acpi function for clc
Date: Tue,  8 Apr 2025 12:51:50 +0200
Message-ID: <20250408104854.829176001@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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


