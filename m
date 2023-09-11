Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E811A8472
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF4FC433C9;
	Mon, 11 Sep 2023 14:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442783;
	bh=DiQKsMBonqxvj2xbKNagFmAXBpcHJu6CI0LVP8830/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kh5gf0ZHMmxXdGicxXt32q4vIWW6351cQWZ7xrg5pwMMTo3vh3ZafO/ULXr4gs+Ox
	 J1PkLFVwDX+8aiTVGd/S2yad5adwOjZ7CIHuiQUdBpxcLve+UXbIGsvA+4jHPiajib
	 pAjdZ4dgkQq0nXtIybPgc+/+ZhHTdIz7YMo/WEog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 119/737] sched/psi: Select KERNFS as needed
Date: Mon, 11 Sep 2023 15:39:38 +0200
Message-ID: <20230911134653.826077033@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 98dfdd9ee93995a408192dbbf3dd219ba23e3738 ]

Users of KERNFS should select it to enforce its being built, so
do this to prevent a build error.

In file included from ../kernel/sched/build_utility.c:97:
../kernel/sched/psi.c: In function 'psi_trigger_poll':
../kernel/sched/psi.c:1479:17: error: implicit declaration of function 'kernfs_generic_poll' [-Werror=implicit-function-declaration]
 1479 |                 kernfs_generic_poll(t->of, wait);

Fixes: aff037078eca ("sched/psi: use kernfs polling functions for PSI trigger polling")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Link: lore.kernel.org/r/202307310732.r65EQFY0-lkp@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index 32c24950c4ced..c70617066a4c8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -629,6 +629,7 @@ config TASK_IO_ACCOUNTING
 
 config PSI
 	bool "Pressure stall information tracking"
+	select KERNFS
 	help
 	  Collect metrics that indicate how overcommitted the CPU, memory,
 	  and IO capacity are in the system.
-- 
2.40.1



