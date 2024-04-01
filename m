Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A6D43AD6;
	Mon,  1 Apr 2024 16:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987980; cv=none; b=fHctI+U5QwuJlcyU7KjFb9ijnRDzQF/1ng9PI2zXFKq4YQdqhpZ/69OU7VGZ2hp4sOuRk8PLRB29vkIv4NigWgrZ5N9dzhqNOJbZnHFdB1CRqMAHAMc5pgDSFnN28omf83hFZsoJ5R8wQpM10x1TVmKFhE6geZNMuaCrt1PhrHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987980; c=relaxed/simple;
	bh=HTXl59X4OsZvsgEm/b+RfZeNMZgFwiXmjnW0FwoFQAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kg6l6mLFmRFvLENaDbLG0h8TyF96/Olca1Q7RaUb2Ic15dZlQd5JIn5SirTYlxP5FUbQrXg/YD4GvqUHxEv+/kfJO2wOcvEFdVMgnaU+QuMYhe5wjAdOTLmec+ponhCJKrkz6mxJ/erBG3RsnYM+g+99CxanBKWrPoIzC3yJksY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJ2qlZV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJ2qlZV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804BAC433C7;
	Mon,  1 Apr 2024 16:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987980;
	bh=HTXl59X4OsZvsgEm/b+RfZeNMZgFwiXmjnW0FwoFQAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJ2qlZV5p+UFfGRQu+AyntjwBfOIrHEQV78TJRuwNw1EBRKbQh8E0+R4fKQvIoK7f
	 WZMSLU/9nj23OjMO8Pas7sZQm9jgDt0DmvygICSIK0YbmvHcX5CMx/JSScCIVI2XZ/
	 D91DewETIGZD1nErXx5DFYE2TrPYDLzJ+Avsf+8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 049/432] mfd: twl: Select MFD_CORE
Date: Mon,  1 Apr 2024 17:40:36 +0200
Message-ID: <20240401152554.591555797@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 3bb36528d46e494987ee5e9682d08318928ae041 ]

Fix link error:
ld.bfd: drivers/mfd/twl-core.o: in function `twl_probe':
git/drivers/mfd/twl-core.c:846: undefined reference to `devm_mfd_add_devices'

Cc:  <stable@vger.kernel.org>
Fixes: 63416320419e ("mfd: twl-core: Add a clock subdevice for the TWL6032")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20240221143021.3542736-1-alexander.sverdlin@siemens.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 68d71b4b55bd3..f8fdf82238182 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1773,6 +1773,7 @@ config TWL4030_CORE
 	bool "TI TWL4030/TWL5030/TWL6030/TPS659x0 Support"
 	depends on I2C=y
 	select IRQ_DOMAIN
+	select MFD_CORE
 	select REGMAP_I2C
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
-- 
2.43.0



