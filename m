Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EBE33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E604C433D2;
	Mon, 16 Jan 2023 16:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884811;
	bh=0e1cB6rDET+Dt2wIFFoOUdT/rkft9TXI9p7v/mduYO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUvS+Unr8NeEf+zf6w5ncUFYMyhNh03Yw7pMqXCr0vUCCeW8K0IXUsw2teaMD1ASf
	 5Be/NRZwqyyh5qp003H5hVNCQ4l9F8nIlrGiPh0YpDz5GpIOdapJFVzLKm9sIa4mzv
	 j1lEcDx2y28KjwYGssEFtRGGTQccTfcX/RSH0tJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/183] Revert "r8169: disable detection of chip version 36"
Date: Mon, 16 Jan 2023 16:51:12 +0100
Message-Id: <20230116154809.628736478@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 2ea26b4de6f42b74a5f1701de41efa6bc9f12666 ]

This reverts commit 42666b2c452ce87894786aae05e3fad3cfc6cb59.

This chip version seems to be very rare, but it exits in consumer
devices, see linked report.

Link: https://stackoverflow.com/questions/75049473/cant-setup-a-wired-network-in-archlinux-fresh-install
Fixes: 42666b2c452c ("r8169: disable detection of chip version 36")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/42e9674c-d5d0-a65a-f578-e5c74f244739@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a73d061d9fcb..fe8dc8e0522b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1996,10 +1996,7 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 
 		/* 8168F family. */
 		{ 0x7c8, 0x488,	RTL_GIGA_MAC_VER_38 },
-		/* It seems this chip version never made it to
-		 * the wild. Let's disable detection.
-		 * { 0x7cf, 0x481,	RTL_GIGA_MAC_VER_36 },
-		 */
+		{ 0x7cf, 0x481,	RTL_GIGA_MAC_VER_36 },
 		{ 0x7cf, 0x480,	RTL_GIGA_MAC_VER_35 },
 
 		/* 8168E family. */
-- 
2.35.1



