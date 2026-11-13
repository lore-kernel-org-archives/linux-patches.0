Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590865;
	b=SvvdRmuk9p9PD3lymoNBcroZiVgr90V09m79QbOEheOZdQiX9pvParVnylGtFeN6+T5J
	 FgeDYglTH3lnPrd4UbD6zOVmvQo65n7ocyxtPwC1eI9LeoYC1I5+/5P9Edu9/xXhFv7fU
	 XMmxSgTiHZ+TTUC3frF1a8AfFPx1p6QRr/Ml8kFjKW5w/W6z97+y97Jdidb0lHhDjwfM7
	 Ft0RCpNGiImc09R3KneE1YQ7pyMiM2+gFTHlc8hgZmxj4DaUqSjlHc4+QpckMRZxL0QVn
	 XWokFYQGlzIFX4uEjtqD1jlnfGaGsfwTsDmHaNdjD2GyNFYLbPyrKaW0ovLNGNxk3gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xMJ8Akir06cP2gbbqAO7lA2b/oAG+KjM08aoVDU1hwg=;
	b=3ZJ4YnLpH1noTSgYjHORIVS3g+jTM30x7befhazwMCU6O/oA5S/kudysOWSpgadQ/dio
	 DJBMwTFjNajPntti1ehTh0oZkVBNn0DvqDRQ+5frF85KP8AQJguQWkdvPHN38QJYCPEVH
	 Ho0KpMSAy95QEBfVU3SrCNQ8lEpucH6s0Cmn2eILDSqARn0z9vzeDz78tXhgehMXGXgE9
	 KSjYtcxy4DeeUH3ocp6yomJzg8f0/wSS+FQbxZXKvBELB88+u9Da4PK583dq2PloAigwe
	 cGJKORC/tpsvlrVwUNovWYWGQ0zxp3Lrho/TzTptRtkqRJNXDu9EWOYmgE2MvTZfskg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yv7LCXG4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833ED606D852;
	Fri, 13 Nov 2026 17:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yv7LCXG4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCBC1F000C4;
	Fri, 13 Nov 2026 17:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590865;
	bh=xMJ8Akir06cP2gbbqAO7lA2b/oAG+KjM08aoVDU1hwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yv7LCXG4LjRQ8h/ll8ymOznv/c7Gef7pscZ3n1jTiJqwhUhnGW76EH7wTuHKH9hFr
	 bvaim/2hekMaoiAyxx+f6Vmh5Ioc9WRfGut488qVqF2vCyf+e2ElqnbQ3byzzXDY+Q
	 lG6jz5KDd/BYptXp6W5sbSPxin/tQr47Le58gy3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/670] ACPI: CPPC: Propagate errors from cross-CPU FFH calls
Date: Fri, 13 Nov 2026 10:43:48 -0500
Message-ID: <20261113153813.677716469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

commit 36e96b469da24868f727b4cd168d7cf01cbd163d upstream.

The arm64 and RISC-V CPPC FFH accessors ignore the return value of
smp_call_function_single(). If the target CPU is offline, the call can
return -ENXIO without running the callback. The accessors then consume
callback output which was never initialized and may report success.

CPU offlining leaves the CPU's CPPC sysfs attributes present. On arm64,
the AMU feature mask does not exclude an offline CPU, so a paired counter
read can expose uninitialized stack values through feedback_ctrs. RISC-V
has the same problem in both SBI and CSR reads, and its write paths also
inspect an uninitialized callback status after a failed cross-CPU call.

Return the SMP call error before using callback output. The arm64 single
and paired counter readers already check the helper's return value. For
RISC-V, also check the callback status before copying a read value: an
unsupported CSR sets the error but does not initialize the value.

