Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507241DED48;
	Tue,  8 Oct 2024 13:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392870; cv=none; b=gw5oUHuJJZ10qZWY61D1nMb3BzFaFtJTYbhkO73vmLqygIc4OMkvx2j6fEGpJ0dj/jLTL25lC+wiFr4DXsHl/NOgD3TFf6Mc7A7KXWJIdjwIu6NrkNxQNFDZrvu7Pz2PFrw+5NsKwAup9eVUrA4+SnYqeFhQBoAgwyCDGJ3M02Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392870; c=relaxed/simple;
	bh=kPqd2+0KAi/sU9miErBMAqyDCHWNcXCXPqW6xXAyxqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfWHYg1F6l9ye8d8n5vBrawnLbmzsqOgUKMQOO4IF91ntuIhp/7evgp3/balti+UoGVwUl+TC9FmBpOy+eXuPzfXA8flLWzA3KYqglEte04jCXYWeenGUEtBd+oQcCEXqrRV5SoO/82zh9H+OSPIyk3ycDcZ0PWkD2u+QkMxKLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUYIl7Ni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUYIl7Ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B213DC4CECC;
	Tue,  8 Oct 2024 13:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392870;
	bh=kPqd2+0KAi/sU9miErBMAqyDCHWNcXCXPqW6xXAyxqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUYIl7Nill7MejPcKPIJ2nBwaQOMSJQoei2WLXewW7Ck48mrpq++1E0poK4xNSSsn
	 5Yrm+oe7Ms0lPtlLa4dE3DBAh2O31/BNn2K8YaafnxHDhre3r87kpNBtFNP01n2PPr
	 s+xj2TJOj6oYWLEKuJcKkrjBKyr/ZcPzhEwbqVNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 542/558] r8169: Fix spelling mistake: "tx_underun" -> "tx_underrun"
Date: Tue,  8 Oct 2024 14:09:32 +0200
Message-ID: <20241008115723.564131331@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 3507c2e28110d..4c22e6f602702 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -576,7 +576,7 @@ struct rtl8169_counters {
 	__le64	rx_broadcast;
 	__le32	rx_multicast;
 	__le16	tx_aborted;
-	__le16	tx_underun;
+	__le16	tx_underrun;
 };
 
 struct rtl8169_tc_offsets {
@@ -1841,7 +1841,7 @@ static void rtl8169_get_ethtool_stats(struct net_device *dev,
 	data[9] = le64_to_cpu(counters->rx_broadcast);
 	data[10] = le32_to_cpu(counters->rx_multicast);
 	data[11] = le16_to_cpu(counters->tx_aborted);
-	data[12] = le16_to_cpu(counters->tx_underun);
+	data[12] = le16_to_cpu(counters->tx_underrun);
 }
 
 static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
-- 
2.43.0



