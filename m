Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB1B8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA68BC433C8;
	Sun, 16 Jul 2023 19:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537320;
	bh=NnW+CSPdz5l/g8gIeBXAk5L6kXTHROrX+7vJitTNmlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCp9W1ESv6qyEJShJPrbnTyQyohUTKP+3dRLxau27Maty75bt6zhy0jxD+7HqjGlS
	 hynZ5ht92K2gt1fpwI10sKeKkLtOw5qO4rBInfqZ5SowSInjedGGmNjMwOiq47WPBL
	 BMdYQC4SUeSmkl4Lq8pXqBTuz07l9R5R4ITkKEQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 026/800] virt: sevguest: Add CONFIG_CRYPTO dependency
Date: Sun, 16 Jul 2023 21:37:59 +0200
Message-ID: <20230716194949.707898903@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 84b9b44b99780d35fe72ac63c4724f158771e898 ]

This driver fails to link when CRYPTO is disabled, or in a loadable
module:

  WARNING: unmet direct dependencies detected for CRYPTO_GCM
  WARNING: unmet direct dependencies detected for CRYPTO_AEAD2
    Depends on [m]: CRYPTO [=m]
    Selected by [y]:
    - SEV_GUEST [=y] && VIRT_DRIVERS [=y] && AMD_MEM_ENCRYPT [=y]

x86_64-linux-ld: crypto/aead.o: in function `crypto_register_aeads':

Fixes: fce96cf04430 ("virt: Add SEV-SNP guest driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230117171416.2715125-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/coco/sev-guest/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/virt/coco/sev-guest/Kconfig b/drivers/virt/coco/sev-guest/Kconfig
index f9db0799ae67c..da2d7ca531f0f 100644
--- a/drivers/virt/coco/sev-guest/Kconfig
+++ b/drivers/virt/coco/sev-guest/Kconfig
@@ -2,6 +2,7 @@ config SEV_GUEST
 	tristate "AMD SEV Guest driver"
 	default m
 	depends on AMD_MEM_ENCRYPT
+	select CRYPTO
 	select CRYPTO_AEAD2
 	select CRYPTO_GCM
 	help
-- 
2.39.2



