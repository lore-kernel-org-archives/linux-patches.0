Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704761;
	b=k0jK3aNEIfshigAimru/fWttHCufkfCgFakL/WIjrjr87MZHjyoF7TNZq3i2UijpyRQY
	 nmvr3ul49y/jFYtTuJ/XOOfreyCn4OCsCwOyEtPOGUWPJdoPN2S7RpKE1r8J+2gBIjHjF
	 VMd7jrJnnuOjn9b9rpX3gBrmggzYZrYJQS5sSDFEbIo5yonHhPa7dIdl0jb46uPldb4wE
	 Mv2GO8GYDTvbSkWV54uTk8dVWUylaLIbPZX2ar+LmY/aQ9n1D/mp4aicTDACnCR9pMqTk
	 n+J1D8sJC+eMiYgcECGmm18WzwXIl5pyKzDQ5WnfQIPS3kysQ9TuGgKnYxMfGDNlAQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/I0/k0TQ2jh2GL3c34LgRhf3k7eUlZkwAan/p2GG9Cg=;
	b=38P/eLNunANIDUtAm4IzKcHTtzNnHTD0AD1om1/ynCP4MBKYblvFwbd50zsRnsfS+CZG
	 hqm3YU6uS/Eoo4jJSfhwHwBPwYUPZZmuD9HTyT8sErofWRooev1w72IWWO2265pbLGhUF
	 wJ4dzXB67j0evZXCtBqe/HMYZZvVaYKg9Nc0dv6LkGUokuT2WlXXGOh5HhPsgkwBT5m7e
	 IN554lIfSpc40fs7+9NBR/Zh+rGp+L1Ea/eCu5lmPKPJN5g36UPB1pPxE4mfyzss4eTYf
	 WCIvC4LBVc49xP2ZLeu1WzWC/lC+JLqbonKlAs79lmNGfZlS5Hg/s1eZxQs5BxWyc2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JW6JGP2R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5841F606A323;
	Thu, 26 Nov 2026 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JW6JGP2R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5D41F000D0;
	Thu, 26 Nov 2026 14:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704760;
	bh=/I0/k0TQ2jh2GL3c34LgRhf3k7eUlZkwAan/p2GG9Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JW6JGP2RUetvqg3ZhzQYMQvm9NZvOCSWYbTAmMuHyp1sGBq/q+vRNZA8ckl2cyWRq
	 zL9m1Q+WfqRi33tI4WjkhP3T+eTdWIVFlG1UXTSSLuN9dmbjbUjLOZqTwrt/xHY9ZZ
	 hx8S6o/zCLybQ3Ch7VvBNZeMHbWT82aPp1/lOrO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.10 232/265] w1: remove the masters files before taking its locks
Date: Thu, 26 Nov 2026 15:39:22 +0100
Message-ID: <20261126143621.475307778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit dfc57752ec53c3cc6105656d3037fb2f5e80e9cc upstream.

__w1_remove_master_device() calls w1_destroy_master_attributes() with
both the mutex of the master and list_mutex held.  Removing the files
waits for the callbacks which are running, and nearly all of them take
one of these two locks:

  __w1_remove_master_device()           read() of .../w1_master_slaves
    mutex_lock(&dev->mutex)               kernfs active reference
    mutex_lock(&dev->list_mutex)          w1_master_attribute_show_slaves()
    w1_destroy_master_attributes()          mutex_lock(&md->list_mutex)
      sysfs_remove_group()                    waits
        waits for the reference

The files are readable for everybody, and a bus master goes away when, for
instance, a DS2490 USB adapter is unplugged.

Remove the files first, before the locks are taken.  That has to be done
before the slaves are detached and not afterwards: as long as the files
exist, a write to w1_master_add could attach a new slave behind the back
of this function, which would then wait for the reference count of the
master for ever.  And it is done before the thread is stopped, because a
write to w1_master_search wakes the thread up.

Fixes: c30c9b15187e ("W1: fix deadlocks and remove w1_control_thread")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-2-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/w1_int.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -180,6 +180,13 @@ void __w1_remove_master_device(struct w1
 	mutex_unlock(&w1_mlock);
 
 	set_bit(W1_ABORT_SEARCH, &dev->flags);
+
+	/*
+	 * This waits for the callbacks, which take the locks below. One of
+	 * them wakes the thread up.
+	 */
+	w1_destroy_master_attributes(dev);
+
 	kthread_stop(dev->thread);
 
 	mutex_lock(&dev->mutex);
@@ -189,7 +196,6 @@ void __w1_remove_master_device(struct w1
 		w1_slave_detach(sl);
 		mutex_lock(&dev->list_mutex);
 	}
-	w1_destroy_master_attributes(dev);
 	mutex_unlock(&dev->list_mutex);
 	mutex_unlock(&dev->mutex);
 	atomic_dec(&dev->refcnt);


