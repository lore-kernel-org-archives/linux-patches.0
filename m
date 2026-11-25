Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618900;
	b=Pb9YJS5OAzQJMRn4x5wCR/8X/1EpiLpJlX/0Jjqc/ukq+zZwjZpdcn2Q39rmO8qhmzvF
	 P/xQ06pIpybMUrNTH8Gz3NoBdXUVa/z/xwIuqgOGfWKPzMTunFQ/YH18jBflvVbsGt/2j
	 58DhToW8ZEIKtKtADFf/lEz3eweeWr8L0rrRr9aRYpv+KxqK+osf2oERSlxctC8gVxJTS
	 8ofy7Ts45O9hQrC7IQYE+XTOrSSxzxcrUp+o+ndsjg2NRlRVLEuh95WREse3znSUgqems
	 DTceYMxKBdfOnPEL+vX8ehEauVBRxs0RjK7h/j0vTD6f4kNAI5TurVp+6nbv+2djoJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2JA5iXCla2xRRX6gRdgTLDWhrrp6UmkJv7G/AP0rN7U=;
	b=XSPpdcFrgXmG7bGfsGL/ryVk8ULC25K63/Ey/3hFzDdfonEF5iVNxYchF/9LnhHjEjh9
	 l+T0wX6IGkrSARFi398izPL90s5pwMS8hy296x5cFZrYVuuMgae/7nteCsyg9OitvGlEy
	 un7PpbsZ0sP4pXziVhiKM0PZBZtmLAl385tghajUYiRaqZVlcpmiZQltSjQd1f6dEAEZM
	 zWpDaVtms410Ux6jFI/+UskRl4f+5JJS0sprIVywVzDV6u84Wfe+Y4peH/dbIVkJCeGjo
	 wKiyQrrATK3wL9rTlE4ODxcnalv0Gn2JegpMGg6tL/qtxE3t7VlpqktscgYRvgH/UwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZWHYEg+O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF41606A31E;
	Wed, 25 Nov 2026 15:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZWHYEg+O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23761F000D1;
	Wed, 25 Nov 2026 15:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618899;
	bh=2JA5iXCla2xRRX6gRdgTLDWhrrp6UmkJv7G/AP0rN7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWHYEg+OKAhIHxxYq2fCzbgenZh3Sn8Dqes3DxI+NqsKt2OTenZHwhuZi2KoBdNiW
	 WvHqJBIpbu48F5RtoWsSqa3SW1T3zZ7ZGNI4EM3nIMb2pMwI1oTrpuWUFexRBeaM4Y
	 RWF+t9Mu7iVXav0nTxXgsQT/h+iYsSOiROYu54uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0407/1005] gpiolib: fix GPIO descriptor leak in gpiod_get_array()
Date: Wed, 25 Nov 2026 15:29:05 +0100
Message-ID: <20261125143831.285426463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit b2a161687acdc297aa91fec7fa0966b5aecf0d16 ]

In gpiod_get_array(), descs->ndescs is used as the loop induction
variable and is only incremented at the end of each iteration. When
krealloc() fails on the first iteration (when index is 0),
descs->desc[0] has already been acquired via gpiod_get_index(), but
descs->ndescs is still 0. Consequently, gpiod_put_array() frees descs
without releasing descs->desc[0], leaking the descriptor.

Fix this by using a dedicated loop induction variable and incrementing
descs->ndescs immediately upon storing the retrieved descriptor.
Additionally, since the fast-path array_info setup only executes for the
first element (index 0), simplify the bitmap_set() calls to start at bit
0 for count bits instead of calculating offsets from the loop index.

Fixes: bf9346f5d47b ("gpiolib: Identify arrays matching GPIO hardware")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://patch.msgid.link/20261105-b4-gpiolib-free-v3-1-bb47ad58642d@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index b16d6d727ac35..3d2b2919dfb71 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -5223,21 +5223,21 @@ struct gpio_descs *__must_check gpiod_get_array(struct device *dev,
 	if (!descs)
 		return ERR_PTR(-ENOMEM);
 
