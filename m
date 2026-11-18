Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061235;
	b=sf3QlFZq299IrXP3E2AZ9BA9frR1EkDf5/1lGX6zzwjCI33zUpL4adlWWJD+wl2HxHIf
	 vytsEuR1HwdrLUmBvyY1iElv0y2jFnus8qjTW9GrqNT5qISmrabowcTRZJzIGQM+t9jV5
	 f0rqQaq1hRe7Fx/CUqetjfZi98y1bl5+m1dgpYkL+x19iJLsorMHgSdzF/EwLMXLDyDb3
	 +8xzeSzVg8XQQhfEAZyhcooZ9fL5OfIZd+r3sxoSv6/i7W0lzVL7q3relqMtJydQwrpeq
	 JutDIwMkceH8Hnk3uOSOR1He3PUk3waFTV8M+wWkqc5GO34XlTbPu6elgRvJB1gjs8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UFLDdKTgPH8YxjY9d8MKULo5UUvBi4xjYNqTc+YuDEE=;
	b=lmabv5+bHqBTBxBH1/+dEP6fWRedK1Wob6Ado36wfwU7N9gK54QV8fR7SqOROCo5Jjaf
	 Map/0+iUArt4VznzxokDc5iI7YuN2lpuBxQsaRJFjL7AoFM9X6w6ngv1FK96S47LMVgtM
	 +Vke+RkShnVbWe6ujCSVEK6w80aXkOF8vTVmeG7IbOkWYlA0/Hsh1V4fpA+35PRRbePKi
	 8XaDV1cm7sXsH+36fLPPsTj1X9UQS0Mgzgk7wdQ66udnJbWXRUO7k/DQtMzjYxZIii78u
	 oeKp3mA9T3JcYOOYeZYlKBM/5kFgd97g9Pfti0vfRLXNJwVl33uNgcmQtO9Y7JIjGUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i2eGY2Ph;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB56D606A320;
	Thu, 19 Nov 2026 04:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i2eGY2Ph
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA591F000C4;
	Thu, 19 Nov 2026 04:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061235;
	bh=UFLDdKTgPH8YxjY9d8MKULo5UUvBi4xjYNqTc+YuDEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i2eGY2Ph5RLUiy2joWGGgce0Ddx63bR3Vahs39HVlqcD4TyF63qio8CQNPFMuE9g3
	 AUtKp5EuxSQmS5K3XOMyZPveIn/HiYy1QIeIT+MqRbLaDTr3Lyw/PhENYSpzkwoCy8
	 DL8gcKDgmqL3GFcih7nlVzefpNgFbIsVYSGtwyhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1463/1848] power: supply: ab8500_charger: Handle detection errors
Date: Wed, 18 Nov 2026 15:58:21 +0100
Message-ID: <20261118150020.593130591@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 1098c619ce7595a77a8c2e366a703e9fc5f29bf7 ]

ab8500_charger_detect_chargers() returns either a charger bitmask or
a negative register-access error. The probe and component-bind paths
use a negative return value as a bitmask, making failed reads appear
as both AC and USB connections.

Propagate detection errors and release the bind-time workqueue on
failure.

Fixes: 84edbeeab67c ("ab8500-charger: AB8500 charger driver")
Fixes: 1c1f13a006ed ("power: supply: ab8500: Move to componentized binding")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-10-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 515483d1b93ae..35612287c821a 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3330,6 +3330,10 @@ static int ab8500_charger_bind(struct device *dev)
 	}
 
 	ch_stat = ab8500_charger_detect_chargers(di, false);
+	if (ch_stat < 0) {
+		destroy_workqueue(di->charger_wq);
+		return ch_stat;
+	}
 
 	if (ch_stat & AC_PW_CONN) {
 		if (is_ab8500(di->parent))
@@ -3618,6 +3622,10 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 
 	/* Identify the connected charger types during startup */
 	charger_status = ab8500_charger_detect_chargers(di, true);
+	if (charger_status < 0) {
+		ret = charger_status;
+		goto remove_ab8500_bm;
+	}
 	if (charger_status & AC_PW_CONN) {
 		di->ac.charger_connected = 1;
 		di->ac_conn = true;
-- 
2.53.0



