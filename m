Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE2A1DDCE;
	Tue, 16 Jul 2024 16:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146317; cv=none; b=ugvsUobW20eLsSKvTrgCcosvai2SXv1n6L4ZN/QI2CLKxXmAiBU4RwtiEuRTA9FiCXoXrLSPl3HaBFmamgYVSWg40bNO77GfdGz5OzQX2MqjtGrkYw7cPqPFzlF55YpCE4nCfoi2GOE9Rf+Zn4h8lLFA0SZNyuvlhSa4XqQrT/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146317; c=relaxed/simple;
	bh=86KBHfXZLR8GAmnIbAr7lyTTffqM1+UeaIVPshtpeqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRk43UEwo8bLr+/1+79NTN7lZPK6Hngo/n6YF9OPSWvc6B+XMkMj5z/DKHRWbU44jYhnza/fqOxEsJ8KW8REclfF5oqu1yR6lVY7qW66zAna/KaLG4h089luFHhpE5EuXOgFiZaNt0yVuE0RKTmVpBBIe2LxtG2O1iLTQQFJiss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9hGcT9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9hGcT9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75425C116B1;
	Tue, 16 Jul 2024 16:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146316;
	bh=86KBHfXZLR8GAmnIbAr7lyTTffqM1+UeaIVPshtpeqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9hGcT9AmONTHBbQLEDNEA3sM7EIjNsSZG7MF4nott/v3g77ZYJtpEbQZc4ZmVe6W
	 N2FbNaIS9ZWnpWykXWSfu4ka58Tc6DojOa4ghnxjDPj7w7ZcWY76N96lNSEEYVGKhg
	 nddu/21M3GlIhaXB6aP/eXhaXS2+LCZ7xNrpz8IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/144] ARM: davinci: Convert comma to semicolon
Date: Tue, 16 Jul 2024 17:32:45 +0200
Message-ID: <20240716152756.229157257@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit acc3815db1a02d654fbc19726ceaadca0d7dd81c ]

Replace a comma between expression statements by a semicolon.

Fixes: efc1bb8a6fd5 ("davinci: add power management support")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/pm.c b/arch/arm/mach-davinci/pm.c
index 323ee4e657c45..94d7d69b9db7c 100644
--- a/arch/arm/mach-davinci/pm.c
+++ b/arch/arm/mach-davinci/pm.c
@@ -62,7 +62,7 @@ static void davinci_pm_suspend(void)
 
 	/* Configure sleep count in deep sleep register */
 	val = __raw_readl(pm_config.deepsleep_reg);
-	val &= ~DEEPSLEEP_SLEEPCOUNT_MASK,
+	val &= ~DEEPSLEEP_SLEEPCOUNT_MASK;
 	val |= pm_config.sleepcount;
 	__raw_writel(val, pm_config.deepsleep_reg);
 
-- 
2.43.0



