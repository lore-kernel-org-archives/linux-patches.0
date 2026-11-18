Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036067;
	b=pnS0s+m4w1ouYt3ViuuUUx1AaYmX4qHIXGf8qtmocX6lSEIdlVWiAgYitOyODKNO/Jm6
	 TmmEbrBt3Z8uOosaq1kCBpaNLTtEo1h6QCJbtZFvgYzKyAb2hUrRXWpfYe7FaaFkpzI6t
	 2q1scq05LWt07SQ+hdPA5ZWP9tt2l+c2PjM8RdaXlR+TY/nyWCeWu+UVdxNFbajpUYCuX
	 8LJrEvoDPytl2QrK8QPk9bJs7sx/BtfeAJOURPv1f2EgcI9B993mO2NwOZaY+860src7q
	 ts1wPaXypTAjPZEuj0D8gOZ6u6VmyYEx6CzmaPB0ZYBEa7o3Q/W/J+Tu8jRs4FVMipg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HFur4dDUThOXeGA3SGnbf0pmC/rwLktdxIOdphGJWGA=;
	b=QGCQT+T4kIl1c7ApJiJunGKbk+pMHNwKUpXohHcZiprVVsLdL5MShnTVUoXGLHo/TbwX
	 rwb4KbOrs5Oktq6trVrwtZy/6qtaL/K62fgimwsmbnXOxVwwkeI0cfuh+LkauRKCZ3hG9
	 UjpObKkdw+qycQ5/cSpo6g9D5WcfV7GqSrY/z/HM85F6NNP5cgBYHdXE22Febw27yXYE5
	 gkk/aaL243hoUOwww6fwFbvvJCU9BE0hYOZR0ue8lfEFc8txwbZd1Yvcvu+HjuC+GrmJo
	 qSV8DnwxrqC9L3OxMW7wPftJGKONkXmq8VN7MqfYdOAQpXQlMhcHwb4W1QSokdXZggQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2N38DZa/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B618606A31C;
	Wed, 18 Nov 2026 21:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2N38DZa/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14791F000C4;
	Wed, 18 Nov 2026 21:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036067;
	bh=HFur4dDUThOXeGA3SGnbf0pmC/rwLktdxIOdphGJWGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2N38DZa/iMlXBC+hiyGECnQVp9Z+EWKAv1CVz1MZ5kUIw0MdwsjMwH3GvvEMVU3Wu
	 ExIlKAkhSPbRHkP6FtS9TCoTpfNYhT2X4J3Y1MXs/UkEpzS3I5Rj8x2HczykL8cG0+
	 myVE3kihgFRWeMRySSs1wnbMQSieAx1xnH+8hK4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0884/3318] iio: accel: mma9553: disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:25:06 +0100
Message-ID: <20261118150345.891061370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 4dda1f9d25fb889649e81bbf015809daa512a049 ]

mma9553_probe() enables runtime PM autosuspend with
pm_runtime_use_autosuspend(). The probe error path correctly undoes
this setting with pm_runtime_dont_use_autosuspend(), but the normal
remove path only disables runtime PM.

The runtime PM API requires pm_runtime_use_autosuspend() to be undone
with pm_runtime_dont_use_autosuspend() at driver exit unless runtime PM
was enabled with devm_pm_runtime_enable(). Leaving the autosuspend flag
set therefore leaves the runtime PM state incompletely cleaned up after
the driver is unbound.

Add the missing pm_runtime_dont_use_autosuspend() call to the remove
path.

This issue was found by manual code inspection.

Fixes: 40cb761306d6 ("iio: add driver for Freescale MMA9553")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma9553.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/accel/mma9553.c b/drivers/iio/accel/mma9553.c
index d01aba4aecba5..0a576eba86e60 100644
--- a/drivers/iio/accel/mma9553.c
+++ b/drivers/iio/accel/mma9553.c
@@ -1155,6 +1155,7 @@ static void mma9553_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



