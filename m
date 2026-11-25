Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625371;
	b=beHdqwNc2Gyl1eyizj/QPEVtEv7TBrrtcDTJCrnyaazYRnP5QNc0fOspRjXxXvcejzmQ
	 Azv5LPsuTSicReWSCRFqNIOK1KDWQn5o4cSbzmEVx9MKJDK20lKPIw9qsIgLg0jm2t5pG
	 aB0v+eWHgwU2DSv0zKeHGEjuYsem7RUOKy9Kpy+geDMAzOGFEVUarwpFJqpiy0OvQO2fK
	 zbTfz+LLWQ+n5p85EB5jleMV6hrYUTUcfqoYwXTsd6abX4EGfgPpBXf8cqnGCyojRFL0L
	 xvH3Xfao7PkKaShqqbLZY5ULN53hxMXk+swXIq2ILi27adFW6OsUIVZdkdZ3cPfJogQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MwAju13PjaZgpUhceP7UoIBhfyLZzO4rfwzdfL1V2lc=;
	b=l4CAxEW+Llnj2tcDjYXQH5O3sYnG7UI3SdVcb7AqaitRgKOffIxCgKpZm6n8dEIYw/oT
	 028iYcV/taJOnPVzVM1DAQmwwFZFNdOiP7pRc0scQqx/3hExOza7DzCtpSHzroDCfigsM
	 PGmYBC/A5AQmzt8W2QyQjxKsrBwHVLzev9zHOkwSsOE9a6rIWnYiwIrhS96kVsbupBt/z
	 rgkMgFWgCnRfnztcq806K5WGhNL2I14bgiB9pe4jsv81BHsi0GfdvcHM4S7EFvbMCfJj2
	 ipSVC8DMIbSqbGPWBM3/WApFqnWRxWPMUijKAXeOWL/BgBhs02oKGYTfmUO02eYMg7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T71kDZ89;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0118C606A323;
	Wed, 25 Nov 2026 16:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T71kDZ89
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D8B1F000C4;
	Wed, 25 Nov 2026 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625370;
	bh=MwAju13PjaZgpUhceP7UoIBhfyLZzO4rfwzdfL1V2lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T71kDZ89bBGSFVcRoofMNFKm7tWyT1hVePQnynBAzdTrU87FAKoK5Uri15C30SiMB
	 OVfw7Cmz9zDHkJed2gGXBrR5WCdPhy266tPydPwLmjeirttO7+4K37BtE6POwNahse
	 J7L+zVFV3qPXhQ+7PPXt2IS/7I/qxi5FbAE/UvWI=
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
Subject: [PATCH 6.12 493/816] perf symbol: Add missing symsrc__destroy() for libbfd
Date: Wed, 25 Nov 2026 15:34:01 +0100
Message-ID: <20261125143900.602684622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index ef4594088684a..4de28911bdb52 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1916,7 +1916,7 @@ int dso__load(struct dso *dso, struct map *map)
 
 		if (bfdrc > 0) {
 			ret = 1;
-			break;
+			goto out_destroy;
 		}
 
 		if (!is_reg || sirc < 0)
@@ -1981,6 +1981,7 @@ int dso__load(struct dso *dso, struct map *map)
 			ret += nr_plt;
 	}
 
+out_destroy:
 	for (; ss_pos > 0; ss_pos--)
 		symsrc__destroy(&ss_[ss_pos - 1]);
 out_free:
-- 
2.53.0



