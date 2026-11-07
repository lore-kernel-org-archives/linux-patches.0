Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064847;
	b=0YTXUyk3L97wcGZV/jndYEiAHS/wOjf3OmOKpxms0OkPgT17T60f/kFWvtfDHGITdZS1
	 5s0DtPZD42+Quzs4zasf6uJU731UZJrRIbTyH2gtqFyGacXYgbPt15YptYzrWpLfQzUSx
	 v1gfaWyfFcV0Pd68TyQ4XR5AX+fkRjgdctFk5BKiknMgV43cKF2+xGJTaJu41MLPuqbkN
	 XggS5/fh4t5ANZ15zYWwqPfOLUxchDsDBPeAw3uYJOdpBj7iyk6DxkqS/hSwPYNBuX2O4
	 hOZIZpuGi/QF9fKwbtu4iUXqFwCDSEtJXwyHhGrOCm+6DVyrg4ktJ4j+eAoBk9a+y3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=grB4I/8AMRzchKzpPmg9Kfgw1lraTkBFUa4GjXG2MDk=;
	b=TO4KOXIVZL2Q28lhSlyA02GzNLhYjrHI684ajI57aIiwPotzipF1RT0q6CgBdbxQja2l
	 rGyc8Bek9AgRZATwHU+EJ4qfAXwgfWOiiCP1lYyAd4ZY5yNii/08jhp4UYMjgjs7pfrKu
	 usdUxq84a3oFZ2SrMWpbKBe+N+2RctQlNL+qTzcKeBT1ifgC7JKMvodiuIIRe4ihQu7sC
	 EuqkfgDVL6nWsU8ACguu68W3YgXrTJuBMaIepTBiRB2aHPaXP3O+/DtCVgqC4hKsbDEAt
	 b5EPBpMUJ4k7ZOkDLTpJpqAM1BREgPQ4krbIJd2db1H/9hwuIpmEgwKUMzsdOYWELGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uNrfiW8Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F6A606A32D;
	Sat,  7 Nov 2026 15:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uNrfiW8Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BE11F0089F;
	Sat,  7 Nov 2026 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064846;
	bh=grB4I/8AMRzchKzpPmg9Kfgw1lraTkBFUa4GjXG2MDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uNrfiW8YiIexMJe5sY+ICdw/KFFK1tl8Q+EK2AlWkJD9T4zUgJvsOjxSKkj3/Crh6
	 E8M+xXQSMwZ/xYpOJUWb39YeWE6tZnucLfNdiWs57Uxck8QA71fgFhnp3Frt8Z9I/w
	 YDECQe4OnevBNx636/WW+/3HRQYfQU/HtJxgyF2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Orlando <francesco.orlando99@libero.it>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0771/1257] Input: xpad - add GameSir Nova Lite support
Date: Sat,  7 Nov 2026 08:51:07 -0500
Message-ID: <20261107135000.592899956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Francesco Orlando <francesco.orlando99@libero.it>

[ Upstream commit 2e6f2e5799f328ca0879dad14d7f3709c7f7496b ]

Add vendor and product ID for GameSir Nova Lite (0x3537:0x1040) in
XInput mode to enable force feedback rumble support.

Signed-off-by: Francesco Orlando <francesco.orlando99@libero.it>
Link: https://patch.msgid.link/20261011165821.72698-1-francesco.orlando99@libero.it
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 810e52782ae89..d2eb48d98fead 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -408,6 +408,7 @@ static const struct xpad_device {
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x100f, "GameSir Nova 2 Lite", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
+	{ 0x3537, 0x1040, "GameSir Nova Lite", 0, XTYPE_XBOX360 },
 	{ 0x3651, 0x1000, "CRKD SG", 0, XTYPE_XBOX360 },
 	{ 0x366c, 0x0005, "ByoWave Proteus Controller", MAP_SHARE_BUTTON, XTYPE_XBOXONE, FLAG_DELAY_INIT },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
-- 
2.53.0



