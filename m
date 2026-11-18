Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024420;
	b=aJRQIhVHTSuwIkq8LGjxgvDnfFFJ2O6c2yZfkvJapN9NWJ8FlNatcX62Xy9gAb1xiA7M
	 n03zOXNXYUcHxxDs4DcrDmN0MCha48lLNEqKxdxqPeSP9tAcRDk46VwbVHPEfEQq5e6av
	 LFGF4ujhSwGBbatGZj4t2eY0IOY+MQTgb2SVZmLbLKlXBK1WYbifni7+gNMOkX5EPj1P0
	 Dvs6cp90LV0PHzx/nWvp8DId5fNYlkkgPxBusZXJjflQnOm+uCAbP8xi2cJp5OVoHeV5L
	 3A9fyBiVGiOPbBoxeWSiiH67JUZpiuojUYi8leMJ8aSmnnILWWBFa5pMy0FRBeCKhFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HlOD7l/ddy/B47b4FDRANLSH1+TqICS1lX4eL5l/yFo=;
	b=zeWIU2mdWgyix1eJe/BMzkiDkRtKA8qfBIWi1XnpJPQ8Vt3hEgakml7BKUyHPv6gFUiJ
	 RxHruQpnh1LVhbgBFbRZKHFLAv4RNwpS0e9mJnQ13UdIj+0ABDhfXR9d8pKy5f4PlA/5v
	 0UBVokWpJisUMU1iRjcsKBeOX26W6XtOQnz5vfJWHpM0BRlcF0FTOiqAL9YzL/4b8zD6U
	 0vKAu2BGsUg4MPX11XVsRZr3vz5gR6rwyYMA7Zd9fpWYQ2FtYguppOh4OAqqd84i6jos1
	 D3BcVBo153pF/GVHfFKuykfEFJf/kjRywbrn/nP9FyooZYBHY3AUx9Dva1OJ0yBNFoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b+a0K0jX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59FE606A32A;
	Wed, 18 Nov 2026 17:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b+a0K0jX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474DF1F000C4;
	Wed, 18 Nov 2026 17:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024419;
	bh=HlOD7l/ddy/B47b4FDRANLSH1+TqICS1lX4eL5l/yFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+a0K0jXM9511hG18M5dDdHroxG5ltbKtdSZSaIUBiyM/IeOfgCkUUztWifZtkqK+
	 p+52P7309WsaviLl7fpSDuUZGDqOEvWbmulWWIB73wIS9TAe8frnHnB0iDzAWM30mG
	 bGFg6jWpC7pARWcsj5p4dOhf3EiCwcZ4kYAtj86Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Tengda Wu <wutengda@huaweicloud.com>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0719/2151] perf llvm: Fix memory leak of args->fileloc in symbol__disassemble_llvm()
Date: Wed, 18 Nov 2026 15:40:54 +0100
Message-ID: <20261118150148.113105378@linuxfoundation.org>
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

From: Tengda Wu <wutengda@huaweicloud.com>

[ Upstream commit fe529886843f451ad6da7e65d53325432e0f80fb ]

In symbol__disassemble_llvm(), after calling llvm_addr2line(), if the
subsequent disasm_line__new() fails, the code directly jumps to 'err'
without freeing args->fileloc, leading to a memory leak.

Fix this by explicitly calling free(args->fileloc) before jumping to the
error handling path when disasm_line__new() fails.

Fixes: 04885681788855bb ("perf annotate: LLVM-based disassembler")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Cc: Steinar H. Gunderson <sesse@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/llvm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/llvm.c b/tools/perf/util/llvm.c
index 4ada9a10bd93f..789bee98badfe 100644
--- a/tools/perf/util/llvm.c
+++ b/tools/perf/util/llvm.c
@@ -248,8 +248,10 @@ int symbol__disassemble_llvm(const char *filename, struct symbol *sym,
 			       (unsigned int *)&args->line_nr, false, NULL);
 
 		dl = disasm_line__new(args);
-		if (dl == NULL)
+		if (dl == NULL) {
+			free(args->fileloc);
 			goto err;
+		}
 
 		annotation_line__add(&dl->al, &notes->src->source);
 
-- 
2.53.0