-	for (descs->ndescs = 0; descs->ndescs < count; descs->ndescs++) {
-		desc = gpiod_get_index(dev, con_id, descs->ndescs, flags);
+	for (int i = 0; i < count; i++) {
+		desc = gpiod_get_index(dev, con_id, i, flags);
 		if (IS_ERR(desc)) {
 			gpiod_put_array(descs);
 			return ERR_CAST(desc);
 		}
 
-		descs->desc[descs->ndescs] = desc;
+		descs->desc[descs->ndescs++] = desc;
 
 		gdev = gpiod_to_gpio_device(desc);
 		/*
 		 * If pin hardware number of array member 0 is also 0, select
 		 * its chip as a candidate for fast bitmap processing path.
 		 */
-		if (descs->ndescs == 0 && gpiod_hwgpio(desc) == 0) {
+		if (i == 0 && gpiod_hwgpio(desc) == 0) {
 			struct gpio_descs *array;
 
 			bitmap_size = BITS_TO_LONGS(gdev->ngpio > count ?
@@ -5262,10 +5262,8 @@ struct gpio_descs *__must_check gpiod_get_array(struct device *dev,
 			array_info->desc = descs->desc;
 			array_info->size = count;
 			array_info->gdev = gdev;
-			bitmap_set(array_info->get_mask, descs->ndescs,
-				   count - descs->ndescs);
-			bitmap_set(array_info->set_mask, descs->ndescs,
-				   count - descs->ndescs);
+			bitmap_set(array_info->get_mask, 0, count);
+			bitmap_set(array_info->set_mask, 0, count);
 			descs->info = array_info;
 		}
 
@@ -5275,38 +5273,34 @@ struct gpio_descs *__must_check gpiod_get_array(struct device *dev,
 
 		/* Unmark array members which don't belong to the 'fast' chip */
 		if (array_info->gdev != gdev) {
-			__clear_bit(descs->ndescs, array_info->get_mask);
-			__clear_bit(descs->ndescs, array_info->set_mask);
+			__clear_bit(i, array_info->get_mask);
+			__clear_bit(i, array_info->set_mask);
 		}
 		/*
 		 * Detect array members which belong to the 'fast' chip
 		 * but their pins are not in hardware order.
 		 */
-		else if (gpiod_hwgpio(desc) != descs->ndescs) {
+		else if (gpiod_hwgpio(desc) != i) {
 			/*
 			 * Don't use fast path if all array members processed so
 			 * far belong to the same chip as this one but its pin
 			 * hardware number is different from its array index.
 			 */
-			if (bitmap_full(array_info->get_mask, descs->ndescs)) {
+			if (bitmap_full(array_info->get_mask, i)) {
 				array_info = NULL;
 			} else {
-				__clear_bit(descs->ndescs,
-					    array_info->get_mask);
-				__clear_bit(descs->ndescs,
-					    array_info->set_mask);
+				__clear_bit(i, array_info->get_mask);
+				__clear_bit(i, array_info->set_mask);
 			}
 		} else {
 			dflags = READ_ONCE(desc->flags);
 			/* Exclude open drain or open source from fast output */
 			if (test_bit(GPIOD_FLAG_OPEN_DRAIN, &dflags) ||
 			    test_bit(GPIOD_FLAG_OPEN_SOURCE, &dflags))
-				__clear_bit(descs->ndescs,
-					    array_info->set_mask);
+				__clear_bit(i, array_info->set_mask);
 			/* Identify 'fast' pins which require invertion */
 			if (gpiod_is_active_low(desc))
-				__set_bit(descs->ndescs,
-					  array_info->invert_mask);
+				__set_bit(i, array_info->invert_mask);
 		}
 	}
 	if (array_info)
-- 
2.53.0



