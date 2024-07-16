Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9DE1DA4D;
	Tue, 16 Jul 2024 15:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144774; cv=none; b=A/+L6iU2nk+2MeoDDcPJ8BXiVAyD6nq2QSzjkFKDQGgkWWHHRwx+ykwLH97PcGMtA781pHDtst+nEvrApQlYMG5i5V4yuqUVnqds40MvW5UYzaby2m1EZY5ZLK+QENHvUSVZF8nNSkyhp796mguMOxdwzdbbQqpByAEZ7/zl7dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144774; c=relaxed/simple;
	bh=nyp4ZMJXSG0ckSDr3wVck9f2sngwWWccIGP72NT5teA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EagfC4PkROGC5vS/vQ4uam8J9cznzWzCtMAxnAdJW2vTTr63XviMBJC53Mji3Ivk8Rhmkfp7vRio/d3xO9HNCBNiFsNI/sAXVfumz/q29X9O5MS27OnFg+iRUkHDTwAyXo08JbYmvWpRHvmOx1nYNTt6SwYYTwppo/5JzEwiCQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdwXIoye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdwXIoye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7DBC116B1;
	Tue, 16 Jul 2024 15:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144774;
	bh=nyp4ZMJXSG0ckSDr3wVck9f2sngwWWccIGP72NT5teA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdwXIoye5dDK2HUC6t2HwVsfHhqFOHbXwOPx8n2oz7Phchq+42bYCMNAN7Uto/PtD
	 7pIRvd/RjOfpR99NoTmC1rLckkPjvdGfHsOttANQsTFMs07JlaJVOWnkGwT0YLxn+y
	 uKLkjEPwNujijQm8W81kyhY8Wz8T5sQnQY5B6/Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/108] ARM: davinci: Convert comma to semicolon
Date: Tue, 16 Jul 2024 17:31:26 +0200
Message-ID: <20240716152748.708010966@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



