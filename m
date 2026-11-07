Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062008;
	b=SuHpyR0BI1moCdzWBpsjcB+2TwlgNsMWgTAuGkQjY7L19Rzo4ak1vRsrabQKaSFk7W5N
	 EMKs63d905r4/DoaZcgorDbsiSGmcm4w/8AP9wW4muExSWqh4kAwbowPesbp32YnaM8PN
	 wRmU+FVIiNlF4ShEooW+MjFoAWIMrk2Ee1F4o+ujvXwZe0PN9HcEramyq7p9sLFyX0M6X
	 AdWHUY/jZ+1BISJu113DGfev07hNpgsr8rbXtJUbCWDivk73nnO/eJzegbeNW/KGb3Yef
	 6nr1YF4SyPwdsHKy1a2gVZUOZVLddr7wWAb9+mvFFhdPkJabwgAfHaDt/kNewsdIzVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gt/ASBzTfARgI+qrkoPqNcz9kinA9gbLq+kyXziOPKM=;
	b=zZeAW0BjV58DK/srQ+qY34WyRnq+VfXhBbD+30AXhbUPSCiDE/qofU5E36hxKxSrDMcS
	 6ZJiC6PYscd6/Unir/oFVtVImf07vbIC16ZJpMHhe5kMgnboK95yt5HMQBoUD5J1/qvk/
	 /fng7XX1OiCaTz7Tyj15fO9KRRumZrut69EQpFKRz6z0I87APfFv+OhNDKuavt4Bf09hK
	 xkQa1ui+G31YecziMrDbOma7GKhqO9P1Dg418KJr5oX7p+sEqs3M1jtBpZvtJhscImnqX
	 +T9c6wH8EhDdmWNzX2iXXvF/PFFtYLpZgdVx9M3SO3cAozGX8ZlAYLmvSK1/xLvj2Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R/Ehaek0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BDE606A333;
	Sat,  7 Nov 2026 14:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R/Ehaek0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D8E1F0089F;
	Sat,  7 Nov 2026 14:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062008;
	bh=Gt/ASBzTfARgI+qrkoPqNcz9kinA9gbLq+kyXziOPKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/Ehaek0JQMs6/dsIi3Yu2jov19W7PMzrTIaNpRPu2pYfvPcUqfxK+G/EhDL/2xAs
	 FlTTW8nCVwrjit7+Ar9JvxojuDd9wNfZMmZlstvehvS4aAftIoPo7LgB1c4hgZ5oMW
	 Pc+xPrwKXTahF1vJee0Bq3kGrx969k17ftb3IHRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0998/1536] iio: adc: at91-sama5d2: disable autosuspend on remove
Date: Sat,  7 Nov 2026 08:50:14 -0500
Message-ID: <20261107135025.697033501@linuxfoundation.org>
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
index e476b71cb2aab..34211d7066e31 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -2510,6 +2510,7 @@ static void at91_adc_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(st->dev);
 	pm_runtime_set_suspended(st->dev);
+	pm_runtime_dont_use_autosuspend(st->dev);
 	clk_disable_unprepare(st->per_clk);
 
 	regulator_disable(st->vref);
-- 
2.53.0



