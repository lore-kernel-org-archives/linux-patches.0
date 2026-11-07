Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062862;
	b=imwqvWwYXE2qdEKttbHtt2j8sC9u09sFB8AHarMFmbIqUpEpwWzPvzQYN3T5h3mTA7WV
	 vkLcGeOjM7uf9Vq4PeZ0lnYSBWyJUuA/Jkk/vHT5yuW9L2JafICaICZE8e5zPBKUzme0E
	 Z6DSMinBFLpCGgN6WYhyK1b90sgT20Qo4AP03vXgxJu2cQqYgTe3w/KXT06TIunov8Cex
	 yi/XO6xHAtzmMhXWzKtEByQMFwyS92sS2ngQEW0oLUrQZcaahujTAUaSe/u8JpL+ki8xa
	 oqh+EwmzC7D+p0iAQUrT6s7qb4SkW1NH7a4YbxWA6ax5GlXXISWDJ+zD4sFG6391Y4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0GVHo4wHFKLWhCaP2SEB0i226Z51Fjz/gzEa0yvd/Yo=;
	b=JGOHmZfXOdawM0qnvmkKwC39RJAt5FcbBkWuEsyoUSVzxjboTx119OCdMyVKEld75eRK
	 vuVsVdh+/xP82eAu+5hyR5g92rw/O5nLzsJrchKolgGGjvx/J82++SUV5at9LZfm9r9jA
	 BzH21Mv+ZkA0wYFHuMrRqk0LtRa0Re6M99n09gaWVihAPAevKJX8cDOGEGKsVL3GfZEna
	 pwY8IdYpu82UtsZz4cpO1ufZSambsKV6R48g167OTP9nFU8ShttU53BlJdfbY2/p1FORn
	 RLY9chE+toBsQpeyGs+uohJNR17UGZ4q6ohQ5D4k7+dzF5dBtJdqzXqmHls80nGY6SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AyrZ2xod;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FF3606A326;
	Sat,  7 Nov 2026 14:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AyrZ2xod
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1195C1F0089F;
	Sat,  7 Nov 2026 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062862;
	bh=0GVHo4wHFKLWhCaP2SEB0i226Z51Fjz/gzEa0yvd/Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AyrZ2xodfWlOKMhHAM5KauNLInCcLoIkVqsSdycsCV3wJXwT/RYHvZnrlP0bKioWa
	 fy+hhTtNHZ6Q9clrjwPFe2Aso28l1pZ2ouAGSHj2d2+ogLPg8YzWlmon2n8xV/Hot/
	 +80icPzUWk9IYwxEIz8rfk5bvpoGQ0NjGccPjLAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 149/869] iio: accel: kxcjk-1013: Disable autosuspend on remove
Date: Sat,  7 Nov 2026 08:47:11 -0500
Message-ID: <20261107134857.400116037@linuxfoundation.org>
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
index 297853cd39e59..a8652bdd011a6 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1548,6 +1548,7 @@ static void kxcjk1013_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



