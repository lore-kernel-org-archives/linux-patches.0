Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1B538FB0;
	Tue, 29 Apr 2025 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947124; cv=none; b=LwUvkFzPvpbKhJ4q02K3G04+rhDz9gXRzJNnxd4VixcZesNOKZa4HAMAJh/dRmQ6Rj5ifKwp2z5Q/p1NApDfNXpIh258Ll2hIocSffkqidkw7AUeIb8tT8RixQgk+G/8zi7GdcJEFquvqTOE+/f9aWbgE/JDY/uRWWHjq3a05Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947124; c=relaxed/simple;
	bh=f9oKqdnRBW0iL1toUgTrf15ktaosC7zUGNPxHXBcgOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WETm8q7itTp8mDvw6uvCLWR3aAY1m1wUVo5l8UCgFuvCL9U+GD/yPNdf7zhHnVTk9krCF51NKajCHi/pVp+m8fUYAPivjQqedNyM0kuGvmdAAGNO2iO51VCvtptoynDS3H/RVcy+MhSqeZDjKH9eEXwbLpZCAnb3hblmBUFAT/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nb8uGPNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nb8uGPNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6C9C4CEE3;
	Tue, 29 Apr 2025 17:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947124;
	bh=f9oKqdnRBW0iL1toUgTrf15ktaosC7zUGNPxHXBcgOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nb8uGPNnlvl6aQP/jDGWkJJF39TxsQljxeO3D9K2lmpxlwqvhJOSUuT/4oFBUZMHk
	 aV4IRMQNYh4LlTvO6rm/MOsFog2x1pPCZMRJ36brr+CML4+TmQENvQdB0PYtImXzob
	 pCLxrQU0ZSpu4E2mdfF28mAru+he3bSqUC12ILmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 180/286] MIPS: dec: Declare which_prom() as static
Date: Tue, 29 Apr 2025 18:41:24 +0200
Message-ID: <20250429161115.314637806@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


