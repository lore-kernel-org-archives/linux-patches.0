Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE728838
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8/k/0g/cnB7JjkrJw62pfw7YETy2O4gsL5oxM2+sWXg=; b=nd7BSFiHFERaOSa0SJThwAwJMS
	bbXewyZgxa0XeZgYNC33U2n/qLEgBIMD3UDzFrq4bIhCUC6jfGewKah3QT/gLm6j/tVgx95ergkqv
	cahwvJB84yGe0Dhc+eq7pRz53STsCK/3l2EmN/Ab17V2/29GQ8N4ozL7ZXYGYrZnLmKoqe9lrYnyp
	wlha/IAEtdmNGOxHTq0h/Zao0/oKC3/+UfKw9n7uNq1ZJuULPtANW8MgD4VEuKSFrH2RK3Z69LpfE
	STv+MNARqOh7s0E1BKlBlhNmrBa+WarhclejAJ//sijYv5s4H1LJ7RH57DJdHauD+nqLPxMkbPLKx
	Dq3odsMg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pamAN-00GcMA-32; Fri, 10 Mar 2023 23:28:51 +0000
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
Subject: [PATCH 2/2] ppc: simplify one-level sysctl registration for nmi_wd_lpm_factor_ctl_table
Date: Fri, 10 Mar 2023 15:28:50 -0800
Message-Id: <20230310232850.3960676-3-mcgrof@kernel.org>
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
 arch/powerpc/platforms/pseries/mobility.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index 4cea71aa0f41..2b58e76abef8 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -62,18 +62,10 @@ static struct ctl_table nmi_wd_lpm_factor_ctl_table[] = {
 	},
 	{}
 };
-static struct ctl_table nmi_wd_lpm_factor_sysctl_root[] = {
-	{
-		.procname       = "kernel",
-		.mode           = 0555,
-		.child          = nmi_wd_lpm_factor_ctl_table,
-	},
-	{}
-};
 
 static int __init register_nmi_wd_lpm_factor_sysctl(void)
 {
-	register_sysctl_table(nmi_wd_lpm_factor_sysctl_root);
+	register_sysctl("kernel", nmi_wd_lpm_factor_ctl_table);
 
 	return 0;
 }
-- 
2.39.1

