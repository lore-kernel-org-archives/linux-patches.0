Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FE62F32
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SD1ieuBB125zMGdksrzDPRIQXff3+i91moAFOeOqJ9o=; b=t0gjE6ECv+RuYMMxdo687dGQwg
	rUuAqEL8BS4ufYj0nj2Owt17YHA7krkRaJKpaAfDpmK8rGM1SBa8xN131ZucPBytAZtvECBxrI0WZ
	1+dylZIy2WQaYYuAaS9+UhZ6xFb/FIKFtPtqcfWHPzbeupN7fXZ43hcfFzcd5sS2eantFNO5WcnHw
	EQJEvVLfeNLpNsDkuWrET6kFk6XebXa1a6B1oHu/ex6Bl9aLDux29hKV7PoMdr3PcWkVj1eckXEtq
	L9PhWujRIwPIns84tBzlrmDvVkPF7AePfyRo3M6XBKeM9l0jBOJgDntXGDOFUdclj9znaWiJE05Kd
	J6ZfweKg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pamAN-00GcM8-1m; Fri, 10 Mar 2023 23:28:51 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: mpe@ellerman.id.au,
	npiggin@gmail.com,
	christophe.leroy@csgroup.eu
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 1/2] ppc: simplify one-level sysctl registration for powersave_nap_ctl_table
Date: Fri, 10 Mar 2023 15:28:49 -0800
Message-Id: <20230310232850.3960676-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230310232850.3960676-1-mcgrof@kernel.org>
References: <20230310232850.3960676-1-mcgrof@kernel.org>
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
 arch/powerpc/kernel/idle.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index b9a725abc596..b1c0418b25c8 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -107,19 +107,11 @@ static struct ctl_table powersave_nap_ctl_table[] = {
 	},
 	{}
 };
-static struct ctl_table powersave_nap_sysctl_root[] = {
-	{
-		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= powersave_nap_ctl_table,
-	},
-	{}
-};
 
 static int __init
 register_powersave_nap_sysctl(void)
 {
-	register_sysctl_table(powersave_nap_sysctl_root);
+	register_sysctl("kernel", powersave_nap_ctl_table);
 
 	return 0;
 }
-- 
2.39.1

