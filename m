Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045035;
	b=yEEckGSjLypr20Nq3+LkkK+5fEhmEM/JgS/ILn/KXepOZzh/ywwJ7hfGMApZXMbZ4uc1
	 u5ML4d2zgKFWLE47rY/PMx8gvE9O/kZDM+W/r8PqXwwxt+R6fkMUG0BoyA4eGuORQNvnL
	 +B4lrXj3h7OSfhzQBQjtyiAeWvhXDZ8gfdYss3/HJCJl6yXeMRec7nWIdtjNvGRgMHf4W
	 6tl/ni+MKejXdwp7VfYx26VV0uZaxWVLw/zZdjbNgAxhxzQGfJKbNbfkVMmYXFBj0ZBlC
	 W5H39rdGpyHJ04koE1kSR6Y0UwQAU+Y2hLFaIr6j7iK1uqQ8xjxy8h/yWv4KiDzr0AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MH954t97fgcx4mHiJsI5RbpBczuKtHKe2auiy1+9KmQ=;
	b=Z8hK++O2fyEF8I5Ftx7sLCgI12QB44fiAtx8iNdpXxNfX/pV5bR5qg/ahhy1dYfyjl2Y
	 Ccj3ltDuPX0zYtc7GW4iiQrTArDmUzgIqWS0yO36SnA/fxpV8GpyOhq8UbGticX/8Fubk
	 5gb3ID3ZuvVQjSuleyCpyKYVQwxT4ktJIgZXPwhYxntU3AXaMnfP7EYBgMg5B6ZQOXsmc
	 +GLbQw+cJKvF7+g5Jlq1p5MNpeXCpCFCVr5vjVOKF8wbJESoFWuDTsO1pLSkpER80DuCG
	 ckSqlfBeXJAvYzMmDvs3xf3F582tOHfG0d1YsKzfrKpL/UMKvf+35W1wUs4HSsJW3gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Zc/vc6He";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A92606A325;
	Wed, 18 Nov 2026 23:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zc/vc6He
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67E41F000C4;
	Wed, 18 Nov 2026 23:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045035;
	bh=MH954t97fgcx4mHiJsI5RbpBczuKtHKe2auiy1+9KmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zc/vc6HeD5lv3QksLJvXJ4lEk3pGsZ1IgaQjW8HFb6jr2BY1YdjQp/LS7U2PYg48y
	 GSKrbIw762WyYfc1NlOfDllZD+sXIlCNwPaQIJXCUp6Kdzrc/q/fKseAZBYu1q7BNX
	 pJUymfeB/UVEzTXwIOnQw3WNgGmaeeWbBI/agXt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0778/2857] iio: accel: mma9553: disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:30:12 +0100
Message-ID: <20261118150229.581538094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 2da0e005b13eb..2d80eb3ba91b7 100644
--- a/drivers/iio/accel/mma9553.c
+++ b/drivers/iio/accel/mma9553.c
@@ -1155,6 +1155,7 @@ static void mma9553_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



