Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249AE17E90E;
	Mon, 27 May 2024 19:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837200; cv=none; b=NY/2wuNM1kjqOtXldMZvyQo6NKzSKrEwqRpLEgs6pBLY642gpbqb5hAvDjMtnFF5RVl7gzHIzQnhrlPuHlc5tzhJUXqYUCgFH7NKgYY/EJlU2H2246MUho/hB/5hbIrveFLVEQvy2HJ0XE5shZx8i3SUaF946xFsst73Dh+h7RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837200; c=relaxed/simple;
	bh=yYsOu6aj1Ljg9lvvu5DkXerBPVRiHEiGmuA5xJeSERg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JEKqTjBZKvvUgsBfWXjB8Nam6/X0SNdXqh0Qp0OFOrpQpUhoCsmhhcU50BsZeBA54WNMzhPC8MMynVa6kC5AqptF6BM0fOKnrKDISh+L1sb9kJXM6DGXFl7vd2SDf5vbMNEgAWfW4XYcw9M6Xt5VeGZzLz2NrerQZWZbYTTVe94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3qHS+Tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3qHS+Tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC680C2BBFC;
	Mon, 27 May 2024 19:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837200;
	bh=yYsOu6aj1Ljg9lvvu5DkXerBPVRiHEiGmuA5xJeSERg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3qHS+TriItOEM2dufD5UfGDtZv45pZgGflo+C38ucjjtl+6WFbxyb3ODUnTawB4l
	 zGaJj7lUDolzDVtGyyESyzSukrGnJ4e9fe9opXNrFpEH45+0B4Um58qsEsMscgCw/C
	 fcPXnQaa0GmMh950OqzCEhM1aLrTYXhzWQZYHe8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 347/427] power: supply: core: simplify charge_behaviour formatting
Date: Mon, 27 May 2024 20:56:34 +0200
Message-ID: <20240527185633.264375893@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 91b623cda43e449a49177ba99b6723f551a4bfbe ]

The function power_supply_show_charge_behaviour() is not needed and can
be removed completely.
Removing the function also saves a spurious read of the property from
the driver on each call.

The convulted logic was a leftover from an earlier patch revision.
Some restructuring made this cleanup possible.

Suggested-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/all/9e035ae4-cb07-4f84-8336-1a0050855bea@redhat.com/
Fixes: 4e61f1e9d58f ("power: supply: core: fix charge_behaviour formatting")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240329-power-supply-simplify-v1-1-416f1002739f@weissschuh.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_sysfs.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/power/supply/power_supply_sysfs.c b/drivers/power/supply/power_supply_sysfs.c
index 0d2c3724d0bc0..b86e11bdc07ef 100644
--- a/drivers/power/supply/power_supply_sysfs.c
+++ b/drivers/power/supply/power_supply_sysfs.c
@@ -271,23 +271,6 @@ static ssize_t power_supply_show_usb_type(struct device *dev,
 	return count;
 }
 
-static ssize_t power_supply_show_charge_behaviour(struct device *dev,
-						  struct power_supply *psy,
-						  union power_supply_propval *value,
-						  char *buf)
-{
-	int ret;
-
-	ret = power_supply_get_property(psy,
-					POWER_SUPPLY_PROP_CHARGE_BEHAVIOUR,
-					value);
-	if (ret < 0)
-		return ret;
-
-	return power_supply_charge_behaviour_show(dev, psy->desc->charge_behaviours,
-						  value->intval, buf);
-}
-
 static ssize_t power_supply_show_property(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf) {
@@ -321,7 +304,8 @@ static ssize_t power_supply_show_property(struct device *dev,
 						&value, buf);
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_BEHAVIOUR:
-		ret = power_supply_show_charge_behaviour(dev, psy, &value, buf);
+		ret = power_supply_charge_behaviour_show(dev, psy->desc->charge_behaviours,
+							 value.intval, buf);
 		break;
 	case POWER_SUPPLY_PROP_MODEL_NAME ... POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret = sysfs_emit(buf, "%s\n", value.strval);
-- 
2.43.0



