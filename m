Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830850;
	b=mKnRmmq6mtLTk67vuzGFYGtcvyK00JnjKNPgB6+dSMHwLq7YejvTrYvAkNoRPxkc36G3
	 VB4QL0RghNQMYK+FgYDunVG9C/YDFj/k8LPmW+j/KTJjIETHz38bDS0mR8BYLJitXWx+I
	 2flL70mZXlwoTGkE8XgDbfyOd9m6IFCTKmH/fu00g5AsPS0LHMFvt4Ya5ukqEltiiiZyB
	 N2JWRXdMz2yuInkQ1cOSs0qNiprUBLR9ZUsrXUePlROEmWx3p2iu9xV6nYQnzxXOEeDPt
	 7PKuJx4p1flS30SGstCmK9qrqo+I/mPrIMWM2d4Ps0DschPUoUs3hSBlVEenfixRFdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3iWc5fqWJFHCR68RQMt9B4/q8wiukcjlAvkzZBlZqks=;
	b=TVUW7Ki9LIktk5c+cdnFKKLhpQJsFGy50LZoV7apgSex+VegHhC+f0KuJE9pKv9cArOk
	 RIoihFo6NO5Ym4ABSWSvG1umG/G9/fdcPw2xcnXgSbr1G8xI1kOpuorawEfjbuJh6Pb/S
	 S2qCq+dJ4tDEUy09bkRVxP9eusGYLUZhmdWUeeACgNKAVh4Oue8kOThXXiJzWjDcO4CWy
	 VFbmw2LIvQGDfOODF7Z/EZOmCCkfhpO3VpKH7r2UFezVSG60LwocJ4SF2g2NN2yD9rkWo
	 a7hmHPJU9IEw0ahUHQgvw4MABW0RVxcjM68a/4rNwPdAvlL54UFaGLY5wO7KLYVaKGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMs134T9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16389606B2D8;
	Wed,  4 Nov 2026 22:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMs134T9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FE21F00919;
	Wed,  4 Nov 2026 22:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830849;
	bh=3iWc5fqWJFHCR68RQMt9B4/q8wiukcjlAvkzZBlZqks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMs134T98RnZ4R+X/Lnbz9du+yJlUnEe7IVqhq0P0CDGwB6dt1+5vpI+e6VaM5v6R
	 ZhCnoNO4uldrX3M0A17UG3orLD/WDDWVUbNbmK9nxYXkyZJlxK7Mz64aMuT1JYc7s4
	 6anRdb8HtJmEQyWrscSjxOA/0MOZ8OJH1dIsHkkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iva=20Kasprzakov=C3=A1?= <iva@yenya.net>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0359/1005] Bluetooth: fix BT dependency for submodules
Date: Wed,  4 Nov 2026 16:01:32 -0500
Message-ID: <20261104211054.138118004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iva Kasprzaková <iva@yenya.net>

[ Upstream commit 6ec1896b5331563fedf3f01014aba9c9e35d7f29 ]

The modules rfcomm (BT_RFCOMM), bnep (BT_BNEP), hidp (BT_HIDP), and
bluetooth_6lowpan (BT_6LOWPAN) are dependent on the bluetooth module
(BT, tristate) only transitively through the boolean BT_BREDR for the
first three and through the boolean BT_LE for the bluetooth_6lowpan.
Therefore, the modules can be selected as built-in even if the BT=m.
The combination of BT=m and =y for the said modules leads to the kernel
build system silently ignoring those modules, without ever compiling
them as built-in or as loadable modules.

Add BT as a direct dependency to the Kconfig of rfcomm, bnep, hidp, and
bluetooth_6lowpan. The modules set to =y when BT=m will default to =m,
rather then getting silently ignored by the build system.

Signed-off-by: Iva Kasprzaková <iva@yenya.net>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/Kconfig        | 2 +-
 net/bluetooth/bnep/Kconfig   | 2 +-
 net/bluetooth/hidp/Kconfig   | 2 +-
 net/bluetooth/rfcomm/Kconfig | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
index 6b2b65a667008..86618afb855d3 100644
--- a/net/bluetooth/Kconfig
+++ b/net/bluetooth/Kconfig
@@ -83,7 +83,7 @@ config BT_LE_L2CAP_ECRED
 
 config BT_6LOWPAN
 	tristate "Bluetooth 6LoWPAN support"
-	depends on BT_LE && 6LOWPAN
+	depends on BT && BT_LE && 6LOWPAN
 	help
 	  IPv6 compression over Bluetooth Low Energy.
 
diff --git a/net/bluetooth/bnep/Kconfig b/net/bluetooth/bnep/Kconfig
index aac02b5b0d170..f8087e2d2c00e 100644
--- a/net/bluetooth/bnep/Kconfig
+++ b/net/bluetooth/bnep/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config BT_BNEP
 	tristate "BNEP protocol support"
-	depends on BT_BREDR
+	depends on BT && BT_BREDR
 	select CRC32
 	help
 	  BNEP (Bluetooth Network Encapsulation Protocol) is Ethernet
diff --git a/net/bluetooth/hidp/Kconfig b/net/bluetooth/hidp/Kconfig
index e08aae35351a7..ba52c7296f18f 100644
--- a/net/bluetooth/hidp/Kconfig
+++ b/net/bluetooth/hidp/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config BT_HIDP
 	tristate "HIDP protocol support"
-	depends on BT_BREDR && HID
+	depends on BT && BT_BREDR && HID
 	help
 	  HIDP (Human Interface Device Protocol) is a transport layer
 	  for HID reports.  HIDP is required for the Bluetooth Human
diff --git a/net/bluetooth/rfcomm/Kconfig b/net/bluetooth/rfcomm/Kconfig
index 9b9953ebf4c02..e7af2d565cea8 100644
--- a/net/bluetooth/rfcomm/Kconfig
+++ b/net/bluetooth/rfcomm/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config BT_RFCOMM
 	tristate "RFCOMM protocol support"
-	depends on BT_BREDR
+	depends on BT && BT_BREDR
 	help
 	  RFCOMM provides connection oriented stream transport.  RFCOMM
 	  support is required for Dialup Networking, OBEX and other Bluetooth
-- 
2.53.0



