Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024088;
	b=hhJ/UVEfAzMotsmrIT20Yx0BtmleeYC4NJiYstTPfZs17yMovDrhkd+4DUVqVgUU2b6S
	 q4CKBjUzSechJZ+gkx4oEse08sSSRqAvp2VuTG0QMR1as0hHj8A5EPIBXvaXwXrVyD7ki
	 c0QumrxdSGCnXx6rHCoUI7AYRK1AiTWCWBZ5x1eWcN+90+tDMwq1aYjGvvp2OBfamtEua
	 IpyrsYHOIKmTbsnGQkVVXCg5eSiu9VsBg7xqnXeO6mfVujEbCe206VuCx++vAvuyAwVL/
	 TJQfA48TBHHM8LqyrUsfiRTK1yC+eFYz7gKO2qJwSjmIKJQBgAWG2TAKggESX+Oenxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pZ3bJbF8yjvbDYAkLkBAuEUnEtavEm0+NkGf4ntDh/w=;
	b=KX5wjN5w9whUrLvzbBtTQQoiD0PYcVm/AnsWj2XlmXknHM4ylqbcX5TlIpO3TucRu847
	 oSRIhoFnq15/Z+63LaMl3PCV86YCj+WiHz4ry6aulEF94M8EkK0MhssHnIg733XZhqh/c
	 T4jA4FPi3MHVKHNpbNtW44JArhfzTlGkU3g385WBP4YgHXY82JYs8nvZAlrP4vo4njuf9
	 r10Bf0DbJlzEkOfOFSm969NNGbr6trUy4ZX/ubU39P1wR+LfRkRg2aG5ciNMUttSkLXQy
	 xHVyl5H1xMyb00RPWQF1fV+0qzDDpjyXHW69BhMhli7wSomMIcTGpr5xOD+RKJuBe9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W0n7n+rs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61295606A32F;
	Wed, 18 Nov 2026 17:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W0n7n+rs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC0D1F000D3;
	Wed, 18 Nov 2026 17:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024088;
	bh=pZ3bJbF8yjvbDYAkLkBAuEUnEtavEm0+NkGf4ntDh/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W0n7n+rsny3/gQ+Y55lFIlPuMsfmetfolh2QTro2Ac32e19j7VoFfWFuDkQQrPfb8
	 i81DgxrM3Xvq+Lf9RPaoaCtdZKHMZCpK5eOzWDpe0eBDZ0rREUZfQEoPtYKzSgm5Fi
	 mxzMfoJDRIWegV+m8mu/TIWiKR+ehWvUxqVPp8+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0599/2151] leds: st1202: Honour max_brightness when blinking
Date: Wed, 18 Nov 2026 15:38:54 +0100
Message-ID: <20261118150143.768385014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit 865d81a98602c828515fa6ac3c530efc4205f9f6 ]

st1202_blink_set() drives the channel current register to U8_MAX, the
full scale of the part, regardless of the ceiling the board declared.
led_classdev_register_ext() takes max_brightness from the device tree
max-brightness property. The driver does not implement led-max-microamp,
so that is the only way a board can ask for less than 20 mA.

The brightness and pattern paths both respect it. Blinking is the one
that does not, so a board that declares a lower ceiling holds it until
something enables the timer trigger.

Program the same value the other paths use, capped at the width of the
current register so an out of range property cannot wrap it to zero.

Fixes: 35cbd34a6a05 ("leds: st1202: Add hardware-accelerated blink support")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: LLM
Link: https://patch.msgid.link/GV1PR08MB84979A5D536C71D319A06808C5BA2@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 98e8a43b5ed7b..aa334a7b2013b 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -383,7 +383,8 @@ static int st1202_blink_set(struct led_classdev *led_cdev,
 	if (ret)
 		return ret;
 
-	ret = st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num, U8_MAX);
+	ret = st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num,
+				min_t(unsigned int, led_cdev->max_brightness, U8_MAX));
 	if (ret)
 		return ret;
 
-- 
2.53.0



