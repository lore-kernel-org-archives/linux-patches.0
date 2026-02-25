Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E47119FA93;
	Wed, 25 Feb 2026 01:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983742; cv=none; b=ofHDnr3GIGkameMgO6MVUm9IPWQOU1fPEVFT0LxDk2MM/IkwkQiRTDRDXDaCP2cTYt4uGMrxI7W4oqzqG4tByzAc/e7ALLkdjY196nmHnEz17ElCWwEUPgljcvVKe4PhnUL9US26neYmfq9qYdaF+IiSpkMu7LZwt6Vnm/PaK4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983742; c=relaxed/simple;
	bh=DmATWHnuaReWS/4dlwsPRBHq6OFUKdPI55SChPdJ8V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJqPIclQ3FLMRozqda5MrxOVzEYi3Ji2y5SoDg8eUiNxXK88HuMO/Lel53m2mVTjPE/++4n4ipR86qDpY+JMzZ1b8hbj7BtRifwc66tY4nh/dBz1HgJ1QfZUD65dFOxqlpe+tt9g+jzsFFMm70vhQj2lG7IsQWyyE2u7f2Y6skY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQxBPMMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQxBPMMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200ACC116D0;
	Wed, 25 Feb 2026 01:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983742;
	bh=DmATWHnuaReWS/4dlwsPRBHq6OFUKdPI55SChPdJ8V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQxBPMMWG057sqISpIbcTSDuzlmtikZ9Ce9jWvl1bSrhzJzElMfxjstg+rKOYaSoi
	 HeZkl4KZB1PhYRhlKJw6lx/ReiqQji6vHTwXz1pMvi0o3rdtGGcTuNQmWM8/vFCazB
	 BmbqwRxSGpFr2aHikVhRyz/7g2/Au0aMNMd6clTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/641] ACPI: processor: Update cpuidle driver check in __acpi_processor_start()
Date: Tue, 24 Feb 2026 17:16:01 -0800
Message-ID: <20260225012349.847997484@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 0089ce1c056aee547115bdc25c223f8f88c08498 ]

Commit 7a8c994cbb2d ("ACPI: processor: idle: Optimize ACPI idle
driver registration") moved the ACPI idle driver registration to
acpi_processor_driver_init() and acpi_processor_power_init() does
not register an idle driver any more.

Accordingly, the cpuidle driver check in __acpi_processor_start() needs
to be updated to avoid calling acpi_processor_power_init() without a
cpuidle driver, in which case the registration of the cpuidle device
in that function would lead to a NULL pointer dereference in
__cpuidle_register_device().

Fixes: 7a8c994cbb2d ("ACPI: processor: idle: Optimize ACPI idle driver registration")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20251223100914.2407069-4-lihuisong@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 65e779be64ffc..7644de24d2faa 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -166,7 +166,7 @@ static int __acpi_processor_start(struct acpi_device *device)
 	if (result && !IS_ENABLED(CONFIG_ACPI_CPU_FREQ_PSS))
 		dev_dbg(&device->dev, "CPPC data invalid or not present\n");
 
-	if (!cpuidle_get_driver() || cpuidle_get_driver() == &acpi_idle_driver)
+	if (cpuidle_get_driver() == &acpi_idle_driver)
 		acpi_processor_power_init(pr);
 
 	acpi_pss_perf_init(pr);
-- 
2.51.0



