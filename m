Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E424C71
	for <patches@lists.linux.dev>; Fri, 13 May 2022 19:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iGO39EDVjPnTYXbXk4m8oqTPwLMaY1sb1Vley0Ob2Bs=; b=xpbCJEZVFLojPYYKLedVllObpJ
	sIKinKb0p4nX/oHMltMoDAc0PB64XIfu2HYPQe9s403D2iryESyykHgKMjzr9inJ9W0jGRh6n0o8U
	yaP6pEuyLGdK2XhsBydQKxUg5VkoD41qsPkLM0zM4tONyTXoFz066JnV872EBNQQ0CkqPK16Zq0PX
	usWYLbFworSaNvmRhDJYjn2h1guPnX5ON2Wx/pk+MLUWFOE74lypAvvcuHZGNmyEA/xXfMkXvbQVS
	X8e/cARTNoRnDpEU1nuCZ9TOLinymaY/TjPbXgJewdSLmXghwq1DboR0x77p8hLTKCawb2v9AGsxq
	Pzvcnmsw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1npb7T-00HM1x-Fl; Fri, 13 May 2022 19:38:35 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org
Cc: patches@lists.linux.dev,
	amir73il@gmail.com,
	pankydev8@gmail.com,
	tytso@mit.edu,
	josef@toxicpanda.com,
	jmeneghi@redhat.com,
	jake@lwn.net,
	mcgrof@kernel.org
Subject: [PATCH 1/4] workflows/Kconfig: be consistent when enabling fstests or blktests
Date: Fri, 13 May 2022 12:38:28 -0700
Message-Id: <20220513193831.4136212-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220513193831.4136212-1-mcgrof@kernel.org>
References: <20220513193831.4136212-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

We have two kconfig variables which we use to be able to express
when we are going to enable fstests or blktests, either as a dedicated
set of tests or when we want to enable testing both fstests and blktests
in one system. But right now we only select this kconfig variable when
we are using a dedicated system. This is not an issue as the kconfig
is a kconfig symbols are bools which are set default to y if either
the test is dedicated or not.

But to be pedantic, and clear, let's make sure the tests select the
respective kconfig for each case as we'd expect to see it. Otherwise
this can confuse folks reading this.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 kconfigs/workflows/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kconfigs/workflows/Kconfig b/kconfigs/workflows/Kconfig
index 7e5c518..7f71470 100644
--- a/kconfigs/workflows/Kconfig
+++ b/kconfigs/workflows/Kconfig
@@ -133,6 +133,7 @@ if !WORKFLOWS_DEDICATED_WORKFLOW
 
 config KDEVOPS_WORKFLOW_NOT_DEDICATED_ENABLE_FSTESTS
 	bool "fstests"
+	select KDEVOPS_WORKFLOW_ENABLE_FSTESTS
 	help
 	  Select this option if you are doing filesystem development and want
 	  to target development for a filesystem and enable fstests so that
@@ -146,6 +147,7 @@ config KDEVOPS_WORKFLOW_NOT_DEDICATED_ENABLE_FSTESTS
 
 config KDEVOPS_WORKFLOW_NOT_DEDICATED_ENABLE_BLKTESTS
 	bool "blktests"
+	select KDEVOPS_WORKFLOW_ENABLE_BLKTESTS
 	help
 	  Select this option if you are doing block layer development and want
 	  to run blktests. The git tree for blktests will be git clone and
-- 
2.35.1

