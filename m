Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060362;
	b=wWNKuna62Mc339dDzcKiLHdswI4R33HAl7Z6+w9PHyjkd1+ScJFfe1mGWtLPFPN+Pxio
	 T0sPLZr3/QUn1G/ItkwPyab0cKtiqOud0AX65jR3Chi9UNQ5hJeJ8dnt9DvaBHz6WiJAU
	 aIjiO31+fAcVOXM1aXyirGBRBbyuu5oCtOcAFFhvUjjPKakNSlahBguhN60WvtnyGExUD
	 xcvJJELddHZDvFrn927rJFCm3kR/VL5hjNo54U7AzswMmBh4qvKQdIads8LlOCrwP5nCw
	 2ZWwrQX4ePBjjWJftqo08IMQ7cF8TJsqAEP38NvP35sIPnqDmxKFb7WwbKHZlXDG0/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5LOM2msOIVGIdPh/UJnY63t/i63/X0X0RpcFSj06m0Q=;
	b=PlCoiAvUWy/Vw5tOP3D8Nq/JGm0pw9R+7i49tP+0TQmrDuVnJe9XxlIuavjihEbcV1Or
	 2QT1pzoCryFNeKQVyGHfUiuPmCgJbTXPrMMVOUNLPzcihCIP1xjswQNX9YPeZ8M2WL8Qz
	 KgD+F68N6QYFq81Bzb+KiUpiGG2nYUnno9HkWPyMPcGISpTmEWqV+FWZLHvlckT75zlP9
	 M40FCrgQN0LdltwHF8zvPgB5F0ujoCKMviNr9F91uZ/xNlhoVDTHZEqUzjKxUNA7Tp/Mz
	 16T3xyrr7w8rB5pvFQU1G/SvGBKzSbAJJhj0BVhyQCgVsY+hIeD/OdQE5B0SPZlKaEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sa0XpmAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A94606A32E;
	Sat,  7 Nov 2026 14:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sa0XpmAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B315E1F0089F;
	Sat,  7 Nov 2026 14:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060362;
	bh=5LOM2msOIVGIdPh/UJnY63t/i63/X0X0RpcFSj06m0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sa0XpmAYeyidke1f03jWSz7SrRjtMHnbQhySWkAGJt9eA0OVXCW9l95Y5Mnr93Bhc
	 o45J3+TDPyeocvy65W5Pb/ck+Bk5/bWWJOUZMlSV9So2XftnZOiw2YccbYS8JYegGm
	 gC0/FeRu4YEHFUrMkLHwMnHdIOfmi/8mCaELrqpU=
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
Subject: [PATCH 6.12 0003/1536] KVM: arm64: Transfer the hyp stack pages out of the host stage-2
Date: Sat,  7 Nov 2026 08:33:39 -0500
Message-ID: <20261107134957.764230508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 08770d7cba4b0..2763bf8dd105f 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -264,6 +264,16 @@ static int fix_host_ownership(void)
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



