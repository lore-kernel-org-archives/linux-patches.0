Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042880;
	b=YilN8hwut+hpb2FcUqRLZdTevIP4ikhEmHkKZiqaOXNNmsBObpC1LPizBB2+6qa/7bxo
	 bgIaKm72KYCpE8vvm3YmnWkTJpybZqVwaXIS45orIYUrnM2nmRzG0VBZtZI05ERjtykvx
	 5OIxPakl0NOdCTXwJlkSq5lyzI+Fz9C6AbLa5/CR8V6Ql9EeKEPh11AaiYV8fCbh0fX2n
	 yBk7Uar8QN+SEzqpMROpw47gqRzorE2mPe5uwkuPfkxC71uUcnHGRFxHLWRcmPO0B13/i
	 ldGJw6P37wo4xOpt2o0LSd2QaDdd/Ctc41yZbnJGb3CR6HQcaDoE+Qw+KebfDUYs7ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=70InLQEZSGBTrst4AvUX9r0nvSOvuC8wv2wB9zTiWhI=;
	b=bAtZ6MbseZ8ARzoCfJDLLUCryfKAJhUG1RS21eLTjXqBhuhSDFQ1HZVksVCsEUQWkFt5
	 obmPcK+59h5Ywu08GifkvEujyWQmNVao01cbSYlkT5lV/EGeAVLSgOYTUZ6FW1M8n2del
	 smJFrVx9SK1mZWVSgSAhdWGm3FYl/CRtMQcUdK9UmlX3pLEKn4yLx6XqXm1eWKUNYjEh6
	 rsidoX+i3m2YIzYNsGNEEq39vKgGPPZhRR09NzKG0TnAKbBiuOp9jZzbwy+2SJwt8Ir+H
	 ySGJOFihm/CmKUGsHayPrYmduhBPey6qcVbL0h37nwSNXy6suqfQUQQOV3jyCjxPMwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oZCjRUop;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E148606A325;
	Wed, 18 Nov 2026 23:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oZCjRUop
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE891F000C4;
	Wed, 18 Nov 2026 23:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042880;
	bh=70InLQEZSGBTrst4AvUX9r0nvSOvuC8wv2wB9zTiWhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZCjRUopJubnWzcDDHTm+1hJ5QpuR+uYSg0kN154+Mr85tQXNgqxDjLLMyMESlWRu
	 ftJ4tGk+rcqtm8T47lgbwUfsIQvSgdAgkICw5G677UyW40/L4XUSarnCuzNk2zB42T
	 Ys0OAf++LDf+eXxqaECW7UizH17AD0lx6mQqzTKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hiroyuki Katsura <hk590@cam.ac.uk>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Vincent Donnefort <vdonnefort@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Mark Bundschuh <mkbund@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0005/2857] KVM: arm64: Transfer the hyp stack pages out of the host stage-2
Date: Wed, 18 Nov 2026 15:17:19 +0100
Message-ID: <20261118150201.512562087@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 3a8c562892b96f35bba1e00d5e455a15963bbb92 ]

fix_host_ownership() walks only the linear-map alias of each memblock
region, and the per-CPU hyp stack, mapped in the private VA range for
its guard page, has none.

Walk each stack's VA range with the same walker.

Fixes: 1a919b17ef012 ("KVM: arm64: Add guard pages for pKVM (protected nVHE) hypervisor stack")
Reported-by: Hiroyuki Katsura <hk590@cam.ac.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260908110713.1540304-2-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
[ 38f9e4b905a0 ("arm64: kvm: Introduce nvhe stack size constants") is
  not backported because it converts nvhe stack code in eight files to
  NVHE_STACK_SIZE, and the hyp stack here is one page, so PAGE_SIZE
  replaces it. ]
Assisted-by: LLM
Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index e8d4ea2fcfa09..89dbe4cb8394b 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -255,6 +255,16 @@ static int finalize_host_mappings(void)
 			return ret;
 	}
 
+	/* The stacks sit in the private VA range, not the linear map. */
+	for (i = 0; i < hyp_nr_cpus; i++) {
+		struct kvm_nvhe_init_params *params = per_cpu_ptr(&kvm_init_params, i);
+		u64 start = params->stack_hyp_va - PAGE_SIZE;
+
+		ret = kvm_pgtable_walk(&pkvm_pgtable, start, PAGE_SIZE, &walker);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
-- 
2.53.0



