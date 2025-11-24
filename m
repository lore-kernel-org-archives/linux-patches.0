Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277F82EE263;
	Mon, 24 Nov 2025 08:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971628; cv=none; b=JUbZ3VJ0n4Trzh8y0nPPqhh8mluDwmh6uzZ4vmdD7HneuEqPuyUuMlDEQYXdDR4krPOA0RqMwGe5s1QnYzrDP7Rm9ca6dAJI5hw/AabFNSM0NtOwwVliWdCBx8ghGVyt0eNc18F7v++PCLBOlH5LqJMd9BtUMr51DCd7a/MFGA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971628; c=relaxed/simple;
	bh=WxKsu3ihlv5iJnGqs1KJRYJ9tmek1AlSdURBHJjo7cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hzXNBt3A2HMYshxVe7PAaF3YLTnlQMpT5OKzzOedYiSASMVuATd/5DHGmnSkUdB864BlfWoz07U30LX2ojESxWk/Ru6+Fxl2I2LEDec0aUc5X3/FJZMt5aI1tDxUmIitrLq5R6hbTQeiEHuR9Oo40d+M9pxG3lz1+dsmrxd3Fjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u5Hscf9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u5Hscf9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA013C4CEF1;
	Mon, 24 Nov 2025 08:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971627;
	bh=WxKsu3ihlv5iJnGqs1KJRYJ9tmek1AlSdURBHJjo7cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5Hscf9xs5OnZlcTLRV6JKmzJnXRaoCglKCPKlIGY6GQE3AYru8STTqjjUyUg5j8k
	 pLBAHrvwa0DJSRJPXTlNY76Wk7C39/pfTosSdOoKBtrvl8/9H12lgs38WiZ7aiPqUm
	 ypyD5vV/jPT+EjHLnU61y8vLHtHeCq91Wfn/JARfEo80tbmVt8gDLqt/AJq+iX5WXP
	 Fbaq0K8dWluwFRWFkJA/A9/FELwqiRzRGTZRf3AiGtkK2t+jq1GpBZRkBqWEN/wVZs
	 xl5C6z0uMv6LgjIvnbKCCJBTQTu44Y0i1UVtJ8BI/MqaQX7lxLwifF5nL/eIXQSGqQ
	 mxSoefSlYgTiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alexhung@gmail.com,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] platform/x86/intel/hid: Add Nova Lake support
Date: Mon, 24 Nov 2025 03:06:27 -0500
Message-ID: <20251124080644.3871678-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124080644.3871678-1-sashal@kernel.org>
References: <20251124080644.3871678-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.8
Content-Transfer-Encoding: 8bit

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit ddf5ffff3a5fe95bed178f5554596b93c52afbc9 ]

Add ACPI ID for Nova Lake.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20251110235041.123685-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

1. **COMMIT MESSAGE ANALYSIS**
   - The subject "platform/x86/intel/hid: Add Nova Lake support" and
     body "Add ACPI ID for Nova Lake" clearly identify this as a
     hardware enablement patch.
   - There are no "Fixes:" or "Cc: stable@" tags. While this often
     signals a feature, simple device ID additions are frequently
     backported without these tags under specific stable rule
     exceptions.
   - The change is signed off by the subsystem maintainer.

2. **DEEP CODE RESEARCH**
   - **File:** `drivers/platform/x86/intel/hid.c`
   - **Mechanism:** The `intel_hid` driver relies on an ACPI device ID
     table (`intel_hid_ids`) to bind to the underlying platform
     firmware. When the ACPI subsystem enumerates devices, it checks
     this table.
   - **The Change:** The commit adds a single line `{ "INTC10F2" }` to
     this array. This ID corresponds to the Nova Lake platform.
   - **Impact:** Without this ID, the kernel will fail to load this
     driver on Nova Lake laptops. Users would experience broken
     functionality for hotkeys (brightness, volume, WiFi toggle) and
     5-button array features (common on 2-in-1s/tablets).
   - **Context:** The diff shows the immediate predecessor `{ "INTC10F1"
     }` (Wildcat Lake), confirming that this driver is mature and
     regularly updated for new Intel generations via this exact
     mechanism.

3. **STABLE KERNEL RULES ALIGNMENT**
   - **General Rule:** Usually, new hardware support is not appropriate
     for stable.
   - **Exception Check (CRITICAL):** However, the *Stable Kernel Rules*
     (Documentation/process/stable-kernel-rules.rst) contain a specific
     exception for **"NEW DEVICE IDs"**. It explicitly states that
     adding ACPI IDs to existing drivers is allowed.
   - **Compliance:**
     - Does the driver exist in stable? **Yes**, `intel/hid.c` is a
       long-standing driver.
     - Is the change minimal? **Yes**, it is a one-line data addition.
     - Is it obviously correct? **Yes**, it strictly follows the pattern
       of previous platforms.

4. **RISK VS BENEFIT ASSESSMENT**
   - **Regression Risk:** **Negligible**. The change effectively only
     executes when the specific ACPI ID `INTC10F2` is present in the
     system firmware. Existing systems (with different IDs) will skip
     this entry in the match table, resulting in zero change in behavior
     for current users.
   - **Benefit:** High for users of new hardware. It allows enterprise
     and LTS distributions (which rely on stable kernels) to function
     correctly on upcoming Nova Lake devices without requiring a full
     kernel upgrade.

5. **CONCLUSION**
  This commit is a textbook example of the "New Device ID" exception. It
  provides necessary hardware enablement for stable kernel users with
  zero risk of regression for existing users. While it lacks a stable
  tag, it qualifies for backporting based on the documented rules and
  the trivial nature of the change.

**YES**

 drivers/platform/x86/intel/hid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index f25a427cccdac..9c07a7faf18fe 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -55,6 +55,7 @@ static const struct acpi_device_id intel_hid_ids[] = {
 	{ "INTC10CB" },
 	{ "INTC10CC" },
 	{ "INTC10F1" },
+	{ "INTC10F2" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, intel_hid_ids);
-- 
2.51.0

