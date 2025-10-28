Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD23E1AA7BF;
	Tue, 28 Oct 2025 00:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761612042; cv=none; b=c05OAcGL1rqn39jbMXvbiAI0EnLLwqssZ2MIBCwzMLiyASaFVOvgEQZ3lQa8G30sIhl2L3u0A7O9KrCM9X/bjiQkoKIVjIFcJE3cqvHY+nRJi1RCzT7smo9fyeg2yNmSF4EVVAMDWNhjwYPRAQXeyxd9lfSLhsgITQcVWK/mxsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761612042; c=relaxed/simple;
	bh=8PNxR772iIn3JNHD/RAHzIa94IW1C8YLtzX0Q7gMUTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CKeu8HR9W35Sgf1EraEo5XYpweSYTRnrskgvOQ4h/N+SJLaD/LmjaEuCm4CdauQ79dYyQSiZB/WbsjlcLmY/67ltT911yih1gpPj0dGiMuGFIoCh8O3ZSFWil/P45EdZH9nYl2iQMYLsr7clci1VJSCnHIxfg3ykx2im3xRxK0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/XexweO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/XexweO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FD3C4CEFB;
	Tue, 28 Oct 2025 00:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761612042;
	bh=8PNxR772iIn3JNHD/RAHzIa94IW1C8YLtzX0Q7gMUTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/XexweOnq9tXUtxMOvwpGdhnStozYzvyon62rK95wyUg1xkwrMx6atSzZ98rTagh
	 HbgaTwLIXNQa2JoBgmoGhKCQ3RPmLbk1UewbeOWzMcnYFp1q4vRLlcijPQb+jbbJvn
	 m/Lngev5200g7BbjWvK4p+GSYVAgjrFi5MpAWIt5plQ5Vc+NYog4HNizs2T+i0VMeC
	 PeCVz5pl9sg+UZ3HTkJHYP0vvTL1srCA04EDhxlKpQMfIOoJBx3TU8znwajOPM/Xr4
	 UU82GjVIXz0yOA73dvNTZK3mrp1z8Hd/Z3EvIVs+ICRpA4xSqp+6jJj3j/v46mNcva
	 eod+YaSDYz5DQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Abhishek Tamboli <abhishektamboli9@gmail.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	xinpeng.sun@intel.com,
	srinivas.pandruvada@linux.intel.com,
	mpearson-lenovo@squebb.ca,
	phasta@kernel.org,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] HID: intel-thc-hid: intel-quickspi: Add ARL PCI Device Id's
Date: Mon, 27 Oct 2025 20:39:08 -0400
Message-ID: <20251028003940.884625-24-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028003940.884625-1-sashal@kernel.org>
References: <20251028003940.884625-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Abhishek Tamboli <abhishektamboli9@gmail.com>

[ Upstream commit 50f1f782f8d621a90108340c632bcb6ab4307d2e ]

Add the missing PCI ID for the quickspi device used on
the Lenovo Yoga Pro 9i 16IAH10.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=220567

Signed-off-by: Abhishek Tamboli <abhishektamboli9@gmail.com>
Reviewed-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## ANALYSIS COMPLETE

**BACKPORT STATUS: YES**

### Detailed Analysis:

#### 1. **Semantic Code Analysis Results:**

**Tool: mcp__semcode__find_function**
- Located `quickspi_probe` function (drivers/hid/intel-thc-hid/intel-
  quickspi/pci-quickspi.c:578-689)
- Found `quickspi_dev_init` function which uses the driver_data
  structure
- Both functions show this is the standard PCI driver probe path

**Tool: mcp__semcode__find_callers**
- `quickspi_probe` has 0 direct callers (called via PCI subsystem
  function pointer in `quickspi_driver` struct)
- This is expected behavior for PCI drivers

**Tool: mcp__semcode__diff_functions**
- Analysis confirms: 0 functions modified, only adds data structures and
  table entries
- Only uses existing `PCI_DEVICE_DATA` macro
- **Conclusion: Purely additive change with zero behavioral
  modifications**

**Tool: mcp__semcode__find_type**
- `struct quickspi_driver_data` contains only one field:
  `max_packet_size_value`
- Used at pci-quickspi.c:194 to configure SPI packet size for device
  communication
- Missing this configuration would cause device malfunction

#### 2. **Impact Analysis:**

**User Impact:** HIGH
- Without this commit, Arrow Lake (ARL) systems with THC QuickSPI
  touchscreens/touchpads (like Lenovo Yoga Pro 9i 16IAH10) will have
  **completely non-functional touch input**
- Bug report linked: https://bugzilla.kernel.org/show_bug.cgi?id=220567
- This is a user-visible hardware support regression

**Scope:** MINIMAL
- Only 2 files changed: pci-quickspi.c (+6 lines), quickspi-dev.h (+2
  lines)
- Total addition: 8 lines of code
- Zero lines removed or modified

#### 3. **Risk Assessment:**

