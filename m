Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0DA198E88;
	Thu,  6 Jun 2024 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682944; cv=none; b=dx33IxXl+dbiw4xF1Rd53Z5HeJPtk9FAagYgwgaKGuT+BuOiTcUQx7Z02vSbF5gtTopa5jDxXrXwZqi8I7sVLLZav9i83oCiD2FxDtmh5eZw7CzNfLsEuIzHr1xffQFn8LI8ccPcRp90fKIVd47+7+qZDPRxYpsMQCEZx4IT72I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682944; c=relaxed/simple;
	bh=P2Bkh6YZyG6vwc+CRgX9z80hMUx4zGDmVIPwRMnA/vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1/Usay8WB4seQbNS1vj1jtdloTM/XIyWsCtP3dOICQUeai/GkA8qV7lsK7YrVN4m/jkVdARAc3FJXu9UfhysXeHxfBRCXW7TL8k4tp3+JyHycH1l67Ke/4ru3+VTzCPi6tvm5gg3cQYMfgVuKdxO/qNHHKjGms7P3+570VGt8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kw/jXtgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kw/jXtgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F92C2BD10;
	Thu,  6 Jun 2024 14:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682943;
	bh=P2Bkh6YZyG6vwc+CRgX9z80hMUx4zGDmVIPwRMnA/vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kw/jXtgOCNZLRHeN+hG1tXaL5S34FvDkCbz4w8gdOH1G0Ldgs7CBGntsehjBaI3Cg
	 ni2Hf8RiynNqnHymEram0w8OQKznLFc/VS1GoK0nUDxmDRfMYTN8q8X47wIaZdu4He
	 +F7VgTF59Cf5ckRGkzJhUUDMsprykBtu3vzU4xM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 094/374] extcon: max8997: select IRQ_DOMAIN instead of depending on it
Date: Thu,  6 Jun 2024 16:01:13 +0200
Message-ID: <20240606131655.052347775@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b1781d0a1458070d40134e4f3412ec9d70099bec ]

IRQ_DOMAIN is a hidden (not user visible) symbol. Users cannot set
it directly thru "make *config", so drivers should select it instead
of depending on it if they need it.
Relying on it being set for a dependency is risky.

Consistently using "select" or "depends on" can also help reduce
Kconfig circular dependency issues.

Therefore, change EXTCON_MAX8997's use of "depends on" for
IRQ_DOMAIN to "select".

Link: https://lore.kernel.org/lkml/20240213060028.9744-1-rdunlap@infradead.org/
Fixes: dca1a71e4108 ("extcon: Add support irq domain for MAX8997 muic")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 5f869eacd19ab..3da94b3822923 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -116,7 +116,8 @@ config EXTCON_MAX77843
 
 config EXTCON_MAX8997
 	tristate "Maxim MAX8997 EXTCON Support"
-	depends on MFD_MAX8997 && IRQ_DOMAIN
+	depends on MFD_MAX8997
+	select IRQ_DOMAIN
 	help
 	  If you say yes here you get support for the MUIC device of
 	  Maxim MAX8997 PMIC. The MAX8997 MUIC is a USB port accessory
-- 
2.43.0



