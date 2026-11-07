Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063499;
	b=nns2vuCDRas9MyF2sbGPHl+lPZ+v0pSmpDvEYnVMdBtRW7ewuHdSBqA7THqtf7yFnBiP
	 byDc6rNG+VAkhqcC6dSm4lC5ttT16AFJx1Z0hEWdxburk+9HmKoSEqkGXs2kidF7tVIsL
	 vlUQL7fk8dGw5B6Px5UN7dp+qRBX+8Ve1m8zzTzyt3n1FEdla2i3hgGEKaUh8QA0nFCzs
	 EojOvOTS9nHaPjeSVd5KLv2WkvYlqxu7+5KQAr+H4ekSHAmjR4QfRlQGDAJOjU9Ml9emk
	 2fINCeTMJEBRFcmXaYO7Ov6n47uW3xzL9yE7SM9m+F3Nr+i3cmB17G3ksqusthaiDBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fcK28k6XMOLw3f2tvSNdx8kJ8lfV0+6F9T2fPc4szGw=;
	b=bISXsAq5Jvjjj1qWLD217uekLkBSG9aLeNwHDwdLahR8ASqHNnpevsZOLd9SjhCc9nOJ
	 Zt413gfcqTztVmzun8kqsj7OlvsGMZu/fdnYv7w/1B9t85A/mGFOzpG0259J7GhM4ckJw
	 Bi7Cue5SCMs0tMLkvlCGkkOUBlKpb2x2Zbtfcre9cc9Qzh+F72GWRDM/j3SoIgy6DcY7B
	 nRoW9rphhiJ6O/XKeTc4ub9ioMv89g34N16GIDo3ocUU5F8gJt96Xsk4glw7ZxfoiuMe2
	 /kPvowgYrptkJRcalIyUEfyXlRATbJYrsUMmm5CPCpVW6sVgjgKvO65r1NWsFrNbSTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wkQO6a5R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1542F606A339;
	Sat,  7 Nov 2026 14:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wkQO6a5R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26861F008A3;
	Sat,  7 Nov 2026 14:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063498;
	bh=fcK28k6XMOLw3f2tvSNdx8kJ8lfV0+6F9T2fPc4szGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkQO6a5RKVCKJorA1bCGPO981QGnGYHNrglxQ9yUGFFv93ZBCpUJTZgCZkIgEwmp4
	 ZWC3ydaG2Nbs7jR/JDpWNtxlVXP5X1B2AfKcVFB9m9ig7+prW5NT9tbYTWbVbfCfZs
	 8vZJ1q4H4xStrzslCImJ7aMWoAi0H3uyiwn9g93M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 606/869] cpufreq: loongson3: Make this driver depend on MACH_LOONGSON64
Date: Sat,  7 Nov 2026 08:54:48 -0500
Message-ID: <20261107134913.652130398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 78702a08364f3..73c1b62c1b37b 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -289,6 +289,7 @@ endif
 if LOONGARCH
 config LOONGSON3_CPUFREQ
 	tristate "Loongson3 CPUFreq Driver"
+	depends on MACH_LOONGSON64
 	help
 	  This option adds a CPUFreq driver for Loongson processors which
 	  support software configurable cpu frequency.
-- 
2.53.0



