Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9491A0BE0;
	Wed, 23 Apr 2025 15:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422562; cv=none; b=HRiOQSMEPht1HpLJriQpbHbHST4WgZHdEhH3ADaHAjRCz/XtgXQrrLzG7maQ7cQsojB6KBXql1Z0LmnbACpzR2GpOQYMT1IZX9dR/DXA+zz0L4+a4kaaHxo77gmbhf0Dl/qC4rzSg51gp6XAVXBw5BV803o3N9GHB+6B80+M968=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422562; c=relaxed/simple;
	bh=tsj06aHCxSHFqd4K/tGsaBIbk4TQ+r+qp+q801e16Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nkXBkI1+eMrfFckPRDRKeIYr5Vz3uZhXZVvyz0SLb+oJ6u3Vl1iXGASWIKhVw2pgMbztCPTpKLoxhapXhoC3gphnAMUD9EwujqmhoLgcPZxVxXexdmoSss5lLtGpscodmb9tFgvSH4rk86rHUytJvfIIrDs6szBvWUa6mn/FGo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+2e6K6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+2e6K6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82687C4CEE3;
	Wed, 23 Apr 2025 15:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422561;
	bh=tsj06aHCxSHFqd4K/tGsaBIbk4TQ+r+qp+q801e16Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+2e6K6Wi4sOVYCBiMH1Gq7ufEMQMgcCxKwYxNI3yJPKS9W65+CE4mEA+K9mB8QhW
	 cLKIivifGMZ45kevw+dQXjC4XcG53Zp/XfcpmSro2LG9Mmw5X/38gXzdur0FyE4jdu
	 xlgQx78W5awfO+AOwXUvOnH/cg164mjcZk4903Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 389/393] MIPS: dec: Declare which_prom() as static
Date: Wed, 23 Apr 2025 16:44:45 +0200
Message-ID: <20250423142659.384979724@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit 55fa5868519bc48a7344a4c070efa2f4468f2167 upstream.

Declare which_prom() as static to suppress gcc compiler warning that
'missing-prototypes'. This function is not intended to be called
from other parts.

Fix follow error with gcc-14 when -Werror:

arch/mips/dec/prom/init.c:45:13: error: no previous prototype for ‘which_prom’ [-Werror=missing-prototypes]
   45 | void __init which_prom(s32 magic, s32 *prom_vec)
      |             ^~~~~~~~~~
cc1: all warnings being treated as errors
make[6]: *** [scripts/Makefile.build:207: arch/mips/dec/prom/init.o] Error 1
make[5]: *** [scripts/Makefile.build:465: arch/mips/dec/prom] Error 2
make[5]: *** Waiting for unfinished jobs....

Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/dec/prom/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/dec/prom/init.c
+++ b/arch/mips/dec/prom/init.c
@@ -42,7 +42,7 @@ int (*__pmax_close)(int);
  * Detect which PROM the DECSTATION has, and set the callback vectors
  * appropriately.
  */
-void __init which_prom(s32 magic, s32 *prom_vec)
+static void __init which_prom(s32 magic, s32 *prom_vec)
 {
 	/*
 	 * No sign of the REX PROM's magic number means we assume a non-REX


