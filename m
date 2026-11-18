Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037709;
	b=cNLKfKb5m/yl4iG9gsK5ntPXMu7TwgY+RSfPAxQVROIhIi+aMamXIs5dCeP7ln7kU1an
	 Dd4Id+fp2iVtZ3636zPkTEOSInu/wq3u7qHFxL4HFEGvS2kHIgYQ9HMUG6/m830hfuM/z
	 IhcI8TkMur+w8CgVwepJUlVbM2Hw7KeBk0hU2jNH9DPa1om//BUzNkPnUnK/L/Ss1fRiR
	 ex0PLSZsUJQwUdlVa3IMSQaczorNPA1oNiyxi1dDqLWrB+BRilOwrUxRhbgzIfSRBOLz4
	 vqm6VC77p07JfkJKhE2ZIfqiu0R8lFgSMPnis+BYWqU4XALveKDb/q6TeG1BLQ2LiFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=upF7RsjQMSj2TBwazlbX0XN5E9Fe6bi7auJFSEb00XY=;
	b=H+gp6pDUj16CNwJ/8YooF0clqfiujXn8ge2QFoIKiqSk6oDlhVhI9dS1+HCmEmRvIiz5
	 LLb7R8rbkRXNZIyYIa4DGJSvcaG2jEbujKvEI60Xnf7ZJCKQEm+L1H2skXXzwQU6mXT2+
	 ZBJo50a73M7TLFLhu6mhCR8CS/GGCO5gawX5e+nwuxeP4L8kqee1ylOAX4ShWYpypvYOF
	 WX+dUg5DPtAyGjIgcIimTJRL0HnozllaA4/ItSNp8JSK43srZtxCO5j3n2RiHlhMr2XX0
	 tvlyDjrTr3FjoI3nRvK2SlnrIFFvNXwa9QaFkIGwuDw5mcEPdczVTZ32Dahwp4qWT0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nTaXmCEx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7617606A320;
	Wed, 18 Nov 2026 21:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nTaXmCEx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B63F1F000C4;
	Wed, 18 Nov 2026 21:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037709;
	bh=upF7RsjQMSj2TBwazlbX0XN5E9Fe6bi7auJFSEb00XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTaXmCEx6aFHXlWvlAqarM1oUnLmuQ2pQ2PZfpigTyyWr4AOrOfp1YU//HrQtRHqq
	 oPmVAgJeuC+zfh3K7pynVaGE2dhizRZNh8ZtSfPKdYeWdIYx1MHjNcYpaJpGkEFnjT
	 ABHlo0XY8YSkP6SYUfNkr6sa9W46XAHBuRlASNdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naman Jain <namjain@linux.microsoft.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Roman Kisel <vdso@mailbox.org>,
	Hardik Garg <hargar@linux.microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1492/3318] x86/init: Initialize wall clock in get_rtc_noop()
Date: Wed, 18 Nov 2026 15:35:14 +0100
Message-ID: <20261118150405.664889661@linuxfoundation.org>
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

From: Naman Jain <namjain@linux.microsoft.com>

[ Upstream commit 7d5af1f256fdecff6a7986bbc9146b69cb355bb5 ]

get_rtc_noop() is used when an RTC is unavailable, but leaves its output
argument untouched. When CONFIG_INIT_STACK_ALL_ZERO is not enabled,
timekeeping_init() may therefore receive a nonzero invalid persistent
clock value and warn:

  "Persistent clock returned invalid value"

Initialize the output to zero, the documented representation of an
unsupported persistent clock.

Fixes: c311ed6183f4 ("x86/init: Allow DT configured systems to disable RTC at boot time")
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Roman Kisel <vdso@mailbox.org>
Reviewed-by: Hardik Garg <hargar@linux.microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260831082528.1623843-1-namjain@linux.microsoft.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/x86_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 268627a17cf0d..aaef9fd1b9040 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -36,7 +36,7 @@ static void iommu_shutdown_noop(void) { }
 bool __init bool_x86_init_noop(void) { return false; }
 void x86_op_int_noop(int cpu) { }
 int set_rtc_noop(const struct timespec64 *now) { return -EINVAL; }
-void get_rtc_noop(struct timespec64 *now) { }
+void get_rtc_noop(struct timespec64 *now) { *now = (struct timespec64){0}; }
 
 static __initconst const struct of_device_id of_cmos_match[] = {
 	{ .compatible = "motorola,mc146818" },
-- 
2.53.0



