Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC12C18C00E;
	Wed,  6 Nov 2024 12:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896126; cv=none; b=IwFxLoDRhuUy/+NgJ2j3HS1ZSVNv5SYcN8B48b3tdbNLUKeuHZ7as9MDF3Uqb0cmz8jXrmfEI0dy6UUIXrznflIuIKfS9ht+OWjIAQMEHz6rW0TJTbKRTUXaV62Gq3v0Iapqhbm906J5YuNB+F4i//2aUrN9Q07XhJqNHjSwMr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896126; c=relaxed/simple;
	bh=9joaXxUeYCyRPOQEY5t3iS72+L3M35cUF7xiYlPeR04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evUYLIq2mYqsJxX4f+pDd83GT77VTKKMiD3Jma4ePHqwI/J6t6wyopbwatY476JY2KPe5VfqWmmtcu8GNP3MSm5nVmeOQG9FkmcwTCO6FSS77sQ3bJdrhU4Tx9WemLfFhs+WaxNvc1fb13YcuO5bJ8nOerKWCTC72zoKDZKWxYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTAFAWps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTAFAWps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53090C4CECD;
	Wed,  6 Nov 2024 12:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896126;
	bh=9joaXxUeYCyRPOQEY5t3iS72+L3M35cUF7xiYlPeR04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gTAFAWpsXMuCqRjw78A/2CmVQ39ywVPIBIOuVwUokdTN6NX9b/TxriFj5UeXbmIzx
	 shF/lFBpKvYP1SlghewgqbRzyuh5IAwrDXiGGOYFyuFAfkEtbMmozUhmbRioYxKxV1
	 K8XIq/Fk+3JHv+Rzn+LvZMi/hvXFaPp76UYnOisc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 098/245] thermal: intel: int340x: processor: Add MMIO RAPL PL4 support
Date: Wed,  6 Nov 2024 13:02:31 +0100
Message-ID: <20241106120321.622181549@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 3fb0eea8a1c4be5884e0731ea76cbd3ce126e1f3 ]

Similar to the MSR RAPL interface, MMIO RAPL supports PL4 too, so add
MMIO RAPL PL4d support to the processor_thermal driver.

As a result, the powercap sysfs for MMIO RAPL will show a new "peak
power" constraint.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20240930081801.28502-7-rui.zhang@intel.com
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../thermal/intel/int340x_thermal/processor_thermal_rapl.c    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rapl.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rapl.c
index 769510e748c0b..bde2cc386afdd 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rapl.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rapl.c
@@ -13,9 +13,9 @@ static struct rapl_if_priv rapl_mmio_priv;
 
 static const struct rapl_mmio_regs rapl_mmio_default = {
 	.reg_unit = 0x5938,
-	.regs[RAPL_DOMAIN_PACKAGE] = { 0x59a0, 0x593c, 0x58f0, 0, 0x5930},
+	.regs[RAPL_DOMAIN_PACKAGE] = { 0x59a0, 0x593c, 0x58f0, 0, 0x5930, 0x59b0},
 	.regs[RAPL_DOMAIN_DRAM] = { 0x58e0, 0x58e8, 0x58ec, 0, 0},
-	.limits[RAPL_DOMAIN_PACKAGE] = BIT(POWER_LIMIT2),
+	.limits[RAPL_DOMAIN_PACKAGE] = BIT(POWER_LIMIT2) | BIT(POWER_LIMIT4),
 	.limits[RAPL_DOMAIN_DRAM] = BIT(POWER_LIMIT2),
 };
 
-- 
2.43.0



