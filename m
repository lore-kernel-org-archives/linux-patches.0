Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEDF32C93E;
	Fri, 17 Oct 2025 15:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714467; cv=none; b=SnCorGir1nyJX0efa9Sn78ZqSBXzqtqYjuK0klDVdOl0y/tBI3bPlCOF4jgBrLBhCD+ueWmy/wF38rKE9VeWUXjT3fM9UPWqrIj6vie+B5FyyHkOjOH8BTa8ValpwFu3uPEA1jZEVaOKyrYSHtGzJnSOpciTFcLgQkefvZvDjvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714467; c=relaxed/simple;
	bh=G5+UexOKeF9gTUKO+hzf0ja7aMbKnSXhcEFV3VZaCO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xemz7ByzyR+Z/28mkfxpuZQOY9NFSWaADlnEzyz3yJGTsB7aodPaLXkkaurkNVtveyTMKWOUC7vNrPdOgDIKwajIkEWOC8FrPk2N4uWsslL0xDyFfeXVQ4C1XavABVotpEWEWtDf3jTtjUpGggTv18LB42hPqnEEWFQbTAUJ0/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jK97BcEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jK97BcEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D73C4CEE7;
	Fri, 17 Oct 2025 15:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714466;
	bh=G5+UexOKeF9gTUKO+hzf0ja7aMbKnSXhcEFV3VZaCO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jK97BcEzG7DifD3k9h5colVOs+6IWsAYPjYLQlSu+XI85d78XCWMXFIsDXUmhJt5d
	 EYpLQdyikM04Imxzt58h/DuyyYxHX1i1jHyaqtjBiuSaD6PGNfXzyXeKE8NIO1FrDU
	 /dFQ/F7JrzTsuHyunRK1tn40PO915L3mBOmwVmwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 155/277] power: supply: max77976_charger: fix constant current reporting
Date: Fri, 17 Oct 2025 16:52:42 +0200
Message-ID: <20251017145152.784895548@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dzmitry Sankouski <dsankouski@gmail.com>

commit ee6cd8f3e28ee5a929c3b67c01a350f550f9b73a upstream.

CHARGE_CONTROL_LIMIT is a wrong property to report charge current limit,
because `CHARGE_*` attributes represents capacity, not current. The
correct attribute to report and set charge current limit is
CONSTANT_CHARGE_CURRENT.

Rename CHARGE_CONTROL_LIMIT to CONSTANT_CHARGE_CURRENT.

Cc: stable@vger.kernel.org
Fixes: 715ecbc10d6a ("power: supply: max77976: add Maxim MAX77976 charger driver")
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max77976_charger.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/power/supply/max77976_charger.c
+++ b/drivers/power/supply/max77976_charger.c
@@ -292,10 +292,10 @@ static int max77976_get_property(struct
 	case POWER_SUPPLY_PROP_ONLINE:
 		err = max77976_get_online(chg, &val->intval);
 		break;
-	case POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX:
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX:
 		val->intval = MAX77976_CHG_CC_MAX;
 		break;
-	case POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT:
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
 		err = max77976_get_integer(chg, CHG_CC,
 					   MAX77976_CHG_CC_MIN,
 					   MAX77976_CHG_CC_MAX,
@@ -330,7 +330,7 @@ static int max77976_set_property(struct
 	int err = 0;
 
 	switch (psp) {
-	case POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT:
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
 		err = max77976_set_integer(chg, CHG_CC,
 					   MAX77976_CHG_CC_MIN,
 					   MAX77976_CHG_CC_MAX,
@@ -355,7 +355,7 @@ static int max77976_property_is_writeabl
 					  enum power_supply_property psp)
 {
 	switch (psp) {
-	case POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT:
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
 	case POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT:
 		return true;
 	default:
@@ -368,8 +368,8 @@ static enum power_supply_property max779
 	POWER_SUPPLY_PROP_CHARGE_TYPE,
 	POWER_SUPPLY_PROP_HEALTH,
 	POWER_SUPPLY_PROP_ONLINE,
-	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT,
-	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX,
 	POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT,
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,


