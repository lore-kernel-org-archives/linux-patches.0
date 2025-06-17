Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9697C2E8E05;
	Tue, 17 Jun 2025 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178115; cv=none; b=Dhn424W33tijeoufn7N9B3hxZ34pryTvBI+2tdsQEh3vcMvrTi1DKQgweTr+lUe57iNKPM7BQ4cdj6Fe07aza+x5fC66sByFLkDvenG1OaeV6MbrClIRnEx/DL6c9xV8f96H37E2Di4wOjB/63Db6BEe6oM/bNjsqA+4LdE58LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178115; c=relaxed/simple;
	bh=icd3bLlFczpTNQ35MCFX0It+KhV+D6Rfrs9GvZEIkX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELc1IFhTav/c98fPFMOGwDmhpZrzTJGWMpYORnOAl1z6KSt8Q4/uECOqNcK/n/FRZdy7QhTGk1E0VttPL4HvfkE4Q+ho3D6RZD6oicKX0ux7ZVVnvrx9VIdHWxAmM7YOaItmYmS3uZ8TOU+MvsTaRG6xYCzEARUOWV1v+RXvEaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdUut/fI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdUut/fI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A2FC4CEE3;
	Tue, 17 Jun 2025 16:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178115;
	bh=icd3bLlFczpTNQ35MCFX0It+KhV+D6Rfrs9GvZEIkX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdUut/fIzy8mvbK3SizuErBkVEUvyPum3xrS2m6THPgJIWLeXHafjnAF6lXDs+AxM
	 aEeYjgjiDjzNbKKoyi41hq2lk0BldmzK3oQjqYpgxSqRBfAro3LcTUiIT0ddjZtMYe
	 qHoNY/AFh3mP8TSQMJpMHZs83vUDLVEAebr28s7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 412/780] ARM: aspeed: Dont select SRAM
Date: Tue, 17 Jun 2025 17:22:00 +0200
Message-ID: <20250617152508.242155950@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit e4f59f873c3ffe2a0150e11115a83e2dfb671dbf ]

The ASPEED devices have SRAM, but don't require it for basic function
(or any function; there's no known users of the driver).

Fixes: 8c2ed9bcfbeb ("arm: Add Aspeed machine")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://patch.msgid.link/20250115103942.421429-1-joel@jms.id.au
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-aspeed/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-aspeed/Kconfig b/arch/arm/mach-aspeed/Kconfig
index 080019aa6fcd8..fcf287edd0e5e 100644
--- a/arch/arm/mach-aspeed/Kconfig
+++ b/arch/arm/mach-aspeed/Kconfig
@@ -2,7 +2,6 @@
 menuconfig ARCH_ASPEED
 	bool "Aspeed BMC architectures"
 	depends on (CPU_LITTLE_ENDIAN && ARCH_MULTI_V5) || ARCH_MULTI_V6 || ARCH_MULTI_V7
-	select SRAM
 	select WATCHDOG
 	select ASPEED_WATCHDOG
 	select MFD_SYSCON
-- 
2.39.5



