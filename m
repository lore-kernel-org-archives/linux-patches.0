Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026541;
	b=Vzl2WI/mwCkxhTWwIp16iEimuSLP9LUTePEqKNraj3u3b4/a9OSXB9A44PUgdyBwWjJk
	 KBjA7/xDg+47KETRJQ72ofkildLf/+ELiAEcUHHR1KvtrByxBF8775tO3Ekn2/CG25yhS
	 jVN+c6xBHLKozchAlrD6GkoFnyzDzqdugU6yTbWGF6x/YeHLGBJCwincLeXMIiNpMs1z1
	 S4TAhkt6FDkIf+sPAAXvxU8Uff8Wd1YXF99uTP4SmYRG7G1uwXv43jkMs1WiyhJuLD9HW
	 qbNTDiHp0NYnx3dAnOu4LwQ7VCLh5BuihwCXySeB3vXEuEzqGu2xlYJvFTryunp11Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zDND3nURgE0Yze0VS0N3FNzcTpd5UM6LEnWBsn4qzKo=;
	b=v0TpdTAoLM5SnSvqFd3S45Yn+CEq+cUNNZYPb6i8n9v2VHaW3AC6QCWdatdNUAvPucyM
	 ZUGIaUHZ5idDjMi+fJXNQN5/mw8Fcyoa8kkJTXpU/Vc/w6zby+a1lilAWrEojJl34clL1
	 /E9swh6vqo7Q4uczHmdxc2154wp+7U84vfwDH7EhVxSzG05/WMqjkcpTxbkO/hs0XZz1T
	 P7meLdYFa2N49+MbOtD1dOFUgrexD8Q1psqivjhW1i+CecBeraNt5y2wov7EDXRCUbcMX
	 Iv0ODJFRRWVfIqxKZS9bf4y1qJh6vrUFXsDSbWK4x5DTi4uJXXqZgfVx+uah8ImTutQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2qBCw9SH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364D2606A31C;
	Wed, 18 Nov 2026 18:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2qBCw9SH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951C21F000C4;
	Wed, 18 Nov 2026 18:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026541;
	bh=zDND3nURgE0Yze0VS0N3FNzcTpd5UM6LEnWBsn4qzKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2qBCw9SHQING7896o94D63rdY5ptfMrnOsW4KCwKyzx8A1XUXuy4vH8gqde3+typQ
	 g+pWZ4M0AUEcjLS2jwiQK7gRiQ1ywj4eV8SS2ec+8zBPnDwHkAwhkAMOdM5QYM9G81
	 u6Gbh08THiql1KGRIEFIVwESeIKw09gXs93j8pKw=
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
Subject: [PATCH 6.18 1465/2151] perf symbol: Add missing symsrc__destroy() for libbfd
Date: Wed, 18 Nov 2026 15:53:20 +0100
Message-ID: <20261118150215.265912644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 756b318bf6290..b7c854b2d43a3 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1813,7 +1813,7 @@ int dso__load(struct dso *dso, struct map *map)
 
 		if (bfdrc > 0) {
 			ret = 1;
-			break;
+			goto out_destroy;
 		}
 
 		if (!is_reg || sirc < 0)
@@ -1878,6 +1878,7 @@ int dso__load(struct dso *dso, struct map *map)
 			ret += nr_plt;
 	}
 
+out_destroy:
 	for (; ss_pos > 0; ss_pos--)
 		symsrc__destroy(&ss_[ss_pos - 1]);
 out_free:
-- 
2.53.0



