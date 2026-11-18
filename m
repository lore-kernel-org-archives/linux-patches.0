Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039640;
	b=cMj6/mhsuz2RaISQxHo1EC3SLF2eg/N3axYq36gJbdEUWpIcn1jKB4dZb8b4/hhvo3GP
	 Vy7/HE/opQkzX3NY6SudEc3CdLBdE2rx0BiI6gGehnTD9JpczSIXN/wIJGRkUlZm/Qu1g
	 OHREiHRFsQMka+/N+6pzS7FTmz0RJSzII2i3FArmEKw8qBT2fvGg3t5p0cGGVBNSJ4U7A
	 D9TdBO8CUyw2a1UhWgYGGKA1iAUPc0NtkrJqhsSLtWZshYeDpbu577jAHKAohpG34KLEA
	 QJMc9Ka4I8U1s7nGGbbKDOBjHnosKDPb88c8KivSB/EL7XWljV8eVig67a/mvxu8GbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ahwViLPCqL3zWKSs/UaSr+A2dP5HyU+A5T6oMYx8EVw=;
	b=XKaAZWe1modajo+2UVu4XRtozITmZHBD9CeZ08pKRZMHs/OjjCYMJEXBZLNOEBX0C3zK
	 Qr9EjkwSyQR4yLKE5t+tbIIUmHme9x3RwxApdFi+VpAiDxtQUYhKrwpMo3w45BF+G7XEw
	 V53dan45Rvln/WrXRXRIR1O1Ll/bZ0sUL2YU8sJI4LFBzoRH5fX601RU1ThWf8Kg6zq1I
	 F7BnpKqQtnKlUtBqPfiubv2GKZsJmPhZrVNQWhCIoC0Lnw6HLeelRNOc8Iuq9aiAE8sxf
	 vDyVUhGWaNhN4TZnA50lIZ1NqoReoyi532l0sCZ9e/Wv06djerVfsx3AO18bxVveKqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALAnGOU7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CD3606A31C;
	Wed, 18 Nov 2026 22:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALAnGOU7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586E71F000C4;
	Wed, 18 Nov 2026 22:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039640;
	bh=ahwViLPCqL3zWKSs/UaSr+A2dP5HyU+A5T6oMYx8EVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALAnGOU7jp7LKquk3GDD95DavRQVnPubvnFu1DayXADxa1Fls6pbiwTmspLWfgZmY
	 4gWTtUTLmxlBol81Z93V9ha8Bc0mJ23sbbcnOo+uS0EEmEqyNE4/RqELXVQY7MXAJZ
	 BUhDb2/26iDzX9bfn+cMx+Icpfm77qR4K3lpvGos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2171/3318] memory: exynos5422-dmc: handle clock enable failures
Date: Wed, 18 Nov 2026 15:46:33 +0100
Message-ID: <20261118150427.117505992@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit cce46902ea9fcd585cd200fffa3166f63bc571f1 ]

Check the return values of clk_prepare_enable() for fout_bpll and
mout_bpll.

If enabling fout_bpll fails, propagate the error. If enabling mout_bpll
fails, disable fout_bpll before returning. This keeps the clock enable
count balanced on probe error paths.

Fixes: 6e7674c3c6df ("memory: Add DMC driver for Exynos5422")
Signed-off-by: Jiawen Liu <1298662399@qq.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/tencent_B0189529F550458590E3BA614EAB800FBF08@qq.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/samsung/exynos5422-dmc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/samsung/exynos5422-dmc.c b/drivers/memory/samsung/exynos5422-dmc.c
index 6d019dbd721c5..1726186fe73ac 100644
--- a/drivers/memory/samsung/exynos5422-dmc.c
+++ b/drivers/memory/samsung/exynos5422-dmc.c
@@ -1304,8 +1304,15 @@ static int exynos5_dmc_init_clks(struct exynos5_dmc *dmc)
 	if (ret)
 		return ret;
 
-	clk_prepare_enable(dmc->fout_bpll);
-	clk_prepare_enable(dmc->mout_bpll);
+	ret = clk_prepare_enable(dmc->fout_bpll);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(dmc->mout_bpll);
+	if (ret) {
+		clk_disable_unprepare(dmc->fout_bpll);
+		return ret;
+	}
 
 	/*
 	 * Some bootloaders do not set clock routes correctly.
-- 
2.53.0



