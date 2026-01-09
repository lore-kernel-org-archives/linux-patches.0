Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1443C359F98;
	Fri,  9 Jan 2026 12:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960329; cv=none; b=f4xDtQdH3yh41qxSGt8cn1rxR89kn/RsqCTngeagplmouqK+uN3b5y6zYz9zIPy4ptreLPG+S6TD4NZxpsCOy3UL5X4peQC3tfVFcITEXN/dxaEO9zmWS6xActdTFZlt4MmyEl2I+PvpCxrmwnCP9n7ZV33KRRXjypPZ06fFYsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960329; c=relaxed/simple;
	bh=Y/52YD8SAOa5w9Hil0SrPQ+OlB6BxZrV7qJoSqNAXQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLeP2IrtIaFx7MvDl4HU5vPfl7B3UWx3sIVjO6Xil875OYsGRz4qmS8ZKtJN7W7U2X+viqqoYU2z+BeiyZRm7mxNIPcbhohK2ucqwhrKLG/X/8Zx55LrU4TLequVTEAGVMZAzETF5ux1vQG6ywf8YqAMrda/y5DKMCi6QUI4ae4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DL+R8+Cp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DL+R8+Cp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824D1C4CEF1;
	Fri,  9 Jan 2026 12:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960328;
	bh=Y/52YD8SAOa5w9Hil0SrPQ+OlB6BxZrV7qJoSqNAXQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DL+R8+CpJOkubJqc6CN66ix3uTD2J1Z/WQo/ToFO/H0GLVScaEMh5n5jbuXBOm4PA
	 uKJd+nKgkE9efC6QjVtV1Nl/TyJKDhLMEAzP43kLobBLlTr97YS2yM0MwrRyOl8m8E
	 lYbMNGW6niqvqzsNB9gqfJBJdOrzjPhQfgm3FpHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 366/737] x86/xen: Fix sparse warning in enlighten_pv.c
Date: Fri,  9 Jan 2026 12:38:25 +0100
Message-ID: <20260109112147.764549785@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit e5aff444e3a7bdeef5ea796a2099fc3c60a070fa ]

The sparse tool issues a warning for arch/x76/xen/enlighten_pv.c:

   arch/x86/xen/enlighten_pv.c:120:9: sparse: sparse: incorrect type
     in initializer (different address spaces)
     expected void const [noderef] __percpu *__vpp_verify
     got bool *

This is due to the percpu variable xen_in_preemptible_hcall being
exported via EXPORT_SYMBOL_GPL() instead of EXPORT_PER_CPU_SYMBOL_GPL().

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512140856.Ic6FetG6-lkp@intel.com/
Fixes: fdfd811ddde3 ("x86/xen: allow privcmd hypercalls to be preempted")
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20251215115112.15072-1-jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/enlighten_pv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 72b58fa4bc17..bfcd6ffc57df 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -110,7 +110,7 @@ static int xen_cpu_dead_pv(unsigned int cpu);
  * calls.
  */
 DEFINE_PER_CPU(bool, xen_in_preemptible_hcall);
-EXPORT_SYMBOL_GPL(xen_in_preemptible_hcall);
+EXPORT_PER_CPU_SYMBOL_GPL(xen_in_preemptible_hcall);
 
 /*
  * In case of scheduling the flag must be cleared and restored after
-- 
2.51.0