Fixes: 68c5debcc06d ("arm64: implement CPPC FFH support using AMUs")
Fixes: 30f3ffbee86b ("ACPI: RISC-V: Add CPPC driver")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20260916162805.1039247-18-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/topology.c |  4 +---
 drivers/acpi/riscv/cppc.c    | 26 ++++++++++++++++++++------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 721df857d7376..326cf60d8d584 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -289,9 +289,7 @@ int counters_read_on_cpu(int cpu, smp_call_func_t func, u64 *val)
 	if (WARN_ON_ONCE(irqs_disabled()))
 		return -EPERM;
 
-	smp_call_function_single(cpu, func, val, 1);
-
-	return 0;
+	return smp_call_function_single(cpu, func, val, 1);
 }
 
 /*
diff --git a/drivers/acpi/riscv/cppc.c b/drivers/acpi/riscv/cppc.c
index 10a2b554b3ccf..ef3b052f9dad6 100644
--- a/drivers/acpi/riscv/cppc.c
+++ b/drivers/acpi/riscv/cppc.c
@@ -99,6 +99,7 @@ bool cpc_ffh_supported(void)
 int cpc_read_ffh(int cpu, struct cpc_reg *reg, u64 *val)
 {
 	struct sbi_cppc_data data;
+	int ret;
 
 	if (WARN_ON_ONCE(irqs_disabled()))
 		return -EPERM;
@@ -109,19 +110,27 @@ int cpc_read_ffh(int cpu, struct cpc_reg *reg, u64 *val)
 
 		data.reg = FFH_CPPC_SBI_REG(reg->address);
 
-		smp_call_function_single(cpu, sbi_cppc_read, &data, 1);
+		ret = smp_call_function_single(cpu, sbi_cppc_read, &data, 1);
+		if (ret)
+			return ret;
+		if (data.ret.error)
+			return sbi_err_map_linux_errno(data.ret.error);
 
 		*val = data.ret.value;
 
-		return (data.ret.error) ? sbi_err_map_linux_errno(data.ret.error) : 0;
+		return 0;
 	} else if (FFH_CPPC_TYPE(reg->address) == FFH_CPPC_CSR) {
 		data.reg = FFH_CPPC_CSR_NUM(reg->address);
 
-		smp_call_function_single(cpu, cppc_ffh_csr_read, &data, 1);
+		ret = smp_call_function_single(cpu, cppc_ffh_csr_read, &data, 1);
+		if (ret)
+			return ret;
+		if (data.ret.error)
+			return data.ret.error;
 
 		*val = data.ret.value;
 
-		return data.ret.error;
+		return 0;
 	}
 
 	return -EINVAL;
@@ -130,6 +139,7 @@ int cpc_read_ffh(int cpu, struct cpc_reg *reg, u64 *val)
 int cpc_write_ffh(int cpu, struct cpc_reg *reg, u64 val)
 {
 	struct sbi_cppc_data data;
+	int ret;
 
 	if (WARN_ON_ONCE(irqs_disabled()))
 		return -EPERM;
@@ -141,14 +151,18 @@ int cpc_write_ffh(int cpu, struct cpc_reg *reg, u64 val)
 		data.reg = FFH_CPPC_SBI_REG(reg->address);
 		data.val = val;
 
-		smp_call_function_single(cpu, sbi_cppc_write, &data, 1);
+		ret = smp_call_function_single(cpu, sbi_cppc_write, &data, 1);
+		if (ret)
+			return ret;
 
 		return (data.ret.error) ? sbi_err_map_linux_errno(data.ret.error) : 0;
 	} else if (FFH_CPPC_TYPE(reg->address) == FFH_CPPC_CSR) {
 		data.reg = FFH_CPPC_CSR_NUM(reg->address);
 		data.val = val;
 
-		smp_call_function_single(cpu, cppc_ffh_csr_write, &data, 1);
+		ret = smp_call_function_single(cpu, cppc_ffh_csr_write, &data, 1);
+		if (ret)
+			return ret;
 
 		return data.ret.error;
 	}
-- 
2.53.0



