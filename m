Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F371B2182;
	Tue, 15 Oct 2024 13:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998277; cv=none; b=YK87Li0l9EApvIhCmC+deV1mt1Jwfs8eArIrjxOH9/qA0cfC1wItLRBFJjDNr8WIyswMzkI917VzoQRvmu792vYmSNnauUtcds6gEEtge1Tlz7PdQ57N0iGsuAiqP8L2fr93fEn5vvtdlz300O1jFbJfRFHG7EnUCZPu/qBsIh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998277; c=relaxed/simple;
	bh=D2FZKkPmzWzJ4Fq3qU9++fzRZnkTs9KPSHESR32LU7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvEbt4qDMbguCaTlJ+ftyaqNNKfJIusQXq92SphalRGm6TZRchVi0+7L/oGamA5FNDrvy6QfOF1ROKtUBB57j1Zg0Y3fQw76G+EDWO+gyYPsAggt/I1fT/tJwHRE5WaxcK7RBqMAtsFAaQfsbDu4xYb1O0pgZTGkQ3R0AcFLm80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYcQCVtT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYcQCVtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C253C4CEC6;
	Tue, 15 Oct 2024 13:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998277;
	bh=D2FZKkPmzWzJ4Fq3qU9++fzRZnkTs9KPSHESR32LU7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYcQCVtTBiDQ+3o0Q+gAUtiwVm6jGd15qwHCDcymqLYh3fs+n6e7YdP3gMwBxEs2k
	 2TkN2otV5sQPNr4yA+dZUAxp289OGW/nTJMy+c/EQqO4gJ/CyxJewZ+hCL/9UG/b+Y
	 L+0xoy7qbc/cG0IhwLujQq8FV22xFLtgCinTVBAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 430/518] r8169: Fix spelling mistake: "tx_underun" -> "tx_underrun"
Date: Tue, 15 Oct 2024 14:45:34 +0200
Message-ID: <20241015123933.587972819@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4c588fc43eb9b..6017682536e0e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -569,7 +569,7 @@ struct rtl8169_counters {
 	__le64	rx_broadcast;
 	__le32	rx_multicast;
 	__le16	tx_aborted;
-	__le16	tx_underun;
+	__le16	tx_underrun;
 };
 
 struct rtl8169_tc_offsets {
@@ -1670,7 +1670,7 @@ static void rtl8169_get_ethtool_stats(struct net_device *dev,
 	data[9] = le64_to_cpu(counters->rx_broadcast);
 	data[10] = le32_to_cpu(counters->rx_multicast);
 	data[11] = le16_to_cpu(counters->tx_aborted);
-	data[12] = le16_to_cpu(counters->tx_underun);
+	data[12] = le16_to_cpu(counters->tx_underrun);
 }
 
 static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
-- 
2.43.0



