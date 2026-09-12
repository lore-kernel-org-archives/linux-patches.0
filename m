Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4795C37DEBF;
	Sat, 12 Sep 2026 11:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212834; cv=none; b=Ag0mRzMEBuhnLRAjTcxeYJ5sYiohH4zSViAKk2W6lmJS3cYg+93e8R8rB64AQ7ajE2D67f2VVTIYOChFZzGN+aOY7XOEJxhsRPQy7ky/5eW8EgaX+pEiWq8jBuUaTcrSMpjx5UzuMBVcgngkTk69nkosJj25qLFVQt8NQ4ATtdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212834; c=relaxed/simple;
	bh=c9kfDe+VdRw9p6mAM565CDv/dwaSPi0fO9Lz4k0KUdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMKblBIR/V3vhR2d4cwovidEoJBk67CppzKQQoh5JGVS05aNf0JSdgjyKrVPnqlcq9LDvFfh9dSlBF3AYr+58SYTmT4PfKBOOqVYb0MUiygwPcejS4TNyjBCqhuEwFnQoHCVqTmwC+xBaFUfGAJ/9lkpkKlKe+FzPzJ04Tg06yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETiNXIG6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETiNXIG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0301B1F000FF;
	Sat, 12 Sep 2026 11:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212833;
	bh=R9SIerK5NpEPOLAnhX4D20pAfJ5OLvdzbKHehcknsb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETiNXIG67z9EOJ1LcNeo7mBGZzJx8uX0bkfzcU30DlD419BSCGdzYmB8RCd12Y2kf
	 dsGQtR8mVBxyulZTr94M/n1xjF/ARZ2YzmraYwFSXROp+4LQjNNoKldhtdl7cwqLHU
	 A8QtQPMKN7B+JCRrHpzy0FtX8TU4qr1ULjJS/mu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	kernel test robot <lkp@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1473/1518] cpufreq/amd-pstate: Add POWER_SUPPLY select for dynamic EPP
Date: Sat, 12 Sep 2026 09:00:42 +0200
Message-ID: <20260912065656.876869188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 679343977588781bd3effba79e9644aee4ee046c ]

The dynamic EPP feature uses power_supply_reg_notifier() and
power_supply_unreg_notifier() but doesn't declare a dependency on
POWER_SUPPLY, causing linker errors when POWER_SUPPLY is not enabled.

Add POWER_SUPPLY to the selects.

Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Fixes: e30ca6dd5345 ("cpufreq/amd-pstate: Add dynamic energy performance preference")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604040742.ySEdkuAa-lkp@intel.com/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260407194949.310114-1-mario.limonciello@amd.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/Kconfig.x86 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index a0dbb9808ae99..027e6ea2e0384 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -41,6 +41,7 @@ config X86_AMD_PSTATE
 	select ACPI_CPPC_LIB if X86_64
 	select CPU_FREQ_GOV_SCHEDUTIL if SMP
 	select ACPI_PLATFORM_PROFILE
+	select POWER_SUPPLY
 	help
 	  This driver adds a CPUFreq driver which utilizes a fine grain
 	  processor performance frequency control range instead of legacy
-- 
2.53.0



