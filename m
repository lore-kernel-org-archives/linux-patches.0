Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705695;
	b=VkYnihCbW90OPEvvwg/SPjE0zqxfCrWK+dVBI7UKnJ05SEstBvcY71z3iZkEhvNXSjGW
	 qiMDOjr1grIUkR3dUNdXPb8Y/4XU6H8mLRmQwuXeNRBP5W5zM2diIE13XXR1f/ArSb9Ws
	 3mo/IVcPQ29TDSzeuqaM6LW5SBLxvYhz81cY+gQwJHEIjk4IXHlLVRBHXYi7e+uSJ/Ebe
	 IZ3wCSI/bbPMuL+sSUfh7H5QZ5pDdbBrnLy2JqlNp+0V+hReTzdxB088OtEdaW7MA3vMk
	 rhPIZgvkc7ENoFbkQZTUXs8iBjU0hMhLtLo5QIcYz+RLT5rDjBEwIoz11bKQuDHg6dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=caq+NI0x3YaXF5th/ZWgs2EWNjwh00d5dH1XgGAxkdk=;
	b=hwdnBqApRZOj23EhyXSgAEnnN/MODneIVFrY0rT7okkno9+OUCw4Z8Izd7hZmxv+woKy
	 JGCtw2sZzGFbiO+D+jQ3GYrbhvmnkCGduk0rT0NHL9gRwriQ366UZkgbOLBeu/qzj6mJ7
	 lAwi6spgDt0RPH05cENKT9BTLdz/w16/nO4gAG9VbpcgVlIe30FtBZQttikLQcS0+dmxE
	 bWvfbkO2igoUubvFfQ5OX2/hF5SElmMnDEFmZUP9hkEIf4qr363LUBt+SYqlQ/ZD7533Z
	 FifwUKRGj8hdq+rVjxQ/ACSVbF9Qd0a5TXnJXDTesLUfZG+UQs7XBPJBCxHEkHwE8dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syVjZloJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155E0606A32A;
	Thu, 26 Nov 2026 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syVjZloJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B3A1F00AE3;
	Thu, 26 Nov 2026 15:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705694;
	bh=caq+NI0x3YaXF5th/ZWgs2EWNjwh00d5dH1XgGAxkdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=syVjZloJW3u0mwRM5D0uiZfE7v9gNikEb4qqhVP29D6n1K2fgmlxBmN4Wb5RbHrJz
	 /8xMIWfGsJ+2AdIFXMRGYmyrUj9G3ByCmHCMxLLlzsYQPoRWNlHJNlhnWOCG+xgjdW
	 VRMjMgS4g5MCuixqGsfHh7y0VF8vz4Ffws6X85P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.15 285/319] w1: remove the masters files before taking its locks
Date: Thu, 26 Nov 2026 15:40:53 +0100
Message-ID: <20261126144013.189437499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


