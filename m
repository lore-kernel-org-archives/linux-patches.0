Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590360;
	b=N+dlfL9NP0kXlS+xW1lpqE11L1z+ZRdKRnOMyER1xJowuXOzB/XH0RJjad8QfnFn2ZOK
	 ok2mzmtS/arwMJSed09hZfKWNmYd2RooG7VOEqGbrAjnY6GzfZm7gcbXhtiiUKn7INwnd
	 7tgjzTWJRTZu3/+NW56ctyNHaaJPkg2Ti3l5O0SxjhDTwHfmAZyDcKUn+fCrz+afKhiaO
	 jkVX4/pHXPe7gQ5roiMDc6v2fBrvXl6Fgah7R+sR57gAYIh5yOGMULaFn8xhrn9dE7U3v
	 u1gKMJKfoGWFK8v/Qi3nMCG5wo+wTIvJAHhw4P2XWby9hdAJYphgvhRtqvJpZ/8yfdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0UKxFD5/UJDqLY7Aj/+YpL07lw7OeNZYyVZeXyM139U=;
	b=U+cNFU6dMGwm4ZTE5/0hDLy/jlEA925ldZpUD+WV8jfSdGl6/FFN1VeSsxkn+f2zlhvP
	 gXv2cw5L+c1uix7JQ7IJkxrl8ACOvneyC65yyCx20PIJiqkEKiyrUgyt33O7kqBKl6/NC
	 D5suEByBEiTb0JWWp+FBVb3LyoUPfSczD5T1LMrBhIt8j+E2CwXHuzZmKFc2m0RI+ElsQ
	 lbbJniMo3Ma0Ga+7z71KidWq1XpBekHPtxkXw+4awrZfvAxUCUew2Bsp3cHm4a066ukB0
	 vWY/OmTNJSL5PY+QVTg01UCJP9foiMdNRMW9AnhjEjI5xb5ptnN67WqhQ3a19K5YO2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GRJExRPj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF059608316B;
	Fri, 13 Nov 2026 17:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GRJExRPj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43A91F000C6;
	Fri, 13 Nov 2026 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590359;
	bh=0UKxFD5/UJDqLY7Aj/+YpL07lw7OeNZYyVZeXyM139U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GRJExRPj1mx7bR3P/5ul72jFohHVGK5GH7lnkotmY98+PgG85CNZWVHs+RBoWdw9T
	 dNyCO4AjNAZxubj5pbdDvNA0DMPyiUNH0vmHizns0uchPH+icWA4UISVBSuKjXZho/
	 AVdiwG/09NIJ6U7VmREuRG4C4m0SJWP0zJsVCML4=
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
Subject: [PATCH 6.18 336/686] x86/init: Initialize wall clock in get_rtc_noop()
Date: Fri, 13 Nov 2026 10:47:49 -0500
Message-ID: <20261113153832.331099638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 0a2bbd674a6d9..c1e20abc7fe52 100644
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



