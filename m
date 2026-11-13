Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585646;
	b=HXMrf7ns03m+s9N3oMlY6NjvjwLObAq9XHFh87QL/fPX6TEX0bOph14Sn9843dUQtu0A
	 yk2ghKxv56WDzZwGUaaRjMYbM5nim+LO96nbw1FsSVco9HRdZG33MH6R6IzW832fnuZVd
	 +K+XcpQWrM9/PHOOBc1iFXYtQ+Pfc5cuqTLdHNrijeZysyp4hCwH8EgQTmh9d4cUJcYp4
	 kjJcLweNyU9HPqxzUMq74IWjO1FS7n0W5Yb1a8NndzczBDCUFFfKJ7xaOGI2LcdGyZnbW
	 A8ZqxIGGfCW3iEZPsod6Inijeb1l+IHnG9dzmgPI5++NjsgofO4P0lP9yHmAVE06M2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=279hh06yzDLdoV+bXybEmxDiYM8rSn89n+eP48kVzyw=;
	b=vymd8dQqEwwaWEDHL+7c6UHi6ZTpePefxXEpABz9ufMC4pG7t9yjvJgaKTjdIbQU0LAu
	 GAZUg9EHGV/cvuzFWT5lMAuY8saho4in9petXj4DhUWhV2u4Tc01SgPuI5QcwemHDUxA6
	 naYFtEY6ymVq7/f5c6Lh+DH7B8EwLF89mXhQhD5Ju8lNr9JOWb8EKUQRi7OYmJ/AoQPH1
	 j8wBKglD9iL2AB/hd9+vF3mca+oFRNvL+DoDZDLnqL3D2Y2CBdh0v6AXFJ9eBxkKODVr7
	 NhOOOFar82CW/F9DTB/xin6Plxq9DO4xigkG1HHI/wu8w3BnwJQo/UNibRY6P9Gty2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E363K2F0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A5F606B5C9;
	Fri, 13 Nov 2026 16:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E363K2F0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CDF1F000C5;
	Fri, 13 Nov 2026 16:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585645;
	bh=279hh06yzDLdoV+bXybEmxDiYM8rSn89n+eP48kVzyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E363K2F0OCuHniAuOV0voo2upRw0LVNbJWUm1dRg8v0bWSWrI/B/CIGFWCK4cbVEu
	 q57k1c35Bcya+1K2CVJlgm1Z9xtr4CJy+oss3SygOXUXJTJ2uhAP9jGloxj4KxKTkd
	 lSIxeFcLt06WHfJEyp9BJ7TmIEh6m00JqTZZR2qw=
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
Subject: [PATCH 7.3 262/507] x86/init: Initialize wall clock in get_rtc_noop()
Date: Fri, 13 Nov 2026 10:49:26 -0500
Message-ID: <20261113153803.430653391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 252c5827d0634..3b9b41820c84c 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -37,7 +37,7 @@ static void iommu_shutdown_noop(void) { }
 bool __init bool_x86_init_noop(void) { return false; }
 void x86_op_int_noop(int cpu) { }
 int set_rtc_noop(const struct timespec64 *now) { return -EINVAL; }
-void get_rtc_noop(struct timespec64 *now) { }
+void get_rtc_noop(struct timespec64 *now) { *now = (struct timespec64){0}; }
 
 static __initconst const struct of_device_id of_cmos_match[] = {
 	{ .compatible = "motorola,mc146818" },
-- 
2.53.0



