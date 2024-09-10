Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8457E17B50F;
	Tue, 10 Sep 2024 10:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964490; cv=none; b=uvNEDJxtA6qSuIkrR7NI2fRSfMSzjZGD1plRmqrx/0d7uq5GskrM9Tllz4hqFgHHPeOA/Pgkxg4cxFZ+JWbJzDhINF5l4JXFTfFd9+qMiNzDvrigYwVDfvjxM1RlnaU9q9qi6jiv9wGMvAyTFbHJMWrSQZs/WzLh8v5Mv8+mD+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964490; c=relaxed/simple;
	bh=hJaUYokpM3wyQifpccXI1kJJi/wgoEO/VUVGTfgRTj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmdpx9iZDrpKCjrWINpcxRtZ+ClxAhT9+Fy+hBazOiFhG3LEsFoQYfHscl3V2vbQiQRBX6FMAGGyY/rwrxzVqku/GvhBgLAQ8XU1q20s+NoTxWTHfwbv9hYHHNgsx05lLnu+ThAAKoIJM+kjXk/rEzmTkA1e26u6W5WBT61IEB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huXK2+XQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huXK2+XQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AEEC4CEC3;
	Tue, 10 Sep 2024 10:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964490;
	bh=hJaUYokpM3wyQifpccXI1kJJi/wgoEO/VUVGTfgRTj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huXK2+XQoHgVEzVeKJES5JY1IbTj/kOZn0+Fllf0YFUCAUxy/Z6Zyy2qqbzaz4dCs
	 sJqhQ5BoMD78cn2YjxEUOaRQT8Clv+zqMonqOLrij0NIWc8Zp8qFuwGgLMYgcx8HQE
	 AbCkZrEdb0tyaO+i23hbublFqzCC6+nMWVPWbVA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Wyes Karny <wyes.karny@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Meng Li <li.meng@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 200/269] ACPI: CPPC: Add helper to get the highest performance value
Date: Tue, 10 Sep 2024 11:33:07 +0200
Message-ID: <20240910092615.221447454@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Meng Li <li.meng@amd.com>

commit 12753d71e8c5c3e716cedba23ddeed508da0bdc4 upstream.

Add support for getting the highest performance to the
generic CPPC driver. This enables downstream drivers
such as amd-pstate to discover and use these values.

Refer to Chapter 8.4.6.1.1.1. Highest Performance of ACPI
Specification 6.5 for details on continuous performance control
of CPPC (linked below).

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Wyes Karny <wyes.karny@amd.com>
Reviewed-by: Perry Yuan <perry.yuan@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Meng Li <li.meng@amd.com>
Link: https://uefi.org/specs/ACPI/6.5/08_Processor_Configuration_and_Control.html?highlight=cppc#highest-performance
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c |   13 +++++++++++++
 include/acpi/cppc_acpi.h |    5 +++++
 2 files changed, 18 insertions(+)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1197,6 +1197,19 @@ int cppc_get_nominal_perf(int cpunum, u6
 }
 
 /**
+ * cppc_get_highest_perf - Get the highest performance register value.
+ * @cpunum: CPU from which to get highest performance.
+ * @highest_perf: Return address.
+ *
+ * Return: 0 for success, -EIO otherwise.
+ */
+int cppc_get_highest_perf(int cpunum, u64 *highest_perf)
+{
+	return cppc_get_perf(cpunum, HIGHEST_PERF, highest_perf);
+}
+EXPORT_SYMBOL_GPL(cppc_get_highest_perf);
+
+/**
  * cppc_get_epp_perf - Get the epp register value.
  * @cpunum: CPU from which to get epp preference value.
  * @epp_perf: Return address.
--- a/include/acpi/cppc_acpi.h
+++ b/include/acpi/cppc_acpi.h
@@ -139,6 +139,7 @@ struct cppc_cpudata {
 #ifdef CONFIG_ACPI_CPPC_LIB
 extern int cppc_get_desired_perf(int cpunum, u64 *desired_perf);
 extern int cppc_get_nominal_perf(int cpunum, u64 *nominal_perf);
+extern int cppc_get_highest_perf(int cpunum, u64 *highest_perf);
 extern int cppc_get_perf_ctrs(int cpu, struct cppc_perf_fb_ctrs *perf_fb_ctrs);
 extern int cppc_set_perf(int cpu, struct cppc_perf_ctrls *perf_ctrls);
 extern int cppc_set_enable(int cpu, bool enable);
@@ -165,6 +166,10 @@ static inline int cppc_get_nominal_perf(
 {
 	return -ENOTSUPP;
 }
+static inline int cppc_get_highest_perf(int cpunum, u64 *highest_perf)
+{
+	return -ENOTSUPP;
+}
 static inline int cppc_get_perf_ctrs(int cpu, struct cppc_perf_fb_ctrs *perf_fb_ctrs)
 {
 	return -ENOTSUPP;


