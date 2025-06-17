Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2372D2E92BC;
	Tue, 17 Jun 2025 15:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175873; cv=none; b=IM4rSSsKr05Oz7ShikxiOYi8O1HsiOgfC4qUuIqwpJqlaVua2geNwKtjBJk/syi+0O0TMia+J7ehKhmHN7IEp68wQDitbGS4vSkFPYsFm9IwX4nTPUjbMBlh96Kv5n5SRI7XorA1tvEf7uBgO9awyf9aw0PJCpnKTWtJhPJDlMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175873; c=relaxed/simple;
	bh=3ec4PhmvagJLuh0Z+DSPn76XYFD+nK6jO7O/2plels0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oxv8B3F7Ug6PsnZ0uggUU9zDJL+b/HP8IRLW3P9Mxvhy3+AyncnVnZkA9M6w6BR9mwUMB5Sg0Ngzlv+kOMoR0Bhj42F74DdLg1QN2+iF4eEpCtQHpzhtnrX9IlfqwiAkMs0rLu4W1R534WDE8HiVgzh+xpbjnYNTG/noJR8lf74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMLffwXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMLffwXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F4AC4CEE3;
	Tue, 17 Jun 2025 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175873;
	bh=3ec4PhmvagJLuh0Z+DSPn76XYFD+nK6jO7O/2plels0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMLffwXbFj31QmjlAb5wqPES6xUIfjsG6s/EwrHXs0Ee2yiCvrKF2lXlt6b2WeVV+
	 0dYkWIXFF/dTHQSRE5sfT1LUjwficvZtS3Sx5iY5mGfdbQfpo0p5durd6ghawRjP8u
	 cZapuu7HBgBXPb4wqSjrMcVH6Y+4UBBRdR9ilk+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Reyes <zohrlaffz@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 171/512] wifi: rtw89: pci: enlarge retry times of RX tag to 1000
Date: Tue, 17 Jun 2025 17:22:17 +0200
Message-ID: <20250617152426.548185373@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit dda27a47c036d981ec664ac57e044a21035ffe12 ]

RX tag is sequence number to ensure RX DMA is complete. On platform
Gigabyte X870 AORUS ELITE WIFI7, sometimes it needs longer retry times
to complete RX DMA, or driver throws warnings and connection drops:

  rtw89_8922ae 0000:07:00.0: failed to update 162 RXBD info: -11
  rtw89_8922ae 0000:07:00.0: failed to update 163 RXBD info: -11
  rtw89_8922ae 0000:07:00.0: failed to update 32 RXBD info: -11
  rtw89_8922ae 0000:07:00.0: failed to release TX skbs

Fixes: 0bc7d1d4e63c ("wifi: rtw89: pci: validate RX tag for RXQ and RPQ")
Reported-by: Samuel Reyes <zohrlaffz@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/f4355539f3ac46bbaf9c586d059a8cbb@realtek.com/T/#t
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250509013433.7573-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 0ac84f968994b..e203d3b2a8274 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -228,7 +228,7 @@ int rtw89_pci_sync_skb_for_device_and_validate_rx_info(struct rtw89_dev *rtwdev,
 						       struct sk_buff *skb)
 {
 	struct rtw89_pci_rx_info *rx_info = RTW89_PCI_RX_SKB_CB(skb);
-	int rx_tag_retry = 100;
+	int rx_tag_retry = 1000;
 	int ret;
 
 	do {
-- 
2.39.5



