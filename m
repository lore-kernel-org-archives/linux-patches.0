Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015543;
	b=VZEdcCx/Z0hY801LcSyQ1gx+VclVGbh3Me+QHLAkFDenIOHzTorXHH6ACAPHX1WtZ19l
	 6vQqSfW+b0Yhxi1vJdNTWjtxwpQe+Q7RouQABcNkrXLOIHue2uWQg7viJMJvotdaJeu0F
	 ClxQOI3YjO8jueH0tpzvn5XTJX4zpPL8Xx9TcUHa7HDnWvZeYs10MCO6nISxpd58b8vPZ
	 qyNu5lEC7QSJnGp+TdkylCyUOJy/jjrKGBh3ia+lvIT6HIhi0GDMP6rHNRoGdlpxWIPtM
	 7BjnoLalCU+1PwP4UrueB3MDedNRI0z6Er1rlw+OeVuzU/GAmlVEDVJ7TIjk9+tEchg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ks14c164YDKIdmZCHDpEimoQBq3N/Lkn69MaKmXV6Xk=;
	b=2oMrai/Z3gI3S6rx8/Ehu7dLXG2lgIrZcvLR7yIhYoRmeBpBW9Cy/xO1R6+19DwzzaP2
	 R6iCld8G27StXLiFsvG9w5nyXfCzB7zfmdPn2v8blweT6DGEUwyfBBgWgjFIelj07ipyQ
	 sVQXhWSHIa2LfJXC7PT8Fwj2GvyW1lZePRwEZlbgZxcX38577bUCXiHPi0rYIcN85ks6x
	 tBsPKNJWke+KpqAP9e0BduuKpbnj4K5LcfT+xhpv8HbauAgS7YG2A0Qto1hB3TFJFpjFN
	 qM+wxMAtNXpQFBCZtnueXjGri4MsIjW6rTGeoHFH6iFB+UOmEYRdLV84rsi7qFcgl2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2JrIKS0A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7D8606A31C;
	Wed, 18 Nov 2026 15:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2JrIKS0A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7191F000C4;
	Wed, 18 Nov 2026 15:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015543;
	bh=ks14c164YDKIdmZCHDpEimoQBq3N/Lkn69MaKmXV6Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2JrIKS0AcjTqU4j5+8x0fOMkUlFGtj+why59D7PDaxdhSFCvGJfEFDDscv0ZW12zM
	 EpjW7kTpwIbR3Ylu0aoWRHngyXHOG5uKXV62ayDGt4qjJOaUqKKuWdj121JSZVC5+Q
	 VCUJekuAQZ2ZfyGtbJ515K78ktj7z4DobRCUjsyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0204/2651] regulator: pf1550: fix division by zero in the ramp rate selection
Date: Wed, 18 Nov 2026 15:24:04 +0100
Message-ID: <20261118150255.206789338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit f0c54cc56a9a21047b1afa209baea8ea931f2e92 ]

set_machine_constraints() calls the set_ramp_delay() op when either
constraints->ramp_delay or constraints->ramp_disable is set. The
regulator binding documents regulator-ramp-delay = <0> as the way to
disable ramp control, and of_get_regulation_constraints() turns that
into ramp_disable = true while leaving ramp_delay at 0, so the op is
called with a ramp_delay of 0. The range check rejects negative values
and values above 6250 but not zero, and the value is then used as a
divisor.

The mapping is also wrong for the values that do pass the check. The
hardware offers two rates, 6250 uV/us and 3125 uV/us, selected by
SWx_DVSSPEED in SWx_CTRL1. Dividing 6250 by the requested rate and
taking bit 1 of the quotient does not map monotonically onto them: a
request for 1500 uV/us selects 6250 uV/us, while a request for the
faster 2000 uV/us selects 3125 uV/us.

Replace the division with a direct mapping onto the two supported
rates. Requests at or below 3125 uV/us get the slower rate and anything
above it gets the faster one. A ramp_delay of 0 asks for ramp control
to be disabled, which this hardware cannot do, so it gets the fastest
rate; pfuze100 handles the disabled case the same way.

Fixes: 7320d41c29bb ("regulator: pf1550: Add support for regulator")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Link: https://patch.msgid.link/20260903082010.4024603-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pf1550-regulator.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/pf1550-regulator.c b/drivers/regulator/pf1550-regulator.c
index ceee553a84b23..84f8b187a91bf 100644
--- a/drivers/regulator/pf1550-regulator.c
+++ b/drivers/regulator/pf1550-regulator.c
@@ -49,17 +49,26 @@ static const int pf1550_ldo13_volts[] = {
 static int pf1550_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 {
 	int id = rdev_get_id(rdev);
-	unsigned int ramp_bits = 0;
+	unsigned int ramp_bits;
 	int ret;
 
 	if (id > PF1550_VREFDDR)
 		return -EACCES;
 
-	if (ramp_delay < 0 || ramp_delay > 6250)
+	switch (ramp_delay) {
+	case 0:
+		/* Ramp control is disabled, so use the fastest rate. */
+		ramp_bits = 0;
+		break;
+	case 1 ... 3125:
+		ramp_bits = 1;
+		break;
+	case 3126 ... 6250:
+		ramp_bits = 0;
+		break;
+	default:
 		return -EINVAL;
-
-	ramp_delay = 6250 / ramp_delay;
-	ramp_bits = ramp_delay >> 1;
+	}
 
 	ret = regmap_update_bits(rdev->regmap, rdev->desc->vsel_reg + 4, 0x10,
 				 ramp_bits << 4);
-- 
2.53.0



