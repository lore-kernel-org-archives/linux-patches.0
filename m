Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90AB4502A
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 23:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758843977; cv=none; b=fPKUba8IqPxUC8AKArW/2JYuhgo25wapyMHqXr2eCwOulKC6jVPrM+4MQWJWqIfarBj8qapmjiqqz6AVPglXDE2qsX+ExwtLL4IRhdY33wCzSy5C0UiYaQH2A7aCO1vPFeB0C9MBCrVBH8NUTKa/oSMooOwGaYKW/0Dsmgb+5L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758843977; c=relaxed/simple;
	bh=jy6XpX73dzULscHEsspzWI272121ql+W/8qzRykVrYw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OKtxSChd98IG1KeCzAJUa7ebbQK7eEfmgN+SB2TFrEHMXVU58NxJRtk93+Fdiqsp6Q8PAbhwBQ1Dlj8tYXHcqgLcYF8T1V+URquIcE+AxUhxO4nXoPCJdNi5kNH1Q9WJCZktYw4P6LKtmGXO3u++BhX8SHDZx/7S4iiT+aOij64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jW8SEeu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jW8SEeu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3096FC4CEF5;
	Thu, 25 Sep 2025 23:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758843976;
	bh=jy6XpX73dzULscHEsspzWI272121ql+W/8qzRykVrYw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jW8SEeu/EqILn9p3g3Lc3UEpDoC65BCidi263ce7vw1jhKXx0XuNnFeTK+KLQivpy
	 PXtMEapZ7EpiVFCc1kUHLc7tafQOv0neAjpa7Mm+lAIir1AVyIGguWRm0Ny+AZzHeN
	 b4q/7z7dBxivOkf4wsBAKOfYE1F3dqR81nOavq3CDk7l0mU/lP885FW9gr3vE3urOH
	 V3Hh4/qoPY7647RmF0nxVsns6ReqUxidoPkAh3BXsaRU8WiYNsowqg7AseifHrmBRr
	 Z1Hj/wgPfl7K37YPYEO57MYmdMENJX5FExuUwDGINC5hflPiZJcaWY+5hYRoN+JV9E
	 uAAkrTPHd78IA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 25 Sep 2025 19:46:06 -0400
Subject: [PATCH 1/2] powerpc/powermac: Include linux/of.h in backlight.c
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-1-d256858d86a6@kernel.org>
References: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
In-Reply-To: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
To: Lee Jones <lee@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Daniel Thompson <danielt@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Simona Vetter <simona.vetter@ffwll.ch>, linuxppc-dev@lists.ozlabs.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2082; i=nathan@kernel.org;
 h=from:subject:message-id; bh=jy6XpX73dzULscHEsspzWI272121ql+W/8qzRykVrYw=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBlXrzjZcf9vrA8PmPpkgfqyNC2FO5cC3l5k2B63qps/l
 W/1rolrOkpZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEQpgZGSYsUPcycnfwl6ks
 017xcMPy+JlXtYxYTVfEHbZZKMQjtJbhn+m/Mz8YL+oKxXHu7Jphy6m4IP7xTY0VS3+uLSp3dvu
 WzAkA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After the recent removal of the fb.h include from backlight.h, which
transitively included of.h, there are several errors in the powermac backlight
driver:

  arch/powerpc/platforms/powermac/backlight.c: In function 'pmac_has_backlight_type':
  arch/powerpc/platforms/powermac/backlight.c:59:39: error: implicit declaration of function 'of_find_node_by_name'; did you mean 'bus_find_device_by_name'? [-Wimplicit-function-declaration]
     59 |         struct device_node* bk_node = of_find_node_by_name(NULL, "backlight");
        |                                       ^~~~~~~~~~~~~~~~~~~~
        |                                       bus_find_device_by_name
  arch/powerpc/platforms/powermac/backlight.c:59:39: error: initialization of 'struct device_node *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
  arch/powerpc/platforms/powermac/backlight.c:60:17: error: implicit declaration of function 'of_property_match_string' [-Wimplicit-function-declaration]
     60 |         int i = of_property_match_string(bk_node, "backlight-control", type);
        |                 ^~~~~~~~~~~~~~~~~~~~~~~~
  arch/powerpc/platforms/powermac/backlight.c:62:9: error: implicit declaration of function 'of_node_put' [-Wimplicit-function-declaration]
     62 |         of_node_put(bk_node);
        |         ^~~~~~~~~~~

Explicitly include of.h to resolve the errors.

Fixes: 9f218f9bb9d2 ("backlight: Do not include <linux/fb.h> in header file")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/platforms/powermac/backlight.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/powermac/backlight.c b/arch/powerpc/platforms/powermac/backlight.c
index 79741370c40c..9afb64723649 100644
--- a/arch/powerpc/platforms/powermac/backlight.c
+++ b/arch/powerpc/platforms/powermac/backlight.c
@@ -14,6 +14,7 @@
 #include <linux/pmu.h>
 #include <linux/atomic.h>
 #include <linux/export.h>
+#include <linux/of.h>
 #include <asm/backlight.h>
 
 #define OLD_BACKLIGHT_MAX 15

-- 
2.51.0

