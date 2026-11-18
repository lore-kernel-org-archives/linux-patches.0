Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035948;
	b=Wdal10AabICMWYqlgOzOBlB/hxvtCU2Ljn9kY6j1t17JaN8K4zbrGOpvPiKzrWHArtNV
	 6Q8+hNb0zEAmLtMgtIhCowcuEXE3t7W4VDZyzFQhyqLiBy11VqHr67fAG/fcRrlUZJsuD
	 6HZw4nCrysKP1YOCHtf/V3gmE03LusiL6adQNaNgFg0KxIHigMol5CHB4e25PdMkSSDZw
	 5/odWJqb1ZcfbfrlnY8Ia15TTkOU4giLmZwVbj+BnbpEk+v19q7RGPODUf1WZnop5REm6
	 NmI1QRRGlvkqakPMYq4I6u930aAV1QHWpPTSEKEmA6L5W76x4HbD1Nizkpjet/AgnUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FvsODOztpCVR6EqMu3TIcfgXnnAQnR9306cTTWJPyy8=;
	b=PV+NnS8eu7PqGMbxkzg6K+0vqEUvOs0vpfZtUYtkKPiT7ITWgtxdM7bU908QeXDO9gFB
	 BpAmZTCWdU/dY7EoHlk1Tpmq6UnHMWkE4j0/tjlHF8G01/Gq4Pw3qMdm57UrBcD29ygU/
	 0Id/PnIL1TopXNX7X+vD5m6UL3F2Y5shhoGrQuU3ENoFMCSQwzzFrFM5Hckxe6NA4YBNq
	 nYIXIbW3moclC9VMMIF9qzahxHw5t1pRgigH+AfNm4o2lrdZmT03yMxNPQBTUZFvHb/JO
	 A/x3OJEmxbnOW9Z0z0ttGJeS0qUlyWH39nRKlEgd8p2q+b8Y9cpQktXvCMxf62/Wnzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wIFVrBsp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28336606A334;
	Wed, 18 Nov 2026 21:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wIFVrBsp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AE01F000C4;
	Wed, 18 Nov 2026 21:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035948;
	bh=FvsODOztpCVR6EqMu3TIcfgXnnAQnR9306cTTWJPyy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wIFVrBspHT+p4yN2I0xHKgrMMv/s1Nm9A+5xKkIY7ARFni4l3I2U5aJymLqe4csH9
	 rs3mrJNUnFQdz3wbZMPDW5p/iiqGb2QzIvl2q3wHmXODjFG7vs3U9V7uh7Ee80/076
	 Xali0efgrP69mGXARs5emU95hzZv1Kmbek2NJ8YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0885/3318] iio: adc: at91-sama5d2: disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:25:07 +0100
Message-ID: <20261118150345.933259879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4ca39a2527c21..7b8550f57c328 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -2510,6 +2510,7 @@ static int at91_adc_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(st->dev);
 	pm_runtime_set_suspended(st->dev);
+	pm_runtime_dont_use_autosuspend(st->dev);
 	clk_disable_unprepare(st->per_clk);
 
 	regulator_disable(st->vref);
-- 
2.53.0



