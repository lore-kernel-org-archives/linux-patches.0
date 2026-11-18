Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015493;
	b=Wf6RMIB0mRwZXCdegGRnhd+eQQdCAsWiOgmnokp8ZffQEQ0FXQMP/GJPY0NxLHuh63i7
	 +/rRH+IdYQ18/ZbjsuSnbQps6zVCDLK1LHxVov/myLg7O38o3Qna45+rgHvWOqKPBFmZM
	 AYyOX9NKIi1tm0YhpQX6Qgf6XumGnAQWyxpIdgWZuT5Z51Tf23quh70aKRe8ngFwM19yE
	 W1BSj+WddfJyeTKKS3n5fqDfR+AT82KGP3egSYHo6L8ldhs9ZjzcSw14StW6gKxXkxq4D
	 th0AL9GtJ4e2YT3UzMFZicVfTWATltxjJAZ0Vud7YC6aYmlOUzqllfG28x2/2Ce5DyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M8dVWgFSzNlpO7wFjMyVlKQfmjoZAEGy0QsqcmGYtT0=;
	b=vb0pAJDkmiP8dBPA5AlySbKxwS4UL8AdHecfvgRJjgvM54kVVg4dLLq9NlQlB3hCo0hy
	 OdUqXxnZSaFAFOIPS5ULFX4trVTuruLV3ixrH/0I4iq7O8JvSnIGzk96kYwCptHT1CP4Q
	 Sz8zK6WEWd9O9zx3KMaP+wJpOFmb7rHy2xAh+n3faHNySbx5LB1MxtmnSAR/t1XCAk43U
	 jhPCKVhgi9gIgQUhY1sdEroin2BYnZBWeVVUPn6vxPo2j7oi9sf847+bx6aku95hIDtnt
	 IO+l7ToCL2qnDnNbV9c8G527fc37noNQ/BsLBEUCKdeUCw62x310MFMN873u85GB7ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sAR2BoTx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C96606A31C;
	Wed, 18 Nov 2026 15:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sAR2BoTx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE571F000C4;
	Wed, 18 Nov 2026 15:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015493;
	bh=M8dVWgFSzNlpO7wFjMyVlKQfmjoZAEGy0QsqcmGYtT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sAR2BoTxI8WtfAKsPkk/VLqgFpU9U/jJMxWfn8r6P1Lc+V9W8GBHIT/kHB/qkgyG1
	 7mIWh1u2/pghnq3Ye+RIWq3z3s77wfe2yFIqTH52/NDdjf20O9eDxDSobuOAWJZr04
	 UUyqXEkfUrg5LosEBtQpjuU51RaIZRJwro092OFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Manush Prajwal <manushprajwal555@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0192/2651] leds: max77705: Use fwnode_for_each_child_node_scoped() in max77705_add_led()
Date: Wed, 18 Nov 2026 15:23:52 +0100
Message-ID: <20261118150254.775297767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Manush Prajwal <manushprajwal555@gmail.com>

[ Upstream commit 4805e5ec50d0b355370e3d1ea906af4fc758accf ]

Rework the subled loop in max77705_add_led() around
fwnode_for_each_child_node_scoped() instead of adding a manual
fwnode_handle_put(child) before the early return on a
max77705_parse_subled() failure, so the reference on the current
child fwnode is released automatically on every exit path from the
loop. child is never used outside the loop, so the now-unused outer
child declaration is dropped along with it.

Suggested-by: Krzysztof Kozlowski <krzk@kernel.org>
Fixes: 3b6eaa3db567 ("leds: Use fwnode_for_each_child_node() instead")
Signed-off-by: Manush Prajwal <manushprajwal555@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/6a914e1e.7d702ed2.1273e8.2a52@mx.google.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-max77705.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/leds/leds-max77705.c b/drivers/leds/leds-max77705.c
index 1e2054c1bf80b..4fd803c959890 100644
--- a/drivers/leds/leds-max77705.c
+++ b/drivers/leds/leds-max77705.c
@@ -160,7 +160,6 @@ static int max77705_add_led(struct device *dev, struct regmap *regmap, struct fw
 	struct max77705_led *led;
 	struct led_classdev *cdev;
 	struct mc_subled *info;
-	struct fwnode_handle *child;
 	struct led_init_data init_data = {};
 
 	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
@@ -191,7 +190,7 @@ static int max77705_add_led(struct device *dev, struct regmap *regmap, struct fw
 		cdev->brightness_set_blocking = max77705_led_brightness_set_multi;
 		cdev->blink_set = max77705_rgb_blink;
 
-		fwnode_for_each_child_node(np, child) {
+		fwnode_for_each_child_node_scoped(np, child) {
 			ret = max77705_parse_subled(dev, child, &info[i]);
 			if (ret < 0)
 				return ret;
-- 
2.53.0



