Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AC319EEA5;
	Tue, 16 Jul 2024 15:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145097; cv=none; b=tPtIwhNfSw/xnggRiFsjOlZR88nkiWMp37vcMLFONwEHlPYNNg3OBA2dM7E6GpGyXZI3YhDhWbjA9m/7XzEXIA7Tmz/3QMqKIAKCsf6V4jXldrDaIJMNCugxWqVVyXBFEOWa12hybeaB4ZXzxfvuDqugd0xQOemqALZ3P7s8I1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145097; c=relaxed/simple;
	bh=mIkIbkx7B1Iw39+r/HcRvbBRoicyj9X9M+KS+A76akQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHDE0H6CZCs76PboHD6+MzRyCNzhyYP3bsSzx2MG47yf3jjDH5eszqUZnEw8kwsxjqgUn0b1pRLbbkngC6mgIPz2G9JCMSixcX+KAstOwI7oNzdOLHBabWPeDr8kYEu4lOQfNDkYCxH6O00s6Zv777c5GuH9htsdbebUBfLoX20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0u83J0OT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0u83J0OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6ABC116B1;
	Tue, 16 Jul 2024 15:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145097;
	bh=mIkIbkx7B1Iw39+r/HcRvbBRoicyj9X9M+KS+A76akQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0u83J0OTL8oa1TTNhJKrxx3kaCSVrJDxBfzl0zQp2smhw4HHs8ts9Z5dDPSu055Vo
	 iYNj72rYdIzhGe1uNP61/b/zT9ZxL6apDXuuqoEL782GHkj+dXvJtMX7bw5u53QJ6M
	 /BgbOeat12rJGLadIeFXxlVaNhZLWmBWyAak9Ibk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 057/143] ARM: davinci: Convert comma to semicolon
Date: Tue, 16 Jul 2024 17:30:53 +0200
Message-ID: <20240716152758.173467308@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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



