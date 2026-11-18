Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027931;
	b=R0/siYLs+/2EBV0gT2Bl0qjQODSG9loGASAWVG4RexCX2fmlKCwOA29lhCol0dCwaBpb
	 qbLjvWCN56686J+1Gdy4eja8Z89bSYX2sAjGl+Ff6m8RJABY6FONvEzrbB/CsoPh4HkYl
	 LtLyAMoHZSR7rwi0xniZKfOALKZbxGEMF6BfsKHlmW5NmscRT8ig7spEjX9i32XTJ6nPx
	 OyNUXQHiHr6hWJo9g3KQTZLwjt3jXcYW2RjsP5/Q2e+HamE3MHt/MND6V366EKPd9LIX5
	 Ca5QlGsyNfkSDLpL+sSjjwnl47I2hpQXpf4ejuML6E6Rmu/X01smiuuqSHuyFcLxlZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c7DQwgpZPiVibqkayBfEJqGiJKopnrYiRZEcBUvYi/c=;
	b=Es8k0XmA5tViZKmhs7uSUIwR2HgwVnhGJQa6vNbUqb20GxXiCihWtUnQr9DGGtPZuiBG
	 H7XsmfxLOtQTg56vbNPn/aZmVVpV0d9OmFo4XMFikxgLzgelF8CkLQ8mSouSbsLon6phK
	 hF9iJePNAbDhW30ER0pi+ITisCb+0uTba7Rl7806Cx0QqNV35pdF+xhZaS7hbvmgQoahk
	 ojOkvuesoeQgavpXIQ53WTGs+8J7kqwLAGpTKvIyDsbYJrPF72huSaI3/vtWSVXebs/mc
	 hoScALbbnXvtkZCU7xqOKOy+u+2NhIZ86/GG8aVrx2WJkkmmGx3hpvCB8LhkJ/BzuRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QaNcGhLd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E64606A320;
	Wed, 18 Nov 2026 18:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QaNcGhLd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2981F000C4;
	Wed, 18 Nov 2026 18:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027931;
	bh=c7DQwgpZPiVibqkayBfEJqGiJKopnrYiRZEcBUvYi/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QaNcGhLdcZzqFsW5l/hOEohiWHMNHUKFIntt0mFctcbpvgpFeuxNcnjvcxdWOeEJx
	 RQJWxGx5fcGtJB739CsdcE1ztY9npyE+Vkjg4DnsDW5XH0o8tvCdBZ5xG/oSnCjtVt
	 4axOki5BxRy3NAWj53r2MyuLsl/3whOSg8cLAcJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1965/2151] thermal: Fix CPU mask truncation in power limit trace event
Date: Wed, 18 Nov 2026 16:01:40 +0100
Message-ID: <20261118150233.333007659@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 82c9c94f54a444a686e926c872dae4b198d1036f ]

num_possible_cpus() counts CPUs, but CPU IDs need not be contiguous.
Using it to size the thermal_power_cpu_limit bitmap can omit CPUs with
higher IDs. For example, possible CPUs 0 and 64 produce an eight-byte
bitmap on a 64-bit system, dropping CPU 64.

Use nr_cpumask_bits for both sizing and copying the bitmap.

Fixes: 6828a4711f99 ("thermal: add trace events to the power allocator governor")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261023060724.5691-1-dennylin0707@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_trace.h b/drivers/thermal/thermal_trace.h
index df8f4edd6068a..2f953fd8289dd 100644
--- a/drivers/thermal/thermal_trace.h
+++ b/drivers/thermal/thermal_trace.h
@@ -119,7 +119,7 @@ TRACE_EVENT(thermal_power_cpu_limit,
 	TP_ARGS(cpus, freq, cdev_state, power),
 
 	TP_STRUCT__entry(
-		__bitmask(cpumask, num_possible_cpus())
+		__bitmask(cpumask, nr_cpumask_bits)
 		__field(unsigned int,  freq      )
 		__field(unsigned long, cdev_state)
 		__field(u32,           power     )
@@ -127,7 +127,7 @@ TRACE_EVENT(thermal_power_cpu_limit,
 
 	TP_fast_assign(
 		__assign_bitmask(cpumask, cpumask_bits(cpus),
-				num_possible_cpus());
+				nr_cpumask_bits);
 		__entry->freq = freq;
 		__entry->cdev_state = cdev_state;
 		__entry->power = power;
-- 
2.53.0



