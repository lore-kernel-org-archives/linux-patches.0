Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046846;
	b=GfZeES/tcBby49x1ZIuGlpZ7RjS0n270T0OhPvydFU1ZF1hNQuVAOd/YzHUjpLcha5WL
	 AeGuGgecl5ksqzT/yg18YrNhhT+hnxiQhkaTxRZUiU8kOIiuknP/fKrm44f0MP8qeoSqU
	 LNRjZriNFHc426EExCtFelDdcT078gZfrDqUPdXIfY+Vl0gzAGL3xeAh1WonF+YrCwozD
	 rKrDg7CXgWk98yVNhzpCgucVIVK0evFpWJaCTe6FR56vMKtm6jGA9Fe5LPzBKxTJl0Pfq
	 0tjQZBk8PNM1hHMVK/jFdtlUMzvTSefG76VPmZlh8F1wkpFYf1j2msYi9GvIekyalQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=akO0nfPD2niXTb1xpz6wdgrwP4/ERyOtrqe+0KAik74=;
	b=pUoOQaYAfscKGYr/e6/fmzPzq3DM3TXn6XxEOHGfOKxBt/u7GnTEC9Wqt27E62eMMRgk
	 L7S3ccF8PeiULraDtP/Dk4KMJzVvF1eEMkTL+euUsVwizCCRMfGOb8EnKzRJNhxpDji+M
	 oc++ZhGbdRkLgvIMFwyyLMT9hubFB3gUTqpfHJRzUgJKYxlpnUa2F8A4Qg15MYn0DRmXz
	 x5EuRI/xQM3Zr0ccQyGe1bq8scAhtHBeykXclpfT4du/Ugvk+2PJ9gPMWEECUvVkSk0m/
	 /rHtWjDanJEoeg7qrxAQiUMb1/yMsBtx/8eC77yFlLvC54+4xqxrpwa8rOOjVmFVtgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ew1VO7h4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28AA606A320;
	Thu, 19 Nov 2026 00:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ew1VO7h4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A061F000C4;
	Thu, 19 Nov 2026 00:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046846;
	bh=akO0nfPD2niXTb1xpz6wdgrwP4/ERyOtrqe+0KAik74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ew1VO7h46F3ugdXDoCDlGv/9QwVcBB/YeSTcvQHh3j2jw7DcfaaPPp8Q+dbShk7JM
	 VS4PSM05tSl8TXVQcRUu+bvbG1VTo4e5N5u+VVC+89oTETUYJh4PckzzIM8uBXpzXk
	 LWltg/AUGmTx6W+7S9BWvxxDr0vQPbcSKWzPYN4k=
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
Subject: [PATCH 6.1 1420/2857] x86/init: Initialize wall clock in get_rtc_noop()
Date: Wed, 18 Nov 2026 15:40:54 +0100
Message-ID: <20261118150252.454575134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/x86_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index a4a921b9e6646..e911315c16a8c 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -35,7 +35,7 @@ static void iommu_shutdown_noop(void) { }
 bool __init bool_x86_init_noop(void) { return false; }
 void x86_op_int_noop(int cpu) { }
 static int set_rtc_noop(const struct timespec64 *now) { return -EINVAL; }
-static void get_rtc_noop(struct timespec64 *now) { }
+static void get_rtc_noop(struct timespec64 *now) { *now = (struct timespec64){0}; }
 
 static __initconst const struct of_device_id of_cmos_match[] = {
 	{ .compatible = "motorola,mc146818" },
-- 
2.53.0



