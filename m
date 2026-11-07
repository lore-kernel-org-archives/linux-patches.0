Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064005;
	b=J22nALUinTCzsqVNXdvDBR+BCnWbAdR25MSU3CFtxZOEG8bHu5KLj5NJMQ5e5Ce/AlTw
	 VHQFjhhwcx/rTRIckAZWdvUyP0PCyv819o0yohA03QUw4MipZ3jXY/e/bD5DRgv3tDDEu
	 HQSJni3sNxNjNjhuf8cQMarhNpjrjtsWUMLIjKEHs6U2igvapnNuEK1+F7JNxaRQDDVqU
	 xwabEhiqFqyzcFvWfkeuFpmNLcTKOfk4oBdQ4STXvOU58l0acGK331LmCHceK+oo2vTaC
	 GrMeyq1FO1CYUXasUFZ9B78AoLrElrKvmD4NRaBzeyjycQtr4b0b0QQzRRy10MB5FLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aQZIrB1EKZ5mpytTDQsm+qb46VzodYB54PX81lLRis0=;
	b=HG9AvdJcJ5GQ47MJsJU+iHiYrXWpIjp8xO9kpN6TWIFdWrq4qjLwVbNY86wwe7SnuqS7
	 hEKKkhAZ4XqPHc5wnO5s5oAQj4AZXrCJPlLy1Gr9pvdEeA7EJ8f5zdtjqdYr/t5ft2g3f
	 5+WB1NtEfvQAF+cnLLD6H/mCpDYIEkxVGjqAwDgpSn01+8PYCQov2HtFiA6PkMmA3qY29
	 i+lxsYHHaFw2BsaQrsRmEotoow4jmiYJOIHfMaZTXRVRroz2X4Y+TUt3VOfbPNqcPEPkx
	 98h768iVNpLjUoMmi8G3wv17EwscOIMxWfpplKId6btiUDzRNJP5p6+WIplKdeWG09g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kri8Kppp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40B5606EE9E;
	Sat,  7 Nov 2026 15:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kri8Kppp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582C21F008BC;
	Sat,  7 Nov 2026 15:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064004;
	bh=aQZIrB1EKZ5mpytTDQsm+qb46VzodYB54PX81lLRis0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kri8Kpppy7T423kmlbtXjIkQSWAMC9seA5P+F1mRLuN39U0Xg95VzNnyu6+RuXdyU
	 4d+YeUV9/g/FDwLu7VcShiL2xRYFFzQy84T2J0vYrUo7rm9uW5gIY8acOT38/gKtxI
	 wRTwJSDCjo9RMzGccmhb3rNbjHwoRB1W2xwHG6nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0185/1257] iio: adc: at91-sama5d2: disable autosuspend on remove
Date: Sat,  7 Nov 2026 08:41:21 -0500
Message-ID: <20261107134944.565771321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e8a5285bb6d4f..e68632e628c71 100644
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



