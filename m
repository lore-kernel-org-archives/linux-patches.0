Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619818;
	b=anKzaLFJVIyDoNe7eFxRJsIlvYuPnrWAoOQ2iHF1mkZFFPoCizI/WntNNIKYuL2lfsRi
	 JFxhAJr+1UHHigpa93Ai81ZIPGI9LQNBQbpxMvtqbWiq4bX/7QOcSrP7/CJowz4PDV9V2
	 z8ObOb+EXUfJufxcHJ7q38/Tv1+ul4hIptUViEWzMI08Ii6Uo8iM6IarN9sqKuAT27I4h
	 GokyjeT9yUzB3TaA3ldOfrbc0oeQE4dIr0i+9fk2P9CJ710kiHoghwysaqzzKm8f4fumc
	 uQz3nq8HDlUkbBReqKZK10Nj3sJSbUaYolnJyBoBEpcTdYZLxFEY/TsiwHI+HTbKkFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HsC9uju/Gsta4xzHSuZ7CYCO1lHI8IJxn1/uPYU1zfA=;
	b=H/CQTksPdLuMYIJGPmtpzADzkFNKEx1pGKuGeOT6ge4FJll/m0j1du8rYUXpNt30+U7P
	 AV+k43rooLpOQ3TgEgRItrPjrbzG84WaHj+g/nuhDUhqkZmEthxX7wUqdzHS8ttoW95cA
	 yrh1f2MUJC+JhoT6owYk6UuDw+XzBR++3MI5Csr9oc8ngSWRke2ouG08OVnQnm5sxnlH/
	 hDs/JCYIaNXW42VIn/NcOIHBlQwhNTo+Ki/hfXOR4i9IiUQgbL+I36w7LoQKGxRaQYRRw
	 q43vbtme4b6vgJZXkjWRKUmpj2FaUkniq/Tn8FTItr6h3oObBRsI9i0XHg1G/Ttp/vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8WjNEYB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83E0606A329;
	Wed, 25 Nov 2026 15:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8WjNEYB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A1A1F000C0;
	Wed, 25 Nov 2026 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619817;
	bh=HsC9uju/Gsta4xzHSuZ7CYCO1lHI8IJxn1/uPYU1zfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8WjNEYBy2WWNSqVf2u7o9xEhqViV3WlyVr3fg63VL2vy6+elqyik3RzggH1li1Fy
	 Vgpa8F0ZRSSJW9jzL6jkZbQhWLc4yD8RNAX6dq0loqDgJRx5lPA/6EpRxkZEALR3hO
	 BOHh/4+SJ6iEyE0qeOGcUsjJariZV0p/O12tXP0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhaoxin <lizhaoxin04@baidu.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.3 0717/1005] cpufreq: intel_pstate: Use rdmsrq_safe() to read MSR_MISC_PWR_MGMT
Date: Wed, 25 Nov 2026 15:34:15 +0100
Message-ID: <20261125143838.553675351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhaoxin <lizhaoxin04@baidu.com>

commit 2c0e6f2858d235c99f7ba4621bd176cd67226f00 upstream.

Commit ed7cad0504e3 ("cpufreq: intel_pstate: Relocate platform
preference check") moved the intel_pstate_platform_pwr_mgmt_exists()
call to the beginning of intel_pstate_init(), right after the vendor
check, so it now runs before "no_load" (intel_pstate=disable) and the
other checks.

MSR_MISC_PWR_MGMT is model-specific and KVM does not emulate it. In a
KVM guest using a CPU model listed in intel_pstate_cpu_oob_ids[] (for
example "-cpu host" on Emerald Rapids), reading it raises #GP and the
unchecked rdmsrq() emits a warning with a call trace on every boot, even
with intel_pstate=disable:

  unchecked MSR access error: RDMSR from 0x1aa at rIP: 0xffffffffa4009342 (native_read_msr+0x2/0x50)
  Call Trace:
   <TASK>
   intel_pstate_platform_pwr_mgmt_exists+0x3b/0x220
   intel_pstate_init+0x1e/0x500
   do_one_initcall+0x59/0x350
   ...

Before that commit, such guests typically returned from
intel_pstate_init() earlier, either because of intel_pstate=disable or
because intel_pstate_msrs_not_valid() failed on the zero ratios that
KVM reports in MSR_PLATFORM_INFO by default, so the MSR was not read.

Use rdmsrq_safe() and treat a failing read as "no OOB mode". The
exception fixup already zeroes the result of a failed unchecked read,
so apart from the warning going away there is no functional change.

Fixes: ed7cad0504e3 ("cpufreq: intel_pstate: Relocate platform preference check")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Li Zhaoxin <lizhaoxin04@baidu.com>
Link: https://patch.msgid.link/20261104070149.41393-1-lizhaoxin04@baidu.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -3661,12 +3661,12 @@ static struct acpi_platform_list plat_in
 static bool __init intel_pstate_platform_pwr_mgmt_exists(void)
 {
 	const struct x86_cpu_id *id;
-	u64 misc_pwr;
+	u64 misc_pwr = 0;
 	int idx;
 
 	id = x86_match_cpu(intel_pstate_cpu_oob_ids);
 	if (id) {
-		rdmsrq(MSR_MISC_PWR_MGMT, misc_pwr);
+		rdmsrq_safe(MSR_MISC_PWR_MGMT, &misc_pwr);
 		if (misc_pwr & BITMASK_OOB) {
 			pr_debug("Bit 8 or 18 in the MISC_PWR_MGMT MSR set\n");
 			pr_debug("P states are controlled in Out of Band mode by the firmware/hardware\n");


