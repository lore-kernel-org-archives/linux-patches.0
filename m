Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016067;
	b=UVP6KgtmxKzv6Ou9RR4ViQPJ/V+Z+eTABdJe5v1PiKuK25HW6SCp7fwMAVb0/Zg9Wtfj
	 1yhsNcV5LO+4ci4t+6AzUVD9rc5c09QPuNeQ/mzx8Edb01C1PvwSYK3nisEzbBmtGK/6V
	 S21DSRgK4dKzCZtQzXIhso7Y/TRn+0LlKXo0QYoOyRC0RdJ4GzvoFCcmXF6ZnpA/52Ufi
	 p/xlccnDZRqE2CAa/UbFD6ktm4iv97rf16nvdspEafjH0kwCBVfRDiW1lPgkri7CGfsOa
	 qMeTZaoI+6W1L4Cap5F1YauWrYpPVqc60SMTXxp5LD4Cgq7Ven3Ng/FleZTSMxIFMFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jjLwEZJsMB2BW5kndrkc1+EtlN4ZiqI3LRDbRn4ycp0=;
	b=B+jZKgREk9TFS+AObG88YZ2P5IgeWPrRZc+59222JdJWuvzT9zOzjOyFPOeC24XiIX2G
	 1RymOCsSpVHgwe6L9hskQTKGyPq/J3Pj7acQzaHqKZJDWtL2vjRE9B2KGTtWTT5wTGHXX
	 xJTi7BWdOI8ljwzo7cuqXw2XoUwffJTKKdZLTY2oA/yR28jy/WF7pUfusCKTkJOt5HFr5
	 MMYjW2JDFKJO8HDvWMC7aN5igHs0L66VigzvmDT+gzB3TRkhifOOCb0fJVWOnUrVyyiZ6
	 T/SlkfUzaPlVUeF2dWMEn8M2pswiJCxcULxaKAiXK/oVxKgitgIJKmnVNvLR1TvYHrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RfG/fyz4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A981606A32A;
	Wed, 18 Nov 2026 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RfG/fyz4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6151F000C4;
	Wed, 18 Nov 2026 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016067;
	bh=jjLwEZJsMB2BW5kndrkc1+EtlN4ZiqI3LRDbRn4ycp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RfG/fyz4/NA2G2cLyvTPmLOqHKh3pTtRNWp98XT7P//SvBqZAocMvq3wqJIYUp28g
	 fQdmOTSovsHXPqFIF+9tBdFa7dJ+/iDXSmc9nO47cq3yyIkSph4rr54B+hwsQqiSuB
	 jafwzH2ZWRo8gOvITf68dG8uWac4C3BYJyL8Y7Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0398/2651] memory: exynos5422-dmc: handle clock enable failures
Date: Wed, 18 Nov 2026 15:27:18 +0100
Message-ID: <20261118150302.168050233@linuxfoundation.org>
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
index 788d49c688b1d..98c3195525831 100644
--- a/drivers/memory/samsung/exynos5422-dmc.c
+++ b/drivers/memory/samsung/exynos5422-dmc.c
@@ -1297,8 +1297,15 @@ static int exynos5_dmc_init_clks(struct exynos5_dmc *dmc)
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



