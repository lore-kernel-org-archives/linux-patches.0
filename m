Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045030;
	b=qYNBApNZnMknkKyKoKSfpieFk2UFrDpZ/GFpx3ZWOBMvrHblOJWT21gUqDVz7jnz0aGs
	 OYfllpxOwAK1H+v9VUxuRlqiSvAe4DQImDwKBG9/+CEtBJW5ukKIWGYyfkjrlHNXv6cvF
	 Pn/s/lJpHw3Ddr14853C1Gj8tmbY8vv0XZebzCAXJuR9rEy6NDsurcaYDvzdYXs8iwo+n
	 JCvwhJuqOv0VW2g/C0vhJjxFlNX6Azoew3qiImkLNKuLmrOn/n9eSr1WR7GMB/HD3MGGx
	 kcAMECDO8qwoYx6ZqGyk0UOQGsCnLM63uU1pLV4ocPYWz5BO2ly3dUUNfXT8LtXutcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iy1sSB9Sd/jySKhWJjodc5yEpMv48L9oslqaxXJ7iI4=;
	b=hJ3AU+onXsdVmx7ak/B+I2HEHGEp7HFYs7uHsaMDsMia/D8nR34YS/yyVhcTAikfFJmM
	 +t/8F3/kGC1DkUVU08/qotTsHMs+AwWQPGWFjsqpzgAzjGzwyCfouI7GQ21SZNZ+TCoH6
	 MmcIBNK0gDJuHuhFmVP40EnRC9xLjO11XZq/xRBVJocQut/ethbvM+ZJCI6teusmtU/bT
	 nPn3esfPHLgKE3wZyQ1L7F8H7roY7lX+At5QJcLReqqmiCTvM/s8XSMcqHaGXdSy0uyWH
	 HcFNU3JCuqykvKAB4DOjN5vYFsy4ZykLXEDWGd9VZx29j35P1+GWxYrb5JCEcrSk37A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h/afOhMt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1322B606A31C;
	Wed, 18 Nov 2026 23:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h/afOhMt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ED21F000C4;
	Wed, 18 Nov 2026 23:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045029;
	bh=iy1sSB9Sd/jySKhWJjodc5yEpMv48L9oslqaxXJ7iI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/afOhMtMhwvGQGusP0ShRPFlnErOzm04rtkiS23r51Sz5Zpf3aBYnHMMcPv9Ugt7
	 kB63gwA0CbsRN+EADhkCWAZLpXJDzFCnhHGqmZPphioDYnRzpzlEXHPU5cpH44rQDc
	 H50XRQOx1/LJTW8+c7+y/G59SaK4jerFZx1UKSZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0776/2857] iio: accel: kxcjk-1013: Disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:30:10 +0100
Message-ID: <20261118150229.508652494@linuxfoundation.org>
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

[ Upstream commit 1de1206a42741adfb72ca8b37dc71a6bc80cb074 ]

kxcjk1013_probe() enables runtime PM autosuspend with
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

Fixes: 124e1b1d0924 ("iio: accel: kxcjk-1013: support runtime pm")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/kxcjk-1013.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index 6f594c42b3378..669e971e25f77 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1618,6 +1618,7 @@ static void kxcjk1013_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



