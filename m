Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C167D1F543F;
	Tue, 21 Jan 2025 17:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482274; cv=none; b=OcBCsBC4OL67XR+EgR3G2Isqqgpei73fixvCnAmsF+Hq1M0oh1NX3VXerqgUb7EHl76LVvt4992XiXD+c1S+kgajtv/eGWeTDWowG2gnjYzGwrWKkyHqFZW3jakbyC+4o6fw1SepSEpH8V/xBQkNQ4/uh31LghnZgF9RDe5hrUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482274; c=relaxed/simple;
	bh=k9KPK/G2oM2/0kRt9QoEUf8WmC/X2CapHPMPnqVAWMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6kfwmASYbQRCmYLun6sZpQMHZzzOyG95fydyKQXGfeO7p4R38UYba6NwlC3Lc0UKcCacpk7n+z5r0zcbGpw60OU/+DRmW/hof3oMA2XuhMgyYWWbPrRaKG+FGZa8cCWFHn5wxXHPsx2LD1m/pIm+UEuYNk/RqaOlhe/JMZBOAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Obh/RAm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Obh/RAm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21A4C4CEDF;
	Tue, 21 Jan 2025 17:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482274;
	bh=k9KPK/G2oM2/0kRt9QoEUf8WmC/X2CapHPMPnqVAWMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Obh/RAm6oc/e3JI3WayGjozuhRuS7uDlRg3LzqadFJ4QIZJ83lY+aNpwSv9Kf53ci
	 aFx1XjDY7hrpgM+EXteiH0PhCHSIKVyrJymJ8WaPK9RBDoKG1vTNMuHnb/dkoOvk/z
	 /bgw13T44UjZKT1KdiFCbCz8kXTSR7Vh0WZ+yGYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Pierre Gondois <pierre.gondois@arm.com>,
	Sunil V L <sunilvl@ventanamicro.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/122] cpufreq: Move endif to the end of Kconfig file
Date: Tue, 21 Jan 2025 18:51:08 +0100
Message-ID: <20250121174533.777841002@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 7e265fc04690d449a40b413b0348b15c748cea6f ]

It is possible to enable few cpufreq drivers, without the framework
being enabled. This happened due to a bug while moving the entries
earlier. Fix it.

Fixes: 7ee1378736f0 ("cpufreq: Move CPPC configs to common Kconfig and add RISC-V")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Pierre Gondois <pierre.gondois@arm.com>
Reviewed-by: Sunil V L <sunilvl@ventanamicro.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://patch.msgid.link/84ac7a8fa72a8fe20487bb0a350a758bce060965.1736488384.git.viresh.kumar@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 2561b215432a8..588ab1cc6d557 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -311,8 +311,6 @@ config QORIQ_CPUFREQ
 	  This adds the CPUFreq driver support for Freescale QorIQ SoCs
 	  which are capable of changing the CPU's frequency dynamically.
 
-endif
-
 config ACPI_CPPC_CPUFREQ
 	tristate "CPUFreq driver based on the ACPI CPPC spec"
 	depends on ACPI_PROCESSOR
@@ -341,4 +339,6 @@ config ACPI_CPPC_CPUFREQ_FIE
 
 	  If in doubt, say N.
 
+endif
+
 endmenu
-- 
2.39.5



