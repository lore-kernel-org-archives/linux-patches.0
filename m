Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E48AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EDAC433D2;
	Wed,  4 Jan 2023 16:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849202;
	bh=o+z/HO3mYJ6hbuTxBezOeImd34Tgq1zLH5BVukxMeLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdMhmmkv8XB2YYyLhWFNShdVLgUzAKg3MMmKETUC8oVhl0n5dIhrmAuI6BL1dlv+a
	 LHMEJlDGZ12OnoU4WhN1cRNCDEmkqOT1Km1LH9wZjkg3f/ykusIJHH9Lh7l+KDaAMp
	 58mFsbYyno7bBdvmfhseNX/gbtCwJLdMRu4e5hco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 150/207] parisc: Drop duplicate kgdb_pdc console
Date: Wed,  4 Jan 2023 17:06:48 +0100
Message-Id: <20230104160516.657308276@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit 7e6652c79ecd74e1112500668d956367dc3772a5 upstream.

The kgdb console is already implemented and registered in pdc_cons.c,
so the duplicate code can be dropped.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # 6.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/kgdb.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/parisc/kernel/kgdb.c b/arch/parisc/kernel/kgdb.c
index ab7620f695be..b16fa9bac5f4 100644
--- a/arch/parisc/kernel/kgdb.c
+++ b/arch/parisc/kernel/kgdb.c
@@ -208,23 +208,3 @@ int kgdb_arch_handle_exception(int trap, int signo,
 	}
 	return -1;
 }
-
-/* KGDB console driver which uses PDC to read chars from keyboard */
-
-static void kgdb_pdc_write_char(u8 chr)
-{
-	/* no need to print char. kgdb will do it. */
-}
-
-static struct kgdb_io kgdb_pdc_io_ops = {
-	.name		= "kgdb_pdc",
-	.read_char	= pdc_iodc_getc,
-	.write_char	= kgdb_pdc_write_char,
-};
-
-static int __init kgdb_pdc_init(void)
-{
-	kgdb_register_io_module(&kgdb_pdc_io_ops);
-	return 0;
-}
-early_initcall(kgdb_pdc_init);
-- 
2.39.0



