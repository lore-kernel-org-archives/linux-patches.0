Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19A71ED41
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534FBC433C7;
	Fri, 21 Jul 2023 18:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965457;
	bh=FUvP6rMKOTXHGMi3/QsWtxDR24XoV2zguEGGI8mDKT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmLUshJSdlxQPtZp7Ac13CEPk9tPPbB8Iv8kuTc3eFeNXJ2QeaC/7Kcxs/VJ+yPz4
	 Q2KOmLfC6UiIp39D1v+D1XfYWUeTrM23YgjKj8J9guT21UrzIKMQmJ69QPuF14F0u5
	 qjQgaK6MS5HjuZzbY04waq0LfBdAtFYhDUC3UUj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 6.4 291/292] MIPS: kvm: Fix build error with KVM_MIPS_DEBUG_COP0_COUNTERS enabled
Date: Fri, 21 Jul 2023 18:06:40 +0200
Message-ID: <20230721160541.464078644@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit 3a6dbb691782e88e07e5c70b327495dbd58a2e7f upstream.

Commit e4de20576986 ("MIPS: KVM: Fix NULL pointer dereference") missed
converting one place accessing cop0 registers, which results in a build
error, if KVM_MIPS_DEBUG_COP0_COUNTERS is enabled.

Fixes: e4de20576986 ("MIPS: KVM: Fix NULL pointer dereference")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kvm/stats.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/kvm/stats.c
+++ b/arch/mips/kvm/stats.c
@@ -54,9 +54,9 @@ void kvm_mips_dump_stats(struct kvm_vcpu
 	kvm_info("\nKVM VCPU[%d] COP0 Access Profile:\n", vcpu->vcpu_id);
 	for (i = 0; i < N_MIPS_COPROC_REGS; i++) {
 		for (j = 0; j < N_MIPS_COPROC_SEL; j++) {
-			if (vcpu->arch.cop0->stat[i][j])
+			if (vcpu->arch.cop0.stat[i][j])
 				kvm_info("%s[%d]: %lu\n", kvm_cop0_str[i], j,
-					 vcpu->arch.cop0->stat[i][j]);
+					 vcpu->arch.cop0.stat[i][j]);
 		}
 	}
 #endif


