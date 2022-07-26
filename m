Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C2A6027
	for <patches@lists.linux.dev>; Tue, 26 Jul 2022 19:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB53BC433D7;
	Tue, 26 Jul 2022 19:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658864796;
	bh=7gd54/nbcaRoM9aB30mFVnqiO7PL2uNVeOxIWqSYP+4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mBEDUfMMxJ80PayXJqTLDagiJQ9ZSJhiy8NmRsYwmAtBxPUhjgMrxfm1SYVuTLAJi
	 4+oIYpSyO561j8/3OQwoiBfHWSjEQEr458bmybiAwmb4yRI3f+zFnqrlRBSD6elJbZ
	 EMEsJI1uOosDeOnWksTn1nbaiQ9mEYrIxxkBsvOk=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Tue, 26 Jul 2022 15:46:28 -0400
Subject: [PATCH v1 2/3] Makefile: Let's start our version at 200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220726-claim-for-great-pumpkin-v1-2-cba88581a0b0@linuxfoundation.org>
References: <20220726-claim-for-great-pumpkin-v1-0-cba88581a0b0@linuxfoundation.org>
In-Reply-To: <20220726-claim-for-great-pumpkin-v1-0-cba88581a0b0@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
Cc: Konstantin Ryabitsev <konstantin.ryabitsev@linux.dev>
X-Mailer: b4 0.10.0-dev-13c24
X-Developer-Signature: v=1; a=ed25519-sha256; t=1658864796; l=493;
 i=konstantin@linuxfoundation.org; s=20211109; h=from:subject:message-id;
 bh=7gd54/nbcaRoM9aB30mFVnqiO7PL2uNVeOxIWqSYP+4=;
 b=AQ3x6muqnYdOiBP7fYth8ovsl/vpYITpt3FM+We5suT1g7dYcoPsHC3NNUpLx3chzIz60Pfr+WyM
 MuiUxmRcAYIoKxF2qq4wIaNIKsRqfSmBk3K6VxjkRdJE9iFGwx2Z
X-Developer-Key: i=konstantin@linuxfoundation.org; a=ed25519;
 pk=fAfUubVyx9rNeSbf8qETNADGwWcptn+Ur6Aaf++c4AY=

Because why not 200?

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/Makefile b/Makefile
index b79c1c18149d..18f749d988e8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,9 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
-VERSION = 5
+VERSION = 200
 PATCHLEVEL = 19
 SUBLEVEL = 0
 EXTRAVERSION = -rc8
-NAME = Superb Owl
+NAME = Great Pumpkin
 
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"

-- 
b4 0.10.0-dev-13c24
