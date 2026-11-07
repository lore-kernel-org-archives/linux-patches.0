Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062864;
	b=IHLInRJrMhunRt0yZAsq8uhabaXIuLrtt1V2rkJ3y/Om4EZgB4AI1kqo9KXJFEiH8Ygv
	 D42FREdUNMRbvZGgbfzEj+k6hdJz3cREzegycAe85lUSF8MCbIGnIeUNZwlpmfPeoa8xk
	 kDVjx9wnbYE0URuQu5gDIc3xphaEyu016+LPFocsms3cDnSSwAQSlkVpO5p3eeGbGlGqp
	 d3DBRgls1LndV2kUVrUIuaM3lMABFLSwz6ldJl4x0/ZYgoruHgKe6ZB/2G3TW3tZSyj2+
	 EYHQEV4+QeFKsNnDjk0TL9pZyd8jHOA6+d0IFHRbyxdDOw3v9lrhaopJlvp+pMmPMLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gUQT6AHst2t+9U36TCJfe0h/rqTc1/4ab2385w/jWHk=;
	b=x0+OhwxuAOcYGQqTOKng9i/ju5sL4ycu9yUKKH3IQ8KF4CksxpQgm2d/3m0BFaP+pbhU
	 JeIZtsoMIyqQqsReFJWC9TTU9MsidaVgGjZGJSUa4IuKz3ELi8LMTHJuI9vZ0Wql0gp0o
	 QvgR2bKmCOj977JduTPBFw2grPbeOMrhnW/5s6Zz9P6wpt0HR6fZJFBlJbRUKv6xRnONm
	 lQC+okApb2o6r2AEgsEKO1NaOx3934uhHKIEEDJoIFJLiz7FiPvNizFdxCYyFxWINV6sU
	 ORJlPK5hQbCGa1c4BZ1qbWYqaAKDrSnw19WR3eYpfTt/U0CPu9oMkWxoTEkMYjECBMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yXoZZFAJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0AE606A32E;
	Sat,  7 Nov 2026 14:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yXoZZFAJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1186E1F0089F;
	Sat,  7 Nov 2026 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062864;
	bh=gUQT6AHst2t+9U36TCJfe0h/rqTc1/4ab2385w/jWHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yXoZZFAJYKUjaBInwITdUUg0RPPqSZBmumALU9Gdd1X917I7/aqGb5OGwxt+WFbEp
	 i4z/CyROYkvKHsWzlR/nuuZO76CBUJFKCXnlTUVjk7aKZ/4AL0v5hly0yeYEHO8OD7
	 jxB2flkBosB5zdcYdQVywhL7eV4Gm5foxs5fijzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 150/869] iio: accel: mma9551: disable autosuspend on remove
Date: Sat,  7 Nov 2026 08:47:12 -0500
Message-ID: <20261107134857.428356002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 8061720f6be1811478914f8b6143778d70f6033f ]

mma9551_probe() enables runtime PM autosuspend with
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

Fixes: 6da93a6710a3 ("iio: accel: mma9551: Add runtime pm support")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma9551.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/accel/mma9551.c b/drivers/iio/accel/mma9551.c
index 02195deada49e..28342a757c6cf 100644
--- a/drivers/iio/accel/mma9551.c
+++ b/drivers/iio/accel/mma9551.c
@@ -503,6 +503,7 @@ static void mma9551_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



