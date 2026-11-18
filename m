Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038790;
	b=DACxwU/P5RuKN+PjYOIjO6pcLxWLdF9h2VqkJfE0SdKjwA0Fp4d2Dblh3F2DjvSebJnI
	 TlsjdQx+13PUlm2r8e5UcswiRyFCb48/iaOYrdzguzluhvwG7Bbfx2429KdOrCimI+U63
	 AR8N6xOvQpKPn8E150LL3iosYNSMe9uuxT8wKzy4gTDR6asZLKNCpP5H3ies48CT3LR7H
	 m9kvS/JgvVXmySJa4tMkpJhKscNq81FcTIa3Dg5PkTq/jiFXWIKPCT05FVFJL+dhsd3e3
	 dp2E7RNjacy8E/rV17XZ0F35YCVRVGDezbeFPJx99N9rqFKPrP5HpcIGcOsSkndhpLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pjmwdW5O+qlKiFIZ/XoR+2lbuFoC6kZxKWi30PG/wiQ=;
	b=wSYwLjmZW7eav8qLxeKsmg2cPNsBxI9tQ54lc3PltQ2UEDTG5BqQkPFX2R2pM/IAc/jR
	 3IaxaES3KtNcDi3XEK1+Bvl5y2pM+7nzuVpxnoHyM523UrfASASBX4ZDlTKmeHn6TXdbx
	 KO6cdAW+AaeZItXXA/NjtZLv6IhNxa300VX1fsnRusSJ4Bc0R4Vhogp78n2NSRu7txgt9
	 7mjHNGPy7+6mk4TtaZgeLLOK1fUkteQTl7/dF61VXFNpa/SkbrGRWs/+P4/Nk5Aa+pgn0
	 AHOEf35p3p5YrJ+oSBxnEBfezK+A2RphJBoFPTtwTntCEf1r5XnJVcf3VOIyMJ/tbJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YbPeghqS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47278606A320;
	Wed, 18 Nov 2026 21:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YbPeghqS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956FF1F000C4;
	Wed, 18 Nov 2026 21:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038790;
	bh=pjmwdW5O+qlKiFIZ/XoR+2lbuFoC6kZxKWi30PG/wiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbPeghqScWA0tH4L6PumIx/uw5A2VU/iVap9F7jhdF9oGQ/Sin3RG1Tshapj1dWbn
	 F2ej+yb9xaOG5W7HoXBndmGu75W8ofjeju+80Bvj555NPOvNKJ+JDtk6ZAg8EWaowr
	 r91dOU1s2JpegkRrU80wMjGhOz7yecr+Kh3J/u3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vernon Yang <yanglincheng@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1866/3318] selftests/mm: include kselftest.h in vm_util.h
Date: Wed, 18 Nov 2026 15:41:28 +0100
Message-ID: <20261118150417.914082839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vernon Yang <yanglincheng@kylinos.cn>

commit d8a866c766ebe34b4371d42f4a3edca200f5e645 upstream.

The 6.6.y backport of commit fdc3bc349794 ("ksm_tests: skip hugepage
test when Transparent Hugepages are disabled"), added a KSFT_SKIP return
to khugepaged.c, but the prerequisite include from upstream commit
d8a866c766eb ("selftests/mm: add commentary about 9pfs bugs") was not
backported.

As a result, the selftests/mm build fails:

  khugepaged.c:1195:24: error: ‘KSFT_SKIP’ undeclared (first use in this function)

Add the missing include, only the vm_util.h hunk of commit d8a866c766eb
("selftests/mm: add commentary about 9pfs bugs") is needed here.

The remaining hunks depend on commit 32b42970e861 ("selftests/mm: skip
gup_longterm tests on weird filesystems") and commit 571a4b62ed63
("selftests/mm: skip map_populate on weird filesystems"), which are not
present in this tree, so we don't need to backport the remaining hunks.

Fixes: 6b117e23481d ("ksm_tests: skip hugepage test when Transparent Hugepages are disabled")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/vm_util.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 9816d6e9bce6c..f14ebc8095854 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -5,6 +5,7 @@
 #include <err.h>
 #include <strings.h> /* ffsl() */
 #include <unistd.h> /* _SC_PAGESIZE */
+#include "../kselftest.h"
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
 #define PM_SOFT_DIRTY                 BIT_ULL(55)
-- 
2.53.0



