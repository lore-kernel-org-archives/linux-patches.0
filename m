Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062081;
	b=z0M8sEO+IiQRp+MTZaf2k/guVQACyI/K/hnAqs2eN3Dyjv64PGaEtYYK/c3SOIgCoIss
	 29wGj7RKL9l0jLMItBS8kiSYeNSNPgMrTNQBtmqct0+NIQi+T/qqTA9pGaRPzvRq6nUgL
	 R4UyzUD1EccflQ/u3rps+yT38OCvyU7+7sSM6yN0+e2PHqnvZnkvrZmfxIMBBGlbXZH20
	 YpUV9Qc+KJEI2mmJeBPnjTPorvMpTrJ8eoo9nrXllOPU0YTiKn6M6WztNMkgnsrX+obHg
	 75d9xbsMAgjUd3IWuZ6kOWLlI6QTtrePoZUVuZoWPNh+heXf/mSeonEEv3D+ZAHaUDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4GqhLEnpnoNr2YLlH64ThBteiyPCrJE9Hr9cDSocTME=;
	b=2GXgTrVHCCkCyOdYVXul7n62q84IJWXn06hRBiJQct0dGTlnx2JfsZEzepeKoubb+QH6
	 zNEOxmep9Jw5p8HtyNs7MtYtKHR7vuoAvUTWOccAlu/ezRWm1nxZbw6ZSP9DBLW5/TKWz
	 X+0FPuJBG4mm15d1cJmhQclQZDPGsZcILERnnWrV/5gDoWuA7/pbwz5dY6BHk+3a+GBU/
	 rMHPNn49nlBTt/mN4kifMkRIdGduD+0EaklRtLM+256hnXKlrJBDflqudkkhO0SGvogGh
	 A9finIxqJBWHzhpRTOX8wkhh+DtEzEs4Nl33xyOGoXzdkIlv/DU5Y9DunigIFk9eSSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nLTzR/g0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DDA606EEB0;
	Sat,  7 Nov 2026 14:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nLTzR/g0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DBB1F008A3;
	Sat,  7 Nov 2026 14:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062080;
	bh=4GqhLEnpnoNr2YLlH64ThBteiyPCrJE9Hr9cDSocTME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nLTzR/g0JRg8Dmx2TYS1QhXPfQsqyeU+TwiIyVamZtD1CmUQk2xaVmF2hHbXCtI64
	 CZsQmDXU2Y4i/669KKlMP/uvdjWRV+vXvR6v7CRWzrVTD3a2ERO0LaDfbnafVeH37S
	 KffZ3XNZ8ujXP1Xyqv0EmMSx6fDMk3B3FIaxbo+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Namhyung Kim <namhyung@kernel.org>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1057/1536] perf loongarch: Fix discarded const qualifier in _get_field()
Date: Sat,  7 Nov 2026 08:51:13 -0500
Message-ID: <20261107135027.371104322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit ed1293302f811fa709897d4a90ad78592938e4aa ]

When building perf on LoongArch, the following compilation errors occur:

  CC      arch/loongarch/util/header.o
arch/loongarch/util/header.c: In function '_get_field':
arch/loongarch/util/header.c:31:15: error: assignment discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
   31 |         line2 = strrchr(line, ' ');
      |               ^
arch/loongarch/util/header.c:36:12: error: assignment discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
   36 |         nl = strrchr(line, '\n');
      |            ^
cc1: all warnings being treated as errors

Declare 'line2' and 'nl' as const char * to ensure type safety. In modern
glibc versions, strrchr() returns a 'const char *' if the input string is
const.

This is similar to commit 7378b6656aa4 ("perf riscv: Fix discarded const
qualifier in _get_field()").

Fixes: 492ac37fa38faf52 ("perf kvm: Add kvm-stat for loongarch64")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/loongarch/util/header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/arch/loongarch/util/header.c b/tools/perf/arch/loongarch/util/header.c
index d962dff55512b..5da7b287b583d 100644
--- a/tools/perf/arch/loongarch/util/header.c
+++ b/tools/perf/arch/loongarch/util/header.c
@@ -26,7 +26,7 @@
 
 static char *_get_field(const char *line)
 {
-	char *line2, *nl;
+	const char *line2, *nl;
 
 	line2 = strrchr(line, ' ');
 	if (!line2)
-- 
2.53.0



