Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58BB1AF0C8;
	Wed, 19 Feb 2025 08:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953904; cv=none; b=UhwJ04YTJS5aLM9YXyv34PmQ3WUZOPFsm5YSmOPi/7LziSz3d/SM21t5Rw0l52lG1qf+4yADgUE/nG0N9C/h34i1UckasHo6cjlcE+GvYsO97s7hmUQDf/TDx0UHi9iNDAaB7HMv2KvVNB1D01nraelQ3wZd3e43DIkkbQrFNd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953904; c=relaxed/simple;
	bh=/JZ4h2bV4j9rvJ74SbHmLqQjqIAMH542/EAsdFMdqGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjoMK66shMobL0EuoQqD1RcSR1t72Y/aBGWiLyaWiLWiJ4qGB/ltroOqJzP5XFYnmtvLCxHsCoKFwuNPW3wTGnnVdNGfiWN52PKGSb5Q+JDs3lLYe5sWQGiMQrEA6Psf15Ivyp4ilFqZcOyWpQ44aHZk5iQ7mKWu3YBJucFWqI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+qIr2Do; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+qIr2Do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F5FC4CED1;
	Wed, 19 Feb 2025 08:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953903;
	bh=/JZ4h2bV4j9rvJ74SbHmLqQjqIAMH542/EAsdFMdqGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+qIr2DoaV9CI/RRkb6h8g2yB4k41js/GJ9Z4VdXW7XVNzRUOBUFbEazvwB0HhaoA
	 tc/OUUEPasdxA+EATS/FYFQ8Z9aDGlaNYtTT10JcgG7+u7eKz9bbzoZ3V5CLyK/IFY
	 KhOkt9IkhwvJC4nPviiBF2zkRRAV59Jq72kaLQKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 032/274] LoongArch: KVM: Fix typo issue about GCFG feature detection
Date: Wed, 19 Feb 2025 09:24:46 +0100
Message-ID: <20250219082610.788623878@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit bdb13252e5d1518823b81f458d9975c85d5240c2 ]

This is typo issue and misusage about GCFG feature macro. The code
is wrong, only that it does not cause obvious problem since GCFG is
set again on vCPU context switch.

Fixes: 0d0df3c99d4f ("LoongArch: KVM: Implement kvm hardware enable, disable interface")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 396fed2665a51..034402e0948c9 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -285,9 +285,9 @@ int kvm_arch_enable_virtualization_cpu(void)
 	 * TOE=0:       Trap on Exception.
 	 * TIT=0:       Trap on Timer.
 	 */
-	if (env & CSR_GCFG_GCIP_ALL)
+	if (env & CSR_GCFG_GCIP_SECURE)
 		gcfg |= CSR_GCFG_GCI_SECURE;
-	if (env & CSR_GCFG_MATC_ROOT)
+	if (env & CSR_GCFG_MATP_ROOT)
 		gcfg |= CSR_GCFG_MATC_ROOT;
 
 	write_csr_gcfg(gcfg);
-- 
2.39.5



