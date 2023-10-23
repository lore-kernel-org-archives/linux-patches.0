Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218F114A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1TReF08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B14C433C7;
	Mon, 23 Oct 2023 11:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059572;
	bh=xwsonGJ71ZJkCxDecOw23S0G10ebWeBfjhVJghD35SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1TReF08B+ya/qXjpvoXrhNQhzjkPfQEO5XH8lYtzIiAFTQuX8Jmlcclq5xCTCBYc
	 Gnw1hEN7RXdUBlS6qTGmzBDXsYeC2rypaDwg5OQtI1FSipTFIkLNQe3bP10bYwV/k1
	 WcBUvpf8pYAFmaxkddRD6utTbu5gSCcJwupA30Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 222/241] powerpc/mm: Allow ARCH_FORCE_MAX_ORDER up to 12
Date: Mon, 23 Oct 2023 12:56:48 +0200
Message-ID: <20231023104839.265815990@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit ff9e8f41513669e290f6e1904e1bc75950584491 ]

Christophe reported that the change to ARCH_FORCE_MAX_ORDER to limit the
range to 10 had broken his ability to configure hugepages:

  # echo 1 > /sys/kernel/mm/hugepages/hugepages-8192kB/nr_hugepages
  sh: write error: Invalid argument

Several of the powerpc defconfigs previously set the
ARCH_FORCE_MAX_ORDER value to 12, via the definition in
arch/powerpc/configs/fsl-emb-nonhw.config, used by:

  mpc85xx_defconfig
  mpc85xx_smp_defconfig
  corenet32_smp_defconfig
  corenet64_smp_defconfig
  mpc86xx_defconfig
  mpc86xx_smp_defconfig

Fix it by increasing the allowed range to 12 to restore the previous
behaviour.

Fixes: 358e526a1648 ("powerpc/mm: Reinstate ARCH_FORCE_MAX_ORDER ranges")
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Closes: https://lore.kernel.org/all/8011d806-5b30-bf26-2bfe-a08c39d57e20@csgroup.eu/
Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230824122849.942072-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 0b1172cbeccb3..b3fdb3d268367 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -917,7 +917,7 @@ config ARCH_FORCE_MAX_ORDER
 	default "6" if PPC32 && PPC_64K_PAGES
 	range 4 10 if PPC32 && PPC_256K_PAGES
 	default "4" if PPC32 && PPC_256K_PAGES
-	range 10 10
+	range 10 12
 	default "10"
 	help
 	  The kernel page allocator limits the size of maximal physically
-- 
2.42.0



