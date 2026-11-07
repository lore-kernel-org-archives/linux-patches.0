Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062415;
	b=T0sG/JXyuj/kQOTEZTvwjnrTI6X431VvsbNE6Kq+Yj7S1cUSEPDLbNvg4aJzfpH/CP8k
	 hr1A19f7b+ijyRq+sXWOnvfcvLurV5PpHiqFIG0DthX5NwWxck4HLQMcxG0MDWq75v2TK
	 xRS/8+2qyRlQ35qjgOmV/BItlv4/EyESwsFlOSJi5ZZmU4l/MnXIJqnO63q2Rlx+MX+5N
	 k5HqnOPnwAEU4xphGimMCDDPtGuXMhmrhkBm99uyy2ahRdVWhQQIuycAC7PkSoueSgaPl
	 1HCg2X5dV37Vuum4Cp6MqR/PJJXxAj0zF08ZJ7a5rDKmlk1cDXru+vEsqrUbZXzro4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uHHdqkieW6sGG9exIU2irx1t8BDJoWW8ZIOq/dBn+ew=;
	b=yRnIxeVqeKxIUaza7y8GFW+5VI14CxQUnbzWNTo/YLylsChewlf3UljVNKqHLdOcZVl0
	 PMx2Q5JouoKsLGocTGOL+EdbMRti/E3UM1U7lyZ89UwusuG2rZRgcR0UXkAt6wcfHNj1T
	 W0fBK66YLBPGdQxl6X1h1n+OqLMsyZgyEx+BEpR49JrBJftAWKs9mJoolQEJ3JifDjMTu
	 brxlQ5DL/MCVEMzRqeVkwzP4QH/Wn7i2mbnsn+zgS2JnR6wvdg6pYCWPiyp6i13GrkFdi
	 6MO7JJXnSZdgq70Iln0e/KacJPXZ9Qo7SNWOUCSaeYWiSt40fgaAbS5ZaLe7SiBLN7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEVZouaI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D09C606A33C;
	Sat,  7 Nov 2026 14:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEVZouaI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A911F0089F;
	Sat,  7 Nov 2026 14:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062415;
	bh=uHHdqkieW6sGG9exIU2irx1t8BDJoWW8ZIOq/dBn+ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEVZouaIvHxA/4w2Od/N/cf6gic9OXJ1bW+7hCbQy8wSOOZABmIUS1MGdT31rQjXl
	 pQjiIIgwK+Jxbxj0OlHPBhd0Hh++SPJcbwpKDFb0EX7gw5YaiRBO3mSVYEzy8p7Hzl
	 4MnBHCcwEEgwSxj/TXS8/iLKt8hCReyM9yVnkzN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1331/1536] cpufreq: loongson3: Make this driver depend on MACH_LOONGSON64
Date: Sat,  7 Nov 2026 08:55:47 -0500
Message-ID: <20261107135035.202427545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 48a82a3f44576a1b227f964fdb150e1cae7455bf ]

32BIT Loongson machines don't have SMC and FreqCtrl registers, so make
this driver depend on MACH_LOONGSON64 (only for LoongArch based 64bit
machines currently).

Cc: stable@vger.kernel.org
Fixes: ccf51454145b ("cpufreq: Add Loongson-3 CPUFreq driver support")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index f089a1b9c0c98..42cb32e928a62 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -263,6 +263,7 @@ endif
 if LOONGARCH
 config LOONGSON3_CPUFREQ
 	tristate "Loongson3 CPUFreq Driver"
+	depends on MACH_LOONGSON64
 	help
 	  This option adds a CPUFreq driver for Loongson processors which
 	  support software configurable cpu frequency.
-- 
2.53.0



