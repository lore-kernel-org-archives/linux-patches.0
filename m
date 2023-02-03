Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F9E1FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6CDC433EF;
	Fri,  3 Feb 2023 10:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419351;
	bh=ci2wQ74Ka6aZRuRC4wL+H/8zkWkpnEHNMXxW19TnQWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrLs+4BuLNw2iywtnE9XxHABwlyRPOpqUYrgDkzLU3PJ15zj8Nz8205AutIOF1nJm
	 O91iNmrRUu/BVCpSdRwsRTQcdEhULL6jx+GhZ63Zt05TNSrIfigawJGlYmoRapp/LB
	 4R/Nqn+1Ma9rKmZHMtIqcrU3eiAkqmBF7ywgX3as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev
Subject: [PATCH 4.14 40/62] xen: Fix up build warning with xen_init_time_ops() reference
Date: Fri,  3 Feb 2023 11:12:36 +0100
Message-Id: <20230203101014.695568832@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Somehow the xen_init_time_ops() reference got out of sync in the 4.14.y
tree (or it never was in sync), and now there's a build warning.  Fix
that up by making xen_init_time_ops() be __init, not __ref.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 03706331f567..8ecc38110bcc 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -516,7 +516,7 @@ static void __init xen_time_init(void)
 		pvclock_gtod_register_notifier(&xen_pvclock_gtod_notifier);
 }
 
-void __ref xen_init_time_ops(void)
+void __init xen_init_time_ops(void)
 {
 	xen_sched_clock_offset = xen_clocksource_read();
 	pv_time_ops = xen_time_ops;
-- 
2.39.1



