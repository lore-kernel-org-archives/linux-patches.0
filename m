Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91314379EE2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301894; cv=none; b=aNDySqnbjxmZZX1xPjxWcqu2/CZn12EwJ+lyX2isVqmrw1rpHbJnyrxS/f4fuZIWyQM7XVRQ17L/bNTasrUtzNf2al9PPnl4TytudZEDSJ1Ndm+Set+kwzrB71AkDGbxmfT1/sLBjrSlCVjQUxNr6FYUKmRsjYLxkADiibwQ7qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301894; c=relaxed/simple;
	bh=pl6AqEC6wjglYTLU/jigJRdu0qg6eL+VYQmehXokAmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVpSPaaGuHYlVOlMSWsZQTyCcMAHUmlGR5ovSz4vI5w24oSsLn67qW7w05AuQ92Y4Jdy1Y2S7rBLDwf0/Sgktq/4JDW4bIjPoJk2WDUaio5eeOTToU0dgIOCJjLUF2eHTLYopj1c2nO3touZA/5riH8CJbJoZ5vsURy9xKPoMFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evanIgQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evanIgQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E66C116D0;
	Sat, 28 Feb 2026 18:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301894;
	bh=pl6AqEC6wjglYTLU/jigJRdu0qg6eL+VYQmehXokAmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evanIgQ+B6Y3XA+yBOmlQrQ+7br8uL/drSd+fTTtyaPyD/AY+pSbPVjpNp+RiS5b/
	 O296t8B8rllp7dpK7aYQRpg+cXODXV+tX7ZXz67EjmZMbuDMItWLkTpJ25ndfBE04D
	 mwon5kcUjbucRqXDzl//EHRHn/TDGKC1ZoR5LoBGhOBte/IpZCyqdQcAEDyv0r9kGy
	 AoNUPiiBhuUgNRHLO/ZYlmcEq8pfEOIpvRkmMuhZ4kZjqbfrtcVPOwwP9gQgGP7X4+
	 cOPhDaehpqz3WWttla7jtJc3tFAhoLLGfHjqACMCwhv6kCr6P34+Sn/0B3Gw497t4x
	 Jj7VGjBXTYXiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/385] iio: test: drop dangling symbol in gain-time-scale helpers
Date: Sat, 28 Feb 2026 12:59:04 -0500
Message-ID: <20260228180011.1568201-322-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d63d868b312478523670b76007dcc5eaedc3ee07 ]

The code for this never went upstream. It was replaced by other code,
so this should be dropped.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216748
Fixes: cf996f039679 ("iio: test: test gain-time-scale helpers")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/test/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/test/Kconfig b/drivers/iio/test/Kconfig
index 33cca49c8058a..3b6d9b1476d8c 100644
--- a/drivers/iio/test/Kconfig
+++ b/drivers/iio/test/Kconfig
@@ -8,7 +8,6 @@ config IIO_GTS_KUNIT_TEST
 	tristate "Test IIO formatting functions" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	select IIO_GTS_HELPER
-	select TEST_KUNIT_DEVICE_HELPERS
 	default KUNIT_ALL_TESTS
 	help
 	  build unit tests for the IIO light sensor gain-time-scale helpers.
-- 
2.51.0

