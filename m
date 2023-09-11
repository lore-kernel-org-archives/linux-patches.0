Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856BE1170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069E6C433C8;
	Mon, 11 Sep 2023 14:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441658;
	bh=Amn0d5cAEvhrxA8oSwFHXgxoKxuFIyOLprJpmrb5iP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d42KSgpt1+/GTZbiRjwOYeKuJJgiid194LzsNuork7qZ2uw/Bq0ufo/d4/1aWp0VC
	 +DzZlRpeHmqgxlODrC/GQY4og1198mibKT3GC0wQxjs8ytYoXNOwp28wJaelzPpViJ
	 G4jfQ7MFfsyjqjNuG/Qsk/oCvql0sl3PS62vqw6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jiri Kosina <jikos@kernel.org>,
	x86@kernel.org,
	Sohil Mehta <sohil.mehta@intel.com>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 490/739] x86/APM: drop the duplicate APM_MINOR_DEV macro
Date: Mon, 11 Sep 2023 15:44:49 +0200
Message-ID: <20230911134704.817160006@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 4ba2909638a29630a346d6c4907a3105409bee7d ]

This source file already includes <linux/miscdevice.h>, which contains
the same macro. It doesn't need to be defined here again.

Fixes: 874bcd00f520 ("apm-emulation: move APM_MINOR_DEV to include/linux/miscdevice.h")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: x86@kernel.org
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Link: https://lore.kernel.org/r/20230728011120.759-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apm_32.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index c6c15ce1952fb..5934ee5bc087e 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -238,12 +238,6 @@
 extern int (*console_blank_hook)(int);
 #endif
 
-/*
- * The apm_bios device is one of the misc char devices.
- * This is its minor number.
- */
-#define	APM_MINOR_DEV	134
-
 /*
  * Various options can be changed at boot time as follows:
  * (We allow underscores for compatibility with the modules code)
-- 
2.40.1



