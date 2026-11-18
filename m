Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033465;
	b=yKJh7cdsGCFx2xNo0R8V2GXOSiBTtJ9aM9Mdp3Q/vhTIb7NGShAzhnp8intQofXlNfNi
	 Jv1qxzjjISUkoFHY1kCJr8CASJJNdP1WTDXkfdrS5z1M7n8josWvpUGOGS/97fOUUlFTO
	 d8iaWPso/ttw5HGyXUfdeG4YHbhLepipOU5nMSO4fHay8yeypEU3ATadva61Rl4rxkGLX
	 es7RBdKg2smPwwqkZ7XvKPW0UmbEWDFVDA3vyG00Qmy1447lytj+m/69iWfYy50bqI4AZ
	 TG7ARTTJNfYe3gZgDQpQ9czBPQPW8XdpXhnFm06Py1/x95pcgpKe1nJHBbmm2jr9J6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FiWcO9YNjCyIx8chNwJH6wXzaJGWhI3X/QjinDybx4o=;
	b=t/68OXKrm3W+AgWmoeOyeWM5w5gj01X4x4XQ6kC6Bz0qY29AL6yY7h2RTE//9ztnWftJ
	 NuY6+8matQfiMoyLUYaOVqPlFi+1kE4R8PSSVLXa8ceFZ3PrTDth27l4ZMqvkIjz6ixGZ
	 8V7yrrz4BaVzhDmMo7xWYVOvCcaRz1lS07rG67ah5PSRfzbc1At0rbxXmrZGicGWZBIi5
	 G1C9T8PbKXBPljPEcnErVbrFWGMq8doke4U6MbVQgYTYDP0r9DTQ0dpYf6B4D+7DFZPoH
	 mfcPOatIczEesYt5v3uTc3EoHA1fs5uD+J7KEIXitw76B1z8B5z4Qpi1YB8fmmxYsWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NReXpOQT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9F5606A31C;
	Wed, 18 Nov 2026 20:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NReXpOQT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4181F000C4;
	Wed, 18 Nov 2026 20:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033464;
	bh=FiWcO9YNjCyIx8chNwJH6wXzaJGWhI3X/QjinDybx4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NReXpOQTgO58Xi/3/6pLqjg6sKEHoJHU1jD8VOp6OEkRMhch3MQdlhs9H063qqhiF
	 wKIWr6KdqfYs0mb9dKetN111ypF7w8FcVRNJY3ZYXYx8qxXLKjef+icUxo8iJbgNj/
	 khDWFNElb87G5nRUMlmFQEy6Zglk+gvQRibiC6ts=
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
Subject: [PATCH 6.6 0006/3318] KVM: arm64: Transfer the hyp stack pages out of the host stage-2
Date: Wed, 18 Nov 2026 15:10:28 +0100
Message-ID: <20261118150313.817447427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 29df463ab350c..e8c1f975e38e8 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -240,6 +240,16 @@ static int fix_host_ownership(void)
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



