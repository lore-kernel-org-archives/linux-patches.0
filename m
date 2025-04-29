Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ECF243364;
	Tue, 29 Apr 2025 17:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949194; cv=none; b=DE1uy9cz1XlDDI1fHydJkzzvqK1kBYapd/Oa4oBgLC2MYdY+jVvBqM6jAqUn0KB82Jqv4sn6i0PR2zSJ4EtZ5akG2/wAfnp6qiCmiwoVcP3r735ByojhvrINxjvm6oZZVzZ17FFWcaut/0x82/V0VCC+hnDdu0eIaXRJ4VqgBxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949194; c=relaxed/simple;
	bh=Ae3eVLbhmWVTh8KHULnGJyYVLPfFtJRghXtk9fCPgBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MjSrPMSM5mYAJ1dS3x6la74p6nBnjbPsxACxqNFpRMKHiINsAcPYCkNWGSPGzzO5QELF4J2J5Ixl+U7mbOhNWLolwBTwL/5X5RJ1U5pJjRG9mu+lJ3FcyTUZ4xwEvMh9Uf8YQt/tLNUV9uOKz0E812Tywr8dplMF+UCzyqVWlzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOd+xQxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOd+xQxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4342DC4CEE3;
	Tue, 29 Apr 2025 17:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949194;
	bh=Ae3eVLbhmWVTh8KHULnGJyYVLPfFtJRghXtk9fCPgBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOd+xQxxTyXRGXZSjjKqVwDKNx5Rzwd0ThjotUuvL/tq+m32S/9RRCHfunCfezqVu
	 6kBPekwwoKjvymCbv3HmdYYeBpP9+y92lkVV2jJ5nelHec7QlHMUpMt+AG67IZGpEe
	 cCl+GuDx0OCVj0sC/qT1jBGTwpe8na7elmBzLXAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 241/373] MIPS: dec: Declare which_prom() as static
Date: Tue, 29 Apr 2025 18:41:58 +0200
Message-ID: <20250429161133.046277142@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


