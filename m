Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884A226A0E3;
	Tue,  8 Apr 2025 12:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116777; cv=none; b=OzkSPOcNbFDHzxjooZIOZ8+BLeu1/RdUWpfIesT99iW9QboN80eqNADgle0wRxOP/yQ1ALfTdpHiMG+cF+h6ApH+/lk7Idsw6ZbphdIge94mifr32NwSJTyCtY93GsU7Ccfh0eaQrMlYcUDw6t0DYYDryeZsk0x99INq/knV4FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116777; c=relaxed/simple;
	bh=SIIvROhcrXFbnPvat55SNav/pODBWVx5/01AVrUgths=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtoRsLj0/Pmmsz2M9WpoQFlndt3sxaq9n6QRwMrwPznq+QR8YiraGhBGtlRzDz4MPVSTIhiPxGWEuWS4Y8/kDKCaYxvb/p/voAGdW+k1F1bIRdl3rN2xr6gzoOsR3OuOMffYkGeKHr0FQMKHASAHG1z56kwkA4imga5L/flPjMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaT3Ntk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaT3Ntk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3652C4CEE5;
	Tue,  8 Apr 2025 12:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116777;
	bh=SIIvROhcrXFbnPvat55SNav/pODBWVx5/01AVrUgths=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaT3Ntk+PFPVP4MiEcVncJNkVA10VOet9BGqjZIVZaykbv2SeUOMNVkDuM8jmULtQ
	 TGWHTixz+iOwEnhFPWsW+nq24q8FlagNWKXDeWcV4gXFUDVFNW2Sq0jgrQqqbO/3pw
	 V4NRmh7jh/IAWWKibVaz2IHXM5MW0B982C/YFiTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xueqin Luo <luoxueqin@kylinos.cn>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 225/423] thermal: core: Remove duplicate struct declaration
Date: Tue,  8 Apr 2025 12:49:11 +0200
Message-ID: <20250408104850.965184446@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit 9e6ec8cf64e2973f0ec74f09023988cabd218426 ]

The struct thermal_zone_device is already declared on line 32, so the
duplicate declaration has been removed.

Fixes: b1ae92dcfa8e ("thermal: core: Make struct thermal_zone_device definition internal")
Signed-off-by: xueqin Luo <luoxueqin@kylinos.cn>
Link: https://lore.kernel.org/r/20250206081436.51785-1-luoxueqin@kylinos.cn
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/thermal.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 25ea8fe2313e6..0da2c257e32cf 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -83,8 +83,6 @@ struct thermal_trip {
 #define THERMAL_TRIP_PRIV_TO_INT(_val_)	(uintptr_t)(_val_)
 #define THERMAL_INT_TO_TRIP_PRIV(_val_)	(void *)(uintptr_t)(_val_)
 
-struct thermal_zone_device;
-
 struct cooling_spec {
 	unsigned long upper;	/* Highest cooling state  */
 	unsigned long lower;	/* Lowest cooling state  */
-- 
2.39.5



