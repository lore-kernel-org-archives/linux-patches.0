Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3876028
	for <patches@lists.linux.dev>; Tue, 26 Jul 2022 19:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A159C433B5;
	Tue, 26 Jul 2022 19:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658864797;
	bh=GULLXZZmNfo8iFcad9Z8ZMo0h9T5amTSQk14SXBUG88=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=0InLgc9TdU3XjUuE4ahbIGhK8nTT3WPc7vW98Ho6mdDPxXIokZRDDurm0amZgbwfU
	 Rjyqw9fIEGBlD7+MZ3aMZhHnnDIGYZN5T57DseMYhiXPEmcgPRiBdutF8BrkK8pqMw
	 5Z49hLftmUASNCIPeBhZ+M4bLVrhgQjxp4Iv45Z4=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Tue, 26 Jul 2022 15:46:29 -0400
Subject: [PATCH v1 3/3] COPYING: tweak license
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220726-claim-for-great-pumpkin-v1-3-cba88581a0b0@linuxfoundation.org>
References: <20220726-claim-for-great-pumpkin-v1-0-cba88581a0b0@linuxfoundation.org>
In-Reply-To: <20220726-claim-for-great-pumpkin-v1-0-cba88581a0b0@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
Cc: Konstantin Ryabitsev <konstantin.ryabitsev@linux.dev>
X-Mailer: b4 0.10.0-dev-13c24
X-Developer-Signature: v=1; a=ed25519-sha256; t=1658864797; l=384;
 i=konstantin@linuxfoundation.org; s=20211109; h=from:subject:message-id;
 bh=GULLXZZmNfo8iFcad9Z8ZMo0h9T5amTSQk14SXBUG88=;
 b=tiLEkETf6a2FseiijaUZjHO6ZS1il9a/oj3fV6smvyweis8GNZl8GZd2N/cGE6GeFAlhv/xzRV8G
 HC6rakRFDj39llsqwO4GZwNm0c+/llEg4yqK64VGwkR5MyfQV4px
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
