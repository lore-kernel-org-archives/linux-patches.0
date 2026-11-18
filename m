Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053093;
	b=3d2oFHjTWFuALZ08I150YgeoKleNVVJDMlF6OTgrgY1B9Ae/6sdsrmQIkVT+pPsKF1hu
	 VMptXwwJCT3wGwt+MTZMbqtuumuXRWa8lkZVT+xLpmJAtb1JnGiFVHVN9oKHlTpUNzKpa
	 HMGrhsyqjvlo4l+3egSnVjQIEfZE9EHnwkcF/3LtNbxbPVzXsCt0Mm/xao7qPK5zVXQmB
	 2oAdb4PiIqwa5gpwVUjRzodMgluDYHJKkkU/XDqwIF5H+T0hoAnkn8Nk4TmGtp4z2XRq8
	 6q4C7Hmb+eqZoWk/kn+BcJUGeFSB5TYhc405sNTgpY6hPZP2Ces5/gJiY9ySrgIt9xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rYXa0h9EZ95jUPxJ2tLrrBClbdYQrLGyHBlUIBKYQGg=;
	b=hdOT38ClgnnaP6NRoN2Lf3y56dNZ2NKMJGIjk8Jk1DQ7bG4GR4uIqwj8qUZsteF+5UHf
	 YqS+Z5A7Zt/E0EGQhVNPr4jK5MkXr3b9Pcv6bEV4FXUi3MEv5UtBVA3xedE8nrqiKy1M0
	 aTM9KWaoKtZ7bgOvmgsQ6xCn+HDLsR48cFA+G8XiN95+UfR97Mklx865GT3TfIXtWHgQ3
	 kC/cjzvgzr0TnHEeyJ8Pncvrpqa1rv6iu/gxErbYLUVjYxfacCCX2EFvvsizKBxvUDkwG
	 Cf3HOzNDBVpjxpgsqZuLlhZ7UZc20b1TAKEQ6XuYmtd6xI+C/R8ONCZFDPDF3ThCq9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVlPHF9r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033DE606A325;
	Thu, 19 Nov 2026 01:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVlPHF9r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580BD1F000C4;
	Thu, 19 Nov 2026 01:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053092;
	bh=rYXa0h9EZ95jUPxJ2tLrrBClbdYQrLGyHBlUIBKYQGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVlPHF9r2Q1JkXwwLpbJDpLnZ1KkvLo8gYIfi7XKy37gMmHFID+ecKLgD+eM6ulnP
	 UnwQL62G7p8EBsPio1Hv3BLYNWeQ5gJ6zCgxO4OeanTN5hATxJ+XZFEHn285fYg3lZ
	 KDoD5Xfbl11MBC8i5V2kw1SYzNx0vfrmi1/5B4wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0798/2214] ACPI: CPPC: Propagate errors from cross-CPU FFH calls
Date: Wed, 18 Nov 2026 15:41:14 +0100
Message-ID: <20261118150043.456214447@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/kernel/topology.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 5feda5b55d454..a1f9053248dfc 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -303,9 +303,7 @@ int counters_read_on_cpu(int cpu, smp_call_func_t func, u64 *val)
 	if (WARN_ON_ONCE(irqs_disabled()))
 		return -EPERM;
 
-	smp_call_function_single(cpu, func, val, 1);
-
-	return 0;
+	return smp_call_function_single(cpu, func, val, 1);
 }
 
 /*
-- 
2.53.0



