Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30151E0DFD;
	Wed,  6 Nov 2024 12:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897485; cv=none; b=eGJmi1K1Dguarx1TJ1jLvup7/zb0Uwx8xhf70m3V4zAeVPsvUqN21vNcheFQ6sOmLPz0Fc3ZlUz8bJaAGzy8XPky2QKi/uGQeJjogaWgnBjnRFInNcPnnls9bY3zUc6lGKETC12QMgadKIhQ+ufuSdkDPtwRZ8CfLAE0+8rfNIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897485; c=relaxed/simple;
	bh=lXq4p9aA5h+VEK+7uP8HqpxABagZSpOwiomWV18QIr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzzTA4QWBj6QfIZAocWjJ/nL0TZ2FOOo851FlLgDNnk10W5THfbH7OXoWH4z8TWl21l4pGav94GmP2ZVQbsWNnihcvSFpKohxTZBIM/JeBZx9sh4+W0ZqzdaEEyLBcsa05RLbpKGHCMoff84hH5n+ZALHXkJ3K5Zcf59XAXf5LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crCx3P54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crCx3P54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C97FC4CECD;
	Wed,  6 Nov 2024 12:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897485;
	bh=lXq4p9aA5h+VEK+7uP8HqpxABagZSpOwiomWV18QIr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crCx3P54McZ/eturddfBfo8zduj1p9jlJlh4aLH1JsjmCWFGtVACF1JOlTMjB3F/x
	 lnDVIx6kpgFSnXQtdy+TtJ4UwdL+dgPpXB6QeMrcfyHsgUliw+Tvz3uVqOqZ6Wq/om
	 YFbDTdALBfiEjJTey1D/vPNjqFpMMGKY/MoIuCVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/151] thermal: intel: int340x: processor: Add MMIO RAPL PL4 support
Date: Wed,  6 Nov 2024 13:04:16 +0100
Message-ID: <20241106120310.708054082@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f7ab1f47ca7a6..f504781f4b7c5 100644
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



