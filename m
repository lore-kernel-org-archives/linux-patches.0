Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369AD1448C7;
	Thu, 13 Jun 2024 11:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278888; cv=none; b=sG/GJzuBxsuBKpGknSzN6uOZ8YHJtSn/N43H2DTdMGAno0n8muDG0pahiO4MX/yHlub1mnDbjgq4lx+bVEhfDu2qcqmIC+qxfwf28qGNzCx0aAc1N4qO4RxMXiSAhZTSvTiG/6RnInUtrYaSba0q364Ai04yllDsuxxeY0rDkHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278888; c=relaxed/simple;
	bh=UyQeI0OqrTF9oKxfB2XN/7FtmWCyn/4HY3wPwSYkNyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZxeyDZpHFVxwCuR4HWgpeoVIw8zh6YJWXD2O/V+K+7vDYPJ7XSjXnw7FIPl7CtNJ9tdyYNJpI/Yijb4d6ezTaH8dR+trzzrTmeeHS3t7Ui5fnn7nGN+nMnZXQN6EebxYgmGA7P9e9/ywVha9FXvpawotd4ac3e3GE6WsrtoJmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEmpdfpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEmpdfpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F9DC32786;
	Thu, 13 Jun 2024 11:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278888;
	bh=UyQeI0OqrTF9oKxfB2XN/7FtmWCyn/4HY3wPwSYkNyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEmpdfpXtqI3gaJkaNbMgEPqvBCfWfoqk5JPUMT8WA8WM7ocatPFxbVmlMut5eKEr
	 +SQjQ8kPxI4uf+dPsAhMia+h4ep+cD6Eom8MLLjsLTDw1PKAowBhtlkoUcK/kMywWv
	 WhGeFaYnK+1ylVgs4VHJOs98cmIxmUkm5a/ZO+F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/213] extcon: max8997: select IRQ_DOMAIN instead of depending on it
Date: Thu, 13 Jun 2024 13:32:31 +0200
Message-ID: <20240613113231.979319997@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index de15bf55895bd..19a1e32c3a7e9 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -101,7 +101,8 @@ config EXTCON_MAX77843
 
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



