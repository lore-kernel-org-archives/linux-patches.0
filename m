Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062867;
	b=1T7G9XLbCvnx1Mz2QURM0vjlkqS1bIFIJbMpNcey0lB02LHiRIXqkrgGV8R5qCczcswp
	 ll1O0dRaF7cjw4AqvV8ZTVZyyh5R9Sk96lRlYvDqhTnRSz0cLYjXWyMHz3fua9fyAbbnG
	 jQ2edXJnFKkteKWGtUgSEoInGjye0VPBNgg4fXDMuG1xDjppEtpoRF+peRqPY5Qv/OfIp
	 LFfJzYBGmZ4f53FWHHkbLFqVMGaynfv0DJvLfH9FIaZ1zqMLPGQS1CpQk5GO50M3kkBsV
	 FLq7wK76jbFhMMnKmlWpdyYCZVS3Co1DrO+kUlf2AuVyqQfAf9CN8pvpo/NLq5GTl3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vry0Jqr41IFEhubjve29hdsxF8Tw/xAsG6BcPZma/yk=;
	b=ZiM0UzCBlFwUUwoHCI61pLZ3fh1Ml4W5O2mfYU2Fs2wHZpKH7JuN+31G4EVH9mv6awzt
	 6AyChk+u5fUaX7UJYbFDHQHY9SuIeq+0NcPiyebbpAZUob/XliJdaVYezpNaaHtf2cMeu
	 x/rO7q/OqDydyX8BdSTePfaCe7TeT0ZJv0HWRJxQ/uQkSIAL+D3lDiF2+1g03je2v8EzO
	 AzZ8U0E7IsNJXv3HgyKtUBTsAdUdteGsBWdrRCyEUIlBLMRiJhALpxikm7R7gmZKDT66e
	 dnzkaRu+tXu83nYkpDNYnE1Twa2ofjvvhJ0hWs1xehbFEiTPS3lQu1Tz9UrHXinkMHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8NhzTuc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13AD606A338;
	Sat,  7 Nov 2026 14:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8NhzTuc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01D71F0089F;
	Sat,  7 Nov 2026 14:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062866;
	bh=Vry0Jqr41IFEhubjve29hdsxF8Tw/xAsG6BcPZma/yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8NhzTuckJg8N4yKTZyflymeBhRTfw90H/rX22kHZxgwEzUauW/VOOGe4o23AiiFY
	 SUo9j5LJtau20A61A+JFyx48M8Zqf+eHm/IjX6TPO5qlZz5Z0K59OHewVk89oL5nlY
	 kJgq5jpe79WRodWP9DUg6Cr+Pg+Tfc2PLAdXGXB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 152/869] iio: adc: at91-sama5d2: disable autosuspend on remove
Date: Sat,  7 Nov 2026 08:47:14 -0500
Message-ID: <20261107134857.484667487@linuxfoundation.org>
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

[ Upstream commit 022996906e70c6bc9a7968ee663ebbe314fe1524 ]

at91_adc_probe() enables runtime PM autosuspend with
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

Fixes: 75d7556ac0e4 ("iio: adc: at91-sama5d2_adc: add runtime pm support")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/at91-sama5d2_adc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index aa4ba3f5a5060..8c16c5938601c 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -2487,6 +2487,7 @@ static void at91_adc_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(st->dev);
 	pm_runtime_set_suspended(st->dev);
+	pm_runtime_dont_use_autosuspend(st->dev);
 	clk_disable_unprepare(st->per_clk);
 
 	regulator_disable(st->vref);
-- 
2.53.0



