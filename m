Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111371DDCE;
	Tue, 16 Jul 2024 16:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145670; cv=none; b=k/2ATLEn8qmZCTH/gTnYSO1DnPN0jaeu7lE80fwR3s30GaG76LDuHSUrRGyv7vMBNSrwCfF4xVXJh0dm1o1on6sTZMImGIbEFGd1LjaZAy9GnjTa73Ftl6TTvZyddg08f7SlNhfibwPKS8JCCcpnhfNI8Ees+EpqIciilQKdvGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145670; c=relaxed/simple;
	bh=tJrs9q8wfKY+KwkdRymiYpsroCB+FcNstDf6b+CXNxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYx/y0X+nGBtfrlLtfa0UIDzMfZ3EqogCJ+2WPooL86ryimJZGMbpoeLWXy8+RdZMqybLHBCVOPLo9dkOH4vaqzsCyzvrNV/bu+K+e035t365gXGwPdFuxRTaMhMTqOIWxnD2XCodtmLmjxJeu7O1zfzl5px8sYXD1RFdpaB+Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mB9h0fMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mB9h0fMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82383C116B1;
	Tue, 16 Jul 2024 16:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145669;
	bh=tJrs9q8wfKY+KwkdRymiYpsroCB+FcNstDf6b+CXNxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mB9h0fMl2DOgx60IizOj3+s2tMCJ8lArYY/zCUywjvUylcbs6P8tJoQZK/wuXKAHu
	 +d/eK01rjju4nujY9pGDPbyXeYvXMmsZckqzlHqpcnK7r6QibxVRjJarQU0R9SSlRn
	 zrbHRg4LnhugJUjnG9xBaG371YBO5ph8JnTZ6Fhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/121] ARM: davinci: Convert comma to semicolon
Date: Tue, 16 Jul 2024 17:31:46 +0200
Message-ID: <20240716152753.020335054@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8aa39db095d76..2c5155bd376ba 100644
--- a/arch/arm/mach-davinci/pm.c
+++ b/arch/arm/mach-davinci/pm.c
@@ -61,7 +61,7 @@ static void davinci_pm_suspend(void)
 
 	/* Configure sleep count in deep sleep register */
 	val = __raw_readl(pm_config.deepsleep_reg);
-	val &= ~DEEPSLEEP_SLEEPCOUNT_MASK,
+	val &= ~DEEPSLEEP_SLEEPCOUNT_MASK;
 	val |= pm_config.sleepcount;
 	__raw_writel(val, pm_config.deepsleep_reg);
 
-- 
2.43.0



