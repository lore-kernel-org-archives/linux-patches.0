Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591204;
	b=s95mbHu3QX7yJg30fwFUsu4cmmC0Uw4FNYXB9G9qvXptuPCKLZu9YYjeBQ2okwSAVNKT
	 ki8oKuSYupB0MlEkkSeJIDGHtUapdun4krFr3iVQZLRAKd71qeMUqNefhjTuA8kSmY1RR
	 4Bp/UCjDlw7A+ye79s98yTxQwdiA16LC/puUkpgMV2gu+7z2Yyu6YDJ0oieeDlsg+gINc
	 iPq308DXH6qZ2k4JeXjaYybNeDv/X90N4VD7QZzLUE247RBoK2rVS0xnkd1VOOA7Nz5VE
	 9Fh7rzpnxYdz3WnO7EZSWv6PXU9jIhwO9ikFXnTvjgMzh3uKUtkgI2XVHAC7bQ++1Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0tbLk07DTcudvkLWy6DmA8hcycKRpe3pNIaH2oCX4qU=;
	b=X2VYwnPpIWpxeKKNV+CSWgvnOA3nkwuc9MZDaVKkfRw2aTLx9v869hL5QnXVtJOFtEDo
	 UFWVSaFp+UbwtKjHos4IBc+W0pcVMHt6F8l3zvJfVoogjIsgzcXOD9J/T/lnEekEZZvgf
	 x6VZHUhRcvKIWMYeztx15pnyzS6+/CmS1CuGoO7+RY+Y8xF88wvxzBxmCrLuqMLWtaDhL
	 gPux9Lp60CaHp08TKXQUJpEBmX/A4eeVDbd7m1a1nokceLNBrnvQaM1+nww43iWT9ZSBD
	 JqDGJA2Z7avaL0NcLoiU5LxvJBAQ2MOOkuUp7HNyxNH0O0HtNTwpD16C7aH54muvDbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="g/yCnQ3U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3816075854;
	Fri, 13 Nov 2026 17:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g/yCnQ3U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE371F000C9;
	Fri, 13 Nov 2026 17:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591204;
	bh=0tbLk07DTcudvkLWy6DmA8hcycKRpe3pNIaH2oCX4qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/yCnQ3UbiJPC1l12huqlO751NNc8okmZvuqwI2+nt+jUxwlkaqcU5zBKVnw1oln+
	 hMM73VGiJXYW7l5VQtaXwsUHFZQ1cCqpxibKNvyvijeEN7xefZlNsTsXNm7aMYPUuV
	 ZjU9+UDai3v5ZLFQlzKV78cdKLeLG+F8/AtA6Olo=
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
Subject: [PATCH 6.12 297/670] x86/init: Initialize wall clock in get_rtc_noop()
Date: Fri, 13 Nov 2026 10:47:41 -0500
Message-ID: <20261113153821.995431111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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



