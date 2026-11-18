Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052261;
	b=Qn2xekj/aoXFF5M9UcaTSRhfowGgiPIOIY+w14uL/HBBBqHoPZ8x2FxpxrW1FaNk1Y0o
	 E6XBU5EfQfB+9VNzdsAOHvycDc00G1kXyHVOIlobN8kIEoF8MoWRtnUtFH6dqnUwLRRB0
	 PvOPQaYYKtstmxcN39W4nOoGU76y0Qo6vITvP2gB6g5v0ZB2/v9sbuWKTxAd4F+YFYAJI
	 jOt0/S3O3Uv3Qdkovjd2xQAFjaj+Rwc8Fhgs2JWO/YxGUMjDzEUEimv0FVo1ZB6M9SMmp
	 pPwzcQRRfVRg7LDAr2jhpFlXIRm5LMWakh/V9jx8eqcBjYQYPhrPl0xX6fGZamHLLZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dx5P/mcUzGyIhr1ZUKI2y4nUbOqS1OtTk6/xXtrAO5U=;
	b=iwqQVayUQaAhYZcVzihbMSLeFdu2QTJeHcfv7lLo5UgUyEhcVZ5vum1dPjFB/FOgtKFR
	 RnVmKTpDxmwhZBZDkkpo4SsbY2rIvHWBW/higwQe7mRjZwI3Dv79lzxArSETTwo34eZ2G
	 MDmlRwFUEsK6lUK7ibYgoyiasxz8V1W208FKAkZa1kGTmKFBFo0j0KFAinnKrLhegZ0dL
	 65aFoKqV2p9EozuouAnWx01X3fltudPU9TNODau9Y24R+WDR5bjmpLfPZCyl+D55hUeQD
	 SUTsX/kKrXQ6HaGzY6ofFpcHBmZlB4qpDzYq1HHFkLbHHgA5jL0A7GEwVcPXp0xOWtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HICkKjuD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265A4606A31C;
	Thu, 19 Nov 2026 01:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HICkKjuD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3585B1F000C4;
	Thu, 19 Nov 2026 01:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052260;
	bh=dx5P/mcUzGyIhr1ZUKI2y4nUbOqS1OtTk6/xXtrAO5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HICkKjuDmOFGYiiLNriuGZZbbj47fEWH/OzkpGJGywPayN1ZV3UVhOwAIIE6g1Ir4
	 uxoSUPX9+K2Xi2ERVmLukh3QR20Uhks6WpGg0f7aPBGYTFaB5/QJRk2n+BEFe0oNvS
	 0MmezaHYIWCVJnfooxDUPATvRr3N2OqGSlQQMdyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0499/2214] iio: accel: mma9553: disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:36:15 +0100
Message-ID: <20261118150031.119870726@linuxfoundation.org>
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
index 1599b75724d4f..a1bc00442cea9 100644
--- a/drivers/iio/accel/mma9553.c
+++ b/drivers/iio/accel/mma9553.c
@@ -1155,6 +1155,7 @@ static int mma9553_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



