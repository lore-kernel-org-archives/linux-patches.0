Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212237;
	b=Wp8aYwx/dAGMGCMJkrnKOEQVTA9YmDR7sjQ1HPWv7/Z3lI9LW0kJc0Axoyhk7tByrfwK
	 9DJsW7vdo9TTJJb7CwcRjSK5QBNDO+wwBy5Jii1Z/k2zE0PWGvoxOy+bGJGa36Qx7chFR
	 bwDw5H/hNj5YERDDPQ1xbfAJCpyXZZ0jI/rVKOmU9cWCvie4K27TPVKsZ/Uo2Ew6Sn6Cz
	 rlKxPltMPh/8s3WgpF1J2WprfNxkz09/k1iRHGrIsuN5sWpAv51N10cd5wsmkFvtsk6WA
	 rH8TIT8tBq9gqpl1AtLET6V/xjUpBs8WXiJ0gl8gBZvZryp1zQn7PKYJfS3/vjVNE9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/z/Z7h1BRIBtsSqc/uIsevYJ8uQU/xOH2sPFyCIMv04=;
	b=tTZmTHqYKGFQ9cEirUJUUDhsDz8eaM++jEqUmRbfmQKARwJ6WYXVr6M9tqq2eyqVehsI
	 T1byu0Z3MZWXAUJ9I4PI9iUEAnDqZL2fASFBdQI8gy+UPHwAVssQ5Q4ZOqmkNAd0QASLv
	 sVIsagi6aVclli3d118e9R1lYEjivETlW7sC82wXGsVeE7s7NADu06oIHbNUmbrvo0aHp
	 K75/0ae3QVjsJyrTuRRKs8R52OYcfDx9pLey44BbBAciJd4fyP5owbb6edu9qaU/6XFTp
	 aQMlcp7NzAvP8w/hlSyjbD/EgvNboCKNWf7MpOI7QEjLWK+Cbi4XrwCqzDaq45gNEAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKP+OIxj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD9C606A31C;
	Wed, 28 Oct 2026 18:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKP+OIxj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5911F01825;
	Wed, 28 Oct 2026 18:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212237;
	bh=/z/Z7h1BRIBtsSqc/uIsevYJ8uQU/xOH2sPFyCIMv04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKP+OIxjMDicvPT+AVGUUtuq/g4AShRWIKR8753qNKIxDIteySKlSZJ8p308Ys9Ls
	 CgqxNLYfVYyvVJBCr56QmGVQe1hY4lqFlAO7wuSvY53ENK/i9anM2EhZC4afkOrLAi
	 FGDKCVJqjvMc/TlH0PPwcFbyxQut8qkgcJC8aY0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0086/1887] power: supply: rt9455: quiesce delayed work before teardown
Date: Wed, 28 Oct 2026 17:36:22 +0100
Message-ID: <20261028170501.193396694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 3e7a1ebc32fad5a558254a478efd401c17a24381 ]

The threaded IRQ handler can queue pwr_rdy_work,
max_charging_time_work and batt_presence_work.  pwr_rdy_work and
batt_presence_work can also queue max_charging_time_work, while
batt_presence_work can requeue itself.

rt9455_remove() cancels max_charging_time_work before
batt_presence_work.  The latter can therefore queue
max_charging_time_work after it has already been cancelled:

  rt9455_remove()                   workqueue
    cancel pwr_rdy_work
    cancel max_charging_time_work
                                      batt_presence_work queues
                                        max_charging_time_work
    cancel batt_presence_work
    return
    devres frees rt9455_info
                                      max_charging_time_work dereferences
                                        rt9455_info

The IRQ also remains registered until devres cleanup and can queue more
work after any of the cancellation calls.  If rt9455_hw_init() fails
after the IRQ has been requested, probe returns without cancelling work
that may already have been queued.  A pending callback can then access
rt9455_info after it has been freed.

Register rt9455_cancel_all_delayed_works() through
devm_add_action_or_reset() right after devm_power_supply_register().
devres invokes the action in reverse registration order, after the
managed IRQ has been freed and before rt9455_info is released, so the
delayed works are drained in both rt9455_remove() and the probe error
path.  Cancel pwr_rdy_work and batt_presence_work before
max_charging_time_work because both can queue the latter.

This issue was found by an in-house static analysis tool.

Fixes: e86d69dd786e ("power_supply: Add support for Richtek RT9455 battery charger")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260723225310.12663-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9455_charger.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/rt9455_charger.c b/drivers/power/supply/rt9455_charger.c
index dd4ff038814f4..62ffc3acc2aec 100644
--- a/drivers/power/supply/rt9455_charger.c
+++ b/drivers/power/supply/rt9455_charger.c
@@ -1583,6 +1583,19 @@ static const struct regmap_config rt9455_regmap_config = {
 	.cache_type	= REGCACHE_RBTREE,
 };
 
+static void rt9455_cancel_all_delayed_works(void *data)
+{
+	struct rt9455_info *info = data;
+
+	/*
+	 * Both pwr_rdy_work and batt_presence_work can queue
+	 * max_charging_time_work, so cancel them first.
+	 */
+	cancel_delayed_work_sync(&info->pwr_rdy_work);
+	cancel_delayed_work_sync(&info->batt_presence_work);
+	cancel_delayed_work_sync(&info->max_charging_time_work);
+}
+
 static int rt9455_probe(struct i2c_client *client)
 {
 	struct i2c_adapter *adapter = client->adapter;
@@ -1673,6 +1686,10 @@ static int rt9455_probe(struct i2c_client *client)
 		goto put_usb_notifier;
 	}
 
+	ret = devm_add_action_or_reset(dev, rt9455_cancel_all_delayed_works, info);
+	if (ret)
+		goto put_usb_notifier;
+
 	ret = devm_request_threaded_irq(dev, client->irq, NULL,
 					rt9455_irq_handler_thread,
 					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
@@ -1713,10 +1730,6 @@ static void rt9455_remove(struct i2c_client *client)
 	if (info->nb.notifier_call)
 		usb_unregister_notifier(info->usb_phy, &info->nb);
 #endif
-
-	cancel_delayed_work_sync(&info->pwr_rdy_work);
-	cancel_delayed_work_sync(&info->max_charging_time_work);
-	cancel_delayed_work_sync(&info->batt_presence_work);
 }
 
 static const struct i2c_device_id rt9455_i2c_id_table[] = {
-- 
2.53.0



