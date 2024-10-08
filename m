Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAEE1DE89A;
	Tue,  8 Oct 2024 13:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394257; cv=none; b=cngTk+tw9drEDHUVfLeUtjPdWyO5KIvWWB2q0i2YtoRza9SxfGxu6Xv5jcnA3wu1pp+S2btnWlqId27wynb1Vq7gmmstW7+giqMEeDeST8LPwTBhfKsuSHiE98ZT1eBnUSPt/Xl84sfXaZuA7LFNYwAMygLQLN4Ipow1VXg95PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394257; c=relaxed/simple;
	bh=o206EfaSPRrXzI+LR0e5yzNETS5afby1DvdIuxp+GgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoKRv/KmWXHabAITCLJKkAZHtFXYxxkGtcqexMFGGq8iXzoJ/BPDjnTGdzOfreAJtSHnnnJ0Xr/DaP8+Lq2/i4yC5o7vxb8ZAF9/QKawMpJlT+UPtChO8T3KlftwiFDdPonpnB33TEmwlEwNH5UvBQUpvhX0mpqrNSa3H45Ch3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DkvIYHVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DkvIYHVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB27C4CECF;
	Tue,  8 Oct 2024 13:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394256;
	bh=o206EfaSPRrXzI+LR0e5yzNETS5afby1DvdIuxp+GgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DkvIYHVfaaV/kEHDYgPPrYsghrYdsgcfZMgrWCRqrrexIPdDB2F4JrH9tdqfiKx6A
	 YDiXEkoCdV40q9RepH4GKgLN8y3G77GpgIe1fjT4aBzECp5DfdugkntIvBn1QdrdBI
	 DQzp6HzfJ2tqHIpInqYK+5NLqRo+a6bmi5Yr7EkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 358/386] r8169: Fix spelling mistake: "tx_underun" -> "tx_underrun"
Date: Tue,  8 Oct 2024 14:10:03 +0200
Message-ID: <20241008115643.470989198@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 8df9439389a44fb2cc4ef695e08d6a8870b1616c ]

There is a spelling mistake in the struct field tx_underun, rename
it to tx_underrun.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/20240909140021.64884-1-colin.i.king@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ced8e8b8f40a ("r8169: add tally counter fields added with RTL8125")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8a732edac15a0..382ba8b04cbfa 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -566,7 +566,7 @@ struct rtl8169_counters {
 	__le64	rx_broadcast;
 	__le32	rx_multicast;
 	__le16	tx_aborted;
-	__le16	tx_underun;
+	__le16	tx_underrun;
 };
 
 struct rtl8169_tc_offsets {
@@ -1726,7 +1726,7 @@ static void rtl8169_get_ethtool_stats(struct net_device *dev,
 	data[9] = le64_to_cpu(counters->rx_broadcast);
 	data[10] = le32_to_cpu(counters->rx_multicast);
 	data[11] = le16_to_cpu(counters->tx_aborted);
-	data[12] = le16_to_cpu(counters->tx_underun);
+	data[12] = le16_to_cpu(counters->tx_underrun);
 }
 
 static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
-- 
2.43.0



