Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040728;
	b=dM2B8mmpfPkrnzYV2tKaPLxYorHQCXfA/Be2tg5IMYGy67UGUwHmzehD5vKxY8OKLQ6i
	 k71DJ7UjQNh1Fr7BaxBl/cX9xb6iNGHs4V7cFAXtyvQ+Rz9mCUAHtSvB7s1p5y8dP+poX
	 WMu+8vBsHopcDsNHOYdvSdGbmW4UfcEo0CJR5alQCdF7AveEx2/MTAOty+lppHddcR5j4
	 xkHtRAamAnN+hc//W3RxGWd4FGqTHpkRrkvoNABKF9DDtFLcyc+QQbhuDlgIqh83Dm8O0
	 eBfLP+F2+luR5t/sA/m5BLQso9/+shb0XGB0J8KxOiw+7OAYZoII8XDoxKYQulrbAKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NFr8PL8C34aVNjrb090RbnSfkpJsXYM6y3xAqCWrAdU=;
	b=OFM/PfkKFSQ8uH2dOu/mscYb0KbKWC6qgVeDH85r6rtrraidZMV2vLamBfJ2MRiZbjpM
	 m2WCL9igFPwQckSMIn5oeK0ohHEkA4F6g1Lb2MKKgAJ/Kkcco+gS0XDVmgVOSrlV+dL9X
	 WfsKqld+eaHMXRazl9iLxo9SKncUazdOP3swtnKt57cs1bNQfYXEBsq7djPNQWWYhR73p
	 A5yBaXi3SOHQaNP2UYViQneBmUjCFEyn5264uAIKvB0/yOCvcUiXdLPb2lJRzUcm+5AHY
	 SkPcqZIuh3ORBUyW+f53GFcrT06XR6wmdcVzAqktUA7N5z0Ds3vUvhZE9nZQTYVr5yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S4q1PS34;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CBE606A32A;
	Wed, 18 Nov 2026 22:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S4q1PS34
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359E91F000C4;
	Wed, 18 Nov 2026 22:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040727;
	bh=NFr8PL8C34aVNjrb090RbnSfkpJsXYM6y3xAqCWrAdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4q1PS34zFmN4DUtcdcBdIuaO2N0/nFUpnXm2NmyV7oYsz9YrOAWRQqNLG/blJ7Uo
	 uiBpuys6HlzhD2LXnZo+L7fTBo7k42fF5gw4XBr0ifGUXcPrVTwZh6PxpGx28NJQjG
	 uOpy9XNQb1XPdyDcQYOcZNc8x48gM8d4s1MPT60U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2560/3318] power: supply: ab8500_charger: Handle detection errors
Date: Wed, 18 Nov 2026 15:53:02 +0100
Message-ID: <20261118150438.060854939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5ebf0080ab2df..a53fe0fb1a408 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3451,6 +3451,10 @@ static int ab8500_charger_bind(struct device *dev)
 	}
 
 	ch_stat = ab8500_charger_detect_chargers(di, false);
+	if (ch_stat < 0) {
+		destroy_workqueue(di->charger_wq);
+		return ch_stat;
+	}
 
 	if (ch_stat & AC_PW_CONN) {
 		if (is_ab8500(di->parent))
@@ -3739,6 +3743,10 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 
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



