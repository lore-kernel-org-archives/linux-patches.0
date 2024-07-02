Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886BC15218A;
	Tue,  2 Jul 2024 17:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940317; cv=none; b=nsOW23mo9qhJsMdtG8NOuyGPN0NC39BLBUSrg5sjRMzWCdqNMSHwxYZ/SUpnkifJHfZI3LW24Ny2dadqXikd4N/dDjUE++lANzGfS7TQbRbIdGkoQ96GXdIZgzp/sYVmbJ4X7/oW6Ot4Mw3nDjdMlsS4d0tbEC0Q9B7EJ2H+1Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940317; c=relaxed/simple;
	bh=J36xiiIEOCnuF3Q4ovoEPTkPuImhkn4TamV1WhsfQ9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pktt/55kX8A0w3wfuAc1+7yXiga8u13loRCSJwWZfd6EPwpbn+RtHt7gaGVKEArR9mgAcdG6nMDmXDkYb/asOds+J5GuBDDx36Y5Ly1KuexCBaYmGQY3Db6xqWqi3Rm68SDDsr4GLgd5yccq0W65p9eX1gqC8miDm9UE4UetNcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tS6PBTT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tS6PBTT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A7FC4AF0A;
	Tue,  2 Jul 2024 17:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940317;
	bh=J36xiiIEOCnuF3Q4ovoEPTkPuImhkn4TamV1WhsfQ9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tS6PBTT8j1BrCZszWZcL+yNhbuo50UgrP8BWXT6qY6EZJVk8HQdeHxV2CfDAD4+Gf
	 m1hW8v8CX91F64JGtyEtu41+z3HoIRQGBO6JI8qJTXthSI/Fn3WiJxIGNwNJrrWbXB
	 SQVlM+kemalGw1HxgMbkTurf/uyfskhgGeqUa3eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 087/222] irqchip/loongson: Select GENERIC_IRQ_EFFECTIVE_AFF_MASK if SMP for IRQ_LOONGARCH_CPU
Date: Tue,  2 Jul 2024 19:02:05 +0200
Message-ID: <20240702170247.302391657@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 42a7d887664b02a747ef5d479f6fd01081564af8 ]

An interrupt's effective affinity can only be different from its configured
affinity if there are multiple CPUs. Make it clear that this option is only
meaningful when SMP is enabled. Otherwise, there exists "WARNING: unmet
direct dependencies detected for GENERIC_IRQ_EFFECTIVE_AFF_MASK" when make
menuconfig if CONFIG_SMP is not set on LoongArch.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240326121130.16622-3-yangtiezhu@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 72c07a12f5e18..bfa1d77749f3e 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -568,7 +568,7 @@ config IRQ_LOONGARCH_CPU
 	bool
 	select GENERIC_IRQ_CHIP
 	select IRQ_DOMAIN
-	select GENERIC_IRQ_EFFECTIVE_AFF_MASK
+	select GENERIC_IRQ_EFFECTIVE_AFF_MASK if SMP
 	select LOONGSON_HTVEC
 	select LOONGSON_LIOINTC
 	select LOONGSON_EIOINTC
-- 
2.43.0



