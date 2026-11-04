Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831500;
	b=q2VZW3hrX7b8VvAsnZViFyxYcPxGa//SMF1ds/aRKFPA1EA9Y8pNrVJgSENB6JxIhdpE
	 eNed5At6lCnIAiL4vhLD/sWC5zYMVNn6h8H2P3MYTHCdm39MoZHdxgUl2skJQyjMIvJFQ
	 22SOszVDaKr5GzRChVGPcYsAhl/LhfUdFgpaFiez4rPQayaUWWrkkB4+T03h4TF5fvTz2
	 uYmpniUIbx4BG9gJl7xtkTEAT8nj7rkV6H9AlWaPBsmGhhT2MOS1pLijSEfS9UvZg/upE
	 2vTBX5BLtnfSzO+fxkFv+HGqs0RxETg0WgTijvNoeGkZkaGKsQOaVoyJwxXAuBmKyKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=55KqPSraxOH/yIv5MpcZWHCbSsF8k5lELCyGvtXTG3c=;
	b=LF/s0WQMyouddnqN4Gl47smRdxj5hpiTX/3L/nb1nJmGpw2674JnY5Vrgj4TA0ZSkTS8
	 YRIywFKIOthK8s4BHUE8gqfojhyqMJxzcBRs0FEl0YUzSI5tSh0BgPwKrafWE2dYFhnzr
	 s5lUJRQx7AtohsIP1vLRNvbLpTypJZKiyGum843yrjei3tk4zoK7xm4qGyoKCJ0HIBghX
	 2kvQKt2CPQ35vXDrSsmFoqIfuhdP0fB5gOT0ZfFrsqM4oC8TaC6Z269kQGeKo49NVogZv
	 IHcN7UQz2+CUxFNQetZu/Y66qIN5igp6QFFy2UgysV7Lfuj3qxwWlGc8v/FuKPeVGLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ayvoEOsP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0364606D813;
	Wed,  4 Nov 2026 22:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ayvoEOsP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3311F00919;
	Wed,  4 Nov 2026 22:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831500;
	bh=55KqPSraxOH/yIv5MpcZWHCbSsF8k5lELCyGvtXTG3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ayvoEOsPHc/Zot8OuXOeXii2aeXJAAGYwUp2J8cD7yiBPlr5wuDCsj8j/vxnkiACX
	 eEbyJIMvXJX/rE83psh/HjEP/t+oNd9y63hi855fH8JuZoV81OCKfxtUSRtzxRF720
	 T2nPxUUxNtNYp5buRLMBaf+ReV8ISlkyEoLXs6bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.18 0741/1005] power: supply: sbs-battery: disable polling before supply teardown
Date: Wed,  4 Nov 2026 16:07:54 -0500
Message-ID: <20261104211104.230963664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -1060,6 +1060,13 @@ static void sbs_alert(struct i2c_client
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
@@ -1200,6 +1207,10 @@ static int sbs_probe(struct i2c_client *
 		return dev_err_probe(&client->dev, PTR_ERR(chip->power_supply),
 				     "Failed to register power supply\n");
 
+	rc = devm_add_action_or_reset(&client->dev, sbs_disable_work, chip);
+	if (rc)
+		return rc;
+
 	if (!chip->gpio_detect)
 		goto out;
 


