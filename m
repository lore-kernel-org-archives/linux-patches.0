Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059491;
	b=OaKu4AtNWKfPoeJz195O4qYsKDwp6J08drrssvVLHcZAsl/D+sSq6zBrNusftyxf0SrH
	 jyx4MQsrkpj2/IGTg3a/8S/YKE0BVDJETi9h3EIQO+0HR5DkRQn9uDrhtGMCdiad1ibdL
	 0JO/o3+SoZJebvODG3gFeTOu3cx6mTFTa3IqfQVTtREjiNXT2uqQRdlUOndJOCxDSD/xl
	 QfMy8yooO7eiM8PHSAhsyAMohMosxQejdDTw2TUGdm7v8aAglLMSkUqWN0PFC6Mz3GF24
	 QppGnvCXdKyEdosR7qNkqmnzPp6Q2NTJdqvVa6Sc1ITQOb3KkgOj0IUThoi6wGljttA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LjL3sAkfgiP9nzzG8e73lGK0a7YTTGlbel3iE5fcgLs=;
	b=tF+OKCkjkhJXIga+iFqQjDITfgaYDfVgcI0a4AvOD0DRbcuJt78buPi0Lmvtt/On8v1Q
	 XDw59qPt04T9jA8WWWqg0ivPRKA6LclUS/cPuvcazOo6VBDyA32lgq917ul7rsBW0PI2O
	 Hy0V9VNV62pWJjvMZ0HrbiSiC02RLcH7XXUfFTRiJ4wtTYcmUhQ8v4970X5vOMr24kjvk
	 uzRdSQ9odEW1gmV6atY2wLQYexwo6qU9LhPjX/Vdl5ljQSIyycnRS3K22X+K2UZO0+GjD
	 nY2FLQSxiuRCKAGqq4igWVqecViACyGqJD17LlEV10hGgxnVJe2LtxFbsryOQfR0TRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GWdT/V5s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D349B606A320;
	Thu, 19 Nov 2026 03:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWdT/V5s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E65A1F000C4;
	Thu, 19 Nov 2026 03:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059491;
	bh=LjL3sAkfgiP9nzzG8e73lGK0a7YTTGlbel3iE5fcgLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWdT/V5s1QVF/HeDr31kjdeZdVFJ1uO3GnL3rqJIMMX3fxKAj3hO37kQL/wpn9AQJ
	 bpO7ANwsvdi86cB3wF6x5d0M9XW5cyKS/oAmC6IYVBxeUC+8zcdQ6WKghmvSXXF1+P
	 8EBW6e849hdO2zs69c+02hsGXXNJli4RZVkNnmt0=
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
Subject: [PATCH 5.10 0861/1848] x86/init: Initialize wall clock in get_rtc_noop()
Date: Wed, 18 Nov 2026 15:48:19 +0100
Message-ID: <20261118145952.545994343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b758eeea6090b..9b78fb832d9c7 100644
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



