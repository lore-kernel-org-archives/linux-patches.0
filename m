Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210555;
	b=qZRrazPv7SfxpAtVDgAJ/uejWBn3Rzdr1R2PO0mpAcg8PNF+oqTp95tIqDHZJE3x8XGH
	 gaX7JYLDbFPPU+9Hcr9Y39yIBm96NjJzF7udTbCVP7KgWw6jhEQTmmZ3QjfPiSkTHwaT8
	 HRdJ1kH6Q96RlfmketNBQvFvLwYOvYNGChWje7cc3TyP3eqOdcLB9077YZJXZXZBtbMgJ
	 Jxh/n5w7s6P2N4mYunMLFZW4FaxmHqrYDmpvo4BU9hYx57kBoaBqOkhtg08WVeJqFAVMC
	 Qpiv40QZa2mFAr0qh6leUkzRNzuePICf3apJ29Vst5RQVB7fmoLwor762kkGZKMZRHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TaQ1WrTVn8EWUrhxObBW8RRtS6UWdxtXxKH2yAvpshM=;
	b=kAaeUlnLNvQa5uZBmn9VpxGTAh63oYafcb56EJybPC7CZHz+gPgDM4ZvnJ6FWio8Rv9f
	 D0uxeTV2KhTukzdLBg6lSuJ4gVPzklXxukqgqE3u+LsOm11yznYs/b1gj3GN8s0AN3Z1k
	 LxqnFKfcIEHQlgjWDa6uMJnoHktWeRzR3BSPXwFARVnexu1eHJBeSmGIMLbTgohxH24vd
	 3pJs7ylyTkIyTJPoy8bmIQb0dDzsCCAUpdQ8hyTSVmLYyoUAMmNPktZ6OBJR8WkgR5mUs
	 ov/zeWAaCWxRz9THzQ0qdwXSc1jTRacTqu3p2QIe1oojIkgPdcjftN12ofp7i9jm7UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DcChyGqD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22602606A31C;
	Wed, 28 Oct 2026 18:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DcChyGqD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721691F01829;
	Wed, 28 Oct 2026 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210555;
	bh=TaQ1WrTVn8EWUrhxObBW8RRtS6UWdxtXxKH2yAvpshM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcChyGqDWKTgyPUTmAd0bzD/jaQ3luPQYIABQ9z6hg5joGxO3nHD2BPCNQZkKPlXL
	 zbxiyCowLLv58btJIdVSyWMI4/ghw1q1OYXXbDgcBI/YQ4nj+el0V44/3w7Hy1pPhJ
	 BVnSgUz9iwjW7Ab/pzIINOuC+0rV0euvSy4b9ciQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/571] power: supply: rt9455: Convert to i2cs .probe_new()
Date: Wed, 28 Oct 2026 17:53:33 +0100
Message-ID: <20261028170009.592097821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 2adfc4370ebb745380a44c3e5418486a32a9ba67 ]

The probe function doesn't make use of the i2c_device_id * parameter so it
can be trivially converted.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 3e7a1ebc32fa ("power: supply: rt9455: quiesce delayed work before teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9455_charger.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/rt9455_charger.c b/drivers/power/supply/rt9455_charger.c
index 89b414fac6c3a..6f6adc7446a6d 100644
--- a/drivers/power/supply/rt9455_charger.c
+++ b/drivers/power/supply/rt9455_charger.c
@@ -1583,8 +1583,7 @@ static const struct regmap_config rt9455_regmap_config = {
 	.cache_type	= REGCACHE_RBTREE,
 };
 
-static int rt9455_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static int rt9455_probe(struct i2c_client *client)
 {
 	struct i2c_adapter *adapter = client->adapter;
 	struct device *dev = &client->dev;
@@ -1743,7 +1742,7 @@ MODULE_DEVICE_TABLE(acpi, rt9455_i2c_acpi_match);
 #endif
 
 static struct i2c_driver rt9455_driver = {
-	.probe		= rt9455_probe,
+	.probe_new	= rt9455_probe,
 	.remove		= rt9455_remove,
 	.id_table	= rt9455_i2c_id_table,
 	.driver = {
-- 
2.53.0



