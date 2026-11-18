Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055812;
	b=ktZzxubfxudX12BTLw+LB6JHGtqPswi9MKEQvkOg/37D3WwhXDjVt3nUeaaAjzcs+eiE
	 wQfLMgeJBc9K12VWa8OheQ5fx/fsv8Wc0Y8c0sLDzBWCAO3zsgX2fH50mYoKIo5qoaiWa
	 XDV53gw2ahZIYGIMnsCuXXZ5VUDfk8tVDwBP2Mh4hhQulvewMOexjsnD05zKRngJGZmta
	 hXXuvREbx/Z18z8lp8zpritP/OSKxLjJuuNXBFEqzTidVUHVDvEHMRbj4mafkW+C59YOk
	 UXCpNfGOmNL6CMthSTSqNeDVcBNRACt98Nt0msrWp0lwWuUD6PUz7aM+hlTLlqKjoiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ewr20IEUr8CkpCvoIaE2mS5WBenHSq0M3gBN4JlViog=;
	b=BnmrhyEO3uAz40JLO3+QtJLbMIiwlNx+LYsW/dH2GP4yvprRSyGBQTV32nIDPwBZ2rmJ
	 Uyf2NIxF40e96bfTGpTF4a65APrl9BCBodZvsFtByYC+701/PvXKKf42jE5v6RVCioM2n
	 Y+6XY4tpScrfuW4LVAAT6Pg9EJ8Pzeh48nXc4VpCQnH4ozni/kDKIGqBVe/ietndiklWr
	 I3GLPkow2/WlCSzaxOmRh2TK0fwnuxHKXixGco6S2H4Dwpt9eFVfoOeLAUbzXi34911jj
	 Tgg8CYbPuRh6z/g6/VG6VC8qPP5xRPSbGB6uK8su/JWNO2O9ya9WyVrmnkLXdRjyEjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9tu2f74;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD78606A335;
	Thu, 19 Nov 2026 02:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9tu2f74
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00411F000C5;
	Thu, 19 Nov 2026 02:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055812;
	bh=ewr20IEUr8CkpCvoIaE2mS5WBenHSq0M3gBN4JlViog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9tu2f74ajj/vBWf0vtilomvsEl3sAej9O9JYqoNrBguY+O+RzQJdzHWxdQaZh6Q6
	 w1zyFZckCE+3smep0/s9uJdH8ze+fo98rh6T6KrG5fH5Mvtbp1DOeFx1ttN/zE/qv4
	 nbfhaBXa69P3Trxe7eyukUU7n50l8f1lazYUE9wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1728/2214] power: supply: ab8500_charger: Handle detection errors
Date: Wed, 18 Nov 2026 15:56:44 +0100
Message-ID: <20261118150120.827435681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ae9e938188829..7f35863717c7c 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3335,6 +3335,10 @@ static int ab8500_charger_bind(struct device *dev)
 	}
 
 	ch_stat = ab8500_charger_detect_chargers(di, false);
+	if (ch_stat < 0) {
+		destroy_workqueue(di->charger_wq);
+		return ch_stat;
+	}
 
 	if (ch_stat & AC_PW_CONN) {
 		if (is_ab8500(di->parent))
@@ -3629,6 +3633,10 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 
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



