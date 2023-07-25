Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6141ED44
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01816C433C7;
	Tue, 25 Jul 2023 11:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283322;
	bh=Twd8ayarVB1qE1t1WLkgVnSABqdKRoM0XPuE0blvbhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQyQ5HgmyoTBH3+ifBg9hJkxq92n6yw82dicavsLo6EQKd81vv5Gj7+FE2ZVEojWF
	 0U5Aq3v805oDfg7JUOa9yOb2ikaMD1d+/MhmlAh8xAI2Y94q3c0iQTYcKzEAHJCYw3
	 9w7pFzLVM2Hv4btP1ncWmkI9vlDwWMWaQntuAcZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/78] [PATCH AUTOSEL 4.14 7/9] MIPS: dec: prom: Address -Warray-bounds warning
Date: Tue, 25 Jul 2023 12:46:26 +0200
Message-ID: <20230725104452.668819435@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[ Upstream commit 7b191b9b55df2a844bd32d1d380f47a7df1c2896 ]

Zero-length arrays are deprecated, and we are replacing them with flexible
array members instead. So, replace zero-length array with flexible-array
member in struct memmap.

Address the following warning found after building (with GCC-13) mips64
with decstation_64_defconfig:
In function 'rex_setup_memory_region',
    inlined from 'prom_meminit' at arch/mips/dec/prom/memory.c:91:3:
arch/mips/dec/prom/memory.c:72:31: error: array subscript i is outside array bounds of 'unsigned char[0]' [-Werror=array-bounds=]
   72 |                 if (bm->bitmap[i] == 0xff)
      |                     ~~~~~~~~~~^~~
In file included from arch/mips/dec/prom/memory.c:16:
./arch/mips/include/asm/dec/prom.h: In function 'prom_meminit':
./arch/mips/include/asm/dec/prom.h:73:23: note: while referencing 'bitmap'
   73 |         unsigned char bitmap[0];

This helps with the ongoing efforts to globally enable -Warray-bounds.

This results in no differences in binary output.

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/323
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/dec/prom.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/dec/prom.h
+++ b/arch/mips/include/asm/dec/prom.h
@@ -70,7 +70,7 @@ static inline bool prom_is_rex(u32 magic
  */
 typedef struct {
 	int pagesize;
-	unsigned char bitmap[0];
+	unsigned char bitmap[];
 } memmap;
 
 


