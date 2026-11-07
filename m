Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062054;
	b=IdOBVsqTtdPCF6LRGEpLLGf1p1m3dGrrRuc8Yn7/H/HBpbkoEXgQBN8WeoS8TmE2W2iN
	 0UeLAkNyfRh5QEYvWMshzhKgK0bnbKjaoas/A1AQfBQ3lqf9HDH8Go5gg1JMz3aRNgD8t
	 zYQE7xwHog2+4eNkz256PUsPEIbVwYqyy97LvJNFULwukHerz3yPRFqZ9W7wJhwaXN4B8
	 PKZ8cq+3+DwC7QTJYh7y7JkapFC+s/mlly8dlA5nBNKrwW2H0CIm6HBf1QAmJFGj7qnkv
	 Q/t/oOcefmexpUS4PRC/4h2ziiMlDbHMudtt574xmNcUNNG4FFu+yCsC0QdXQ/OVPvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XBXvHX0s7t2GFvJDUZ+cxVeF8JBfpb44ufENSF69vT8=;
	b=DFeEuTRug4DpJ81jcw5eM8icuBq3VrAZ1YcPhe4vZJZgr2S7T+fASSXgMJeMtr9Jk+zi
	 J/zogRhiUC9Mm5HJCSoQ5GYbrku28AiBbSi8vrZ5W+8KbdcXhj+TUZSZWHczbrnQprp2R
	 pC4rg9PZExL/HZVs1eBBem+nU4FWw9qANN36lcsJ7ls2JY674zN2JctdR7TZlumUDsDwG
	 F5KlgsBOCDkX0DHBTJtMGZiA0JMKC/Vws388oFErwbLbaJydedwkSLmC39MzNiMDqC4x2
	 YeJxEdtrC3+irWiRLU0ZSYtoBSs6fMfIxa65O6APwON+wxdgrTOCcK1odxEzVkNixmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0QUtRtCw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535B3606A337;
	Sat,  7 Nov 2026 14:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0QUtRtCw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EF71F0089F;
	Sat,  7 Nov 2026 14:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062054;
	bh=XBXvHX0s7t2GFvJDUZ+cxVeF8JBfpb44ufENSF69vT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0QUtRtCw5QhyeudyOckiXKLiRo7ioElxiNoasP3rgjl9XBjpb80Oia4bJXYnPtY9q
	 fTpSP12kWeMYZls0pdLxPszeVepBHf59coyDtZu1YfcP+qTifR2GeVzGHwg3VfRMwP
	 v8htBpbdSDicyoiuPDfdyhKY+LXXPKgefHZRRIBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0997/1536] iio: accel: mma9553: disable autosuspend on remove
Date: Sat,  7 Nov 2026 08:50:13 -0500
Message-ID: <20261107135025.668887849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 86543f34ef17c..2840ccc40a80c 100644
--- a/drivers/iio/accel/mma9553.c
+++ b/drivers/iio/accel/mma9553.c
@@ -1155,6 +1155,7 @@ static void mma9553_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



