Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A72387368;
	Tue, 10 Mar 2026 11:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140796; cv=none; b=o8XrozlPJukV+Jy9zyP6TduESE928RNLyfMvyCLX2J/zV+OxroXWnMsDVAaKt7v3ZqWFTYud+AQW39nOIliFEHo4L3GJGihF4y8vseDEyhqH4TMExaAiAPrMxoZ+gIYOtn8Z/Zn/dXA1xTnGuipd9F/+pU5F23Rx3tuCeIotL6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140796; c=relaxed/simple;
	bh=xog/9INT4CDDhigivBKMVonYOJSZ2D978RqOiCUxYl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ry+evZyd4LahCDH7m7damD07EalOWvj3JyAwrGGjQ79vZjXMMODhgqGsy6lI54YHqiI88XdeycgMW32ByVhWnK/QSPwvrjzwHTExkX62UXshtc7a51yMABXncQmk7MMUSK78pNblahKwZJfH3ytw/4OqznT8YVgDDAqYKxeaaUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvcy+i/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvcy+i/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1666C2BC86;
	Tue, 10 Mar 2026 11:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140796;
	bh=xog/9INT4CDDhigivBKMVonYOJSZ2D978RqOiCUxYl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvcy+i/VPYaH1llNf0erDVdr1hf+bZsmnf0PGxRzv2TMH+66bUoo+Nd4LrivyicGF
	 geTNmZ0/Z+ii6uUoGqiLByAo6JhpZGt5rBUJYiQjgCn1ciOutmL5Vfbe6LPW5zOKdQ
	 ZiYgrRirnDn/+1exNBwvb6ORgm19N7gklrW/qmi9YvvwYwYGgjaxcTw2jVHVJne2V6
	 QnWoWdNIkJWpSDxZPJuiShO8lfADmyyE1Wh+ptzHzPgLekbnsIIJTiCpPdL44iDG02
	 5fNBd1BrYfOwlvq+NM57hSyD6H7dWdQzOxW0NkSWjrMiukuZpDbx2nAqG1coTQLUq0
	 dxbb7j2pAFxEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Hou <lizhi.hou@amd.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 033/311] accel/amdxdna: Switch to always use chained command
Date: Tue, 10 Mar 2026 07:01:20 -0400
Message-ID: <c944462643de878e3f3c28236456b0558ecd38dc.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit c68a6af400ca80596e8c37de0a1cb564aa9da8a4 ]

Preempt commands are only supported when submitted as chained commands.
To ensure preempt support works consistently, always submit commands in
chained command format.

Set force_cmdlist to true so that single commands are filled using the
chained command layout, enabling correct handling of preempt commands.

Fixes: 3a0ff7b98af4 ("accel/amdxdna: Support preemption requests")
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260206060251.4050512-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 37d05f2e986f9..6378a0bc7b6ea 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -23,9 +23,9 @@
 #include "amdxdna_pci_drv.h"
 #include "amdxdna_pm.h"
 
-static bool force_cmdlist;
+static bool force_cmdlist = true;
 module_param(force_cmdlist, bool, 0600);
-MODULE_PARM_DESC(force_cmdlist, "Force use command list (Default false)");
+MODULE_PARM_DESC(force_cmdlist, "Force use command list (Default true)");
 
 #define HWCTX_MAX_TIMEOUT	60000 /* milliseconds */
 
-- 
2.51.0

