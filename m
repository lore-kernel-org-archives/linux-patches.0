Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064290;
	b=Jr5pz4gRWLlKNTfo+t2SJREuEyP5kXjDovq73NvlRfrAGGNy3rL2to3pLLYQny4THjUN
	 lv5UP0ebN+d5qZACLVXnXWCnTvd0X6SF/gQwJqKqoeqwS56Ai9dDqXoQD47xAQhKtA2jA
	 Y1P9xMvD5pBDjwHUsSrHYZTrzK53R8iqHyhQU6dS/XHshkBSML+TS5aNZlrxWcf0/5Wpp
	 ICk+39TCyfG1mccsNiNAdzy/63r1DN+h8VMpS1eTqtnPYuDYZoIiF8ZhSA12ustRTLIRq
	 +c3VBSFtjhTzRCqelnc/ZdxiEnsAYsmaoCyNHLutzzD6Cbsq1h2jetXUlFkce6BFO7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mky9UJJYXJ3iwsIdJtNk3aVWbwQKdHfz/Zt7vKC9/IA=;
	b=2FIMicndefTDyiUHYIy9KRm/IwJQgxUmYEBFUbITJ1IifTsWy7jB2cN3Ef1AVp8TiMMH
	 eJp0+pg8aqa3l+Iyq3R5W9L1/ZqTGLm0JFdZZeANNIbneczNh+5ZMSlczoXIIe0hHy2oo
	 p8RyPUK3YIZcvr4iQixO1mzzZ6sofetIEfvpr9O3cZeioh+LC0yigz3Xe3lo2/NDUY3DR
	 ECZwnbSPKmDAzPdWtySecwhTuqbKVtT+gjDQjYjCQXiwu91s9akSfPF/beatPySWSXrOr
	 JXQNX2yKofx760c97zJLLDablOiwuMqBPkbX3eqYW0NFsHiHRZX4+NyTLa8rhQl9T4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trF6ZGj+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51691606A9E6;
	Sat,  7 Nov 2026 15:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trF6ZGj+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D451F0089F;
	Sat,  7 Nov 2026 15:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064290;
	bh=Mky9UJJYXJ3iwsIdJtNk3aVWbwQKdHfz/Zt7vKC9/IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trF6ZGj+/ZAwNZ1qwBl6Lav4Prz2p0KGNYDhzL/HflCrnhg8bm3ICmdkQkLmScaRH
	 mr3SJkf2XXCiBrkSPnFK6A7r1DEJ7VSJrnwB3xCLx0DYnUEEDAI6A0EGNfteizMeNu
	 wvF5ptI2BPARRotA8ggLsnduwsxnsnTz2heB0sgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0377/1257] pseries/plpks: fix error code for wrapping key reads
Date: Sat,  7 Nov 2026 08:44:33 -0500
Message-ID: <20261107134949.964368459@linuxfoundation.org>
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

From: Srish Srinivasan <ssrish@linux.ibm.com>

[ Upstream commit 0d0eafedcaf4939819d38ede6ad355ea37acd978 ]

PLPKS variables with the PLPKS_WRAPPINGKEY policy bit set are not
readable. Return -EPERM instead of -EINVAL in this case to better
reflect the access restriction being enforced.

Fixes: 133aa79e211d ("pseries/plpks: add HCALLs for PowerVM Key Wrapping Module")
Cc: stable@vger.kernel.org # 7.0
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-3-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 7e56b3dcacbc7..ccf5765a907bf 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -829,7 +829,7 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 		return -EINVAL;
 
 	if (var->policy & PLPKS_WRAPPINGKEY)
-		return -EINVAL;
+		return -EPERM;
 
 	auth = construct_auth(consumer);
 	if (IS_ERR(auth))
-- 
2.53.0



