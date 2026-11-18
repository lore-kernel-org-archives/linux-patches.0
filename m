Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058891;
	b=DleqOAfaGKX5svD9+uQiNyskYdhfBcRQqk29q+RzzKVikmZV5479AKbzg/texdSuulWs
	 3c+5WiawOONzSe2TAZ6KWYrF4z5Eu3u8Jc/jwLih2xUc+YO3ddgcJ2f/FF8d8pib7uHW1
	 kB0BCADibamxCXTiF11ehV1mwoRbfaEs8ZFdKhb+sTFhkexksm9aU+9E9WYGvA/UodWFf
	 5lvDzJ3GQxt82qNovDH0TSnLheh5ODB6T5ynxL4aOleKAj8EnDDc14+4ojTu9JRQgo7i7
	 qB4cU298gbLpBC1FJkEZGiFdb2rcbeAOLAlMWoV4tMuqpMi8HNhlNwMiFvJ/kO7XQng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7kjNm+b/SNMIV/UlAQQiJ9oWjvjnqB145KAge5yHkZ4=;
	b=14ITYRf+W+ZcZH/lA9nzwzEob2MERV8BGKrmO2iVfxGX7LBKhx1JztwRDBrHoSVEKAyZ
	 61NStHicmX+cYN3LRBI8LDe8qJqBOuGpAD/AA9t6U2zJFB3HrtiRwvDOMa6K8jt8q2d5k
	 peMYO3tdMgXKr3/B4L/k87DD+M2TlGD0zON4S4vG7M/ZtKyXSDe9qy6xey0Br3NZZsIzM
	 uHSr52qso8zRkQBGsrEma+c5uyyKQmhDgGavlBbw14s3NERa1nuGoglMzrbxQ2YAyd8dv
	 EgrbysyLBJYUTNMeHHw+r+STnoVve9LH270PAihUn3q8z4gnmYW0f+b2HtR9rvVVL7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X0M0zkAW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4038606A31C;
	Thu, 19 Nov 2026 03:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X0M0zkAW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0EB1F000C4;
	Thu, 19 Nov 2026 03:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058891;
	bh=7kjNm+b/SNMIV/UlAQQiJ9oWjvjnqB145KAge5yHkZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0M0zkAW9DGhusH+f9N7qx08aZ8pTuDno9qKZR9QLtaU4L5r/2qWrtoNNl1qUFqto
	 Sd/7pr0FO4Ed6TNs16mthpIR/AJxkZix2JxBBRAux6YCGtGfW9rTPEdYQr5xArUnxp
	 k0G2wd3kNlUhgoI3DvwaAmIY6konNFW4/+sJztUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0647/1848] ACPI: CPPC: Validate FFH register fields before hardware access
Date: Wed, 18 Nov 2026 15:44:45 +0100
Message-ID: <20261118145942.895701664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

commit 6b016c5c96448c0a5f09328d37f66562d154a5e5 upstream.

The x86 CPPC FFH accessors construct masks and shift values using the
firmware's Bit Width and Bit Offset without checking that the field fits
in an MSR. A zero-width field or a field extending beyond bit 63 can
therefore cause an invalid shift. The safe MSR accessors only handle an
access fault, not invalid field arithmetic after a successful read.

Also, the 64-bit GAS address is implicitly narrowed to the 32-bit MSR
number. A descriptor with nonzero upper address bits can access a different
MSR from the one described by firmware.

The arm64 AMU counter readers have the same unchecked field arithmetic.
Validate the field bounds before reading a counter, including both
descriptors in the paired counter path.

Dispatch FFH accesses before decoding the GAS Access Size in the common
read and write paths. Otherwise, a large access_width can trigger an
invalid shift in GET_BIT_WIDTH() before the architecture validates its
register. That field has architecture-specific FFH semantics and is not
needed by the generic memory/port accessor on this path.

Validate x86 MSR addresses and share the field-bounds checks between
related accessors within each architecture.

Fixes: a6cbcdd5ab5f ("ACPI / CPPC: Add support for functional fixed hardware address")
Fixes: 68c5debcc06d ("arm64: implement CPPC FFH support using AMUs")
Fixes: f489c948028b ("ACPI: CPPC: Fix access width used for PCC registers")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20260916162805.1039247-17-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/acpi/cppc_msr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/acpi/cppc_msr.c b/arch/x86/kernel/acpi/cppc_msr.c
index b961de569e7e5..37543b21ce94d 100644
--- a/arch/x86/kernel/acpi/cppc_msr.c
+++ b/arch/x86/kernel/acpi/cppc_msr.c
@@ -4,6 +4,8 @@
  * Copyright (c) 2016, Intel Corporation.
  */
 
+#include <linux/limits.h>
+
 #include <acpi/cppc_acpi.h>
 #include <asm/msr.h>
 
@@ -14,10 +16,20 @@ bool cpc_ffh_supported(void)
 	return true;
 }
 
+static bool cpc_ffh_reg_valid(const struct cpc_reg *reg)
+{
+	return reg->address <= U32_MAX && reg->bit_width &&
+	       reg->bit_width <= 64 &&
+	       reg->bit_offset <= 64 - reg->bit_width;
+}
+
 int cpc_read_ffh(int cpunum, struct cpc_reg *reg, u64 *val)
 {
 	int err;
 
+	if (!cpc_ffh_reg_valid(reg))
+		return -EINVAL;
+
 	err = rdmsrl_safe_on_cpu(cpunum, reg->address, val);
 	if (!err) {
 		u64 mask = GENMASK_ULL(reg->bit_offset + reg->bit_width - 1,
@@ -34,6 +46,9 @@ int cpc_write_ffh(int cpunum, struct cpc_reg *reg, u64 val)
 	u64 rd_val;
 	int err;
 
+	if (!cpc_ffh_reg_valid(reg))
+		return -EINVAL;
+
 	err = rdmsrl_safe_on_cpu(cpunum, reg->address, &rd_val);
 	if (!err) {
 		u64 mask = GENMASK_ULL(reg->bit_offset + reg->bit_width - 1,
-- 
2.53.0



