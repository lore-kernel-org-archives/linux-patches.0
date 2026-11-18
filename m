Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020015;
	b=07XEz/r1LpJt6cdVRvGYvTQawzC2tZMGFARnXGChl2zeA/kD+uZT7XNUQAkpXFf0brhR
	 g9ZPqrxXmZVk+QFYD0KQ0pPtdOapWPM5KU7IF6fLhNvu5v4SA4NbOo+VY19ARjYqOM4Cx
	 QzKomB3RsXqyO8zdFoCvgAojG5DPZVandT4dzkkv66mfYs63+MPyisI3dCHTgMJJPMNXn
	 ykPAp/HrkBGrpnvh3eQeT595xDNFfIqbg6R8LZGZW1jQtWIYwBRUkRBJ8u1RF4OwP2G9R
	 oQk+M7KHn9D9+O43xY5E+zLpvDhS6okyTcW40/JMlANOzSV0lH3G9Z2Z5r2wb+TO1WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X0/Okos0wmGMC40KpQKefhQufkR+LRz53Fv6/slmJ3E=;
	b=Zm7wTTEFatEg2c0FLixX7BZ1qTXLZj5CrUVrF2vFHRKTdqO+/sUmO0FT3irdR8o8e9Ft
	 8adDSLxI1oQ9Dygmzv/TPoGrVpmiAABj3uX9IumpbQ5XEV6BFr4OLrrbk+x3PWbNp9jK+
	 3UDy/0nJN/P9iLhh2FNgBCr5YLe9bYN0pxIXQ+oxXUE7ZVraelpzZwfdGZT4IAVEBfaW0
	 Rl42uLits1IrbBNOD8WotGEN748cK+lgj7erlJTtGDi+AiT+MCWC+k7O/yQJ/Rd7BfG/C
	 SJGLJeLO+hRB4pVFM/f8qHuKuh+IQjzIHfip1oYhSeYb3vu+wvJMTgVKJ/yd9R+mjdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAhdSM3P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57C5606A31C;
	Wed, 18 Nov 2026 16:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAhdSM3P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193F91F000CE;
	Wed, 18 Nov 2026 16:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020015;
	bh=X0/Okos0wmGMC40KpQKefhQufkR+LRz53Fv6/slmJ3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAhdSM3PPHsbXwag7J89i0iwXRW5B8v/Y9t2Iy9JRsfQ3do7oLbLzkehdJoGuGnU/
	 DZ16bzW+biAMyA0vYitT9Bzz7wqsWuvwByDLq95HoJxnOewoncT4YFmqBwouZ8PwMX
	 HBLQMFamReMf7OOTv3KNH+g782FFdwyL27CBemDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Remi Bernon <rbernon@codeweavers.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1802/2651] perf symbol: Add missing symsrc__destroy() for libbfd
Date: Wed, 18 Nov 2026 15:50:42 +0100
Message-ID: <20261118150352.157030498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 35477b351e6a697c85dc7d37e5081621889f8e40 ]

When libbfd loaded symbols and there's a pending syms_ss, it'd be lost
or overwrite existing symbols.  Let's destroy it before breaking the
loop so that it can safely return from the function.

Closes: https://lore.kernel.org/r/sashiko-outbox-162540@kernel.org
Fixes: eac9a4342e5447ca ("perf symbols: Try reading the symbol table with libbfd")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Remi Bernon <rbernon@codeweavers.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 06a3b88d7c747..3a5488e74590c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1931,7 +1931,7 @@ int dso__load(struct dso *dso, struct map *map)
 
 		if (bfdrc > 0) {
 			ret = 1;
-			break;
+			goto out_destroy;
 		}
 
 		if (!is_reg || sirc < 0)
@@ -1996,6 +1996,7 @@ int dso__load(struct dso *dso, struct map *map)
 			ret += nr_plt;
 	}
 
+out_destroy:
 	for (; ss_pos > 0; ss_pos--)
 		symsrc__destroy(&ss_[ss_pos - 1]);
 out_free:
-- 
2.53.0



