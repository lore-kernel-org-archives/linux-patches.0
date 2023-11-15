Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C34439FC0
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vz1isihO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2B5C4E77A;
	Wed, 15 Nov 2023 20:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081810;
	bh=WJSn6gn4D/x3sDcamz+/W3VgGbxxgb7KwYcKs1uHc54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vz1isihOl6yyqfQaOTt7j9RFZJb5oPzjgQ1++9JqJ7FXf37NJzMON/snAvY+8bFIy
	 MemSOj4TvqQ8hX2PRKAzdQG94Yv3q97iHYM2LpBRoWPf0oNBdsgy59D0qbbwjq7FDX
	 /MNCr/sdX0cJGPly8jQPUD8hs2ezcO4M88yHkYfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/191] powerpc/40x: Remove stale PTE_ATOMIC_UPDATES macro
Date: Wed, 15 Nov 2023 15:46:55 -0500
Message-ID: <20231115204652.912117964@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit cc8ee288f484a2a59c01ccd4d8a417d6ed3466e3 ]

40x TLB handlers were reworked by commit 2c74e2586bb9 ("powerpc/40x:
Rework 40x PTE access and TLB miss") to not require PTE_ATOMIC_UPDATES
anymore.

Then commit 4e1df545e2fa ("powerpc/pgtable: Drop PTE_ATOMIC_UPDATES")
removed all code related to PTE_ATOMIC_UPDATES.

Remove left over PTE_ATOMIC_UPDATES macro.

Fixes: 2c74e2586bb9 ("powerpc/40x: Rework 40x PTE access and TLB miss")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/f061db5857fcd748f84a6707aad01754686ce97e.1695659959.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/nohash/32/pte-40x.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/powerpc/include/asm/nohash/32/pte-40x.h b/arch/powerpc/include/asm/nohash/32/pte-40x.h
index 2d3153cfc0d79..acf61242e85bf 100644
--- a/arch/powerpc/include/asm/nohash/32/pte-40x.h
+++ b/arch/powerpc/include/asm/nohash/32/pte-40x.h
@@ -69,9 +69,6 @@
 
 #define _PTE_NONE_MASK	0
 
-/* Until my rework is finished, 40x still needs atomic PTE updates */
-#define PTE_ATOMIC_UPDATES	1
-
 #define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED)
 #define _PAGE_BASE	(_PAGE_BASE_NC)
 
-- 
2.42.0



