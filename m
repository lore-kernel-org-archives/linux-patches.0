Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BCABA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F076AC433D2;
	Tue,  7 Mar 2023 18:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213504;
	bh=P4tDWW0Z0TMN3K+XqbQ72yqJtZe9x/jttgJIqnVgMI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKOxqzagyqx13bHLPk6DCaezqlrQshm6SJrj6rS5BMzSh1/2Cyt2HNpQFObVbvWFw
	 M924xPGexxMWr2WhuE/h1DcdRQaikaCC/0ynMYapn+4kV07bck8f5nN/seLdcFFfW/
	 ns0fz8sfXL6hrO53kg+3Q6JuaeoAMtfp2MqX/IvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 527/885] ARM: OMAP2+: omap4-common: Fix refcount leak bug
Date: Tue,  7 Mar 2023 17:57:41 +0100
Message-Id: <20230307170025.362870118@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liang He <windhl@126.com>

[ Upstream commit 7c32919a378782c95c72bc028b5c30dfe8c11f82 ]

In omap4_sram_init(), of_find_compatible_node() will return a node
pointer with refcount incremented. We should use of_node_put() when
it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Message-Id: <20220628112939.160737-1-windhl@126.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap4-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 6d1eb4eefefe5..d9ed2a5dcd5ef 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -140,6 +140,7 @@ static int __init omap4_sram_init(void)
 			__func__);
 	else
 		sram_sync = (void __iomem *)gen_pool_alloc(sram_pool, PAGE_SIZE);
+	of_node_put(np);
 
 	return 0;
 }
-- 
2.39.2



