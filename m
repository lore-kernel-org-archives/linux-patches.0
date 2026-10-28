Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214592;
	b=ZurYMH0ZkvWz5taSv5QigMgZ3KEW8HcosIgjWV7/aFrNVsz2dKzCLapnbfS8yxs8s+bE
	 gdUphLK7ybRHVOc3lzx9B1qaKy75a/aRQS+QeeUgZKM0rr73aVgz2mL+7ffHBANCkEvks
	 NYRiSUM5EvgYhekGALwbvzHEfB4Qsy4Khzr/5wc9XdWJv4ooMy3JEFQR0FqqrzIoztCLm
	 jbCbYXAxYYJVliYBOinW0nZ7h5IhA1yI2lchrE10elkjxtSGfKAxYuygb6gesbwdJ2zve
	 xozFxhf4+A4dhDf1SOx0DEFfqRrjGH2pSYgvfpdZJx0rRB6vCsFwRGjWR1aMFAfjELA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0GJUTPSpGvGKcmcYExemcckNspr8wzMY6CmUYZOy9N0=;
	b=qTirThkAW1MbP6uEkIvuqzVT0fJZivPhqsZQhCWWf53h2aR+sDNEedMg1I3e2G76KoWG
	 Q63aH6XhoO1+Oh4uqQNuRs5P9wwEndW4QxMJkvGhueO0fWBfnZGY3e4zPvAz9xUv5NLIs
	 NAIIpuMi1EzMoyivIfBvD5oI++eaMxU9mkGYXOWfdUPYtqchPvZJbH5aWboN+oz6HUYXK
	 dFURxx6UY04bNqaTP1/PYX70avN5HR9t3Py719yvxl6aLm5yJSZjos437lQfgbLcoq/lP
	 2/WvGjvbtRH3TnSkzNyw4lLIipGCJ/ixwni1ddlIu/PcS0c6GJVZecY+ngl+YLhMF6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rZxoVNVz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E6A606AB00;
	Wed, 28 Oct 2026 19:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rZxoVNVz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D905B1F01829;
	Wed, 28 Oct 2026 19:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214592;
	bh=0GJUTPSpGvGKcmcYExemcckNspr8wzMY6CmUYZOy9N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZxoVNVzzf2o6RUttjJm2my5aWOHCOgOuc2kOOhMpTUwEV9FKobne0ArQ36e8Dq3Q
	 0MzFyHE6brD3flTv3/ltE47rGnMmJcR+K3eZ0FC8VP6I6DOc9PQPP9Qv67TDtU6qJY
	 WGc43gyvb3JE6zo7fzdKw+fPcq3NLr0NA+5NOhxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0914/1887] iio: imu: st_lsm6dsx: fix LSM6DSV sensor description
Date: Wed, 28 Oct 2026 17:50:10 +0100
Message-ID: <20261028170520.215221712@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d94fbd9231a2b4062cf5972629999402ea7dd6fa ]

Fix sensor ODR description for LSM6DSV/LSM6DSVX

Fixes: a1c6d631ff12 ("iio: imu: st_lsm6dsx: add support to LSM6DSV")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/653e14bf79bb88d8581d2bc42da2f784caaf3776.1668417770.git.lorenzo@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: c34e2e2d67b3 ("iio: imu: st_lsm6dsx: fix iio_chan_spec for sensors without event detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index d692b0f1f7622..6936db2e72f88 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -34,6 +34,13 @@
  *   - Gyroscope supported full-scale [dps]: +-125/+-245/+-500/+-1000/+-2000
  *   - FIFO size: 3KB
  *
+ * - LSM6DSV/LSM6DSV16X:
+ *   - Accelerometer/Gyroscope supported ODR [Hz]: 7.5, 15, 30, 60, 120, 240,
+ *     480, 960
+ *   - Accelerometer supported full-scale [g]: +-2/+-4/+-8/+-16
+ *   - Gyroscope supported full-scale [dps]: +-125/+-250/+-500/+-1000/+-2000
+ *   - FIFO size: 3KB
+ *
  * - LSM9DS1/LSM6DS0:
  *   - Accelerometer supported ODR [Hz]: 10, 50, 119, 238, 476, 952
  *   - Accelerometer supported full-scale [g]: +-2/+-4/+-8/+-16
-- 
2.53.0



