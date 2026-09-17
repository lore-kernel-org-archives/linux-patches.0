Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27B24B44AD;
	Thu, 17 Sep 2026 16:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661061; cv=none; b=Z3tDjMQpByjlbamURe5OTiAr5Y2nQP1aLz+zqgKg71W7bk2WAoweBunbWGjmRo9F8ULtHstJ2Paqsr7k7AfCmY4rzUXQk9f9rf5V85+uimTJ9I3Ymvd8OJgTPKKfdpL0EAcaL/Rdq1pUTuT98smUFMc99noD+yKG0PMr6AKPrz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661061; c=relaxed/simple;
	bh=BWLkR0WBpVRKDmxq/iQFIREywb9jr1Vt7K+IFDtH8Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cz9zKGqj8qQEJadHH6rEwfhiPP5Jqz8mb3M0sxRiO/GGZvofNAU9IkqH7aSt//Hb1iFT55ZwTnuT9TxCco2vmYBhcr0GDnCxxU/gTqGbWVYk2QrNOiJp3+WVePwsR/X997wu15Y8V3aNuzqVfGOE7aG7JUkHaRaz4UedoFaqL4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N25J1aRr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N25J1aRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5735A1F000FF;
	Thu, 17 Sep 2026 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661059;
	bh=dNXh9EnCPJTdyTjjlyO4ZIZq4UYlf6CrAxcG+UljKMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N25J1aRrHdZ1XBU8I1+FoPaQjlzBd6kib2706MUmlPXO1YM+mIpQi/9WTLhI7FRnm
	 vpgWnVebfx+gR0X9CmvpLlBtCLxD2nq5+wQdNmeKm3ozGR04j/sOL3v7bU4JxIpBdL
	 Piutoe1vN1UhHVPN7ssu6ZV9NERkllZc4CE/EXsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0068/1250] net: dsa: mv88e6xxx: define .pot_clear() for 6321
Date: Thu, 17 Sep 2026 15:57:43 +0100
Message-ID: <20260917151553.786066174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 17826d9708a57d27011d0a6efdebb628d6f8299a ]

Commit 9e907d739cc3 ("net: dsa: mv88e6xxx: add POT operation") did not
add the .pot_clear() method to the 6321 switch operations structure.
Add them now.

Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://patch.msgid.link/20260504153227.1390546-4-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b115575f157fe..f324b88450427 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5228,6 +5228,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.set_egress_port = mv88e6095_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
+	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
-- 
2.53.0



