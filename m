Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043626;
	b=iHv5i0w8WRxEXKLbYYpvOeJYR0cFBDzYGjD1ipBDEmRFSwN7PnsC5TlopXmhwEEYbG2n
	 vxHCWSjruPwnZ2hKe4Z3Dw1JOrn7aJhi2eXAz63t6zmVt3jl4tSMCWr+fKXe2r1aLQVVD
	 QJvf4RXV/4Mjtj3R4C6oO9qZ8v9Wr4oZ7yZNhaCcdIAqs22Di29PDLEGuYmNSDyW0Qh+J
	 IwO9ZTpgC7BL6kqbito59y1Y7HuKiYfB44RqOOWbi7Bm/2nwxXOTCY+tTCJA10YkVb8ft
	 jheHmImUC8opTytdQg5FkkQSgpbwdQgBRYTRXeTN3DxlzF9OK5jqFi/i/h0Hfb0uKKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HCZpXdjx9Eg1rSicSUzj3xTYSd/uvR0jg6jo3qrUuLs=;
	b=C0b1WsTN/c8wZ5nqdBWHWwHwAG9ItpHSIgPu1cfh+/gIt3g4iebAYaR/rOrdOrIZ5Y7D
	 SKRK7qkWWHDcv7zUMJe2Vdk0Yr+Ikf/TqdLhq+XcIxHOUkgtA8T/ob/E+GHJUKYSl/8hy
	 NcrRuCZ3nxLho+pQS3gayKXJaIGq5/4L8u/YRSwFxCxUQxKDWGo+p6rS474XYFsnDp0GI
	 3aagI0pGS6almBJBdRCWjRLvmhQVI1+J4MOao9KCEex07co5kUj1i2617FcIce5XDGfKV
	 seLWErptrtZcvC1EXWj806gToMxyi3xCtVESuL1gR+ptA+9R2/0m/K5Ydg7/cLoygFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3jw0b+v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD3D60A262F;
	Wed, 18 Nov 2026 23:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3jw0b+v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA621F000CD;
	Wed, 18 Nov 2026 23:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043626;
	bh=HCZpXdjx9Eg1rSicSUzj3xTYSd/uvR0jg6jo3qrUuLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3jw0b+vo2OIBOzK4xzDNkailACmr8Zywv2hTp65KYA3zSoHA7CwSpsxpSXa6bBU6
	 pwRbEpz7lb/qAr8K9i3It1K4N2GRb/TvdvhSTV0cW6Ib9Kq2jTFNIE0cgrIrWcMtQA
	 2EnVJKwx5dA03A2iv7d+WxhOf4W9m0asRtgLv99k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0236/2857] soundwire: dmi-quirks: Disable ghost Realtek on Asus ROG Zephyrus Duo
Date: Wed, 18 Nov 2026 15:21:10 +0100
Message-ID: <20261118150209.951448324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 5b08a3afd2995e5312c4c47ffea9d21b651e8e13 ]

The Asus ROG Zephyrus Duo also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine
driver into attempting to create DAI links for the device. Add a
quirk to remove this device.

Suggested-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260807121425.1952003-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index f738e547a1f30..768255dd12db6 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -193,6 +193,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "GX651AR"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
-- 
2.53.0



