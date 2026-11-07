Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062052;
	b=1eh+f3373cNV00EUyqmU2Nng4rT6om1pyEGiz5OubisPmdIi6dPJ7FACPPfhi6IRG8JX
	 rFJjhElWjFuQ1/imXUGqchCLp5hd7uxNfqsah0OxeLroHTob25H1h+KRTMomjPMGAzYr9
	 /HUHhS4ujM8mAUeebcLFYZZq39sLqf2NcF60DG8MBOXoWKWQxuMhmdjcLEVqzRfHoL4eW
	 CPmQ14gvijw4BtJEg8YIgB/dc9en5InnP681xiqj4acQIw90jHlEPhnnfHzLt43nOLZ7n
	 s7E9IbpRAydFDY2fNoICFvap1Rn+UcIYlnGKeBf0zwRxEQ04T4XzfTH/1A+TsG1Idfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DR5DP03c0Ar51xFbFHeeyHXqYQxs1OznCm/amhaAnUM=;
	b=pBvbTM3nS4LYD/tUvYKh+GEnQgCTupEjPapn3gr9iE6OI0NM8uyBg54+DGuvo5IbW3Ts
	 +PtSI2VhxGB6mNZS8uwrgETGKWF/0X8tpoowSNib4jNH16zagTTckAzgbFXpSmuHEqC6G
	 +2DKj6mYGVKepsMheFf97HIAVCQWzM5RDo4oQ5EobN3Ds2Vp3B/21hzRVXTGRkqUJs1QY
	 QCDve0o4gy9feXabvBYm/srY42jwapuggFsdoVv0PrTnHEwcA/HvrgwqhffYJVokSEcBK
	 kvLeFQ5+9a8Ya053OLx/SThciNtaU2TAo3VmlEZP8pjoNbOlcGqSPqCNwYqccs+wvxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfYghiSP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDE7606A334;
	Sat,  7 Nov 2026 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfYghiSP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992C21F008A1;
	Sat,  7 Nov 2026 14:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062051;
	bh=DR5DP03c0Ar51xFbFHeeyHXqYQxs1OznCm/amhaAnUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfYghiSPle4NMAqyexMxK2tAKJyqcxFeJ2h381b7SlRQhe2/W58qAy9fXlQZPuQc+
	 NFPO3ty0WeqwvZlG7+AFdURYGrF16Xe0MAcdf8WQZ+Er76S9cNcziHYZIlzQwIMuBJ
	 XhId7dYWlo8RLfpTLHN2F6awZMD8uRmdbJWisJkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0995/1536] iio: accel: kxcjk-1013: Disable autosuspend on remove
Date: Sat,  7 Nov 2026 08:50:11 -0500
Message-ID: <20261107135025.612143084@linuxfoundation.org>
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
index 4cda8e05cb463..a8e16dc995ef9 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1623,6 +1623,7 @@ static void kxcjk1013_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



