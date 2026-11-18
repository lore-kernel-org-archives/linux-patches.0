Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053866;
	b=J88LvgsqG/Jo1ivqwGN86UEfvFq3wsiKMpYfLKL/osXkxTx1MsV/R6l8cpr/fI3fiH5j
	 M+7MsRI3ggPVaq0rveog2vrAgo4rGWQni7yfJfqeE6GhmdXND1Xg2d7OjgtjisoyE9Uh3
	 U0VkQ2Zt49id3fWEZCIoAOEeO1nIr+vKQ9JrMbuZREoE/tkhTYbGBqiNvwHqeBDLHetja
	 FAqC5r4huoaql9BZB3gAg3BCAvmGPMgwjZxUrUpHHg/IFmE90MRNPEJVrbW3bIESEhUB6
	 T7geEiAqaZyKe8vHBKam32kyrUjPdjjouFrHNDMGIJ5SPZy7ynnsq/9HwJvGM9BlJLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oLeahPxMmDiIj19aDGMZxS8k+q5K3+bMEdw94z1RXVY=;
	b=nDCEH8s8CrjcWTBnOVY9a5UK56OPkE+5eyhgIUzyqL3/NQW7V609DXtR5Reuig8QQ0Ft
	 ffVeWQEk9B4VZ9ECS3srDtrUumhdREPqCZjjpelNdUsqN7PISBrdHUG2NyWvQCibUIOtj
	 Dc+tHVyqeYBd2HuFKGsTUkW4qVaoYD6OgiY11hEszCIx745LptbxPsPej9La1g2n3qsTP
	 3pxAfe52uDlq6JiPHAiXqVSUpwZxT7nRLNvfGty4fD+F91ghI0AWIyf/W15DB9hjyjJU8
	 aLRWqO3whi5OP3l2ULRbdH8BnBhhEbwOoTe6e0RgYzBfyqjAuBraIn6bMatIjoP2cpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TlXdj9UE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CD1606A31C;
	Thu, 19 Nov 2026 02:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TlXdj9UE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7FB1F000C5;
	Thu, 19 Nov 2026 02:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053866;
	bh=oLeahPxMmDiIj19aDGMZxS8k+q5K3+bMEdw94z1RXVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TlXdj9UE/04C0pD314e7P42N4kBvXHa0F/fAw9deGAGjVNriZhytcUClQXSE8hkRh
	 iKcTJzBteNzNw9EumUsdgiElQDb7wfC6yPPgdoumDJq1nzMebaAnSHHMmCg+7UXNIt
	 3Qg47DXjwdwe9aRO3NDYFk3ereBCH8hQF+4rcQpI=
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
Subject: [PATCH 5.15 1030/2214] x86/init: Initialize wall clock in get_rtc_noop()
Date: Wed, 18 Nov 2026 15:45:06 +0100
Message-ID: <20261118150053.530177239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d3e3b16ea9cf3..ef8c7f975f7ad 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -33,7 +33,7 @@ static void iommu_shutdown_noop(void) { }
 bool __init bool_x86_init_noop(void) { return false; }
 void x86_op_int_noop(int cpu) { }
 static int set_rtc_noop(const struct timespec64 *now) { return -EINVAL; }
-static void get_rtc_noop(struct timespec64 *now) { }
+static void get_rtc_noop(struct timespec64 *now) { *now = (struct timespec64){0}; }
 
 static __initconst const struct of_device_id of_cmos_match[] = {
 	{ .compatible = "motorola,mc146818" },
-- 
2.53.0



