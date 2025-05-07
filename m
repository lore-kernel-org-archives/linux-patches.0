Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FF01FF5EC;
	Wed,  7 May 2025 18:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643977; cv=none; b=Qg+DRA1PIuiB2TZqKGpSCwGnPsC46zV+Xu7rKYNBeoBfS+OAeg86nbkoQjyhJt/BA/2TiLqZT7E3acYr2M9rzbb8mNQ3I7xNfu+pUiKgsqI6BDM5C3QdkDVCrr7VhEaLWanh7THBBkSUBnUN49LHC9NfI+t1XB2xGhsNppjxkR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643977; c=relaxed/simple;
	bh=+YQxLNL4DAw+XCyvsM7i9YYmbU3jV9UgPTN/vl29d3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omOF6QBaYgboe3ifWb2P6TqC5FMSZeHq/74OHXAOMo6EQvzx/WnhB5HF4vHtUwSSgu8H693DDqjTXqJbeDlg4sFMwmxR6+zkA0m61Y7zQ9aNk46DnoGoWVUmG4ZjnCIF/Cgcz47T5BJ2BjRrogkMZwk0QliYGfxFeAtjVr1lwUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHJQXD18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHJQXD18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D71C4CEE2;
	Wed,  7 May 2025 18:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643977;
	bh=+YQxLNL4DAw+XCyvsM7i9YYmbU3jV9UgPTN/vl29d3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHJQXD182vTtA1F4ZxYJwydVyoaqCeKEA6F5BH4ihxLEMPmdHeR4ODO3E2TXc20Yq
	 S+MrHzdC2ItMUiPvVU0yLfVH00xykb0DK69pjLEB8W58Zbktl5vpt9Ugs63IoYA+ec
	 YiFdOZ3KEyE8ah++IhAKkXeIVWsNstZEYHtvxwH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	David Gow <davidgow@google.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 050/183] ASoC: cs-amp-lib-test: Dont select SND_SOC_CS_AMP_LIB
Date: Wed,  7 May 2025 20:38:15 +0200
Message-ID: <20250507183826.718190240@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index ee35f3aa55216..0138cfabbb038 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -763,10 +763,9 @@ config SND_SOC_CS_AMP_LIB
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



