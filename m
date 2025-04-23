Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F14428B4FF;
	Wed, 23 Apr 2025 15:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421322; cv=none; b=omk9OycR9Tmf4JwHyeDaqQqg47UfrGYt/y55owOcGsVP4jEvDSRsQQrMsz40idbpxypPIvA1VY9cuLJYYHAkqY5FIfXdU94pz5OLD9nFiVpbA5GGUQm4SeXOqqZ/aN3C2fprTuuhkUSoeZbl6B2M7Lyu3Qwtlf2CAUOCyT6b4fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421322; c=relaxed/simple;
	bh=NmKO6G51xM2C+OdH12Iwex6ZfzqOU77hep4X4MAq6WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cDZVE38cfIvKL5BGUGml1x9N2fSMMAd+mXO9ZtnT9mIElhE0ot/UK2Ob45wQFIaXjebfwKpFAy1DvNag3HazOx8kJmWQhtSo1CXQd0Ws2t3PyJF5/nmDPPYas9ATfBPwrIWr+DWDQQN44JWpnqympmKer3xiMcUgZB544N3UP+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jp3eOiam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jp3eOiam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57EAC4CEE2;
	Wed, 23 Apr 2025 15:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421322;
	bh=NmKO6G51xM2C+OdH12Iwex6ZfzqOU77hep4X4MAq6WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jp3eOiamPd5ONXkFpXlhMObUK20Hu06fSg0UtGC9PfOar/nFmGYzdC0BUERYNl7ww
	 Ur4TX8GAi+ZfxshBlPsl06gnqULuxIazNNX2YMf9lQ+u6+/4oL5WTUs3yFCrBqVIXM
	 L+Sx++gPtbrH83rw1qRTjh+8zUeBYidEn2jz/VBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.12 211/223] MIPS: dec: Declare which_prom() as static
Date: Wed, 23 Apr 2025 16:44:43 +0200
Message-ID: <20250423142625.756577752@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


