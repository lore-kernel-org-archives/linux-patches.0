Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691C9F9E8;
	Tue, 16 Jul 2024 15:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144473; cv=none; b=tk9p58EcG+KZbEFhZpQJt3/Jdj1f/T11ON0NtUyqQL18jt0cDtemUNhr89yeNzFJJVqn5Oz1miq+RfZvtJlTziisTIKFqAJRfsroLND31u7roMi4qOTZFyzDWSvuPlK+zgh4E6wu4SEGkg7TkNkF+iDkxrIp94FdsxD/tH638ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144473; c=relaxed/simple;
	bh=v90KkQGJtlr95uHfv9m1WY0mUgQPOcbp5wOKusnGMuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1udrzu/ubFPgcpH4MxjGKMCdMKSrnq+oGGWRj+SHxKOt81G6DqxenhYFW8Yd77yJjXgpL/aPtup2nlPJXBVJh8bcfYXLJpra55xJmvrE/3jgSk50eNISOiutniUZytiysX7J9hNDB20wtA+oXNmGY/xVPUzhdxZvuPP2QeoW3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAMWkqaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAMWkqaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3394C116B1;
	Tue, 16 Jul 2024 15:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144473;
	bh=v90KkQGJtlr95uHfv9m1WY0mUgQPOcbp5wOKusnGMuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAMWkqaJhBF+QpXyx3oxieMSMQlp3ZWXCemYg9cF+SBCY2hmV4BnK0abJLY5AZMTw
	 2rQkFI3CarMY8uWxtzjGwEa1Fls/thgZL9VoIL4ONoOeZKRLUmpKuzSyLsbCmgiFb6
	 HEdFTZQRVme0bJ5r9oO5voBzxFDodr2+F8SpTRX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 57/78] ARM: davinci: Convert comma to semicolon
Date: Tue, 16 Jul 2024 17:31:29 +0200
Message-ID: <20240716152742.849102431@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e33c6bcb4598c..bae0a2e07d866 100644
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



