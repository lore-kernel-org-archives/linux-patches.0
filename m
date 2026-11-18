Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048165;
	b=L0kZoi4ZMV/DCwAWBGJtEy1vqNCPLM01aIgqZYTyu2j1IbBHZvgsGNQaYmlb0xRD1xxz
	 zDOJggcWXkBDZKBuxAQQZ9emfcGa1vo/VjJfdrFon/IqyBNov7C4zK5OLlmdwnso8+CBu
	 uHUq2Z3sesFasHrgYCh1i1t+wfXGQS7Ay7h/b8QrenK1duNauzCIfHCmzxm9o/ywT76hl
	 +f94KXZLFarwLrK4cr2V6bCHpws7QEAB6NX+ltg/iSCFxs1E+ZO3CxkURHCKWvIars8gK
	 PnY1ASqYonGq/EY3qz0+zS+la2kOU7OcmdFLCKxTXR1pAVKzBYB7Egig7KNeIhFGGLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sGwUoWQhzfbUDn798c/MIFta5lgfEb5WQcpsewndRcI=;
	b=okM+QmpIo14ovuqkkHe6hujD/O/qOqkE11TsuXAsp44fngbedz4byLwr/ZwA0QYx/KUG
	 QMASgGewHrbvhhVG/NqK+88LyuKOXohSwNUWsSbWTF7ksnZsjjXgYJatfpJwkeGuOaGpr
	 nz4EUpOBzK8/ZRY2VWrXDatCj7ykefIhcq+3QyA0CoD6tIN33GMnCL1GF0H041buL1WnI
	 JQOPD14EOZsHU2C3+hSpB28rsZISHRrblVvLsaGnemHYF8Kvf1Rm6qTcRv/+O5uQTOHC3
	 wPCdqFL5PWui2gWWuDzatySqIfZRDWtKptUFICoMkZPcHhhQSFkyw5IdP+4G5WdCQtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SrZ47kr8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B00606A32F;
	Thu, 19 Nov 2026 00:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SrZ47kr8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB991F000C4;
	Thu, 19 Nov 2026 00:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048165;
	bh=sGwUoWQhzfbUDn798c/MIFta5lgfEb5WQcpsewndRcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SrZ47kr8kpuu5e5+K2rzsldGtGUtA1mqrDcKP5ekRkL2L+v6NEcDD1lOMTrH3o6Yi
	 11ijiMpDnyK4/rjRmGYM1L9WwV2Ox7dpl7IPppT+N7G/qG08oHViDw4mxNK5EVGYGQ
	 uwFijU7BQcETVL600ck4eLA+oCaXX7gvWMb3rCGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1896/2857] memory: exynos5422-dmc: handle clock enable failures
Date: Wed, 18 Nov 2026 15:48:50 +0100
Message-ID: <20261118150309.502590099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c491cd549644f..85c05c9c75332 100644
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



