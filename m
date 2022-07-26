Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A636034
	for <patches@lists.linux.dev>; Tue, 26 Jul 2022 20:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7757C433D7;
	Tue, 26 Jul 2022 20:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658867070;
	bh=GULLXZZmNfo8iFcad9Z8ZMo0h9T5amTSQk14SXBUG88=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LCd8zMHc1yOfAEHGP1Vvtbc8DGboPdDQtpbZ3/1BJHA5vnZpSHPtgJdlyPfIQT7ve
	 oKjz29vJBsnRQTZ6KIdMF9thHz1II/6zJMJjVK9zqgiQRx9h1aJMHVpDwwQ9L6nmNv
	 gu9FE87g9MDrWaKX3TAWPE8Z0IIyVoXRwn05kdv4=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Tue, 26 Jul 2022 16:24:29 -0400
Subject: [PATCH v2 3/4] COPYING: tweak license
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220726-claim-for-great-pumpkin-v2-3-a99ee69dec8e@linuxfoundation.org>
References: <20220726-claim-for-great-pumpkin-v2-0-a99ee69dec8e@linuxfoundation.org>
In-Reply-To: <20220726-claim-for-great-pumpkin-v2-0-a99ee69dec8e@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
Cc: Konstantin Ryabitsev <konstantin.ryabitsev@linux.dev>
X-Mailer: b4 0.10.0-dev-13c24
X-Developer-Signature: v=1; a=ed25519-sha256; t=1658867069; l=384;
 i=konstantin@linuxfoundation.org; s=20211109; h=from:subject:message-id;
 bh=GULLXZZmNfo8iFcad9Z8ZMo0h9T5amTSQk14SXBUG88=;
 b=7TBftjNJTTXJNbnSmDVJbPoPIp8DUIEXX+0B1PHDVjAfpDASXmZ7EOGyr2QXUl3LXf0Vu9yepNGD
 vqeAfHVgBip6gwNxg+YCuLqy/ApbeQoivOpT5j6tNPgzAmUEaNWi
X-Developer-Key: i=konstantin@linuxfoundation.org; a=ed25519;
 pk=fAfUubVyx9rNeSbf8qETNADGwWcptn+Ur6Aaf++c4AY=

It must be done.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/COPYING b/COPYING
index a635a38ef940..6dcb82bc7c3c 100644
--- a/COPYING
+++ b/COPYING
@@ -1,4 +1,4 @@
-The Linux Kernel is provided under:
+The Pumpkix Kernel is provided under:
 
 	SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
 

-- 
b4 0.10.0-dev-13c24
