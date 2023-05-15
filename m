Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C5B17730
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAE2C433D2;
	Mon, 15 May 2023 18:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173912;
	bh=FWrdJUOVDUfaF82ePCRRUrLyhKUa8xyRp8tooUuq0sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAXz1jKeYPZ87Aj59JkxND8EqmKVR/7PAbz6f0hOL1SiYr9Jfo6dDEtDwHt38bg6I
	 xeNgs/fZEfcPICb5NEDpkwfPehtzscvfCzkdKBJAHeUFocknCnjyr1kfbuBDCTjrdj
	 tE9/HZPNw1mp0Uu+4+PodcMveF7S1imEYOYC1O6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Igor Zhbanov <izh1979@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	linux-sh@vger.kernel.org
Subject: [PATCH 5.4 247/282] sh: nmi_debug: fix return value of __setup handler
Date: Mon, 15 May 2023 18:30:25 +0200
Message-Id: <20230515161729.665565349@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

commit d1155e4132de712a9d3066e2667ceaad39a539c5 upstream.

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from nmi_debug_setup().

Fixes: 1e1030dccb10 ("sh: nmi_debug support.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <izh1979@gmail.com>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: linux-sh@vger.kernel.org
Cc: stable@vger.kernel.org
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/20230306040037.20350-3-rdunlap@infradead.org
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sh/kernel/nmi_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sh/kernel/nmi_debug.c
+++ b/arch/sh/kernel/nmi_debug.c
@@ -49,7 +49,7 @@ static int __init nmi_debug_setup(char *
 	register_die_notifier(&nmi_debug_nb);
 
 	if (*str != '=')
-		return 0;
+		return 1;
 
 	for (p = str + 1; *p; p = sep + 1) {
 		sep = strchr(p, ',');
@@ -70,6 +70,6 @@ static int __init nmi_debug_setup(char *
 			break;
 	}
 
-	return 0;
+	return 1;
 }
 __setup("nmi_debug", nmi_debug_setup);


