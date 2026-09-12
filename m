Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4EC472541;
	Sat, 12 Sep 2026 13:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218232; cv=none; b=aFNH34Wtku218cHVGVRW5SBlkwFdgL0emAwOUmbfsmsEkqgCw1jaL4t3bN1csdlqHyAmByZgd7TxlpVWojomKkx7PQvbYL+3Y3h1HmLhplBuJKhnQeXgHqzgGosjtz8ExSqs/YdrbwEtt0Uq6BKDskz+XdjmsX1lgBwf5sgmoWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218232; c=relaxed/simple;
	bh=BR/IQuv9V+fWqb/DTMaSS0gGnDQ0Dmq79GtD1znRBKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ljpGCZvZ7mS43OAdomeJGrYocYQmarg0vygFevLLpX12V/ew7sQizg/I9cWN+9rRCQauCzmyOMz59WpolYeU8GBPfSBUnUwqMZX3N1Wz4/V8mfrOmrOkohEBtjuLW8XTapjUcf+bICwtDEoSatXvznKCvwtVO7kEDrehMZpNFW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6g9UVks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6g9UVks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723431F000FF;
	Sat, 12 Sep 2026 13:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218231;
	bh=DEfnFuBb+N/ABhHg7yNZKOO6MDH3XqfOa+dn2/HGN9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6g9UVksUjFzntoj06bKUGj+p612ZsShzh3Q7Yus08HophRReZ/POeELWcTdwa3RU
	 aXSujy4p5gvrMccrHwVbB9c7IMY5Ha8U4wOJieWyZwaUT9Mr+azHoP7bgpPJDG2oa5
	 8RMoJRRdebmmnGoa2t3qKAhHAKSpvvAhNPWZ8iPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Kalle Niemi <kaleposti@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1101/1376] power: supply: bd99954: Drop bad register fields
Date: Sat, 12 Sep 2026 08:58:47 +0200
Message-ID: <20260912065632.097692599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 177299384a224377b4152242d875e752e5958c02 ]

The bd99954 driver creates regmap fields for all the registers. All the
fields for VBUS_UCD_FCTRL_SET (extended command 0x33) are accidentally
created for VCC_UCD_FCTRL_SET (extended command 0x2b), causing all
reads/writes for the fields to access wrong register. Luckily the fields
for VBUS_UCD_FCTRL_SET are unused.

Taking a look at the data-sheet all the fields in the VBUS_UCD_FCTRL_SET
are marked as: "In normal operation, please don’t set these registers"
with not much of additional documentation. As the fields are wrong and
because there seems to be no users of the fields - it is better to just
drop them. This will also decrease the memory footprint.

Drop incorrect VBUS_UCD_FCTRL_SET fields.

Datasheet: https://fscdn.rohm.com/en/products/databook/datasheet/ic/power/battery_management/bd99954xxx-e.pdf
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 0902f8366491 ("power: supply: Support ROHM bd99954 charger")
Tested-by: Kalle Niemi <kaleposti@gmail.com>
Link: https://patch.msgid.link/758fd430d02286a6f18603a8aecfe443f5ddeb8e.1786356145.git.mazziesaccount@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bd99954-charger.h | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/power/supply/bd99954-charger.h b/drivers/power/supply/bd99954-charger.h
index f588979253830..d053ac901274c 100644
--- a/drivers/power/supply/bd99954-charger.h
+++ b/drivers/power/supply/bd99954-charger.h
@@ -279,17 +279,7 @@ enum bd9995x_fields {
 	F_VBUS_EXTID,
 	F_VBUS_IDRDET,
 	F_VBUS_INDO,
-	F_VBUS_UCDSWEN,
-	F_VBUS_RREF_EN,
-	F_VBUS_DPPU_EN,
-	F_VBUS_DPREF_EN,
-	F_VBUS_DMREF_EN,
-	F_VBUS_DPDET_EN,
-	F_VBUS_DMDET_EN,
-	F_VBUS_DPSINK_EN,
-	F_VBUS_DMSINK_EN,
-	F_VBUS_DP_BUFF_EN,
-	F_VBUS_DM_BUFF_EN,
+
 	F_VBUS_EXTCLKENBL,
 	F_VBUS_PLSTESTEN,
 	F_VBUS_UCDSWEN_TSTENB,
@@ -626,17 +616,6 @@ static const struct reg_field bd9995x_reg_fields[] = {
 	    [F_VBUS_EXTID] = REG_FIELD(VBUS_IDD_STATUS, 5, 5),
 	    [F_VBUS_IDRDET] = REG_FIELD(VBUS_IDD_STATUS, 4, 4),
 	    [F_VBUS_INDO] = REG_FIELD(VBUS_IDD_STATUS, 0, 3),
-	    [F_VBUS_UCDSWEN] = REG_FIELD(VCC_UCD_FCTRL_SET, 10, 10),
-	    [F_VBUS_RREF_EN] = REG_FIELD(VCC_UCD_FCTRL_SET, 9, 9),
-	    [F_VBUS_DPPU_EN] = REG_FIELD(VCC_UCD_FCTRL_SET, 8, 8),
-	    [F_VBUS_DPREF_EN] = REG_FIELD(VCC_UCD_FCTRL_SET, 7, 7),
-	    [F_VBUS_DMREF_EN] = REG_FIELD(VCC_UCD_FCTRL_SET, 6, 6),
-	    [F_VBUS_DPDET_EN] = REG_FIELD(VCC_UCD_FCTRL_SET, 5, 5),
-	    [F_VBUS_DMDET_EN] = REG_FIELD(VCC_UCD_FCTRL_SET, 4, 4),
-	    [F_VBUS_DPSINK_EN] = REG_FIELD(VCC_UCD_FCTRL_SET, 3, 3),
-	    [F_VBUS_DMSINK_EN] = REG_FIELD(VCC_UCD_FCTRL_SET, 2, 2),
-	    [F_VBUS_DP_BUFF_EN] = REG_FIELD(VCC_UCD_FCTRL_SET, 1, 1),
-	    [F_VBUS_DM_BUFF_EN] = REG_FIELD(VCC_UCD_FCTRL_SET, 0, 0),
 
 	    [F_VBUS_EXTCLKENBL] = REG_FIELD(VBUS_UCD_FCTRL_EN, 15, 15),
 	    [F_VBUS_PLSTESTEN] = REG_FIELD(VBUS_UCD_FCTRL_EN, 14, 14),
-- 
2.53.0



