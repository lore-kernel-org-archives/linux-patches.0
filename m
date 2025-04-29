Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2614122172E;
	Tue, 29 Apr 2025 17:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948276; cv=none; b=Ulu4FFkt8w+t7dJjycd7GuCoATl4gVEd4JuQPX0ZAxPvC2SVQymYbYLwPalbs7xPjGjQfvOMB4A3eXf1lKepKFQWcQKa/dySeajOlKgfz8Co5LjnJrCHzbnTnDu2kkfcplTedHG6vCDvpjtzBgehfvTNx+WDveRw4tPgNU8zufA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948276; c=relaxed/simple;
	bh=ucg9UN7wsG7GI0r/eOauj0U5xOmLFyts9sYVJr4SLtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp9H5HwRSoBlCE90mKhX2nUy7TmHUSFgH6u26isSdP6/ymGrEEzI561FQUg9MRNRDCampUTAT+08/BUV0+OqYqpLyDWxQRAcsKdT/uT29P09MkHNfmDtzchR51BKml/ARr5r6MJJ8QAw0ZSqH4dH+S2raxOVmkYhvv9ze+G9340=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fr0qdho7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fr0qdho7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9653BC4CEE3;
	Tue, 29 Apr 2025 17:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948276;
	bh=ucg9UN7wsG7GI0r/eOauj0U5xOmLFyts9sYVJr4SLtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fr0qdho7s46Sid7oJk1gt22uQ+qV+aAyk3GJryEec71h7Foa8bKwprqovemQIQ0sk
	 d0rKaaAcVBtjg+QWhK39gtBZgrYxQYeS3Zh5UWE4PqEy90EfJeRzw+XUy8rp+64fF2
	 bSfFzZceLrLoonyTQowXoRAOnArmTK2cgdvCv2uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 200/280] sched/isolation: Make CONFIG_CPU_ISOLATION depend on CONFIG_SMP
Date: Tue, 29 Apr 2025 18:42:21 +0200
Message-ID: <20250429161123.312263696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit 975776841e689dd8ba36df9fa72ac3eca3c2957a ]

kernel/sched/isolation.c obviously makes no sense without CONFIG_SMP, but
the Kconfig entry we have right now:

	config CPU_ISOLATION
		bool "CPU isolation"
		depends on SMP || COMPILE_TEST

allows the creation of pointless .config's which cause
build failures.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20250330134955.GA7910@redhat.com

Closes: https://lore.kernel.org/oe-kbuild-all/202503260646.lrUqD3j5-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 243d0087f9445..2b4969758da83 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -708,7 +708,7 @@ endmenu # "CPU/Task time and stats accounting"
 
 config CPU_ISOLATION
 	bool "CPU isolation"
-	depends on SMP || COMPILE_TEST
+	depends on SMP
 	default y
 	help
 	  Make sure that CPUs running critical tasks are not disturbed by
-- 
2.39.5



