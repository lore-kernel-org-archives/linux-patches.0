Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCED34AAE0;
	Tue,  6 Jan 2026 17:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719939; cv=none; b=Q1UaJPkUMBcJe46Fn8lKPZoiznqStp9xAbEUal8Bg7tXZljaL+wnO81hs0bOfKUhBpnYqFJgWr4Vbmd9rM6se0+JruRu7ANckd4VqREl86DUPpoMXD18XpaIobXMojHy3y/RISRGO8UqulFJdY24CNG9Q02ajH1taqIfuqXDahs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719939; c=relaxed/simple;
	bh=fG/9WHJWqFsFrelx5pyw4iC0GZMJm07bePM5hp1JMCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjSj/YayQJj3+HwJwH9vSjEf6fu8rrQOdHUgjJKBRisPFPAlUliXjdyM5CagxXENAHoUY53IzAkhCsuBb57qtHKILO0nufzFuQeRkevdov6/0N4TergmMIyK+EaZXFw8e720T99NPHs1/QQ1wM2WapRA7taFplDfaLBEEy30ibc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doSZFZxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doSZFZxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230ACC116C6;
	Tue,  6 Jan 2026 17:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719939;
	bh=fG/9WHJWqFsFrelx5pyw4iC0GZMJm07bePM5hp1JMCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doSZFZxqoy7fsGHiegPlvzf0Qnv/wNPEt7Od+RQufhNY/9llR+87PKl/SH+5VXZul
	 bvNScIriYlotCYbLHnDY7fB+HJH4c1DICAOmqe0JD4jY0w2Wew4EJcOzQzj22tboK+
	 BBtwyBV2cR8oi7gabP8oaUldE+fygBuHUgFzfOGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/567] x86/xen: Fix sparse warning in enlighten_pv.c
Date: Tue,  6 Jan 2026 17:57:48 +0100
Message-ID: <20260106170454.512500840@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6e9d1b287f8e..bf750cd599b2 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -106,7 +106,7 @@ static int xen_cpu_dead_pv(unsigned int cpu);
  * calls.
  */
 DEFINE_PER_CPU(bool, xen_in_preemptible_hcall);
-EXPORT_SYMBOL_GPL(xen_in_preemptible_hcall);
+EXPORT_PER_CPU_SYMBOL_GPL(xen_in_preemptible_hcall);
 
 /*
  * In case of scheduling the flag must be cleared and restored after
-- 
2.51.0



