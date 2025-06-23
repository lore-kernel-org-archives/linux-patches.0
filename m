Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76B3B676;
	Mon, 23 Jun 2025 22:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717700; cv=none; b=dr/0QR5m9fNYqOjXDulsko9T2G94j6lSO7hKHZTbu+3qEVLD9Ov2OVwfBH/eZ0wG7bK1rZol5U/Wxl00fXGNI5pLLblkJplwIL41e3/dRObx1axsceJc9K8jvfTuoDzfEtqiEsyib0PE4AcxpoFrqrf+HjETp8fttXcKenCJD4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717700; c=relaxed/simple;
	bh=qh2o1UqkM/Ni/LvJloMrNzd2bA1BYlrvQRv+AxmfEe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rwfOvg4Q1FRu2T5+9maj//KUlHdec1FWPdqQXS45uLWJUO4wi45i0CvHSGobQDNM0R2EAoo2W+C7NB2Bleh37RmsOtVNNXiqCYYFUZ2BgrQ33JUkihqYSZK/Cnf8D2QajqLbx+qjGLvX8KfydyosF66q/sm9kpfjhJqDVVG1ovs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWHoClFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWHoClFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C515C4CEEA;
	Mon, 23 Jun 2025 22:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717700;
	bh=qh2o1UqkM/Ni/LvJloMrNzd2bA1BYlrvQRv+AxmfEe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWHoClFLyZX3mCxAH0PW2ZccvCGBjoHDh0WgyOd2Me5oNlpCuAVQeFSjf94diZ96Z
	 YJpEZgu1itLoiYqlh/iq4hOIjVB0nD1Gnc10kzVAUnLDZdEb4lV6xm/dWcqV4nzDVE
	 e767v2Tz2wNq9YdcBaUvzl/H58XJmqr/MU7gjhJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 508/508] RISC-V: KVM: Dont treat SBI HFENCE calls as NOPs
Date: Mon, 23 Jun 2025 15:09:13 +0200
Message-ID: <20250623130657.490176745@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit 2e7be162996640bbe3b6da694cc064c511b8a5d9 ]

The SBI specification clearly states that SBI HFENCE calls should
return SBI_ERR_NOT_SUPPORTED when one of the target hart doesn’t
support hypervisor extension (aka nested virtualization in-case
of KVM RISC-V).

Fixes: c7fa3c48de86 ("RISC-V: KVM: Treat SBI HFENCE calls as NOPs")
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Link: https://lore.kernel.org/r/20250605061458.196003-3-apatel@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi_replace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 304d29383e6c0..1b8b3fa5f74ab 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -113,9 +113,9 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID:
 		/*
 		 * Until nested virtualization is implemented, the
-		 * SBI HFENCE calls should be treated as NOPs
+		 * SBI HFENCE calls should return not supported
+		 * hence fallthrough.
 		 */
-		break;
 	default:
 		ret = -EOPNOTSUPP;
 	}
-- 
2.39.5



