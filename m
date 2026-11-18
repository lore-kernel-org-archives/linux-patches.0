Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030936;
	b=y00NCiJISAslI7regF9eAfLgVt5ED42Rcb9M2ffV61Xp4h/purw5/kLGr9FPMm2ILd5O
	 cyfiOtfK6mGsZcfVkpa0FQYUZ9Oqk5nEpk6981kAfr8S0KmRjhM40JAHDDjnfg0FhJ1io
	 bV1QiWAUprnZXFS1x1kMNaAVelmqOW8E7BfnnLt4JKjw2fhPky0kHO6lLKrxvvpTk7T6N
	 NGtZkTNqjCOYAENWsfXweaMlp1W6ylQEFFF8Kpb+rbruvXM/g6yJZajtnHhiTiYTZMavY
	 rUg5EYJRx4JQU16ZcQj+Jy/D7KEYVotP6JN4g3C9ZISiz9y700zjvtiCGe6/1a6i61A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LXOJBkhGUmcpmzGpW/GY2aqPUE2nxU24G6gl0IDJOSE=;
	b=nPxJmi46w3ilk2TXTdWqsNGzPCJ08d5D3LiBzFpP4edBj9imAj+eLyW6dN3FnjnRSKSS
	 FOkroylbRYbc4fPiRR1OyFpRuL4S0jIrLKgGpmolzycIQDozrUO0xzTEOTPchkxlWEwc0
	 nrBM0hARvlQ5Yl/sapvMGs2Nc75+96BxX1k+J0pvngKILQy4OyTwJOTuUhhHF37Ym7aYm
	 TUiJlYZXphb6VQufPIoqyvKc0AHqCp9F+VGzrWpYL7Z8w55CI1rqwntxQyzxDxrIpGueH
	 op2CSLzNWriLoKQn/PO7v3+OYVnQbhzKuDlZUohw2+F9aCa41eRVCxSKChpXepOxDCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8sXCeVo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9312606A7F6;
	Wed, 18 Nov 2026 19:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8sXCeVo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447ED1F000C4;
	Wed, 18 Nov 2026 19:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030935;
	bh=LXOJBkhGUmcpmzGpW/GY2aqPUE2nxU24G6gl0IDJOSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8sXCeVoj32vj+w2xDGQrRRliXT3v+WKjlI6ptI8yXWnlbh20R4Hy46AJDoPTPI+t
	 sqWfwYsqYfZdIWakN7Ozx2JRq9qbqzxLS/bNsPGO5lztJ97UW6+4nq+hAn20B10U2t
	 bmC2bZ1pGy5JijtiU9HmCeGGCy2X3TePBn6B/o9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0838/1756] power: supply: ab8500_fg: Finalize current measurements
Date: Wed, 18 Nov 2026 15:49:25 +0100
Message-ID: <20261118150042.819116814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 9a0461fb5e7cc64ed303bee3661452879ee139a1 ]

ab8500_fg_inst_curr_start() returns with cc_lock held and the CCEOC
IRQ enabled. The bounded sampling loop in the load-compensated voltage
path returns without calling ab8500_fg_inst_curr_finalize() when it
expires, leaving both resources active. The next fuel-gauge work item
then blocks on cc_lock and all cached power-supply values stop updating.

The Samsung-GT-I8530-Gavini, Samsung-GT-S7710-Skomer,
Samsung-SGH-I407-Kyle and Samsung-SGH-T599-Codina-TMO product trees use
a bounded sampling loop in drivers/battery/abb_fuelgauge.c but still
call the finalizer. Follow that pattern so the normal completion timeout
also performs the required cleanup.

Check the start result as well and return an uncompensated voltage if
the instantaneous current transaction cannot be started or completed.

Fixes: edc400e1632f ("power: supply: ab8500_fg: Break loop for measurement")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-14-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_fg.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index fe143d13718c4..3e530a37535de 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -934,9 +934,15 @@ static int ab8500_load_comp_fg_bat_voltage(struct ab8500_fg *di, bool always)
 	int i = 0;
 	int vbat_uv = 0;
 	int rcomp;
+	int ret;
 
 	/* Average the instant current to get a stable current measurement */
-	ab8500_fg_inst_curr_start(di);
+	ret = ab8500_fg_inst_curr_start(di);
+	if (ret) {
+		dev_err(di->dev, "failed to start instantaneous current measurement\n");
+		di->vbat_uv = ab8500_fg_bat_voltage(di);
+		return di->vbat_uv;
+	}
 
 	do {
 		vbat_uv += ab8500_fg_bat_voltage(di);
@@ -945,15 +951,14 @@ static int ab8500_load_comp_fg_bat_voltage(struct ab8500_fg *di, bool always)
 	} while (!ab8500_fg_inst_curr_done(di) &&
 		 i <= WAIT_FOR_INST_CURRENT_MAX);
 
-	if (i > WAIT_FOR_INST_CURRENT_MAX) {
+	ret = ab8500_fg_inst_curr_finalize(di, &di->inst_curr_ua);
+	if (ret) {
 		dev_err(di->dev,
 			"TIMEOUT: return uncompensated measurement of VBAT\n");
 		di->vbat_uv = vbat_uv / i;
 		return di->vbat_uv;
 	}
 
-	ab8500_fg_inst_curr_finalize(di, &di->inst_curr_ua);
-
 	/*
 	 * If there is too high current dissipation, the compensation cannot be
 	 * trusted so return an error unless we must return something here, as
-- 
2.53.0



