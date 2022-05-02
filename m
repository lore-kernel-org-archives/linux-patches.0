Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0E62F32
	for <patches@lists.linux.dev>; Mon,  2 May 2022 19:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=yRDD6GoS6DAfz3FwxZlLZLO0tBVTGRHb/j6VGwr5CQ0=; b=MKS2c0XpYRCJ2kaFjaby+Vt3yB
	rd9QZibX802Ido5zH+A9szqNuazg4Hfk8uwdwGObp9EZOBmPx8ln5Fy0KHZNiXvrSTnF1ympLVHHs
	sj7YmJGmFsQYAeUXhHB7wWx1xzfHmmlRErsxy2Osx1PXg+YsElY+khV7uAsTuDGgl0CKfL9OHq5sV
	frfioOjjnfeGeSfCE0n1mZL95/YSeXEVaWydPsED9tPoluGpoFuFQiJg7g5JGraNPKNJd/xThZQHd
	pNuHZonyu315dKEcOlYb3TjHTSBQ4HINm3eZb2++9b5kTN02jUL8YDXXwETzLjSiQPosiQ/jcW0RR
	Uh2UOaVg==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nlbjq-002Osb-33; Mon, 02 May 2022 19:29:42 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linuxppc-dev@lists.ozlabs.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Igor Zhbanov <izh1979@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2] powerpc/4xx: cpm: fix return value of __setup handler
Date: Mon,  2 May 2022 12:29:41 -0700
Message-Id: <20220502192941.20955-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from cpm_powersave_off().

Fixes: d164f6d4f910 ("powerpc/4xx: Add suspend and idle support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <izh1979@gmail.com>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
v2: drop some email addresses that bounced;
    change From: Igor to Reported-by: Igor
    update Igor's email address

 arch/powerpc/platforms/4xx/cpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/4xx/cpm.c
+++ b/arch/powerpc/platforms/4xx/cpm.c
@@ -327,6 +327,6 @@ late_initcall(cpm_init);
 static int __init cpm_powersave_off(char *arg)
 {
 	cpm.powersave_off = 1;
-	return 0;
+	return 1;
 }
 __setup("powersave=off", cpm_powersave_off);
