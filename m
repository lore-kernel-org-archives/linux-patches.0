Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061586;
	b=zYpbSU3PdRiNIYTR3nDC7JZ//Guez6qsmFybG8tlxEbUv6El49IkVtlyMKRmCr0Gd+qc
	 TVkZkc/gJMeg2O5ZoiR7TBa/+74gMfORxfPpvlYwSvpjDBH5KyJea59iiD66g7Yh7SoUp
	 QbsFuI8R2mGqaq94FSjHdtE1Z2rSjAXhWgfdvCofjkKHpTk3oMTvPsvm5GfnVaiqo+gTa
	 kRue83JWP3s9NImpxAFNKC2ZqC4AQjCC9iZ+BIC8fdEN+WhBHgZodnQrAuxCWL1ny8Ijc
	 XkzlWabZbg0g5jH/M03XMe4rmiJqG5BmNj4c7zlqDjxbRpgzpJSe4g76TgWerQvnRoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BrUdwWNHgjsDjZAjEh2RrAF4tByaN/YYbc0LS2zv5uw=;
	b=vdfNHVwnpXOWMJfH/uSfwoz7hRGG8CQTWT8xiegR8MfqGa8yAS0Yc9dua22LbOgEJgHW
	 zeG+xmFATuzD3bSneHCQZMUZy22peHYKC9ZadQvMyopIQxYL3gSVAGk/plQ/fEmF20xo1
	 N3bzI5+jWLRnDnSc+FxpsfTsFR8ngeJ93HoC8unhjkpolZ2meAXjsHj/S75O4/LSXAXGN
	 Lx+NCxdbsn6mEYNZX81UHC0YY0ot3tKwdnDJJ2UbXBF6fCwS6MmDfNJtPUkcjI//z3Orz
	 Obab9ieQ+YV7J4DXgQWny04/wMKWBcfwm180aUtEiNfFaClocd6jyAhDyM/tBRC8q4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XRcwk6Zp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EBD606A32F;
	Sat,  7 Nov 2026 14:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XRcwk6Zp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7181F0089F;
	Sat,  7 Nov 2026 14:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061585;
	bh=BrUdwWNHgjsDjZAjEh2RrAF4tByaN/YYbc0LS2zv5uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRcwk6Zp/regL4SnTE6UjUQwWwJia9Aok+t99uDhMXZ/ji4dVvAonzomlpSvQOkUH
	 YUjtXZl5aOe2UDbfORncpA11fPmViWkbeKrWBGngi/RoQDIqIfCpsLjn9TIWVc0jGH
	 K9ePAfDvP7DU4Q7tEOJuq2bly1IR6Hv2uoiam16c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 0659/1536] power: supply: sbs-battery: disable polling before supply teardown
Date: Sat,  7 Nov 2026 08:44:35 -0500
Message-ID: <20261107135016.030624374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 5c1c602463d597c5189ddc5a73dece588ba2c57a upstream.

The managed poll-work cancellation is registered before the power
supply, so cleanup unregisters the supply before draining polling.
A pending or running poller can then call power_supply_changed() on
the released supply.

Commit 8d59cf3887fb ("power: supply: sbs-battery: Fix use-after-free in
power_supply_changed()") moved the IRQ request after supply registration,
but did not change the poll-work cancellation order.

Add a later managed action that disables and drains polling before
supply teardown. Its retained disabled state prevents external-power
callbacks from rearming the poll work after it has been drained.
Keep the original autocancel to initialize work before supply callbacks
can run and to cover failed supply registration.

The teardown ordering issue was found by static analysis.

Fixes: 6d0c5de2fd84 ("power: supply: Clean-up few drivers by using managed work init")
Cc: stable@vger.kernel.org # 6.10+
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20261004041019.1123723-1-mhun512@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/sbs-battery.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/power/supply/sbs-battery.c
+++ b/drivers/power/supply/sbs-battery.c
@@ -1059,6 +1059,13 @@ static void sbs_alert(struct i2c_client
 	sbs_supply_changed(i2c_get_clientdata(client));
 }
 
+static void sbs_disable_work(void *data)
+{
+	struct sbs_info *chip = data;
+
+	disable_delayed_work_sync(&chip->work);
+}
+
 static void sbs_external_power_changed(struct power_supply *psy)
 {
 	struct sbs_info *chip = power_supply_get_drvdata(psy);
@@ -1199,6 +1206,10 @@ static int sbs_probe(struct i2c_client *
 		return dev_err_probe(&client->dev, PTR_ERR(chip->power_supply),
 				     "Failed to register power supply\n");
 
+	rc = devm_add_action_or_reset(&client->dev, sbs_disable_work, chip);
+	if (rc)
+		return rc;
+
 	if (!chip->gpio_detect)
 		goto out;
 


