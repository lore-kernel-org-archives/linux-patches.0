Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590046;
	b=ti1iCNzVbuj+Sg05c6Kwm73iHBkN7SuSX66WrqbIul9GLFYkA1ivmnM5bdzU/mMe8Ja+
	 3K/N5FLLCUuAEm6PNyfDPA3lOXDa+nztER+w9cNA5tBhIHp2WllvTAvUnbclMfUrfKFpi
	 uhrW2FG4Rsyddq371ZdcL/OP557ySEvJ2nOkTPJqSuRQsS86qX00xJgN8PnAkQsrvuM60
	 PIKae5a7ChIuGaNklwe39T7Zx/euqLvF5OxqVaMqrQ95zs6l/hD02JI6ABO2eC/8Ue7YK
	 JJ15J6oECQSybAh3qevkHEs3EutpzvYdF4aeU6oB+YCxQPTDEmFe8pzNVObwaXotu6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OBpk0PKzIgSEJcJ3YabTqoYS2FZochPAd4xnBmK4hes=;
	b=x3+SEcI8R8L5+pEt9FUk/f7P4r4zq964le1IuyOxoeSADLHoRbUilcg92+kpQ/D+hQRK
	 CMr7to1tkZ8TMFZU6dDH9bawEt0F5ZPHfZpDJX1Muw0ZTOPBt00wF+q8BA/Jn25O6RHJD
	 YT4xbfeAHUoHVGzNWQYNDWcDMLcL1hfTGpLnsvD6sgnwBut52c0RdfYzq8oCMhlWwI44C
	 AfOBucpQ+fNMxwU1sdqRn7kQBJUmQiCcejo+gcHDslAPy3RKPczO6MxW5lCF/+LCc3Q1+
	 An2xCPGNBaZhwB+Lgpq6A75nDL/IhDrzFOqrqLIF7sGiaWhv2IfCrEQ/haRvsOe8V8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HKKPgtdv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABA3606A8A0;
	Fri, 13 Nov 2026 17:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HKKPgtdv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2E61F000C5;
	Fri, 13 Nov 2026 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590046;
	bh=OBpk0PKzIgSEJcJ3YabTqoYS2FZochPAd4xnBmK4hes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HKKPgtdvDdSosy+wLuTosQZKOlibZ292kblowwwVl2uHpJrkz1tucvkaQCy/Ghxs4
	 NPyBLl/UWuYY6nExUmAEEIv4U97OVaxCPFZ9gF/aLXj9A8csC61CjBabrsNsgGtOks
	 qh2vf2QXa0HJCRjPP/gGHpdydjm/JyH5Z9U/QI+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/686] ACPI: CPPC: Propagate errors from cross-CPU FFH calls
Date: Fri, 13 Nov 2026 10:43:33 -0500
Message-ID: <20261113153823.597739410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bbbe866680fd2..415891ffa62e7 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -449,9 +449,7 @@ int counters_read_on_cpu(int cpu, smp_call_func_t func, u64 *val)
 	if (WARN_ON_ONCE(irqs_disabled()))
 		return -EPERM;
 
-	smp_call_function_single(cpu, func, val, 1);
-
-	return 0;
+	return smp_call_function_single(cpu, func, val, 1);
 }
 
 /*
diff --git a/drivers/acpi/riscv/cppc.c b/drivers/acpi/riscv/cppc.c
index 42c1a90524707..4ea4ddedd91f1 100644
--- a/drivers/acpi/riscv/cppc.c
+++ b/drivers/acpi/riscv/cppc.c
@@ -97,6 +97,7 @@ bool cpc_ffh_supported(void)
 int cpc_read_ffh(int cpu, struct cpc_reg *reg, u64 *val)
 {
 	struct sbi_cppc_data data;
+	int ret;
 
 	if (WARN_ON_ONCE(irqs_disabled()))
 		return -EPERM;
@@ -107,19 +108,27 @@ int cpc_read_ffh(int cpu, struct cpc_reg *reg, u64 *val)
 
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
@@ -128,6 +137,7 @@ int cpc_read_ffh(int cpu, struct cpc_reg *reg, u64 *val)
 int cpc_write_ffh(int cpu, struct cpc_reg *reg, u64 val)
 {
 	struct sbi_cppc_data data;
+	int ret;
 
 	if (WARN_ON_ONCE(irqs_disabled()))
 		return -EPERM;
@@ -139,14 +149,18 @@ int cpc_write_ffh(int cpu, struct cpc_reg *reg, u64 val)
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



