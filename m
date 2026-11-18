Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053737;
	b=m1ZTV6YbeeUtGRCX2UGElQ8PGGeqBXu6FEK/ctmg6yWePc6lnH6Ax5XTVieaADTjQ5EM
	 Kcsznc4RNU8g1ORjTfHN31sjKW6lmMjvQky/z9VeKaGEvqNmu8oR1j+tOfNW+PuwO175s
	 zsacP3wTgKVCxut2saOn+bwVgplRO4Lv72y51S95FtI5K8/pSHLJHkmgxQCjyK+unFcCo
	 1GDE+z51Y4Z+gkeHHXJhFfR00ax1v9Bul1Cq0yGoFQDxuEKZe/wYrjrZML44hMTzS8wfP
	 2gtHPs4VpCg3yw3zUFjz1zh+cvHn4LGq5VKHC8SJfMCvF+M7f0IzzCHP6VzKpCdNJKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vr3rU1EgFexiv/L5qUtXs7c1IS8sZgIyKA0FLWg1fnY=;
	b=LVBIRLGzVlAt7q56swfG+GK39H+hcJknQKGB0LtzQh+JO54bflG+TYIDF3Meb+dvorhm
	 DbXQI1DEcQyikEV4ek5YXxIkuxanHIzPyqYHM52m0AmtZXU0aOQevadot43oG2xMwdbZH
	 rooO/AkyH+F/niwWoRNL5oQFIvjlpE1prUXr42OfMtIregvbvVE34GBt2CzUTzMlrEhqT
	 we8356wRQpAPTQMMLx7ypX1qqD2OfStpdLcO/Zn9j1yTpIEBlhCtAGZQRj60+Ys+6kh1E
	 hgVB0UnG5XPfJ7fV6A+vP+3kmD539U7b6Tg3jXLDDPNrAGuWW4YGoyg3LLIQSPO3bSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+D4Cz6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46968606A31C;
	Thu, 19 Nov 2026 02:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+D4Cz6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4521F000C4;
	Thu, 19 Nov 2026 02:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053737;
	bh=vr3rU1EgFexiv/L5qUtXs7c1IS8sZgIyKA0FLWg1fnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+D4Cz6gTj7IVNkb1ABV0ulBTMBk3RW97iG6eRY1Tg/fp2JqNqD2qDlqKA8UnRu6p
	 Jgc1ykQJBYsRNjWcyWoPHt4SNOunajVFAKM5Z5f8eB4lRUcaXXXJjIDnF+AS47kbNU
	 ET7xUKbFvsKn6U1pnJLskrzg6uQhsLueoN2IwlIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Fabio Cesari <fabio.cesari@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0984/2214] iio: light: isl29028: fix runtime PM reference leak on error paths
Date: Wed, 18 Nov 2026 15:44:20 +0100
Message-ID: <20261118150051.599134214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Fabio Cesari <fabio.cesari@gmail.com>

[ Upstream commit 0e30d15b15647df786e60022650613e16dd70645 ]

isl29028_read_raw() and isl29028_write_raw() take a runtime PM reference
with pm_runtime_resume_and_get() but return directly on their error
paths without dropping it. The usage count never balances again and the
device stops entering autosuspend for good. In isl29028_read_raw() this
needs a regmap access to fail; in isl29028_write_raw() one rejected
sysfs write is enough, for example

  echo 200 > in_proximity_sampling_frequency

which is outside the [1:100] range and returns -EINVAL with the
reference still held.

Take the reference with PM_RUNTIME_ACQUIRE_AUTOSUSPEND() instead, so it
is released on every return path.

This also stops the return value of pm_runtime_put_autosuspend() from
reaching userspace. That value only says whether the device could be
suspended right away, so -EAGAIN or -EPERM turns a successful access
into a failure, and with CONFIG_PM=n the stub returns -ENOSYS on every
access.

Fixes: 2db5054ac28d ("staging: iio: isl29028: add runtime power management support")
Suggested-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Assisted-by: LLM coccinelle
Signed-off-by: Fabio Cesari <fabio.cesari@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: used explicit isl29028_set_pm_runtime_busy() calls instead of scoped runtime PM guards ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/isl29028.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/iio/light/isl29028.c b/drivers/iio/light/isl29028.c
index f4e1f7de1e421..7d377b6a2b838 100644
--- a/drivers/iio/light/isl29028.c
+++ b/drivers/iio/light/isl29028.c
@@ -407,14 +407,9 @@ static int isl29028_write_raw(struct iio_dev *indio_dev,
 
 	mutex_unlock(&chip->lock);
 
-	if (ret < 0)
-		return ret;
+	isl29028_set_pm_runtime_busy(chip, false);
 
-	ret = isl29028_set_pm_runtime_busy(chip, false);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return ret;
 }
 
 static int isl29028_read_raw(struct iio_dev *indio_dev,
@@ -423,7 +418,7 @@ static int isl29028_read_raw(struct iio_dev *indio_dev,
 {
 	struct isl29028_chip *chip = iio_priv(indio_dev);
 	struct device *dev = regmap_get_device(chip->regmap);
-	int ret, pm_ret;
+	int ret;
 
 	ret = isl29028_set_pm_runtime_busy(chip, true);
 	if (ret < 0)
@@ -476,17 +471,7 @@ static int isl29028_read_raw(struct iio_dev *indio_dev,
 
 	mutex_unlock(&chip->lock);
 
-	if (ret < 0)
-		return ret;
-
-	/**
-	 * Preserve the ret variable if the call to
-	 * isl29028_set_pm_runtime_busy() is successful so the reading
-	 * (if applicable) is returned to user space.
-	 */
-	pm_ret = isl29028_set_pm_runtime_busy(chip, false);
-	if (pm_ret < 0)
-		return pm_ret;
+	isl29028_set_pm_runtime_busy(chip, false);
 
 	return ret;
 }
-- 
2.53.0



