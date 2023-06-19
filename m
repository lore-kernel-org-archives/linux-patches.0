Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D84AC8CD
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91E1C433C0;
	Mon, 19 Jun 2023 10:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172364;
	bh=svi6qGxnp1fm22+G3/CI2v8WGSS1aZUBN7qrdBbVMgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1TA7DUJ79ha/ywzfddOG135fIQdlAJ6k5BchdOJr+iWfVa2HAxcx9SVEXWw2wF4Ys
	 63NpmeLg9rTaXvID1Iu3FUL7O4RqiiNQaKCSYug+PZXy8RVdPvjk+Oj2whDmYd5SeR
	 lqWNgNraFKEF4/kzh4n5EE/RcCKW1XAnfEeCN/54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Lauss <manuel.lauss@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/107] MIPS: unhide PATA_PLATFORM
Date: Mon, 19 Jun 2023 12:30:08 +0200
Message-ID: <20230619102142.690476267@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manuel Lauss <manuel.lauss@gmail.com>

[ Upstream commit 75b18aac6fa39a1720677970cfcb52ecea1eb44c ]

Alchemy DB1200/DB1300 boards can use the pata_platform driver.
Unhide the config entry in all of MIPS.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 393eb2133243f..56c0f75e7a76e 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -81,6 +81,7 @@ config MIPS
 	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
+	select HAVE_PATA_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
-- 
2.39.2



