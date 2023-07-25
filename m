Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342AB1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66C5C433C8;
	Tue, 25 Jul 2023 11:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284191;
	bh=3NNCmys3mcbaBWupSTJRD2ZZlizmujbBEXYyQS2MU94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3SxuDhDccCkCSc9O7zeOrae6JDSk+VnWRtKj89PrPrGAr+XHF6B7I61Zp5qwoXNR
	 K6ciXjAI2AqPcFHpZE0FGqFlb82ypdbdgsWpn1nUOYhPEexiPsOdAkphMU2GUVbhvF
	 wbwtgwvEkuYEpjYqkKMbrd4FQmocJ6lZRmRjJ4m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 267/509] powerpc: allow PPC_EARLY_DEBUG_CPM only when SERIAL_CPM=y
Date: Tue, 25 Jul 2023 12:43:26 +0200
Message-ID: <20230725104605.980447743@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 39f49684036d24af800ff194c33c7b2653c591d7 ]

In a randconfig with CONFIG_SERIAL_CPM=m and
CONFIG_PPC_EARLY_DEBUG_CPM=y, there is a build error:
ERROR: modpost: "udbg_putc" [drivers/tty/serial/cpm_uart/cpm_uart.ko] undefined!

Prevent the build error by allowing PPC_EARLY_DEBUG_CPM only when
SERIAL_CPM=y.

Fixes: c374e00e17f1 ("[POWERPC] Add early debug console for CPM serial ports.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230701054714.30512-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index 52abca88b5b2b..e03fb91544206 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -234,7 +234,7 @@ config PPC_EARLY_DEBUG_40x
 
 config PPC_EARLY_DEBUG_CPM
 	bool "Early serial debugging for Freescale CPM-based serial ports"
-	depends on SERIAL_CPM
+	depends on SERIAL_CPM=y
 	help
 	  Select this to enable early debugging for Freescale chips
 	  using a CPM-based serial port.  This assumes that the bootwrapper
-- 
2.39.2



