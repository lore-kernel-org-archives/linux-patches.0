Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021803;
	b=ix6Ij01OtA++AMLuqsPN7UUokP/By5J1G4kvCNkCP/Y34y03J5B2HIJsZP6tcS4/1vND
	 SbsG9A2MbEjnLVY+Ke7GgTyKIbaHJTCycAUU9cg45LFvlkSWLlX7TixxscbliVF/we1v+
	 mnwquM1f0U7tRLQ6BfW9Q1karyI4nipxELR6vDo6sZOahfuI79+IWBVGWNDpvLoFcWMON
	 AFyIW/bgLLM0hp1MY6qvIUFkb+3Qv5Z3e9dVA8+DgOby28ecpoCKG7QNHS9UO3OdcAmyg
	 pRtqOrVZmPB4WwO4TgKbIsmntRALKpg38cuRi5TpA6b6HUQdTTFwJ6XQuXDedy38kqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vUqe/YQx0RwzDL6fdLl36j+2r+Sm2rWRY6zGhTpvE9w=;
	b=vf/v++pC7AB40q5VRwi4ofoCABdc6N4YuWcoN3aacu2Nce5BXQAId2PVeRxVrXkZkBpn
	 HdIpk6nfOo4gNXc+fpD+fwDKmcJpo4HvuNCO9DdZCOau3j/+bC88XKNdDLNG8j4zZV+ge
	 ZENS2PLopyfAfnA5Is1LYMQoVj3n1Et2kvBB2p+7JqbQnstguYVNzyiRLcrfnqJcf7cn8
	 bpKNSv1CsRoVx5C/UzqLpvwFOp+9nhjJXzTUK9OI5BKphNVCMW91opaIEvzHzqn517GX0
	 fNjX2OwVszg7ypNCDXhQ7qOKQ7YXB8sWZL0dyf4GwPeJugBEt/FIy0z6C8mPXMPOBYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Le3rU40y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E7260A260A;
	Wed, 18 Nov 2026 17:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Le3rU40y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0876B1F000C4;
	Wed, 18 Nov 2026 17:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021802;
	bh=vUqe/YQx0RwzDL6fdLl36j+2r+Sm2rWRY6zGhTpvE9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Le3rU40yD/qPGwMOtVEHBKVWPd2HEB+z4Lr9pdi7WxNaDd+MVg1hgYgMayjq3VMr6
	 icok59DfX14L/bG7scTSBqfuqoYB73pB41/auBo8x6Nyhb5kvZjX+jQ7DRrTyOPWsv
	 ncaGmFE0JOPUwx6xGovpijMwjGLqQvzPm30VITqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2435/2651] thermal: Fix CPU mask truncation in power limit trace event
Date: Wed, 18 Nov 2026 16:01:15 +0100
Message-ID: <20261118150412.853481572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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



