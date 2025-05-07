Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97FB1E22E9;
	Wed,  7 May 2025 19:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644472; cv=none; b=rVVZli8+V83J+hLtbv2LnLudYbsmA5D5oAwZ0v+16v7dc2RHetXDf8gJZ1obwZVmWdIriyvgYkAdCZUqmGvF2u0UsmXgi19ANsY8BZY2G/8Qz4ia3QZTe3n0tYA+hOf1yvGHnkTjqMC+p0pKJ86AdWxu6tlJtEKT+mRryuyyGCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644472; c=relaxed/simple;
	bh=UZgns7wcqi2swwqPzQ2PV3v+1mgQykza6zqckqJacjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ie1cUmlogmQYr0Q10Qu27Fj0ov86dEZJa5zUlKTrcCsCFvMY7zpOUblL2ss5SOMc1/M/ZmUeUqo5xaCG7PfW2TK9CcFnU2ISsGI/LEFYc4FTpt7MWBcdan0qcvIRnPjCJXvUZECLrr1MzDY2C4GdGhaIAXORN9NA0IUYrDtP9uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MN2BPke1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MN2BPke1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2749FC4CEE2;
	Wed,  7 May 2025 19:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644472;
	bh=UZgns7wcqi2swwqPzQ2PV3v+1mgQykza6zqckqJacjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MN2BPke1JN4ozN2SMLABeQpQnG+JoHP4WXVWtUsYYaf0XC48CSdma3v2OvSPhCDXJ
	 UMzJ98wo3PfbkOHhdU+JV7L+0pqrMYQvg2b+oxnIy2qqoDy/dosnk2eZorDNLZyIks
	 a3pylF+lZ5abL0oKkCX5m2oMfTO4ys2PrCkUjeXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	David Gow <davidgow@google.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/164] ASoC: cs-amp-lib-test: Dont select SND_SOC_CS_AMP_LIB
Date: Wed,  7 May 2025 20:38:58 +0200
Message-ID: <20250507183823.082018067@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 96014d91cffb335d3b396771524ff2aba3549865 ]

Depend on SND_SOC_CS_AMP_LIB instead of selecting it.

KUNIT_ALL_TESTS should only build tests for components that are
already being built, it should not cause other stuff to be added
to the build.

Fixes: 177862317a98 ("ASoC: cs-amp-lib: Add KUnit test for calibration helpers")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20250411123608.1676462-3-rf@opensource.cirrus.com
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 0d9d1d250f2b5..6a72561c4189b 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -746,10 +746,9 @@ config SND_SOC_CS_AMP_LIB
 	tristate
 
 config SND_SOC_CS_AMP_LIB_TEST
-	tristate "KUnit test for Cirrus Logic cs-amp-lib"
-	depends on KUNIT
+	tristate "KUnit test for Cirrus Logic cs-amp-lib" if !KUNIT_ALL_TESTS
+	depends on SND_SOC_CS_AMP_LIB && KUNIT
 	default KUNIT_ALL_TESTS
-	select SND_SOC_CS_AMP_LIB
 	help
 	  This builds KUnit tests for the Cirrus Logic common
 	  amplifier library.
-- 
2.39.5



