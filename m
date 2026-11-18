Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057694;
	b=s9/RqjmukLIpy6Vw85aXrR46KAgCxJaQAS8JEN4YSrBnKADh7C9fg3ejXJcx28fRwjDi
	 FeORn53RPAiCUkLrkyHUpb9riTvffgwsQN5Abu4Bu8Vz1nRD0qUur+hofsRKe7Ftm4a1k
	 uNeDp/9W9fB/od1vZ65T0629WCThfhkMNbs6bpfpgiyfQYidDosmfKxkNc8HsduxiA3zg
	 vi9NCnT92MLbFjP3oHOdUdb6A5Yg3LY8sK3FuWpQpRefDy8vZa40PIzmRxcVGhuBTh1fQ
	 GZwgf5BycReMX003maVnSLEhR96np6IstpO3FKSP8GiOkrARaMqrrodflqjM+wUyoQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QnromATK67rf4Tr1Sj1qI9EHdRejslUqHUR5P+x1JHU=;
	b=BgzEwD5SaWkxbiGwPFoT7AHJJLWGYF8GWzxdGCa1x4NPliSNKbbaDDICgWT0OB16jbt5
	 jzfOErjzbt8UsylW2APRpKz1pO07ggFaMk2C1G6F1ZcOIfoGBYrKPr0ftizQTVxgcwz7Z
	 EA+aH0/n459uaHz4th50Jdzk4BJaru8+wfTtTs+lnUI5wKI9mOiDdTpuZGCWXiRL58WMU
	 oN+l+AGvLroSBTlbZ5w+BInXraIEnCM+2a029Glpk82sjrLX1cWrlcYST+76o0KJK4eVy
	 RSm7q541jKx8uhIlqZMz/rldFq/BEW8h0qvg4oDVHRuYheLfTebciwoX8CKIDYGV4ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w6NyLCLY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0083606A325;
	Thu, 19 Nov 2026 03:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w6NyLCLY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD5C1F000C5;
	Thu, 19 Nov 2026 03:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057693;
	bh=QnromATK67rf4Tr1Sj1qI9EHdRejslUqHUR5P+x1JHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w6NyLCLYb7OXDkgYIL3Z6/RYmbtGZPkXVdwd+feD2HFsGTFLG9FhW0m1eoQBiPJ1j
	 C43oFEG/C7RB0oR1kGjKqRuRtNifDXsK5yH5tNFMZMtwBJrpyWauy5517uQBg6pfn8
	 NzgR78CHeH7wnlPtyYssJDJErdXsWtMadEx1fmgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Leussler <robert.leussler@leica-geosystems.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0181/1848] rtc: ds1307: fix RX8130 wakeup alarm WADA bit for day-of-month mode
Date: Wed, 18 Nov 2026 15:36:59 +0100
Message-ID: <20261118145919.095239098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 50e6cc94962a0..f26d8b48d43e5 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -674,7 +674,7 @@ static int rx8130_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	if (ret < 0)
 		return ret;
 
-	ctl[0] &= RX8130_REG_EXTENSION_WADA;
+	ctl[0] |= RX8130_REG_EXTENSION_WADA;
 	ctl[1] &= ~RX8130_REG_FLAG_AF;
 	ctl[2] &= ~RX8130_REG_CONTROL0_AIE;
 
-- 
2.53.0



