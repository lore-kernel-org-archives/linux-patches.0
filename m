Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027652;
	b=bR04JFtNG7e2uzha6+J7Ug5GijbEDd1LQsUEo5nUHhW1aQazbSU/t3FoxRB5Fej7szKf
	 dBdRz7D8zgCruj/mVjSnxEkgdn4+6wGnfEbaMqHskL/4bgHOSm7QePdPLGeZpxHq37rmD
	 71svWJO2V7ZTVElpUh+kBTaAWnm2YbBqEd+OXKHbpphZQfMkti+1TLIN4C/sIO5ebRd5q
	 ZjsY1dyEJtdX5xmbjgzPgZksKimXyYBPYJCDT08jPV4cg9J8lu3zfSd2Ox9DaiqUz82Gv
	 hWRAzzSpETgzt/pxbWzjzHausbb0r61erViZdziFfQpl1g+xphT/AjmV8mRm9xwff1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Bj9gZB1wGB2PpPQdwmioHJE52gMtLYB1ovhICvtgac=;
	b=01FhcaOQ+3nWfuwside3F9qCvQW7vhIuEE8/I1XSrxxRZIqkMy/WJpzhZFyLeCS1SZuD
	 N6yaAyarPd1uyYmeV0ORElbgpRBEvWFf8iAcBkMWVBlNaBypRq9e9GQ/jgdh+pVJCQe55
	 zdPuh42Mv09+kvttC/1Sc3IWhilVkc7Q9tVv2BBjohrQdDRGPrpB/HVgh32hgtftY6Dns
	 A+bYYbfL1+sfPTlHdr1vju2nDQI7Ja9G3IgZPgLloRahbOmxxOKILD24bSmr5GLfETf0A
	 j5ZiXd0dCvVr8t7QJ0ckmOPjBcbI5m1n2N+PGvHpyR/g2aaT0VPV4p79FAyoYmqgyYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rI76T6nf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB4F606A33B;
	Wed, 18 Nov 2026 18:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rI76T6nf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDD71F000C4;
	Wed, 18 Nov 2026 18:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027652;
	bh=1Bj9gZB1wGB2PpPQdwmioHJE52gMtLYB1ovhICvtgac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rI76T6nfPNkNENvu6zG1f9B/lQBpQPcYeiRUO8iSd+VoVtuPQGBxTS+AAOzr79aOU
	 WLtqkTfSrJS6CKexSVvOSdHrofroxaqLXRN1ouaoPoeBIWtQfCnh7x/ljx7wjNhUZ/
	 TFFSXktG8h6ClccoCqvECLLsG3GR522TgaHVTnI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1863/2151] x86/hyperv: move stimer cleanup to hv_machine_shutdown()
Date: Wed, 18 Nov 2026 15:59:58 +0100
Message-ID: <20261118150229.669893698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Jork Loeser <jloeser@linux.microsoft.com>

[ Upstream commit f7ce370b525a02127527b0f54ee877413705a709 ]

Move hv_stimer_global_cleanup() from vmbus's hv_kexec_handler() to
hv_machine_shutdown() in the platform code. This ensures stimer cleanup
happens before the vmbus unload, which is required for root partition
kexec to work correctly.

Co-developed-by: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Signed-off-by: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
Reviewed-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Stable-dep-of: 228e21764b38 ("Drivers: hv: Run VMBus kexec cleanup from syscore shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mshyperv.c | 8 ++++++--
 drivers/hv/vmbus_drv.c         | 1 -
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index cae0dcd9006bd..183301f27f080 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -195,8 +195,12 @@ void hv_remove_crash_handler(void)
 #ifdef CONFIG_KEXEC_CORE
 static void hv_machine_shutdown(void)
 {
-	if (kexec_in_progress && hv_kexec_handler)
-		hv_kexec_handler();
+	if (kexec_in_progress) {
+		hv_stimer_global_cleanup();
+
+		if (hv_kexec_handler)
+			hv_kexec_handler();
+	}
 
 	/*
 	 * Call hv_cpu_die() on all the CPUs, otherwise later the hypervisor
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 5b55a44c3dd96..1cc2c8695e0bb 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2876,7 +2876,6 @@ static struct platform_driver vmbus_platform_driver = {
 
 static void hv_kexec_handler(void)
 {
-	hv_stimer_global_cleanup();
 	vmbus_initiate_unload(false);
 	/* Make sure conn_state is set as hv_synic_cleanup checks for it */
 	mb();
-- 
2.53.0



