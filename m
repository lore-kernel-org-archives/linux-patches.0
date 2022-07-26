Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D074601C
	for <patches@lists.linux.dev>; Tue, 26 Jul 2022 20:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC18C4347C;
	Tue, 26 Jul 2022 20:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658867070;
	bh=b+SjvJC/v1AUV/6fyI3qTQYP5h9Z1PV/7gwh9fBzFiM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jxjFqt2kchW9t4KzOxQ5sOtEIdj2lKgg4xGvKtNIFdFNIrDfg1APr0jJnn/XhBfBA
	 Hs1Hwitf9EGDYMtZGSSC/FOYhD7V7skG+6rM03rfsLGfrxUeAPSepY7VTVR4/qsiky
	 JcWy+tMtK/wew85z0hbIILrBDxqZ/5qT4tUZsAmE=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Tue, 26 Jul 2022 16:24:30 -0400
Subject: [PATCH v2 4/4] MAINTAINERS: Add Great Pumpkin
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220726-claim-for-great-pumpkin-v2-4-a99ee69dec8e@linuxfoundation.org>
References: <20220726-claim-for-great-pumpkin-v2-0-a99ee69dec8e@linuxfoundation.org>
In-Reply-To: <20220726-claim-for-great-pumpkin-v2-0-a99ee69dec8e@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
Cc: Konstantin Ryabitsev <konstantin.ryabitsev@linux.dev>
X-Mailer: b4 0.10.0-dev-13c24
X-Developer-Signature: v=1; a=ed25519-sha256; t=1658867070; l=559;
 i=konstantin@linuxfoundation.org; s=20211109; h=from:subject:message-id;
 bh=b+SjvJC/v1AUV/6fyI3qTQYP5h9Z1PV/7gwh9fBzFiM=;
 b=GyzEe+pelTLRPUzQhOtghjsJ+AYB+GtxFUBpTtcR9sD0huYPOduE1atJmY8vn0CWW/K2oZ4rRf5G
 DDSZwAONBiYachEEzJsMf2a4D0KcfSQ9RT0J6+EN2khSYivlM4v+
X-Developer-Key: i=konstantin@linuxfoundation.org; a=ed25519;
 pk=fAfUubVyx9rNeSbf8qETNADGwWcptn+Ur6Aaf++c4AY=

All reports go to the Great Pumpkin.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/MAINTAINERS b/MAINTAINERS
index 64379c699903..6804d2b6a008 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22257,7 +22257,7 @@ S:	Maintained
 F:	mm/zswap.c
 
 THE REST
-M:	Linus Torvalds <torvalds@linux-foundation.org>
+M:	Great Pumpkin <devnull@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Buried alive in reporters
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

-- 
b4 0.10.0-dev-13c24
