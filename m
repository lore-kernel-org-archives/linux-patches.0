Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1387B388E43;
	Fri,  7 Aug 2026 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114307; cv=none; b=Y14jCQHygPoXW8Z7BQdIkDptMDVbBBJnuMIs/k7aZzTaTCwuGG2PEsoL/jDFaGQzc2aug+in1YkZLmNsopkH4rUVvniSTtxASziKWHi8tOmZUkM5i99F2Wn/bhG7tjtNDs88fWSJ+69oRwUy2dHVIsr4H/E/ybfpkVzwxuNzDBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114307; c=relaxed/simple;
	bh=mg2Ujh5UL20h9vw05t0o9tf5vrBQzv5VubJiE1zH7ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DaHdLYv3xs3EU4iwLQZFem+oXF+K4M9q1QSsXAqv9TgYLrcav1WnLCIbkw5DvFX2lpnpywmhvkmnnnl4JODd240BBv/2HIhFMtaxKeAYRV6XmKgX9ACkFV7nDkCMorFDAAhghY1CjEjS4F6da+vKACejv2JhAjUGsDO9iB+D38k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hG0x6Vsq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hG0x6Vsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE681F00A3A;
	Fri,  7 Aug 2026 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114306;
	bh=lv5khsyeo9MUJHePMguILfmG1xgMW+E6i+Zr1kJbCss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hG0x6VsqQo8LWCK7p9jfEVVrstYOmjY7YeXl3ndt1FLqD+vsSXXMecosUF0Jk9aEp
	 C7WjSK5HOInyw4/Ej9qVxA4STrJTZApxlnwSXYMja289C0F+kUgI9G4Qvx9btjprkp
	 c1jtZnyUU4U1OMMNkna/o6uELjGKccDPU17xdeKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nava kishore Manne <nava.kishore.manne@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 215/337] phy: zynqmp: fix L0_TM_DISABLE_SCRAMBLE_ENCODER mask
Date: Fri,  7 Aug 2026 16:36:58 +0200
Message-ID: <20260807143423.213238112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


