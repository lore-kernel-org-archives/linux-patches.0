Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253653B298;
	Mon, 14 Oct 2024 15:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919582; cv=none; b=CHLzdQOkjPQcK7omGps/HngHdCwsqA+G+NRbY2Dvh7kezd14c62K31SILilmDQErSAfX+zA5sdX68VHwo8o4dAYMeSs0u2LFfNMm/2gqJ5MsFTLTeEcjki15HH9/5cr4Z06ZZ/9kH4ITFI48snLXPeYbjjfq50mJ/yMLmBhQGJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919582; c=relaxed/simple;
	bh=tMH0vUD8BIMncS3GPYppMIxJmHv5KSpKmKoUpBmqQzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smfYjfV0ylIJEgSpC+xm8jf/29ishuTssODiSOac88PlzLdCh0lDxpgWEstRk8oxG2CI1h7tdCgm/sLGFqdIySCtlI6kbBpkSYj4soFEghNCSTeUtKn5Ihd2UCaYU7Gf5MccPojDXDEVBTWBE4a4YQecNIhnonXz+cKrDgXw7sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lp35FtY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lp35FtY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66887C4CEC3;
	Mon, 14 Oct 2024 15:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919582;
	bh=tMH0vUD8BIMncS3GPYppMIxJmHv5KSpKmKoUpBmqQzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lp35FtY8AtXs9nVkTUJkJBahLWxMM+NhlIzx/7wfab5WRoqiAohWeHQHq/r4kADvj
	 4UEoNtNuRF5p9x4I7mJqfnw8cATl9EvCSNccQ1xOXfsBRB7tf1Vnzx4XpWmYK08tbQ
	 Noq0kSSEzT8fOSOc9BohoxoSRUP2h1xT2ujb7vlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 648/798] r8169: Fix spelling mistake: "tx_underun" -> "tx_underrun"
Date: Mon, 14 Oct 2024 16:20:02 +0200
Message-ID: <20241014141243.509214380@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b187371fa2f0a..beebb2dcd00f5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -563,7 +563,7 @@ struct rtl8169_counters {
 	__le64	rx_broadcast;
 	__le32	rx_multicast;
 	__le16	tx_aborted;
-	__le16	tx_underun;
+	__le16	tx_underrun;
 };
 
 struct rtl8169_tc_offsets {
@@ -1710,7 +1710,7 @@ static void rtl8169_get_ethtool_stats(struct net_device *dev,
 	data[9] = le64_to_cpu(counters->rx_broadcast);
 	data[10] = le32_to_cpu(counters->rx_multicast);
 	data[11] = le16_to_cpu(counters->tx_aborted);
-	data[12] = le16_to_cpu(counters->tx_underun);
+	data[12] = le16_to_cpu(counters->tx_underrun);
 }
 
 static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
-- 
2.43.0



