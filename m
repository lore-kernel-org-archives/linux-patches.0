Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC911F76B2;
	Tue, 17 Dec 2024 17:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455540; cv=none; b=BmNS/V/ruBuTBpHcfC2F23xJo8UfhwRZa8LM50JJSD66izwu0ILd4cvR553FkkXGO9Eo9P+f/X3f/j5KAdfhIMYt05rMLyFCveCEVU+/tHGZdd3d9PFNhGIwHcnefppAANVSUnFX+pjQuN5gf8m3vOE+0V/+3NaIt0FQre7H0Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455540; c=relaxed/simple;
	bh=AUnvHAAxKZbBmn5xz29+/XGTrzBV5C4TUE7JWLtKtAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yb7/BQs9PTIf+QvghMaIU/1/p1PLAGPHE+dLoUehyR/ob/0gyFJ8hsEOcYQdIQs1sBWojaRy4I2D8NCK/2WktB2j5WkkNamlQEuLvak9kft2h8WhjeiZE863mpq55F7osD+AY6yKVJsCK8h2NrFegzeMemOr0SvIe/jrQs0ZPEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9ME+Dpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9ME+Dpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62888C4CED3;
	Tue, 17 Dec 2024 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455540;
	bh=AUnvHAAxKZbBmn5xz29+/XGTrzBV5C4TUE7JWLtKtAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9ME+DpnhcZni7kHySwh/VyYIvg22I3NxG2odjmSMwEDjAfNTc2PE5RoEzZg7NoFh
	 WtZ0p1O4Z5GpDLKsdAiP4NxnjzoBX9tn35Laq3UyqBs1URUirQA5Esm+X9HVUyamj5
	 0t1GXjhskoS9DplHdiUkLsY3ID3GdRI0y2uUxQ7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Ross Burton <ross.burton@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/43] Revert "clocksource/drivers:sp804: Make user selectable"
Date: Tue, 17 Dec 2024 18:07:24 +0100
Message-ID: <20241217170521.951579331@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit ef1db3d1d2bf which is
commit 0309f714a0908e947af1c902cf6a330cb593e75e upstream.

It is reported to cause build errors in m68k, so revert it.

Link: https://lore.kernel.org/r/68b0559e-47e8-4756-b3de-67d59242756e@roeck-us.net
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Ross Burton <ross.burton@arm.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -398,8 +398,7 @@ config ARM_GLOBAL_TIMER
 	  This option enables support for the ARM global timer unit.
 
 config ARM_TIMER_SP804
-	bool "Support for Dual Timer SP804 module"
-	depends on ARM || ARM64 || COMPILE_TEST
+	bool "Support for Dual Timer SP804 module" if COMPILE_TEST
 	depends on GENERIC_SCHED_CLOCK && HAVE_CLK
 	select CLKSRC_MMIO
 	select TIMER_OF if OF


