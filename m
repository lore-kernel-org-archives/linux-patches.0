Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDA36030
	for <patches@lists.linux.dev>; Tue, 26 Jul 2022 20:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D37C433B5;
	Tue, 26 Jul 2022 20:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658867069;
	bh=J1itiQ8CeACU/YCqOWAazfhMCQvHObwApFPJR/7qc1Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ExQG3mqObfYOhfFVMhyhHI7VyeD4L8vzjXAQoccWnRWmnikXt889JM8OmCxvwrz7c
	 j73N2r8HqJjrZcYIPs4XpGpkt6WRZI4DXkQof41JRfqOW6vfzzw4PC6/arvaZB6JQc
	 R1uew1pGnfmy/b0F50O281QCTp3nLZUFoQ9nYCUQ=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Tue, 26 Jul 2022 16:24:27 -0400
Subject: [PATCH v2 1/4] Rename into Pumpkix
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220726-claim-for-great-pumpkin-v2-1-a99ee69dec8e@linuxfoundation.org>
References: <20220726-claim-for-great-pumpkin-v2-0-a99ee69dec8e@linuxfoundation.org>
In-Reply-To: <20220726-claim-for-great-pumpkin-v2-0-a99ee69dec8e@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
Cc: Konstantin Ryabitsev <konstantin.ryabitsev@linux.dev>
X-Mailer: b4 0.10.0-dev-13c24
X-Developer-Signature: v=1; a=ed25519-sha256; t=1658867068; l=516;
 i=konstantin@linuxfoundation.org; s=20211109; h=from:subject:message-id;
 bh=J1itiQ8CeACU/YCqOWAazfhMCQvHObwApFPJR/7qc1Q=;
 b=3x+TQZ3sifQLB32XtLz8s8Nf+u/XMAidT9jFG6prdKIA/yyGCK/pkw1uKpExPIswcSZDdudC5MS0
 Ga7XQOOYBMGD/e3KTlisIdQ9iNeM1SVMG7VTJb7d6a0RItwwLRQ8
X-Developer-Key: i=konstantin@linuxfoundation.org; a=ed25519;
 pk=fAfUubVyx9rNeSbf8qETNADGwWcptn+Ur6Aaf++c4AY=

Because why not.

Reviewed-by: Sockpuppet Squirrel <konstantin.ryabitsev@linux.dev>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/README b/README
index 669ac7c32292..4e9414583df9 100644
--- a/README
+++ b/README
@@ -1,5 +1,5 @@
-Linux kernel
-============
+Pumpkix kernel
+==============
 
 There are several guides for kernel developers and users. These guides can
 be rendered in a number of formats, like HTML and PDF. Please read

-- 
b4 0.10.0-dev-13c24
