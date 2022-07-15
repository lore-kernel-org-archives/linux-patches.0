Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD474C6A
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 19:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9D7C341CA
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 19:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657912830;
	bh=vrJg913REtBhJXtzjUMzKbDV9ZudnRcOmO8cQm2Itig=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=oOm87DUnu2Uu3I/Cc6dgCIvRFjlOWj9NCs+wDD3E+3gjYm+WbpUXM9ObilMTueulJ
	 1hGCegqVSVVUJKrZdq+WwRQhLBq0WjCW7ZK4kfg6hZcww0gRM1lgRXrfcxa6IbRx5v
	 kBuAjiG3Oz9LRlqtD3XaDfujae4188i/qWNrny8U=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 15 Jul 2022 15:20:30 -0400
Subject: [PATCH v2 2/3] Our version goes to 11
Message-Id: <20220707-my-new-branch-v2-2-c378d618b16b@linuxfoundation.org>
References: <20220707-my-new-branch-v2-0-c378d618b16b@linuxfoundation.org>
In-Reply-To: <20220707-my-new-branch-v2-0-c378d618b16b@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-05523
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Developer-Signature: v=1; a=openpgp-sha256; l=523;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=vrJg913REtBhJXtzjUMzKbDV9ZudnRcOmO8cQm2Itig=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJIu7v0b+Le1su/Ghxs3kt/+O3D11b/rlmcttXibOAx/e19y
 V356qaOUhUGMi0FWTJGlbF/spqDChx5y6T2mMHNYmUCGMHBxCsBE3hox/OEU25LgXuU0eYv4Wo/o60
 Fh/f8Xm1/jyRL5fnvutPsmJSYMf/hWqzhkuev4RCzr+XPwz+37nEnKOtGbrtndbXrOt9NuDx8A
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is not a real commit. I'm using this series as testing ground for
b4 submit.

Acked-by: Lol Whoelse <mricon@kernel.org>
Tested-by: Mister Mismatchy <mricon@kernel.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/Makefile b/Makefile
index 990d2ee79186..51b4bd808d46 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-VERSION = 5
+VERSION = 11
 PATCHLEVEL = 19
 SUBLEVEL = 0
 EXTRAVERSION = -rc5

-- 
b4 0.10.0-dev-05523
