Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618628;
	b=XpLq5c+YPbFgW9WFs8NGyiYb8Fzo1GbYlWC0YWyvywC/Ya5TFvHsiJD+rKPgWpGPMX9x
	 7xGxNO/rSQ4W6SWNRoJAiTluVwxV3R5nsnxhd8LZe+DaYPnQDSeN5uKxS2a2YyaOoZrLt
	 meMp83Vyq12RswpDhDRCG29sXzkD+6p/qgE2WDA7uyEZb0LGUqfWCCaVHT6ANV4voIw77
	 kn4ZLeZPzFvE2NUFn1xEDSq67vAtqqAQWdbvyLb2gjht5Eig5Ka5A324HYk0V0WVnQ5cz
	 3w4eq92xCXGRxFY/K27dYlO5ySJrVRrB/SgilU7f5sDlDLMP2d/ZyCtk7LAM82gnUxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VOx8zu8zDJ6Fh11gOqLSLJfmjYhxFM79SogNqFzo/yI=;
	b=XRse+d6uvhSKfxh6MuA2WwM7or40Q12AQuM6RMF+58CO8w2MsZkgUHH6Okgo+loDhyzW
	 WOmzxPJV1Zy/SLmIeqoiMSQBpqIPIncMC9MLuXUg0KPTekmSuCHQn6lJTjsH+gA6OPeMB
	 A5cW8JKkN+U9l3OmiG9iMntjSremfGKP7zjmtLQAhXj0tJ18b78GHy4y9kpHkmm7DBurR
	 2DlOXALV+0JKv5i0o5MOPoOI1N/MpdtG2XOQiYxAEPS2Yh+e3Ue/TzybTLvB8fg77KR3l
	 aIGqnvpuE2IF9C9NW710RSxgXgF7KRdrcXb+5jqfjA+uHue9mjwITyJzQTeTziTDT4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2z3Mbsl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB23606A31E;
	Wed, 25 Nov 2026 14:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2z3Mbsl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E27D1F000C4;
	Wed, 25 Nov 2026 14:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618628;
	bh=VOx8zu8zDJ6Fh11gOqLSLJfmjYhxFM79SogNqFzo/yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2z3MbsldO4lsN1Q+LN8EUBmV4VYp3kIs2Q3x2Rik9eCGUO84AwvLrj0wttNFY5ul
	 GVvuS8fj119ACuvlEDT3ebEJcUQPTw6q3LafwFiDxqwrN+8uct6iUfQWhaIgPecyjx
	 MhBxEfhAXLYpUJL3PnbgxX1+Ri91KddsKZYA3X8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0338/1005] perf/amd/ibs: Reset CPU0 IBS state on syscore resume
Date: Wed, 25 Nov 2026 15:27:56 +0100
Message-ID: <20261125143829.653212734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit 2c1d35bd95b13b50b43a0cb2167305dabfb54c07 ]

During a suspend/resume cycle, all CPUs except CPU0 go through hotplug
callbacks, which sets up IBS state. CPU0 bypasses this path, leaving its
IBS state stale after resume.

Fix this bug by explicitly setting CPU0's IBS state in the
syscore ->resume() callback.

Fixes: efa5700ec0da ("perf/amd/ibs: Support IBS_{FETCH|OP}_CTL2[Dis] to eliminate RMW race")
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Jim Mattson <jmattson@google.com>
Link: https://patch.msgid.link/20261026041838.941-2-ravi.bangoria@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/ibs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 3531f9c23b8c9..bfb51f8e184fd 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1948,7 +1948,7 @@ static int perf_ibs_suspend(void *data)
 static void perf_ibs_resume(void *data)
 {
 	ibs_eilvt_setup();
-	setup_APIC_ibs();
+	x86_pmu_amd_ibs_starting_cpu(smp_processor_id());
 }
 
 static const struct syscore_ops perf_ibs_syscore_ops = {
-- 
2.53.0



