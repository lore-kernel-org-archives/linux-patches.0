Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061073;
	b=VdRF2sWnq7YdkMHz0+kCJu+Aci9d5mXxON9l7N55fEfWDAFoHyvKNlNf15fx2Xqhtln0
	 u6grqWTu2p8+Rsa9wVX8vmiqt+AcefzmE5GTPcPIQ7eRIwohclYJVMOXjk+Gaww8V5io2
	 lgfPyH9N6KUAiQ/Iad0k/TGzJx5uKH3IqznuDHnApIVMYhg+6YZivMwYjbx4BNSQ7xeux
	 sfZwGS0nJm/iyOAPUQ0/rucAc/UFLRcG00Y9/Tt5rSGozCVD3v+Cn8U3w5eWC4/h21liH
	 zXI+LqISQaJWArtlAZuTDWSswnZECwH2954hjsDIQM1A0aUS7RL740o9LIWh3uFZBYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aiIBHQw/BQ8iBNWjoQpSeqETwq+rbwSlye0+md8cFik=;
	b=vg9veS9GcdEn8ApHUtDBKqcwJEn293N+7dh7zMo77x0YNJfbwHG/YW8rt/enWalWVOim
	 LaVbWB6oyyZFoO/NAqiVLgHxRrTuCa2dAn56Mc9R2rNcP+NBh8P43fRFsqPkwhjykyPQ4
	 1cnMUTMpxXH5rGnacaEi76WyI7zqxV0vmnaOr6hf9ELtsi5LzXKlCy5HegFwOvM11iB2/
	 zc7Ra7Iyl7G6/nSFVT9TCFSaJU3pnKIGDp/W/vvckWJCtL6MB6Ae3oS7xbYtm+N0DglXa
	 1OzRiJITcBaCVeomsck/9094DGmhUvuE65p//pHhlleaL3nzGX+g/2pHO7h9/+wIs7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uAaJhZTI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C3A606D80C;
	Sat,  7 Nov 2026 14:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uAaJhZTI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27051F008A3;
	Sat,  7 Nov 2026 14:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061072;
	bh=aiIBHQw/BQ8iBNWjoQpSeqETwq+rbwSlye0+md8cFik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uAaJhZTIltd2/8MdkJS702/inH+bujx3bFxO5S5hLGuY6hSsYhyEkc2MN6BB75yLH
	 8zOsg+ZoULMqjvH47BS65XqagpDLmieO+9JdcSLWKSFoSW79AoTqXplaM14nU8EaY8
	 8Y9IR9pEwAUgJ8o3yqSo92cenhS20VrTX0+bhfl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Leussler <robert.leussler@leica-geosystems.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0372/1536] rtc: ds1307: fix RX8130 wakeup alarm WADA bit for day-of-month mode
Date: Sat,  7 Nov 2026 08:39:48 -0500
Message-ID: <20261107135008.090852234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Leussler <robert.leussler@leica-geosystems.com>

[ Upstream commit 878d93aaa596a861dbc8d71f7c38e62a2e805f01 ]

The RX8130 wakeup alarm never fired when set via
/sys/class/rtc/rtc0/wakealarm. The root cause is that the WADA bit
(bit 3) in the Extension register (0x1c) was never set before
programming the alarm registers.

Per the RX8130 datasheet:
WADA=0 - Week alarm: register 0x19 is compared against day-of-week
WADA=1 - Day alarm:  register 0x19 is compared against day-of-month

rx8130_set_alarm() always writes a BCD day-of-month value to alarm
register 0x19, so WADA must be 1. With WADA=0 the hardware matched the
day-of-month value (e.g. 15) as a day-of-week index, which is always
out of range (valid weekdays are 0-6), so the alarm interrupt was never
asserted.

Fix by setting the WADA bit in rx8130_set_alarm() before writing the
Extension register back to the device.

This is consistent with rx8130_read_alarm(), which decodes the same
register under the same assumption (24-hour and day-of-month mode).

Signed-off-by: Robert Leussler <robert.leussler@leica-geosystems.com>
Link: https://patch.msgid.link/20260721081907.3518648-1-robert.leussler@leica-geosystems.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 858c29494f5f5..0b32e94f4fe51 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -662,7 +662,7 @@ static int rx8130_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	if (ret < 0)
 		return ret;
 
-	ctl[0] &= RX8130_REG_EXTENSION_WADA;
+	ctl[0] |= RX8130_REG_EXTENSION_WADA;
 	ctl[1] &= ~RX8130_REG_FLAG_AF;
 	ctl[2] &= ~RX8130_REG_CONTROL0_AIE;
 
-- 
2.53.0



