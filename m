Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D00B33C53A;
	Fri,  9 Jan 2026 12:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962205; cv=none; b=JgduLhhutrkXoM6Tu883JjvzF1CmYvVKvmLdfRAYhBuj+vSqP98291u5qyxaP/ZSmjqATxHKkrhYFKcgyzRqN1sWbnwpmrExBCdJmiuE2cfYOAxet94XYm3lLkbNenTA8CABOSfR6blKO+L0FLimK7QX95X9ZrrFbtp6bc13l4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962205; c=relaxed/simple;
	bh=2lUnh4ZGIGMVdf2hCvA3HvtuodQD+uts4vOVKeq9Ie8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNQOxhew7hbE6B9qo+0ps/Iqcv04yLCQTECTsm99SIf6Jwek0b143hA5pExFpQt6R6yS/QulhnRBkjb+9Y8WDceZEy6zGmiDWdQDQSC0SNGv2lT7eabE3YpklhagK+tvLQSY9VU301UNNIyvFxXNod0WK/Ed6iLAdaEH7LroT04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udm96323; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udm96323"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7E9C16AAE;
	Fri,  9 Jan 2026 12:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962205;
	bh=2lUnh4ZGIGMVdf2hCvA3HvtuodQD+uts4vOVKeq9Ie8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udm96323EmCCYLdMSVFwybt3Qk0r7N4ADIbVyNtaID5TKRNly+Pj9BwCF2OJ+PhOD
	 5lsi3cSKQ1NZO57jeUbHxxm9NfGhva7XiFYnFM4QmepgN+Haa7sRb/fxbSdZRpdzxD
	 n4ua3ejW6MuQrZlvFqc5TgI9jTNmL8b52rTKmNUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 276/634] x86/xen: Fix sparse warning in enlighten_pv.c
Date: Fri,  9 Jan 2026 12:39:14 +0100
Message-ID: <20260109112127.918389498@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9a54049744bf..772970fce042 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -109,7 +109,7 @@ static int xen_cpu_dead_pv(unsigned int cpu);
  * calls.
  */
 DEFINE_PER_CPU(bool, xen_in_preemptible_hcall);
-EXPORT_SYMBOL_GPL(xen_in_preemptible_hcall);
+EXPORT_PER_CPU_SYMBOL_GPL(xen_in_preemptible_hcall);
 
 /*
  * In case of scheduling the flag must be cleared and restored after
-- 
2.51.0



