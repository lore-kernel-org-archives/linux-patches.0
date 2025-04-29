Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A747A2517A8;
	Tue, 29 Apr 2025 17:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947440; cv=none; b=T2FfDSg4JLkzDUFVjYYCwYDdzDtdl/Uirzvod0L8t1HTVqQe4yHGLtcpmAQVFFA5oOgfW7cUuaHAjxQHWQsJS92LIhlDP/HRxot4g9FaaCIu5SIEeqWG115JzagHV/KE7RqtqU5Fi4TMetVVNJExWPZ7usPp5djZ8rGbNnI5eII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947440; c=relaxed/simple;
	bh=chbBEeRX4MGusOuWJfJ3TYUy1SyQV3tS5Ul76ryfDwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gt7TWO6pU/J41De4eVyLRklX3AX+j5HIqCKOjmgBfDej8abAozLq+znHsllpa5lrBvi6kpWiheW6Fc/6kG4rZW9pdkLyiaELglx7f20AP37QAf4RY3i5gNUC74faekkWxINw8JqiWCclDEqgLE2shGFKC6THwl6XQzNRligbPvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZLYIUos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZLYIUos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33156C4CEE3;
	Tue, 29 Apr 2025 17:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947440;
	bh=chbBEeRX4MGusOuWJfJ3TYUy1SyQV3tS5Ul76ryfDwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZLYIUosuTGUHHrxRgDrz0J9VwCfXDwHVztxByGc9BVkFq424RWsbJ1n7oxIKYytr
	 GUj6GoYHuI1FtDGqxSqu8nvQnBEH8VHMJEz79LXyObbTHLBeSlu2Du7W9uiMVytDsW
	 dIKB1m1eYm+sH/OznT4njlldVPUeQWXAzGKYDHPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 281/286] MIPS: cm: Fix warning if MIPS_CM is disabled
Date: Tue, 29 Apr 2025 18:43:05 +0200
Message-ID: <20250429161119.470164744@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit b73c3ccdca95c237750c981054997c71d33e09d7 upstream.

Commit e27fbe16af5c ("MIPS: cm: Detect CM quirks from device tree")
introduced

arch/mips/include/asm/mips-cm.h:119:13: error: ‘mips_cm_update_property’
	defined but not used [-Werror=unused-function]

Fix this by making empty function implementation inline

Fixes: e27fbe16af5c ("MIPS: cm: Detect CM quirks from device tree")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/mips-cm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/mips-cm.h
+++ b/arch/mips/include/asm/mips-cm.h
@@ -104,7 +104,7 @@ static inline bool mips_cm_present(void)
 #ifdef CONFIG_MIPS_CM
 extern void mips_cm_update_property(void);
 #else
-static void mips_cm_update_property(void) {}
+static inline void mips_cm_update_property(void) {}
 #endif
 
 /**


