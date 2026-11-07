Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065022;
	b=daXdR5QBfg8axDKOCg1Nnh44v7DhvU4w1GkWBUVzSTbKrQf22uh2xIWk+lr81knsH++O
	 EZ6bKpO7lHfxz+FDnn/rgWOj9yh1j3YSlsdiak1upzbFG9yzZysGr+WyVhnV74CY748uw
	 Z9lfa05YVpHk/KWFP1rTwEmQaNmkT1LzFqKmgiqbHoB44NzJRQ4BPy1HXUlynNbJNOXZe
	 RwiIpZ2FTCYxDB/nRUlS84OoC5aPQTimX9sLsAqgXqLXrpjNyKUQ+C+9XKgn32Rc3PRP5
	 DOwJ7yyX14cHbrhQzNzCC+i0+Iek7YFuDO1ZfbrAWv3ObsR2wp8dJrahhwAsgrWsJ1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5iGiWgcmdPE1hOdrSvvYWXoLiHcE9vDyHE6fJzzf7lM=;
	b=ACqElmEcn7uoBiYugblOWWRD7qIvrNm4A/gehFCbZ2j39kxNdIxEki3dDXIgHlRvdGnA
	 oCcFPyVjGxWEI+//JMA2IVzH4aK1Dmp3APUVfT/xA5UMVpvQTLgVYM0a1oN64EwOm/B8d
	 asmITTGv4nEUTGNU7w9ztLd5WbIpAWWimHtMZhmV6se4c/HTJhWRNS90/HDSLv9DnDr5c
	 xnFvCXhJr1CuEoKb5ABQF1BIZquuFEhFlTeNW3Tm7evoOO8w/i0jzqEXybRPdOKmz6TZP
	 ku2fIt1jC3K6JVCUtgbuS4RMPqnVmotlC+UdUcZdJkcdJMT8r0e8xltsSwwwyDPQCtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=alawdWUx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFCD606A336;
	Sat,  7 Nov 2026 15:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=alawdWUx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA651F008A2;
	Sat,  7 Nov 2026 15:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065022;
	bh=5iGiWgcmdPE1hOdrSvvYWXoLiHcE9vDyHE6fJzzf7lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alawdWUxfJ0FO4g4cQq7d+NH2mEtGv4R0WhMmAJZN0+FH4HxZ/FTFihgqfaWxr4tc
	 ZnqwJI6FRVtFQ2SDVTEaydtM9XR5SIg8EcHOekoKoz/GbFJvIG71SMP1znPLfBxobc
	 kDe6VB6GGG0m/MVhkyxfQUC8cMW/D7KNVdnQfuks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0832/1257] cpufreq: loongson3: Make this driver depend on MACH_LOONGSON64
Date: Sat,  7 Nov 2026 08:52:08 -0500
Message-ID: <20261107135002.311783586@linuxfoundation.org>
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
index db83f3365698c..edc1299098d47 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -288,6 +288,7 @@ endif
 if LOONGARCH
 config LOONGSON3_CPUFREQ
 	tristate "Loongson3 CPUFreq Driver"
+	depends on MACH_LOONGSON64
 	help
 	  This option adds a CPUFreq driver for Loongson processors which
 	  support software configurable cpu frequency.
-- 
2.53.0



