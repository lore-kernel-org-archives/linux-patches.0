Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059367;
	b=oTiogGvKoNUP4lpPvBWO/RnNWs6vY9VvGSqmO4u2B5SCwQMe634slCoIt/3huk1BYOLY
	 YLKZWcyzjUbHLzVpJfM9kMdvimDfrIhMWSHzKEXYLs0Vit0OcHpJUrSHvebmSTF48hN/D
	 O5HX+9THWEIycp/PEzmGe7Yf8bVkg+fSgmx4DeccMuDkPCo5dzPc34heM5MEBqbyrcVgF
	 nOD7nrmleXU56Vh2wWDJa826/Hu7cyByo07oCtq2Iqq/y6M8ZujKHce+82B7Qj1syGJJW
	 UzYUPcWZPkD0oaojWayLCmOoJKItqbSfGl+oTzUbipRM486QweZhOgc+XkaXGePQ+Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zAOEtE/UPrxqxHysu72OeaONn9Nts99WArfbSJnD8k0=;
	b=NfUMQ9h3xtZhiRmkNy6094DB6WvhwSee/04WKtQNbLrC+aDNA0of48aUbzs7dlXlHfS0
	 jFOPfqgZNVcBP9FJm8+AwxgIYmHfkRncOQnOOzRR+SNIJZqVYqsTnly6t7RwnfwWGaWnI
	 ggIrBYdwW4TzOZeqEnDH60CUprRj9r9dOCLlIycdsP0a6/UpTgCFxLeeK6bxfn3hmEYJC
	 UAbw5JCBWwS5xODP1z7bZr6eGLqhkzHBTqDukwLdQQUzebytCeew2UZV4ffjeiIuOMPAl
	 a+qfyeFFuwtMoWXFgHVqSqp/kWx0r93wbHuUjgWU2gyXOzeYALHAkx/LyRIMIheOqmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tX7830MT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D777606A320;
	Thu, 19 Nov 2026 03:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tX7830MT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3ECC1F000C5;
	Thu, 19 Nov 2026 03:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059367;
	bh=zAOEtE/UPrxqxHysu72OeaONn9Nts99WArfbSJnD8k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tX7830MTC/rsxmQsKolKhmDR35l3Kfk3WH5P2EpTtocxkBL+Ls/qC32vEhOI0VcBq
	 lO01GKq+M+LCF6EGNEt+TvzgVBd8qz6oJQHnvbESa5zobJ06TtzQHQparHSZpuecgO
	 JhRvkfX52iS9btgFKoNt41L0HNTP0bCuqBkDPmxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Fabio Cesari <fabio.cesari@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0816/1848] iio: light: isl29028: fix runtime PM reference leak on error paths
Date: Wed, 18 Nov 2026 15:47:34 +0100
Message-ID: <20261118145950.561859245@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 15cf67b5e8549..8aa84e06eb51e 100644
--- a/drivers/iio/light/isl29028.c
+++ b/drivers/iio/light/isl29028.c
@@ -409,14 +409,9 @@ static int isl29028_write_raw(struct iio_dev *indio_dev,
 
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
@@ -425,7 +420,7 @@ static int isl29028_read_raw(struct iio_dev *indio_dev,
 {
 	struct isl29028_chip *chip = iio_priv(indio_dev);
 	struct device *dev = regmap_get_device(chip->regmap);
-	int ret, pm_ret;
+	int ret;
 
 	ret = isl29028_set_pm_runtime_busy(chip, true);
 	if (ret < 0)
@@ -478,17 +473,7 @@ static int isl29028_read_raw(struct iio_dev *indio_dev,
 
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



