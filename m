Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063020;
	b=BO2jQdvXuFvhIevr0nWi56APKocuOpbHZXVPyHEIJhvYJlwSFB7QzdQ7ows/nqVlSY5H
	 qBm1Cc/az59jajDXJSmfuRyWkhDG+F4VifHsxRDrxR1fBFWsHLTa4cHumn0+T13aOJc4K
	 rJg5kkiaSQT6PiUYmJslh5NlwpYnkMzyXgjWdMeGnrVmRaVeCwMKAVdIxkqNms73Xw5TV
	 6BcTA10zBia0tYWsbgPiDInD/xoAIOyrSzP+1fmbmdrBoh4R07OXQJaCv0bCJNYBGwkYM
	 0VxCuJnXDdm3Me5lqEyvnrejyQy1K5xqqiGYgUKFYHY0gYt7RFqQu0lzGQwS5/gmiFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XBsrx0mY6sS3nDsMu4QG7//IZkmGQfPBat77ZoR7I3I=;
	b=3zAIpLhHJ0h3Cbg22FnCGpDIoWmtp8JBSFGP6eVOGZLs7cbDs+vCjWTIvUZkaMC1OWn2
	 BWiXqfwl7MN0CqZs1q/AG0CHsSjSK1Apmnx+ewcpv9H+Dlw/UVQl0e0gq9zBP4aBPvUGl
	 ctUxnXjPuc+VrQK1UbOki1AwJ1/EMaEN1KT9SjPre4UFTaJe6af12CBIiqnm/LNdvp6bi
	 te66BHZMdiwX2G32Gw8I0LdNZSRww+LA/OOsWJUkJRfbkpG0pblascw4O5H5kZaWWpnh+
	 SsWpBXrFDxSme6EybDi2dQJjH0oPsnvq43MaZsx4Gtmm4fooBeiYoL/Wx+2G77OT2AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2GaNKMO6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D29606D827;
	Sat,  7 Nov 2026 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2GaNKMO6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3801F0089F;
	Sat,  7 Nov 2026 14:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063020;
	bh=XBsrx0mY6sS3nDsMu4QG7//IZkmGQfPBat77ZoR7I3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2GaNKMO60UmyZwNyu8/qswRY4jbUu6E7uO86Hys9Q0TLWTdJ7lD9cf6JZA7igl6Uj
	 aqhTbhlxW8ljWNTdTCfdJV+RGtFycqdeqRi/p9xgTUmtdds9oeBQZ5UTveJd4mg+BE
	 FppQo/7/ebYE1lTeTN9Zq6NN9vDjEoch0iECzFDo=
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
Subject: [PATCH 6.18 233/869] perf loongarch: Fix discarded const qualifier in _get_field()
Date: Sat,  7 Nov 2026 08:48:35 -0500
Message-ID: <20261107134859.730495269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



