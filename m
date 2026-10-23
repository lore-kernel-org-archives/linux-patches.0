Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773913;
	b=zhDUuWwv6ehcIPVA2X1nD7FJWnrwY45cb20GZLA4hGTTO6qfq/jBL/ePH2MCO/C33Cfk
	 svVERCfSKIfyQeSX5CesiTH5i0vV7fHcgEVRUj9+bvxAAK1lqSkc/LgtGyOl2oLss0t9w
	 mBDsW+Skcw8lleyhs0l82FxEiOKNCcu4jvZXz8levCtpiLyZ3VpAuqsrXN7vGohfOrQS1
	 ph4wRrkb3l16CLrjTX8W8oTlAc6VIbF+vYRHfITIjqWKWI88NBzveSIUX2Co4/3TMMs2x
	 sZEyz4wbCe+XeGFSwS1N4gvytLM+cnZK6t0a5iWO2aovDlpd+MPtYVrjf6hCBUEEIQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=opxNk2zOVt7CKBM13A80UBoV4oFyoySJ2MjQRI5vub4=;
	b=tBZS6/zR7aWHqLt59yOKhaoXg9UBLnLhjkliFtV5O4vIMdUhIi4mfNVcto+CbzKTXiC8
	 KG9zX4VdiDsmZ4IJ+s6CMpwboSYBJmpu0tIKLzUJpBsPDQROI6lqUwt6dGzKIINxBulIx
	 2EjEzfxLYHKwrD8Pc1uOlDCtnfViGcEJjco1Y+oOJG38by8RCsbwqe3rrP45w4PWZtG9L
	 PlhqbbCoXpHK55KvYH6HVX8TuBgVIhsDYh9nnzrkQSvzg4kpmAXX9L+H2+L0N6CSJwoRR
	 IyEG98Avp8iiPhlwx5KYfKiF0EE9t4vsZ/E9yUs/6y8YshqUfYIPbE6ScKGaxvGFabw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9mA+4VG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80043606A31A;
	Fri, 23 Oct 2026 16:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9mA+4VG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32371F01825;
	Fri, 23 Oct 2026 16:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773913;
	bh=opxNk2zOVt7CKBM13A80UBoV4oFyoySJ2MjQRI5vub4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9mA+4VG1E7Hx2+4T0Yp2QtRhAk5tXP9x5yLz3RtaoaUrPsVJvR+PfDdFt2e3Pvhr
	 rGOxPj8H5PqvQCwYMPjTc5hDUgmR+RHroycKvN83yyhQ7jv0H3sXnyDb6X84iPt/gT
	 MNz0QpbK48svr8PsGEz2i2Xw0Sb4RXBKabBxmsew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/193] tools/power turbostat: Fix CWF PMT off-by-one
Date: Fri, 23 Oct 2026 18:34:56 +0200
Message-ID: <20261023163714.656651543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Len Brown <len.brown@intel.com>

[ Upstream commit 5e940dd96bef6ca03b3b1b4740351237e5ec17e3 ]

Fix off-by-one error causing last CPU on CWF
to never get a pmt counter allocated.

Fixes: 5ce1e9bbb2a1 ("tools/power turbostat: Add CPU%c1e BIC for CWF")
Assisted-by: GitHub Copilot (claude-sonnet-4.6)
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 47471377ff43c..b8ccf277acb23 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -9961,7 +9961,7 @@ void pmt_init(void)
 		mod_num = 0;	/* Relative module number for current PMT file. */
 
 		/* Open the counter for each CPU. */
-		for (cpu_num = 0; cpu_num < topo.max_cpu_num;) {
+		for (cpu_num = 0; cpu_num <= topo.max_cpu_num;) {
 
 			if (cpu_is_not_allowed(cpu_num))
 				goto next_loop_iter;
-- 
2.53.0



