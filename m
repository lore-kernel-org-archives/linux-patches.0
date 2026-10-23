Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773805;
	b=gqfdJOCR4dq/jByfyMx2cO+0UvubyjER1+YC13TQpB0wfdtnpnY7Uh8oPAhW4SF/KKMZ
	 g4vCCpwJ3Mnlirl+neRjuHTL8IoV67d0fAu2FsbiRV5VC3lEGHxCgAQYHCShlNEfudxTT
	 2f4XYq4eBLtpItTyUpY+Mly7EgaqF0bLd7xnSg+TRPG1QUeHCfXxV+AzLup2qofVtcXJv
	 ua5g4JvlrkwGgbOL6tIom6bKGOtkJ6aUmX87FKCJSRWdJnGaHAhugWsdseBmEnXRREBem
	 2v8kV7lxKDvub9JFyTLFpjYAV49IU4CdXFGxcIcpeK4DfXdCcakywZ2tReCenYTOEWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/F5y3zh0VPy2I+N0E3tVKfv1LtPLUymb0ND+MzV6CKA=;
	b=fibSRzJSHWxuuxkKOkFjzoC1Kc1fruyZv/tfacnAMgGgWrdEvJ30tdYW8XIYDdvOddoJ
	 QI+BIYNTonXV/BltdOBBeqKcfa+QAWKEntSzMpFBfw9emovCaNqGfOdzgUdhGHJeaZaDC
	 t2wgKKYvR9O6uVWfCcRsuVGfETZ98I2ChATuQWXUJALn7fiIkqwQz6PYnghlTxt3oVX3h
	 e+G/6+it72V8vmOKzqr//2LA5OR9+UZ4OYT1sgm/kU2mPXKw+0Wa1CCXukF8jVHb33pGx
	 7xxwPx5QTi+gIL+TXIsmhTTQAftIxiKhvxtsJIge6s37TmTM3mklCgg6J/yPTMgF5lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OCNhRoU4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAF9606A31A;
	Fri, 23 Oct 2026 16:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OCNhRoU4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408F51F01825;
	Fri, 23 Oct 2026 16:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773804;
	bh=/F5y3zh0VPy2I+N0E3tVKfv1LtPLUymb0ND+MzV6CKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCNhRoU4g0RkeDscrf65Pj95nn5MZNQr7I7UagMks+4z7l+qHTbi4ml8srqn7C/S9
	 eO/I6ADYalG+BppCLqG8b8f27yHl8zBlQ8TGjig8nE7l/PBdOvrHbkW7597j4b6SS6
	 CdCYRI5KL/Rl6/awdLqQSuQU7wEXpzjr3CdnTsJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/193] power: supply: generic-adc-battery: Fix temperature IIO channel conversion
Date: Fri, 23 Oct 2026 18:34:59 +0200
Message-ID: <20261023163714.726033872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 6bca94e64255053ab2aa56f2588fda73d399b790 ]

Temperature IIO channel data is provided in milli-degrees, while
POWER_SUPPLY_PROP_TEMP is expected to be in deci-degrees. Adjust the
existing logic to reflect this conversion properly.

Fixes: 33088c0513818 ("power: supply: generic-adc-battery: add temperature support")
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Link: https://patch.msgid.link/20260926142905.206215-2-clamor95@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index f5f2566b3a32d..c69c9b9fa0eba 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -90,12 +90,17 @@ static int gab_read_channel(struct gab *adc_bat, enum gab_chan_type channel,
 	int ret;
 
 	ret = iio_read_channel_processed(adc_bat->channel[channel], result);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&adc_bat->psy->dev, "read channel error: %d\n", ret);
+		return ret;
+	}
+
+	if (channel == GAB_TEMP)
+		*result /= 100; /* Convert from milli- to deci-degree */
 	else
 		*result *= 1000;
 
-	return ret;
+	return 0;
 }
 
 static int gab_get_property(struct power_supply *psy,
-- 
2.53.0



