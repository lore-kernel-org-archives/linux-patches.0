Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB6B42D747;
	Mon, 17 Aug 2026 14:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977467; cv=none; b=lA8w4oIyiAHsqTTYiZOEtsx+b42JueCkoc+xVHoCtn79H/gmuApJGpNrhjX17BdIrR6nyZ92gUL2VDAvU/T2qaiRx7vusN9nv7JcZRKMIL17SsSbTUO+lXNDXWirrQrtaWiHh7K0OyunrPGp1DEhmernUzufeSXzaia5TQe1D5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977467; c=relaxed/simple;
	bh=KTGW3bBXCzmSTE/6RDnT8kmiSIv/v0FeQeGTrSdTrJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpCGSWRY23fvSN/gCDwjtIWJ9fpxmVkl2k55KMISgsI0AVc3PxjqUxg+/xwR5YhJk/4mxZ2aASLfq5sIcMqhkZiIz1d8f4C5QIFbYWEl7ch0TmuH/+SUqL5aXtWHFm1er9B46lTWOUp292Q0efkIpQMHFC5Rr9eUCXY5Jh6WHg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGy2hEB6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGy2hEB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B241F00A3A;
	Mon, 17 Aug 2026 14:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977466;
	bh=Yv2hBbBHaJOkblbFBdUeLODmLuE98Qe5ZjJPffO/pOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGy2hEB6/wEccAFF31KyIQFLc1xoKMof1ip5a0wDVnh7hrMpw2jnwesZK+gIigadt
	 IWJPwBrkkU/kFKcvqXCSVXa63PU7anrEVCvvcc1LCquAi+LyIGjPvhIOjjJ2HsREeA
	 wmbLpTFrDAV74r/GbT2erjv3oU3UxVrOXUxK3734=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nava kishore Manne <nava.kishore.manne@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 339/456] phy: zynqmp: fix L0_TM_DISABLE_SCRAMBLE_ENCODER mask
Date: Mon, 17 Aug 2026 15:32:09 +0200
Message-ID: <20260817132552.861831877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Nava kishore Manne <nava.kishore.manne@amd.com>

commit 6cb22477929489a412df8d153e550e77a012e701 upstream.

The L0_TX_DIG_61 register bit 2 is a reserved read-only field.
The previous mask value 0x0f incorrectly included bit 2, causing
unintended writes to a reserved bit on every scrambler bypass
operation.

Correct the mask to (BIT(3) | GENMASK(1, 0)) to cover only the
valid scramble bypass control bits.

Fixes: 4a33bea00314 ("phy: zynqmp: Add PHY driver for the Xilinx ZynqMP Gigabit Transceiver")
Cc: stable@vger.kernel.org
Signed-off-by: Nava kishore Manne <nava.kishore.manne@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260627155229.2791113-2-radhey.shyam.pandey@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/xilinx/phy-zynqmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -53,7 +53,7 @@
 #define L0_TM_DIG_6			0x106c
 #define L0_TM_DIS_DESCRAMBLE_DECODER	0x0f
 #define L0_TX_DIG_61			0x00f4
-#define L0_TM_DISABLE_SCRAMBLE_ENCODER	0x0f
+#define L0_TM_DISABLE_SCRAMBLE_ENCODER	(BIT(3) | GENMASK(1, 0))
 
 /* PLL Test Mode register parameters */
 #define L0_TM_PLL_DIG_37		0x2094


