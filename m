Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36B21774B;
	Thu, 18 Jan 2024 10:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575307; cv=none; b=u2TshFcLi9NQhyGZlQ+4d428iC1W/VSqng7YVEAbjFsg/Sm9dTWJHddXpjym+f6GBuiF3+lkpFG1Y6yD99B2xyuJ2DIIqRePbLv2Zn0YJgt797dByRdrAY0mGtlUdHJ/dkr0Lq6SAQ4Dnrkd//I5kTA0GZ5iSMz8I5EqdA9L7xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575307; c=relaxed/simple;
	bh=nHemeRnK0/nfqo8b6NeHT1O6g7Jzv+EJLcg06iuBFaw=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=E4xD43bOsKcH3ay0ng1zN+zjL4TDLnXHMZ1AZ2FDnWbr7LnoVAgp9V7H7UPom496lvZP7HvZKyc+ExRRxAW6I9XCNB/XpIWdYKmq3usJhMj/0GiLt0UWsaZ6ppoanDQeKamkkO0qVhnlh5eGIcQMYO1lQFmzWio/q2eEdDmPRVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AMIUK3b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AMIUK3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24244C433F1;
	Thu, 18 Jan 2024 10:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575307;
	bh=nHemeRnK0/nfqo8b6NeHT1O6g7Jzv+EJLcg06iuBFaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0AMIUK3bEMYHSYumUuJUQXRbJgVJ3Cq+zjcmB8W+ncIlqsoTmEIdDNM+UQWCaG8yf
	 t/LjxfqRCmQr1lV4bx7tAi3UnGaVTtlXzvc6PZSFHgu6XGQjl1znr+33i9lRHObuI2
	 g0EQe8/g07K+Zk6C/MHltH5xEAGTucP+17fbjPA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Pekkarinen?= <jose.pekkarinen@foxhound.fi>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/150] Input: psmouse - enable Synaptics InterTouch for ThinkPad L14 G1
Date: Thu, 18 Jan 2024 11:48:27 +0100
Message-ID: <20240118104323.897778690@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Pekkarinen <jose.pekkarinen@foxhound.fi>

[ Upstream commit c1f342f35f820b33390571293498c3e2e9bc77ec ]

Observed on dmesg of my laptop I see the following
output:

[   19.898700] psmouse serio1: synaptics: queried max coordinates: x [..5678], y [..4694]
[   19.936057] psmouse serio1: synaptics: queried min coordinates: x [1266..], y [1162..]
[   19.936076] psmouse serio1: synaptics: Your touchpad (PNP: LEN0411 PNP0f13) says it can support a different bus. If i2c-hid and hid-rmi are not used, you might want to try setting psmouse.synaptics_intertouch to 1 and report this to linux-input@vger.kernel.org.
[   20.008901] psmouse serio1: synaptics: Touchpad model: 1, fw: 10.32, id: 0x1e2a1, caps: 0xf014a3/0x940300/0x12e800/0x500000, board id: 3471, fw id: 2909640
[   20.008925] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[   20.053344] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[   20.397608] mousedev: PS/2 mouse device common for all mice

This patch will add its pnp id to the smbus list to
produce the setup of intertouch for the device.

Signed-off-by: José Pekkarinen <jose.pekkarinen@foxhound.fi>
Link: https://lore.kernel.org/r/20231114063607.71772-1-jose.pekkarinen@foxhound.fi
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 22d16d80efb9..7a303a9d6bf7 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -183,6 +183,7 @@ static const char * const smbus_pnp_ids[] = {
 	"LEN009b", /* T580 */
 	"LEN0402", /* X1 Extreme Gen 2 / P1 Gen 2 */
 	"LEN040f", /* P1 Gen 3 */
+	"LEN0411", /* L14 Gen 1 */
 	"LEN200f", /* T450s */
 	"LEN2044", /* L470  */
 	"LEN2054", /* E480 */
-- 
2.43.0



