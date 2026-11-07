Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064608;
	b=ZkGFTnMzEznuIGL2vr8b4xh8yEIjvYkTEpPHj/wuNT3SAy9i79+OI37Y8OV8RN7K6/ZJ
	 1sPtTzRU/8oa5a54FMznwfsCRKXneGohOb8XmTAy+nROay53eazWLaA+msUFw2P9uA1qD
	 0qiCbid096I3BR/T/OpVDlKe+EwMuKb459E3qbWL8hhHlK5OFIoUK7agitAH6G7GippmM
	 cRPnsEuAlboVB9mpbQzyVpKYZhQ62p5R8VRUCN/ZQGD8IU1ctT/2cTtGH+hkRe1rmeH9r
	 zfOTTVqDRshzKz1lLpzfNKL9KmyjgwUd6DKG0tyuju0FRTB4OxtDO1oUqTbVbL5lmtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cp428scmMcMNcwyR4rWToLPyzEMoGHoZDoTRMd/JM9Q=;
	b=vPQKvPbLo1tUHfi21x8+ZpYcDkF4cRFDTzaY9+g/001OznBPbnQMqoBBL3ttd2y81dEw
	 aeLq3QyQnUXDg1afnKIfEZUwbx0BtkxeV6ALRUk7e/QM57oG9D/l5TFTNFU6cCLhCCqcc
	 0dEPvo6ZaN4r2oQgdy6CD6hndDA0dQgg8yHigm47wOjWbrI3Vc/oNRGVX9UdLGG0Pz0vc
	 fLOVg32kTQjIJXCl5rC7t5hEj8bF/wp1rgwc0KpA18iQfrHRQ/j6S2oLmJRjEftDOLgdr
	 T5ORvYlXa6vXP3hL5sUBG+UlQBslAnaKF4YlYmsvacFj3fqCAVSR3YclpCG6ocJZW3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnrAu4qh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C40E606E8FE;
	Sat,  7 Nov 2026 15:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnrAu4qh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE141F008A2;
	Sat,  7 Nov 2026 15:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064607;
	bh=Cp428scmMcMNcwyR4rWToLPyzEMoGHoZDoTRMd/JM9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnrAu4qhwGlM0R6Ia2jBgbrpT8EfRq30fA+HK+LkaIFdbWCXlWo/InR+15gAxOh44
	 ZvOcgWZEI1Av7zw8sCfYoEQp6gf+mvv8XoJ99r5p7KSPPexWsnDE+fI+jcNjqRtHlG
	 WIy2Ae1QWOKOxq6NCtaZcpvIvZe+b1XX/p792Nro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0619/1257] KVM: arm64: Prevent 64-bit overflow when computing hyp clock rate
Date: Sat,  7 Nov 2026 08:48:35 -0500
Message-ID: <20261107134956.396209498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 6164ce3491bcc3a27a2e2e9260a286eb2df2301e ]

The hypervisor clock rate is delta_cycles * NSEC_PER_SEC / delta_boot.
It is computed whenever a deviation occurs. If the delta between two
rate updates is big enough, delta_cycles * NSEC_PER_SEC will overflow.

Prevent overflow with mul_u64_u64_div_u64(). And as a bonus, simplify
the clock estimation with mul_u64_u32_shr().

Fixes: b22888917fa4 ("KVM: arm64: Sync boot clock with the nVHE/pKVM hyp")
Cc: stable@vger.kernel.org
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261008104212.3134550-2-vdonnefort@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp_trace.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 9644c424819b7..c60d7dfbf5e26 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -59,14 +59,8 @@ static void __hyp_clock_work(struct work_struct *work)
 	if (hyp_clock->mult) {
 		u64 err, cur = delta_cycles;
 
-		if (WARN_ON_ONCE(cur >= hyp_clock->cyc_overflow64)) {
-			__uint128_t tmp = (__uint128_t)cur * hyp_clock->mult;
-
-			cur = tmp >> hyp_clock->shift;
-		} else {
-			cur *= hyp_clock->mult;
-			cur >>= hyp_clock->shift;
-		}
+		WARN_ON_ONCE(cur >= hyp_clock->cyc_overflow64);
+		cur = mul_u64_u32_shr(cur, hyp_clock->mult, hyp_clock->shift);
 		cur += hyp_clock->boot;
 
 		err = abs_diff(cur, boot);
@@ -84,7 +78,7 @@ static void __hyp_clock_work(struct work_struct *work)
 					    err / NSEC_PER_USEC);
 	}
 
-	rate = div64_u64(delta_cycles * NSEC_PER_SEC, delta_boot);
+	rate = mul_u64_u64_div_u64(delta_cycles, NSEC_PER_SEC, delta_boot);
 
 	clocks_calc_mult_shift(&hyp_clock->mult, &hyp_clock->shift,
 			       rate, NSEC_PER_SEC, CLOCK_MAX_CONVERSION_S);
-- 
2.53.0



