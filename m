Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4241E1EF0BC;
	Tue,  3 Dec 2024 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238123; cv=none; b=M9ExJ5tNSS6gTUbAYSeMubrIOnPggrf8eGsKEREYekVaIYCbsNWeYE61nvIYFPDFljDM+T1aQgQt0r/m07LJ4gH6pNgqhLJ8JlAwzDlN1giQR3/0sfbzYJ555mCIoQXnbpV6a2ku5FM5fWWsrug+tvM7MMxoom8QWcBzbz1NByc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238123; c=relaxed/simple;
	bh=rpDjAqYJ61Q1LcLLTOQbWADz+R1VwPlYASR1/y+9V4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqndsJlEZxJOnYN+lGDwlX1Xx43ozm4xct3e9uzzTPpIOxOglWHwUWiffZsCyUkFB76ySE76nbRNjvwZrmRZAxiRz8UBJKCtEgz962bdAAltVFQFoL4QpLCByMWbOO05T9ABcltWQmQKTtOnU7zK4vffdjBD4too70MOe7oIClM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ze1xfPCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ze1xfPCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B495EC4CECF;
	Tue,  3 Dec 2024 15:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238123;
	bh=rpDjAqYJ61Q1LcLLTOQbWADz+R1VwPlYASR1/y+9V4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ze1xfPCR/72pO2Hbm/WnFhUiM+UdDsVXhxfKeDYX2JrWvutXLEtmPLu1Y1gsWEKcI
	 NWiS6PIx3PfnTW2whfMymQ8Vv/D3eFzj2wXNovgaujJxkcuKpEMf1D/w07pr42wTZT
	 gRKTr4ykjladlA1Uc/RYXRkKbeTJ3vOlGuwb/j2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Burton <ross.burton@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 138/817] clocksource/drivers:sp804: Make user selectable
Date: Tue,  3 Dec 2024 15:35:10 +0100
Message-ID: <20241203144001.110410838@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 0309f714a0908e947af1c902cf6a330cb593e75e ]

The sp804 is currently only user selectable if COMPILE_TEST, this was
done by commit dfc82faad725 ("clocksource/drivers/sp804: Add
COMPILE_TEST to CONFIG_ARM_TIMER_SP804") in order to avoid it being
spuriously offered on platforms that won't have the hardware since it's
generally only seen on Arm based platforms.  This config is overly
restrictive, while platforms that rely on the SP804 do select it in
their Kconfig there are others such as the Arm fast models which have a
SP804 available but currently unused by Linux.  Relax the dependency to
allow it to be user selectable on arm and arm64 to avoid surprises and
in case someone comes up with a use for extra timer hardware.

Fixes: dfc82faad725 ("clocksource/drivers/sp804: Add COMPILE_TEST to CONFIG_ARM_TIMER_SP804")
Reported-by: Ross Burton <ross.burton@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20241001-arm64-vexpress-sp804-v3-1-0a2d3f7883e4@kernel.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 95dd4660b5b65..d546903dba4f3 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -400,7 +400,8 @@ config ARM_GT_INITIAL_PRESCALER_VAL
 	  This affects CPU_FREQ max delta from the initial frequency.
 
 config ARM_TIMER_SP804
-	bool "Support for Dual Timer SP804 module" if COMPILE_TEST
+	bool "Support for Dual Timer SP804 module"
+	depends on ARM || ARM64 || COMPILE_TEST
 	depends on GENERIC_SCHED_CLOCK && HAVE_CLK
 	select CLKSRC_MMIO
 	select TIMER_OF if OF
-- 
2.43.0



