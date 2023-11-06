Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918A4200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPdGSHfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F824C433C8;
	Mon,  6 Nov 2023 13:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276226;
	bh=UC/Gih80UfWqJMubRGpC4KHqd5CsCTQLiTTUwEgI7J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPdGSHfJy921oXBfVBskgLEr4Vc1IrvM3zA7K4PX41kB/IYA8u93gCGOdFv6Dkvs1
	 vwKmTJIEUTvnlNrGy+9SoTKqxZueuHKfxSX0ftlYFDOeNCYdQlNZbsMjKx5cGJZ06B
	 yVnquhse4TwY0+EGWhGdn1xdufKj7Nt1TFmYPDkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/61] r8169: rename r8169.c to r8169_main.c
Date: Mon,  6 Nov 2023 14:03:04 +0100
Message-ID: <20231106130259.846441245@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130259.573843228@linuxfoundation.org>
References: <20231106130259.573843228@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 25e992a4603cd5284127e2a6fda6b05bd58d12ed ]

In preparation of factoring out firmware handling rename r8169.c to
r8169_main.c.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: dcf75a0f6bc1 ("r8169: fix the KCSAN reported data-race in rtl_tx while reading TxDescArray[entry].opts1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/Makefile                  | 1 +
 drivers/net/ethernet/realtek/{r8169.c => r8169_main.c} | 0
 2 files changed, 1 insertion(+)
 rename drivers/net/ethernet/realtek/{r8169.c => r8169_main.c} (100%)

diff --git a/drivers/net/ethernet/realtek/Makefile b/drivers/net/ethernet/realtek/Makefile
index 71b1da30ecb5b..7f68be4b9f51f 100644
--- a/drivers/net/ethernet/realtek/Makefile
+++ b/drivers/net/ethernet/realtek/Makefile
@@ -5,4 +5,5 @@
 obj-$(CONFIG_8139CP) += 8139cp.o
 obj-$(CONFIG_8139TOO) += 8139too.o
 obj-$(CONFIG_ATP) += atp.o
+r8169-objs += r8169_main.o
 obj-$(CONFIG_R8169) += r8169.o
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169_main.c
similarity index 100%
rename from drivers/net/ethernet/realtek/r8169.c
rename to drivers/net/ethernet/realtek/r8169_main.c
-- 
2.42.0



