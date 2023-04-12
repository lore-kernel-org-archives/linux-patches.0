Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C602E2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA1CC433D2;
	Wed, 12 Apr 2023 08:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289556;
	bh=4aQrJerB+MWE5Oj4yX/9WYrE4NapjAY9hboYbKt03Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0R/9dL2PUeFUdcUJrlBoUDUSRLbjy0Gh+zjd7J355uotpvF7rUGSysnY07FwIc7f
	 QNAFhUGlBqf5nN47jglNyYrVuMfLvxB0GQGAA8PQ0ZC4o2E3aXriuXl6fBS9dxNIfY
	 iXoHFPkEkypSRfYtGSVUDtow/AKPDY8bhnvGynBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.2 144/173] wifi: mt76: mt7921: fix fw used for offload check for mt7922
Date: Wed, 12 Apr 2023 10:34:30 +0200
Message-Id: <20230412082843.921877932@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit eb85df0a5643612285f61f38122564498d0c49f7 upstream.

Fix the firmware version used for offload capability check used by 0x0616
devices. This path enables offload capabilities for 0x0616 devices.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217245
Fixes: 034ae28b56f1 ("wifi: mt76: mt7921: introduce remain_on_channel support")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/632d8f0c9781c9902d7160e2c080aa7e9232d50d.1679997487.git.lorenzo@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -20,7 +20,7 @@ static const struct pci_device_id mt7921
 	{ PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x0608),
 		.driver_data = (kernel_ulong_t)MT7921_FIRMWARE_WM },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x0616),
-		.driver_data = (kernel_ulong_t)MT7921_FIRMWARE_WM },
+		.driver_data = (kernel_ulong_t)MT7922_FIRMWARE_WM },
 	{ },
 };
 


