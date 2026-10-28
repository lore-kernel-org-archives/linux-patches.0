Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213790;
	b=nhkOG7oofOjRP3EluhNH8u2YgQkkJiD9fmOt8mzRZlNRLU9Z/6EBaO8vIxbmzGPN3CWr
	 zSpSIT1gCRbyXjJXGt/+X91DuvzppU8g9qi+BnBpKLe5O/eXoOIWQSA9hpYYJTuvtUwez
	 pzV0x2TUM10I4ipu7/nD+z8d9uCXwSOQK8+N+LyrA65qkw82RRJhKHjb92K1YmJC1VJdy
	 Mx0pHej3+5F3HykLEOZr+quxv378phA4CdeW7KuAHzb3LX2k6demGPYle2R5gqrpS8SJR
	 sI3ajDFuBMTzKwQD/m+egkj1GNYfe46ohIAtT7T7YPJ086X5TcTrcUT5Y1FUw5ApicA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7/n1qvoWWCK4JAdskADB3gbEFor2Zs7+CP2gHgWLW8k=;
	b=fxQDnLfzAj5Zi7CBR7NqdZgNQPzE9bzklAV9TzIpU8iHbhmFmyA0gO0zC0cElmxnlm/j
	 QnPWTk51BdAZL/Ui9ufOsVK1/M51DXzpcpo3Yc35sghlaW5Ow0UWohCNR+DChYz3Ma7cB
	 ck7kU1fAnWY+dAJHs2mzgJKyhkaf5eF4ztotzMP12aBjWExqU7VxlvBn9l+d+yhKPQ2t0
	 EU4ZQ8M+cZkYg4DoCBNsFZy4DEjif43Ze0XaA7JAuxNyFHvLGEop3cgX3lUx+HCtkRe8R
	 25x2Rg8QfhphiROZp8hre7PBAzJdAJ2BoJxpzp4FyIPnj20peoobdyOyupIKkh6iL2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d7fZGA8o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5403A606A31A;
	Wed, 28 Oct 2026 18:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d7fZGA8o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36351F01825;
	Wed, 28 Oct 2026 18:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213790;
	bh=7/n1qvoWWCK4JAdskADB3gbEFor2Zs7+CP2gHgWLW8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d7fZGA8oEhD5WyHWankqq6v13e7PJdczZXkzD/iHT4CT7FqP4WgX33BUCw7WgzdiE
	 dY+dFJ2ZgKv4l+IJZfyeA+3HTutYDdUoi5HDS7O+2f29UiwY0IzF1GPiIVgO5KbyKh
	 R28+Ohv1BtCZfoRoQizcwYNCkVBY9/8YX6jLLnVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0623/1887] platform/x86: x86-android-tablets: Unregister devices in reverse order
Date: Wed, 28 Oct 2026 17:45:19 +0100
Message-ID: <20261028170513.586473580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 3de0f2627ef849735f155c1818247f58404dddfe ]

Not all subsystems support a device getting removed while there are
still consumers of the device with a reference to the device.

One example of this is the regulator subsystem. If a regulator gets
unregistered while there are still drivers holding a reference
a WARN() at drivers/regulator/core.c:5829 triggers, e.g.:

 WARNING: CPU: 1 PID: 1587 at drivers/regulator/core.c:5829 regulator_unregister
 Hardware name: Intel Corp. VALLEYVIEW C0 PLATFORM/BYT-T FFD8, BIOS BLADE_21.X64.0005.R00.1504101516 FFD8_X64_R_2015_04_10_1516 04/10/2015
 RIP: 0010:regulator_unregister
 Call Trace:
  <TASK>
  regulator_unregister
  devres_release_group
  i2c_device_remove
  device_release_driver_internal
  bus_remove_device
  device_del
  device_unregister
  x86_android_tablet_remove

On the Lenovo Yoga Tablet 2 series the bq24190 charger chip also provides
a 5V boost converter output for powering USB devices connected to the micro
USB port, the bq24190-charger driver exports this as a Vbus regulator.

On the 830 (8") and 1050 ("10") models this regulator is controlled by
a platform_device and x86_android_tablet_remove() removes platform_device-s
before i2c_clients so the consumer gets removed first.

But on the 1380 (13") model there is a lc824206xa micro-USB switch
connected over I2C and the extcon driver for that controls the regulator.
The bq24190 i2c-client *must* be registered first, because that creates
the regulator with the lc824206xa listed as its consumer. If the regulator
has not been registered yet the lc824206xa driver will end up getting
a dummy regulator.

Since in this case both the regulator provider and consumer are I2C
devices, the only way to ensure that the consumer is unregistered first
is to unregister the I2C devices in reverse order of in which they were
created.

For consistency and to avoid similar problems in the future change
x86_android_tablet_remove() to unregister all device types in reverse
order.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240406125058.13624-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/x86-android-tablets.c b/drivers/platform/x86/x86-android-tablets.c
index 94710471d7dd2..2063e1ac9d0bd 100644
--- a/drivers/platform/x86/x86-android-tablets.c
+++ b/drivers/platform/x86/x86-android-tablets.c
@@ -1748,19 +1748,19 @@ static void x86_android_tablet_cleanup(void)
 {
 	int i;
 
-	for (i = 0; i < serdev_count; i++) {
+	for (i = serdev_count - 1; i >= 0; i--) {
 		if (serdevs[i])
 			serdev_device_remove(serdevs[i]);
 	}
 
 	kfree(serdevs);
 
-	for (i = 0; i < pdev_count; i++)
+	for (i = pdev_count - 1; i >= 0; i--)
 		platform_device_unregister(pdevs[i]);
 
 	kfree(pdevs);
 
-	for (i = 0; i < i2c_client_count; i++)
+	for (i = i2c_client_count - 1; i >= 0; i--)
 		i2c_unregister_device(i2c_clients[i]);
 
 	kfree(i2c_clients);
-- 
2.53.0



