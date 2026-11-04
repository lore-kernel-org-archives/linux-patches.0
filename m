Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831249;
	b=0+FzibvO0uV3ZhfEhRCUN8A7o9wLagg591QVH1c/pVfLNCJDstoAQeyacOzuLunCMcu+
	 A4HbsrAiRlvVgmaxbOcbwD4qok4rENCvqvLZzd8ECZP4mBoM9I7MM9DAahVgcpI/c97w1
	 oAiJLQvp/m+qaxmD1+JxGMwwlZ5B29uyD8BsD+yDf6/n1nm3p02vTtFaRYxrE/i/EDhZo
	 KX1CGBFDB6vuit8WqALyoyAIZWH2Cu30F3aobJm70b5WR9gBGl110roisKpccnGVOtETG
	 wToTtDtdyGgI1ZQFrd9HwM7uxli3IVpDEcyXNl8aE9wcsq4uSfEMJcA3Ph6yVR6B50g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UfRY7YsDFKkhnZXiW7hRnenVMJIsQWD2zrLxOfHR5l4=;
	b=VZQQ7at7K6TxeyzPOH3mZnqrhJO8flNzsUP7xv9mbLUANS5bcXbujz1RjE2GQrLFDNdq
	 2Y2WJEc5puXyjLNb5I3mVlRpORG4WWIhCsZ/os2btXminvivtfkh+ILwxvc5ugwLftomt
	 9tfYD0hr9k/pUJXKFZ5mwpCY9dfycSGp4O8aXo8de+auI+3Aw2Y07KzHXDLzwPi/V6HAH
	 m5iPSyVpAs4T0aVNJ5UGvXTd9LgpnXgo8xgiOhVMPlAgMun4eX2rAGu4eftf5gHkhcGor
	 Vm6JMdnOBSeiCWltLiJWpD2hqlPLBHvYxP6hKSFRTan0LsgoAnN5TdKUe238zDWW0Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lHx5X0e/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7AD606A33E;
	Wed,  4 Nov 2026 22:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lHx5X0e/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A261F000C1;
	Wed,  4 Nov 2026 22:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831249;
	bh=UfRY7YsDFKkhnZXiW7hRnenVMJIsQWD2zrLxOfHR5l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHx5X0e/TOZ3eFBl9LkSGKAwuZNCgIo98vkSmt5qFos04oLDf6KpI95JL+6RCdgRm
	 dBB3OauHwXykub3rK3dm6om+MI7stlz0vzVyXh8ZKO2NUIu2H6RIsony1RFqNO+iVt
	 Kp1r+Tjg8TvwlU78dXORB7NZisbdy4/Wd81MTB+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0551/1005] LoongArch: KVM: Set vcpu->cpu before IN_GUEST_MODE is set
Date: Wed,  4 Nov 2026 16:04:44 -0500
Message-ID: <20261104211059.326589109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 32d05564a6128d59ea876cf9078fe6866a809e14 ]

In function kvm_make_vcpu_request(), it will send IPI to physical CPU
when vCPU is in IN_GUEST_MODE mode. And physical CPU is set in function
kvm_check_vpid(), thus it should be called before IN_GUEST_MODE is set.
Otherwise IPI will send to wrong old physical CPU where vCPU is running.

Cc: stable@vger.kernel.org
Fixes: 2fc3bd86db4b ("LoongArch: KVM: Implement basic vcpu interfaces")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/vcpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index ee969e3957009..e0bd2ceeada4a 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -282,10 +282,10 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 		 */
 		local_irq_disable();
 		kvm_deliver_exception(vcpu);
+		kvm_check_vpid(vcpu);
 		/* Make sure the vcpu mode has been written */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 		kvm_deliver_intr(vcpu);
-		kvm_check_vpid(vcpu);
 
 		/*
 		 * Called after function kvm_check_vpid()
-- 
2.53.0



