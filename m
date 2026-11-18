Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036309;
	b=UqOk2ukHPZX51pf6xFxMjt8AjApHF04has7baSZ/SjuRzSKmeA2ZudbvcDMQ+Y6UHXC2
	 +6M5ppv1bIeTt5v/t0xbOGOzPq6xYCGqxAqH3REYd8TmkOkp+BMFhOj1IRg0bxipo2X8/
	 8+gg14+g3P+Bp/hE6R/4L6MPtN/PCNNF1nvqNozlV82APZhtAQk65BcjOWrIIOk3NJXPg
	 fhS0wnJMuzaZZpPkua4aAVz3pI4nP/TuxL0u9N4V2KSkVktsFgmuVO7Xzq1TWnLkJFuTB
	 6MZX7rUlDL7Ep48Xs8It237SH2lrvFGkbPoUuEjpmftpcOs/aP8hGAHXf3j9VuIuV0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YJpkdYKsGd51VMxW7S753m4Ml3U/Ks/0EPkWnvu8DuQ=;
	b=hFcJsXKEHtztpDL0Ulwc1YWLjVnLHozin2gAmFT7zXCuqpO2k2TYFK9a0gHw0uNFun94
	 u+CgkXtwNYOzXjvD1MyvHyJua863ffPOloI0RS6XSF3T8wxLPumFYUSO3aWuiz3xD8yez
	 LFtFyuf6Bjzquo0m/O4sz5AQW+cj8QbyWG1hDBCgbr0lvSjilmh5HRSQeyBEm2Q0p7fMm
	 Hn26V1ubP28HSrzLL7dRpVV3qNn1tzkjPijznSsgvDAkllj4mJcnYzJjr6AMWM4jOVHm+
	 lOPyWs89lets6iBWwoZsj9Dgwz4DB44k21zSvudih8ebSlkQnuXhMwJdBCSS5sJ02hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=APUJns1q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281C0606A320;
	Wed, 18 Nov 2026 21:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=APUJns1q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326311F000C4;
	Wed, 18 Nov 2026 21:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036308;
	bh=YJpkdYKsGd51VMxW7S753m4Ml3U/Ks/0EPkWnvu8DuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APUJns1qXGfhAr0zQdXe4/UmjCgXP6KjvD0mwlgMaIat8UbzKYhsbcFlf1mfPFG3A
	 cuTeKrLaBCJf7Uo4d9D0QdYy5eygaTtHhiZ0jCHtHsqtOMWxyrk2sP7m7b289Rqtnm
	 xfI1oHURSFnXMUpzyYAZJfHJcqrCfQAIK8v2Cb+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1011/3318] power: supply: ab8500_fg: Report sub-percent charge changes
Date: Wed, 18 Nov 2026 15:27:13 +0100
Message-ID: <20261118150350.210412641@linuxfoundation.org>
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

[ Upstream commit 4d40dba1815d46c6ef9019ed80e3b998b0fc443d ]

The fuel gauge updates bat_cap.mah from the coulomb counter but exposes
bat_cap.prev_mah through CHARGE_NOW and ENERGY_NOW. It only refreshes
prev_mah when the rounded integer capacity percentage changes, making the
momentary properties appear frozen between percentage steps.

Refresh prev_mah and notify userspace whenever the new charge remains
within the currently accepted percentage. If a discharge estimate tries
to cross upward into a higher percentage, the existing rejection still
leaves both the reported percentage and charge unchanged.

The AB8500 fuel-gauge implementations in the Samsung-GT-I8160-Codina,
Samsung-GT-I8160_HD-Codina, Samsung-GT-I8530-Gavini,
Samsung-GT-S7710-Skomer, Samsung-SGH-I407-Kyle and
Samsung-SGH-T599-Codina-TMO product trees retain the same percentage-gated
prev_mah update and contain no finer-grained reporting workaround.

Fixes: 13151631b5bd ("ab8500-fg: A8500 fuel gauge driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-2-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_fg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index fabab6f9961bf..b8b96e3225b27 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -1392,6 +1392,13 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 		}
 	}
 
+	/* Keep the charge properties current between percentage changes. */
+	if (di->bat_cap.prev_percent == percent &&
+	    di->bat_cap.prev_mah != di->bat_cap.mah) {
+		di->bat_cap.prev_mah = di->bat_cap.mah;
+		changed = true;
+	}
+
 	if (changed) {
 		if (di->bm->capacity_scaling) {
 			di->bat_cap.cap_scale.scaled_cap =
-- 
2.53.0