**Regression Risk:** ZERO
- Change is **purely additive** - adds new PCI device IDs only
- No existing code paths are modified
- Existing hardware (MTL, LNL, PTL, WCL) completely unaffected
- Uses existing constant `MAX_PACKET_SIZE_VALUE_MTL` (defined since
  driver introduction)

**Dependencies:** NONE
- Driver was introduced in v6.14-rc1 (commit c8f3027dd2a5b)
- All required infrastructure exists in kernels >= v6.14
- No new kernel APIs or features required
- Reuses existing MTL packet size value

#### 4. **Stable Tree Compliance:**

**Fits stable tree criteria:**
- ✅ **Bug fix:** Enables missing hardware support (touchscreen/touchpad
  broken on ARL systems)
- ✅ **Small and self-contained:** 8 lines, 2 files, purely additive
- ✅ **Zero regression risk:** No existing functionality affected
- ✅ **User-visible benefit:** Makes hardware functional
- ✅ **Well-tested pattern:** Identical to WCL device ID addition
  (cc54ed51c7617)
- ❌ **Explicit stable tag:** Not present (but not required for all
  backports)

**Not a new feature:**
- This is NOT adding new driver functionality
- This is enabling existing driver for new hardware variant
- The driver already supports the ARL architecture; just needs PCI ID
  matching

#### 5. **Historical Context:**

**Similar commits:**
- cc54ed51c7617: "HID: intel-thc-hid: intel-quickspi: Add WCL Device
  IDs" - identical pattern
- Multiple commits added device IDs for PTL-H, PTL-U, LNL platforms
- None had explicit stable tags, but all are good backport candidates

**Driver maturity:**
- Driver introduced in v6.14 (released ~Jan 2025)
- Available in stable branches: 6.14.y, 6.15.y, 6.16.y, 6.17.y
- Sufficient time in mainline for stabilization

#### 6. **Recommendation:**

**BACKPORT: YES** to stable kernels **6.14+**

**Rationale:**
1. **Fixes real user pain:** Users with Arrow Lake laptops have non-
   functional touchscreens without this
2. **Zero risk:** Purely additive, cannot break existing systems
3. **Trivial change:** 8 lines following established pattern
4. **Proper scope:** Only backport to kernels containing the base driver
   (6.14+)
5. **Aligns with stable rules:** Small, obvious fix for user-visible
   hardware issue

**Target stable branches:**
- linux-6.14.y
- linux-6.15.y
- linux-6.16.y
- linux-6.17.y

This commit should NOT be backported to kernels older than 6.14 since
the base intel-quickspi driver doesn't exist in those versions.

 drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c | 6 ++++++
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
index 84314989dc534..14cabd5dc6ddb 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
@@ -33,6 +33,10 @@ struct quickspi_driver_data ptl = {
 	.max_packet_size_value = MAX_PACKET_SIZE_VALUE_LNL,
 };
 
+struct quickspi_driver_data arl = {
+	.max_packet_size_value = MAX_PACKET_SIZE_VALUE_MTL,
+};
+
 /* THC QuickSPI ACPI method to get device properties */
 /* HIDSPI Method: {6e2ac436-0fcf-41af-a265-b32a220dcfab} */
 static guid_t hidspi_guid =
@@ -978,6 +982,8 @@ static const struct pci_device_id quickspi_pci_tbl[] = {
 	{PCI_DEVICE_DATA(INTEL, THC_PTL_U_DEVICE_ID_SPI_PORT2, &ptl), },
 	{PCI_DEVICE_DATA(INTEL, THC_WCL_DEVICE_ID_SPI_PORT1, &ptl), },
 	{PCI_DEVICE_DATA(INTEL, THC_WCL_DEVICE_ID_SPI_PORT2, &ptl), },
+	{PCI_DEVICE_DATA(INTEL, THC_ARL_DEVICE_ID_SPI_PORT1, &arl), },
+	{PCI_DEVICE_DATA(INTEL, THC_ARL_DEVICE_ID_SPI_PORT2, &arl), },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, quickspi_pci_tbl);
diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
index f3532d866749c..c30e1a42eb098 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
@@ -21,6 +21,8 @@
 #define PCI_DEVICE_ID_INTEL_THC_PTL_U_DEVICE_ID_SPI_PORT2	0xE44B
 #define PCI_DEVICE_ID_INTEL_THC_WCL_DEVICE_ID_SPI_PORT1 	0x4D49
 #define PCI_DEVICE_ID_INTEL_THC_WCL_DEVICE_ID_SPI_PORT2 	0x4D4B
+#define PCI_DEVICE_ID_INTEL_THC_ARL_DEVICE_ID_SPI_PORT1 	0x7749
+#define PCI_DEVICE_ID_INTEL_THC_ARL_DEVICE_ID_SPI_PORT2 	0x774B
 
 /* HIDSPI special ACPI parameters DSM methods */
 #define ACPI_QUICKSPI_REVISION_NUM			2
-- 
2.51.0

