Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3267C1CEAC2;
	Tue, 27 May 2025 17:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366942; cv=none; b=hD3j/cFKo94NwAdIMSXPCWMZRJ3l0mHSTxXSHZ7aclg752k4KgYxQdS5UM2SVi+ZX5YdTVUCpSUQBeG0V/ZvzF+DjRUkilhaMsL40M+JF9il1BPUMOJj8bliRiEEd1XNN/NVJ1Aa4IE3rWuarRM33KD+cxAAY6JY5/NACUIzaxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366942; c=relaxed/simple;
	bh=QW/fLO4h4R/lqKmGS/XDEM5qSFrQTYigY6i1CpgK9yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHpxHk1z9/e4bWKbUSCz7JHUbR+FoXVsjf/SmabLT6M235Q9w/w5ilPOhXbTgsRfrzdn9s+Eayf7JWnNczR91u2asLuxewS5r8CHBvOYRsx0W+iE1dp3XvOLBzIWDx5MhfJsffSO68I0YIVd0V5b/n9IuF4JBzKSLleMiPqJdVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHTzTp1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHTzTp1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92955C4CEE9;
	Tue, 27 May 2025 17:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366942;
	bh=QW/fLO4h4R/lqKmGS/XDEM5qSFrQTYigY6i1CpgK9yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHTzTp1iTrTEeb7q39kOLg0WuFA+SR4EKFexoZa6C0GOL8Pzq9yQ/wJdttZIvkyFM
	 KoK/00Gbh4D2L6wVguELx7WcmA3/+ODh933jUbA3Vonpl7eEZqYta00XTdtX9uQL41
	 VCLu4E2ox4NWnWtMWaxmGiwZyQ/OMREGdex1ThMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Salvaterra <rsalvaterra@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 227/783] r8169: increase max jumbo packet size on RTL8125/RTL8126
Date: Tue, 27 May 2025 18:20:24 +0200
Message-ID: <20250527162522.369061918@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 473367a5ffe1607a61be481e2feda684eb5faea9 ]

Realtek confirmed that all RTL8125/RTL8126 chip versions support up to
16K jumbo packets. Reflect this in the driver.

Tested by Rui on RTL8125B with 12K jumbo packets.

Suggested-by: Rui Salvaterra <rsalvaterra@gmail.com>
Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/396762ad-cc65-4e60-b01e-8847db89e98b@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4ead966727734..485ecd62e585d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -89,6 +89,7 @@
 #define JUMBO_6K	(6 * SZ_1K - VLAN_ETH_HLEN - ETH_FCS_LEN)
 #define JUMBO_7K	(7 * SZ_1K - VLAN_ETH_HLEN - ETH_FCS_LEN)
 #define JUMBO_9K	(9 * SZ_1K - VLAN_ETH_HLEN - ETH_FCS_LEN)
+#define JUMBO_16K	(SZ_16K - VLAN_ETH_HLEN - ETH_FCS_LEN)
 
 static const struct {
 	const char *name;
@@ -5353,6 +5354,9 @@ static int rtl_jumbo_max(struct rtl8169_private *tp)
 	/* RTL8168c */
 	case RTL_GIGA_MAC_VER_18 ... RTL_GIGA_MAC_VER_24:
 		return JUMBO_6K;
+	/* RTL8125/8126 */
+	case RTL_GIGA_MAC_VER_61 ... RTL_GIGA_MAC_VER_71:
+		return JUMBO_16K;
 	default:
 		return JUMBO_9K;
 	}
-- 
2.39.5



