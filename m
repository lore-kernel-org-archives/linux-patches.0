Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037340;
	b=3yWqJjPiEjKCzyP2qsrA99h9iFa5c3NI4054C7RdRCuAYHgDY2RmHrgpD5IYAKln3SOC
	 CC7dVpR6Qixr6r8/mTUgQ+ckKo7I1HvvgR8fctS0CgkA/JBPr7uoaUd1EUAcpZsgY9ppF
	 ZVN+jwlb21c8if1lA4j1NP5cR9tJQS+vdXfKoga4jv2vJCmh+HJaWY/rBiuHGc4t+nuQp
	 xcJwCdwMwPfpM9+WHhz/ioTNMDjC5a44DDV8bRNDAEXghS3Go0aVMIZQ/6Jk4UdDSfy3m
	 R6k0ykebZAu+NNaQKa+xNCdp/C9RaIreIaSJxHGi3P12mV8c0YawcSY+vMzXyJ0SdLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eGGLYl+vo+VcQCrpFHLkc283NHUsCkEvVzFCI0b9mlg=;
	b=DRYk/yM3u6iIfiR4NNepxV9HSaVGOOq/VoFhNp+i/piEEFujRf2fTu7EpngSszWidfRq
	 RTwyOW3jfzSO8RHCzjXIs6V/BGi4JvjOLmbEZZgKg88SLjfEdldsGFm9A2F9K2SnDzIk8
	 eIR45WIbzTsiRk060eiamO/tse1xuJxvkwLRtaQ4+qzLjM71zZkwPeauUb3+lR2JHL5K9
	 Km8dZM03/hMjyKIQk0kk95oXH4eEUx+wPFtzViF12HjXs0STiiXR1vRc94scFKQN3Cr9u
	 4L1ivBEPSXLQSBKW5emdMFbQl+zPVFyPOx47mqmL8xLVzcQe0+l+gOzuYhWmBQ8NPhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N35gdGty;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79859606A333;
	Wed, 18 Nov 2026 21:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N35gdGty
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991541F000C4;
	Wed, 18 Nov 2026 21:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037340;
	bh=eGGLYl+vo+VcQCrpFHLkc283NHUsCkEvVzFCI0b9mlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N35gdGtyHKf/yOb/Kpu8BPXCY/9AhwhZSU9jYZfiz9x20SNmtW4FuyoX56a4+M7WT
	 QhemwHXjelklsINY1INzcUdWWIHxC5w6UoDMvAOBKK4samleRnmpJ9Sqvb6/AxqMqd
	 zD2nnpN2vDf8j7lyjO9VNrOxNOSxEfMIWkr0Mhqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1369/3318] mtd: rawnand: ndfc: fix gcc uninitialized var
Date: Wed, 18 Nov 2026 15:33:11 +0100
Message-ID: <20261118150401.568368020@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit cceca8cb776b03e83985578f84bd730c30d57f70 ]

Now that this can be built with COMPILE_TEST, an unassigned variable was
found. Set to 0 to fix the W=1 error under GCC.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606141301.iyVdFgl7-lkp@intel.com/
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/ndfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/ndfc.c b/drivers/mtd/nand/raw/ndfc.c
index 29198c4af5e6d..a2e2238339ec1 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -188,7 +188,7 @@ static int ndfc_probe(struct platform_device *ofdev)
 	const __be32 *reg;
 	u32 ccr;
 	u32 cs;
-	int err, len;
+	int err, len = 0;
 
 	/* Read the reg property to get the chip select */
 	reg = of_get_property(ofdev->dev.of_node, "reg", &len);
-- 
2.53.0



