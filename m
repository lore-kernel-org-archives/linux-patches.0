Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620140;
	b=q9yLygkdLuqxspQeIpTDOMNd1HMYqw83X/AXAgwYDeysmSgsjY4vsER5tQ9FPgOK10nU
	 B3lE+Jm+nPgXY+QAmOkKDaNCJKeCxplaoeK7hMWJEO/AFZxP6DyuaO8HhpqxoUgjwp1Mj
	 HQtKUuNSmZmpUKDut3YXbdXML+3eZPVDnmNfR2wYocMFpbvxBm2bsrHMUPvt7JyKwTElV
	 mJlnzxHF4qPls+p24T6zs5oh1k45OcTYE0qnMywkY3amiFXnkca3yBwrUbAe6ca8T1mWB
	 brceN9C1Oa21ujYsQFOmjbmqj5Uw8ygTiRc6jxuMfTD2WKBGL5m6ISmeJK2F/qK5Ocw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VZiA7eS8kX+IKAMOxd2SO+sB/0M01qdOzIN1OR+6Ed8=;
	b=00y5yg25wT0ZjrHo1ifNcrYhp4GEfp+6lV6vw5M8KlXpa/BNSEqutFFxhWwtv0bGE1IG
	 EDm/0vvB5UcJ1W26u6GE9YG5KpcpA2r9hPfMKU4QJIIpx8Ce7NpoAfrc3FX+ybyACtrcr
	 MKm//5L6UrBZ7tKb9F16a44j37vIyU1k0EGNJTiZvLTX1bulpUnJdmHP4EHU9hyoB0go7
	 QmoaW1khVeCskeToept+rYNoADhF5P+rOsZBpaRJrSYcZTvXgbtTLtIRk5qnb//KHrS5t
	 +SSlCn+fvwwCGqzb8Ecg1q1l94fGFZx6tmKic+wD9CNV5wPE+qUNhrF+0wCuCmp6YLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYdHBm9n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FAB606A321;
	Wed, 25 Nov 2026 15:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYdHBm9n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B141F000C6;
	Wed, 25 Nov 2026 15:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620140;
	bh=VZiA7eS8kX+IKAMOxd2SO+sB/0M01qdOzIN1OR+6Ed8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYdHBm9nfR9kMDy80JCwQkvDqYdueQR/69HiYxZnjTJrWucVW5YtGIfPxIBc7AIsL
	 ZDM1yeU6x/NcPijgqBztmpNslpdW6VnGVwhwX26N76uAcatf4rHi1JClAdEodZBJPG
	 Db71sVXjtH/oOmBm5+2ncP5vT0B7uThLCpAfgcoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0821/1005] gpiolib: synchronize updates of descriptor labels
Date: Wed, 25 Nov 2026 15:35:59 +0100
Message-ID: <20261125143840.958528930@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 82028344caeed2ea3536708906adee02e472633d upstream.

desc_set_label() swaps desc->label with rcu_replace_pointer() but
without any synchronization of concurrent updates. The swap is a plain
read + write: two threads can observe the same old label and then call
call_scru() on the same SRCU head corrupting the state of the chain.

Add a spinlock to struct gpio_device - we're using a single spinlock for
all descriptors as using a per-descriptor lock would unnecessarily bloat
the size of the desc array with very little chance and no consequences of
contention - and use it to serialize the pointer update.

Cc: stable@vger.kernel.org
Fixes: 1f2bcb8c8ccd ("gpio: protect the descriptor label with SRCU")
Closes: https://sashiko.dev/#/bug/linux-2f7ac8b6-5034-4ff1-9afa-5700ff44e3e9
Link: https://patch.msgid.link/20261105-gpiolib-set-desc-label-corruption-v1-1-fa84726ceac0@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |   11 ++++++++---
 drivers/gpio/gpiolib.h |    2 ++
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -154,9 +154,12 @@ static int desc_set_label(struct gpio_de
 		memcpy(new->str, label, len);
 	}
 
-	old = rcu_replace_pointer(desc->label, new, 1);
-	if (old)
-		call_srcu(&desc->gdev->desc_srcu, &old->rh, desc_free_label);
+	scoped_guard(spinlock, &desc->gdev->desc_lock) {
+		old = rcu_replace_pointer(desc->label, new,
+					  lockdep_is_held(&desc->gdev->desc_lock));
+		if (old)
+			call_srcu(&desc->gdev->desc_srcu, &old->rh, desc_free_label);
+	}
 
 	return 0;
 }
@@ -1210,6 +1213,8 @@ int gpiochip_add_data_with_key(struct gp
 		goto err_free_ida;
 	rcu_assign_pointer(gdev->chip, gc);
 
+	spin_lock_init(&gdev->desc_lock);
+
 	ret = init_srcu_struct(&gdev->desc_srcu);
 	if (ret)
 		goto err_cleanup_gdev_srcu;
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -37,6 +37,7 @@ struct fwnode_handle;
  * @valid_mask: If not %NULL, holds bitmask of GPIOs which are valid to be
  * used from the chip.
  * @desc_srcu: ensures consistent state of GPIO descriptors exposed to users
+ * @desc_lock: synchronizes the updates to descriptor labels
  * @ngpio: the number of GPIO lines on this GPIO device, equal to the size
  * of the @descs array.
  * @can_sleep: indicate whether the GPIO chip driver's callbacks can sleep
@@ -71,6 +72,7 @@ struct gpio_device {
 	struct gpio_desc	*descs;
 	unsigned long		*valid_mask;
 	struct srcu_struct	desc_srcu;
+	spinlock_t		desc_lock;
 	unsigned int		base;
 	u16			ngpio;
 	bool			can_sleep;


