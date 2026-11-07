Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064139;
	b=hEJhZ6ab8OdqCiLkV910V/IIlShWhNv73jPHihg44uhvefFokBBzgKGcARf9Z0SMHNWj
	 4gIsKFrQUeLc9yw8FnRpd+kecYNfdjwHbNwYh/76Qs55oCheTno97MEzaY0vvNDKimYAv
	 kcu1mWARyp/weRenQON24xg522URm+IOVpYnDcQmEd5XdhLTMj9kkDGhGvtnINdaK2lDZ
	 9Mg2dInMVi5voFuRUg/rKRv8a3cpCb7PY9Ry27LO3m/PaIywy09IKdG4ln3SrduErDQY8
	 okZ0teJnlasoiZ0tz0g7zsqKHtQUVuWRECmmkCsPPaXvcdArErTelnPncgY2kgnKagA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yjCoduKeDqhIuB+6HmbZ93Zf7fE9zLhmGXZmXib7qyA=;
	b=wpMon15t23DqruEoP+rPa/02CBsd1maRL66+FwreiPVR4xthfA3VT0eF3TWimCgdvki9
	 /jywLfWH7j29uhfWWw7QjW85l7Lm75BL0mtiVU2tRqNXG7Y7fRV6LEUUg/V+ldh5Rc+h7
	 +ILvK0MihDtvyEbYnKuVkQleCLlGufyS4KpBcCFG0KjCeySFstWsq5OUSLRyqndCithTe
	 7QUKTDGeBSapqX5/9YaBF3ndNvmTbVEQubsM/mo97U9DDp7HWYVsSeyD5X9Enfp4WMYSd
	 szYQEkNub9GlEaYNgvhnOv3BcdGeelu1D/slbRA0+5CYtPQiuHIQnxMlcKv1CEusr6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncr2FFN0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EA8606A33F;
	Sat,  7 Nov 2026 15:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncr2FFN0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04ACE1F0089F;
	Sat,  7 Nov 2026 15:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064139;
	bh=yjCoduKeDqhIuB+6HmbZ93Zf7fE9zLhmGXZmXib7qyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncr2FFN0ue/Fp2plQP23mlcZ2TeF5FGDiDf7Gt/v9cNglEz1EhtTHhnhA/lZzsugC
	 EiqcEB0nIa1sV8wqt53hEHbMEkKob47Ar/bOgVj9aMOqSRarwHz53bsXwSXJ15Z61Z
	 IWur/pM2cwNw+pd+DJL4SwKq3i0f+M3Fhvh60I+8=
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
Subject: [PATCH 7.3 0288/1257] perf loongarch: Fix discarded const qualifier in _get_field()
Date: Sat,  7 Nov 2026 08:43:04 -0500
Message-ID: <20261107134947.423937905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0c6d823334a21..46f53a74f71e8 100644
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



