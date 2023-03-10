Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CB78838
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=W5CkyZqwpXK0guxscdXqblrjimKCSpeT3+UESPQJLyc=; b=jaGse98W/kVZnbkxIDlAa5Drtm
	ECzv1p4Va1Hgmq7iQInbYEWIWvG0pU3LUqjB7qxhyWsFe4plRrao8z4nx91dk03I/JOV8xTn9WZSI
	Ck0ltx/i1X071oSNI6mK4vYVD7EW7qT28k10RGrJy3sSkZ9WQjtl15yeQJQR0i8zWxFWmt1soS/EO
	s6Iybcdyqzkn9FQzrTTYGuritihgr9N2iHV+sZMvBJgCo9thoieew7QXBQA1M3r2rkBwvC/+v9kVw
	2WDNkESPCXQlstFXilVEN2DwjsZsU1VpPXXo/1HSZmC0beYK1x8hrsqCpocYLNk7bfwRPky4ukBzL
	RtR+37YA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pamED-00Gdb1-UP; Fri, 10 Mar 2023 23:32:49 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: luto@kernel.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 1/2] x86: simplify one-level sysctl registration for abi_table2
Date: Fri, 10 Mar 2023 15:32:47 -0800
Message-Id: <20230310233248.3965389-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230310233248.3965389-1-mcgrof@kernel.org>
References: <20230310233248.3965389-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

There is no need to declare an extra tables to just create directory,
this can be easily be done with a prefix path with register_sysctl().

Simplify this registration.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 arch/x86/entry/vdso/vdso32-setup.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32-setup.c b/arch/x86/entry/vdso/vdso32-setup.c
index 3b300a773c7e..f3b3cacbcbb0 100644
--- a/arch/x86/entry/vdso/vdso32-setup.c
+++ b/arch/x86/entry/vdso/vdso32-setup.c
@@ -70,18 +70,9 @@ static struct ctl_table abi_table2[] = {
 	{}
 };
 
-static struct ctl_table abi_root_table2[] = {
-	{
-		.procname = "abi",
-		.mode = 0555,
-		.child = abi_table2
-	},
-	{}
-};
-
 static __init int ia32_binfmt_init(void)
 {
-	register_sysctl_table(abi_root_table2);
+	register_sysctl("abi", abi_table2);
 	return 0;
 }
 __initcall(ia32_binfmt_init);
-- 
2.39.1

