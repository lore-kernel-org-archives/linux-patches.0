Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827208;
	b=KyRz3BTS/NyCnWZY20iBUB/2Y/j+veiNMgkz+nPtBI/4jWPhUppfbQs5SGnZNzP5mPMS
	 qVqtWPhmXsBQPQbr2f8Kgac47omAy4t8WiKUn83nG/bM1pqh7GgRHJ53Pi56EqjrRmPR4
	 /4ReqDM8I6cCNUVIja44Wr4brY7gmekYOo/hqXnY5JkMh0WIHNazy5QtYacY2KdxbqjSO
	 g+d7yncOfNvLIlHYHnZvNZK3RvYIsbMnx4U2n7YXA2txSpDOgFr55ci6Jc2ha2DM4VFBS
	 Sjl0MDxXiWym9L0vCR2LO5uWQO43SrvaiScS/uRjn7Pchh4qMB9JrGsEmnBcRNdFxCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q4eYvozL8ZDt0H/OLJYfrzCIu/PPHp8dC+bWP4IvTeQ=;
	b=OIfB9DO9ZsdprxahABfRtCxksmWwy4Nx8DEpMlJRiRNUYV4PkRN1bMHYuxTUrpOhxFMe
	 vYL71qpuWCoZuqqx37n5rMxhYK01l//jiVtaFIENg8K2aX7LazodxlQ1o2rC6FsxqASnQ
	 duLVl2g6+YG//f2axQod4PvKnpGPymSaFXzYQZBAx8m7lf4i6rqeCkFyQ5t2+fkYuzQ7q
	 fFDlw3mOXxrbLM9CQjbBF6FBMuYJtEUiwbZvfuRNIQ2/PUF1vCXRDU9Xauu58+c5K8JYP
	 RnnIQQ3tTsMLCD4Rtfp8csSlEGGEwUol+OMfS5MFFTv7c2L9TM/fuKVXmLdUSJBVBtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ApsJQUXB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026A7606B2F6;
	Wed,  4 Nov 2026 21:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ApsJQUXB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917881F0093A;
	Wed,  4 Nov 2026 21:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827207;
	bh=Q4eYvozL8ZDt0H/OLJYfrzCIu/PPHp8dC+bWP4IvTeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApsJQUXBGSxu9TvvoA/e321cJ/uUzhR8uXDnkS9jh8mT8N81cCT14RZQemUy8FAfI
	 9MlzSIEsOEXOpyEEW4dQdn6y/rO5W3OJoMuw6TW9bPasz9FRAZHi1MI+gKfQU8Hw+y
	 dJkHvW2nVNuL8lLWR4XU4/rLDpXAb7GSZje3Dns0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.3 258/547] power: supply: sbs-battery: disable polling before supply teardown
Date: Wed,  4 Nov 2026 16:07:22 -0500
Message-ID: <20261104211045.512882042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1068,6 +1068,13 @@ static void sbs_alert(struct i2c_client
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
@@ -1208,6 +1215,10 @@ static int sbs_probe(struct i2c_client *
 		return dev_err_probe(&client->dev, PTR_ERR(chip->power_supply),
 				     "Failed to register power supply\n");
 
+	rc = devm_add_action_or_reset(&client->dev, sbs_disable_work, chip);
+	if (rc)
+		return rc;
+
 	if (!chip->gpio_detect)
 		goto out;
 


