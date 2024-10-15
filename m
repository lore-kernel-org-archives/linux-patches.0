Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA441C57B1;
	Tue, 15 Oct 2024 12:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993989; cv=none; b=qrOI0jNXm5zGDL4Lg91X3dvA7G+RcQ8zmHLthRK1gTcFxR9oWkAE3Q0vFgYGdBcsqfXaUpkCHVZEtvaabUrF95P98zxVddogZ0RHo2rz18RmF0oPWjcP8B3MsJ6404zXFHpTIQaunBurZwmcJihxxcVWXPzNtbuAxbAbIZ8zofI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993989; c=relaxed/simple;
	bh=jbFlsaZUmqdFe4EqaqDLfsTq4qpxDCHsy/OkhYNkhBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyAs0jw6tWyqLM2OspswqCVS8Luti0M9mwKU4d9ze+xQmNzxj1R79pNq3kZWQ9zVehk2DvlBA2eEIfxJQBXMBb57cfqbGPeZKmv9yVtxHNU2Qi8dCbPX4O32czzoVD+u7zjMvpPicw95MKne3JlkC7KudEgxGtop4Q43z42F6gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gx+Z4KlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gx+Z4KlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C25C4CEC6;
	Tue, 15 Oct 2024 12:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993989;
	bh=jbFlsaZUmqdFe4EqaqDLfsTq4qpxDCHsy/OkhYNkhBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gx+Z4KlZMT1vgB0TYXJZDTLzK60cdbKZgtiznJEBSwN8gKOh5fSNIU+gI15HymN3t
	 0tKhhEHdY0yydx3UubUvn0hXZqkm8hwVZKrt7nn5rpEwF7ya5fwdB8B4qSCM9+1PhP
	 cJkFGwQMQkcg6c8kEV/mzOpq+xbFBYUBPnjRGvHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 574/691] r8169: Fix spelling mistake: "tx_underun" -> "tx_underrun"
Date: Tue, 15 Oct 2024 13:28:42 +0200
Message-ID: <20241015112503.124579965@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 49a3cd4ce89c2..f6e0424bf83d5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -575,7 +575,7 @@ struct rtl8169_counters {
 	__le64	rx_broadcast;
 	__le32	rx_multicast;
 	__le16	tx_aborted;
-	__le16	tx_underun;
+	__le16	tx_underrun;
 };
 
 struct rtl8169_tc_offsets {
@@ -1666,7 +1666,7 @@ static void rtl8169_get_ethtool_stats(struct net_device *dev,
 	data[9] = le64_to_cpu(counters->rx_broadcast);
 	data[10] = le32_to_cpu(counters->rx_multicast);
 	data[11] = le16_to_cpu(counters->tx_aborted);
-	data[12] = le16_to_cpu(counters->tx_underun);
+	data[12] = le16_to_cpu(counters->tx_underrun);
 }
 
 static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
-- 
2.43.0



