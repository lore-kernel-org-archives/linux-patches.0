Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623707;
	b=j+f5/wpOQVV4XVFs/+8YH0oc6MZma42ykAaBkyOBbtUf609rLx2pEd1jLgNYw/L50I1b
	 UFCRPm3gwVVGPTP9Vn4pI8pMjKu/4TW2ARDdKPaON8+td6FgCy+GlD8X9l3dyFXVd9sjQ
	 8XzBOloVHsZ+dUmsOB59A6K5Aeg5YjsCvcMt162VZaZ4Mq9lkfaHm1oSaWCHKvdeGmJUu
	 G/acXex0iuBZhFTn8ttaBnvx++bVJ4LZgwQYXXaLZneFtMHEkcJ33DenABjeY2v8nSFMq
	 aqmjGc8lr/kpGj8XIjpZgcLXNsuKGJeyyuEZLs94OnQhq9ynazoIeKkdnKre7M20X4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7oOhAKMIQussGGYDbwu00aCbQxiSrrz9i0oDi4lHoWI=;
	b=nAyFEWZjYnAFHjKIM3fG+F+LqkrkfsF9NFGfA3ThBRXcaekPNvhRNbMyxjt754hmffDq
	 Om3IWUnT3HB0Mf27YMmALMsaWVPWvMDk2qkqYUMvZRlaEQuA3qerkzXED4WM/6C4et8FW
	 h572Ombj/qMILD+6zcdR/2ewWdXL78cUha9z+YNJPxpPejSOrO31XzuRSuLsYhvHtcHe0
	 LPP9UG9IaQUwoB4X4awWgonc4dqKA1vognbRpMqzePYkKr15rSidaEZ4h3YXI1oI7ecUS
	 356sxKjczFw2cFfF9MCR6ltk3n8G1a24BICLPbEQFU43dCqo5v3yHe1uFoOmOkGzchQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mlHYjwbZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B15606A31E;
	Wed, 25 Nov 2026 16:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mlHYjwbZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBA61F000D2;
	Wed, 25 Nov 2026 16:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623707;
	bh=7oOhAKMIQussGGYDbwu00aCbQxiSrrz9i0oDi4lHoWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlHYjwbZ3qtUT2BvEbSFhF0oxkpyMyMH63D7GVMkIANG78hznwo4N57nOvboMJ8Dy
	 tNUIEgnI7Xz5bEZ58yufMA5RazpQQf5GchqeK7GW2mAoX8oHLmSpYNal/YQZ/uuQZH
	 OPHC7ivVMc1aRbH+Q2lDV1FbujvK4eSwikeTAC5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 6.18 928/990] w1: remove the masters files before taking its locks
Date: Wed, 25 Nov 2026 15:38:15 +0100
Message-ID: <20261125143843.736918804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -176,6 +176,13 @@ void __w1_remove_master_device(struct w1
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
@@ -185,7 +192,6 @@ void __w1_remove_master_device(struct w1
 		w1_slave_detach(sl);
 		mutex_lock(&dev->list_mutex);
 	}
-	w1_destroy_master_attributes(dev);
 	mutex_unlock(&dev->list_mutex);
 	mutex_unlock(&dev->mutex);
 	atomic_dec(&dev->refcnt);


