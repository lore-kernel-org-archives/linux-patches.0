Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F7F107B4;
	Sat,  3 Feb 2024 04:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933957; cv=none; b=B/7bpl59eMQKYTD/tNhSkNQCo8IIbd+uY7tTqjlFPVdt2ImF6GVTPnPMN3LUocgf4El3iM8OP0cETZyNTeaJ/u17DrH8Bqv4hYLPanCsqcohAgW6PNdtVwUuM4Yic3zpgjjAlZqKd5hiKLcePMBRwLf2aQjivqObqs2zWm7xHFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933957; c=relaxed/simple;
	bh=3wTCD02B8VHlj8C57PnEYWUYEsk4TU2+q8snCw/j+7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A7pmhEx4GTRkdxJQVZ4gtviSPehSI7O0V0eXoG8NoKJt34wtm7Wyw066WX7G0uqMwW8iNn0Q5BDIVcmcMIxYYNIFF9w8c8y+s48S4AuQRmkSnI5BC5U1HFye2+rL4PkQLvp7pR39cYAWkpaZQ0SX58Cf38rPuPZrXq7RuKNn8CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ON07oyMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ON07oyMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1913EC433C7;
	Sat,  3 Feb 2024 04:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933957;
	bh=3wTCD02B8VHlj8C57PnEYWUYEsk4TU2+q8snCw/j+7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ON07oyMwZnO8rhA9yowdbzr9l8ksy1qTuHwCIcPv5Pb5aYHTDbhAQGJ0XKI4BLriU
	 oioIxFWOisUyP2NSEvMJn3lAbtyVWc1/XkTLtxHVCfIFIQCPLKZd8n25WkFtJIoB7v
	 GqW/cBm9155Hxlvfw3y7PLEgdW0NrscfqD92UE0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 308/353] net: dsa: mt7530: fix 10M/100M speed on MT7988 switch
Date: Fri,  2 Feb 2024 20:07:06 -0800
Message-ID: <20240203035413.583964632@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit dfa988b4c7c3a48bde7c2713308920c7741fff29 ]

Setup PMCR port register for actual speed and duplex on internally
connected PHYs of the MT7988 built-in switch. This fixes links with
speeds other than 1000M.

Fixes: 110c18bfed41 ("net: dsa: mt7530: introduce driver for MT7988 built-in switch")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/r/a5b04dfa8256d8302f402545a51ac4c626fdba25.1706071272.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index d27c6b70a2f6..2333f6383b54 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2838,8 +2838,7 @@ static void mt753x_phylink_mac_link_up(struct dsa_switch *ds, int port,
 	/* MT753x MAC works in 1G full duplex mode for all up-clocked
 	 * variants.
 	 */
-	if (interface == PHY_INTERFACE_MODE_INTERNAL ||
-	    interface == PHY_INTERFACE_MODE_TRGMII ||
+	if (interface == PHY_INTERFACE_MODE_TRGMII ||
 	    (phy_interface_mode_is_8023z(interface))) {
 		speed = SPEED_1000;
 		duplex = DUPLEX_FULL;
-- 
2.43.0



