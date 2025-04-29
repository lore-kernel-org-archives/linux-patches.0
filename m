Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB502459C9;
	Tue, 29 Apr 2025 17:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947465; cv=none; b=M/HLfgZYvYlkcga0b5ksIxLCoh4xYzxnb9pLKpLH83E7Pe1jNV9qVQCR4JDHGrnoKA8/zFWmfaLhzB20GTyMzO0QkEMn5we1tlDorWkJvppjXQGO9nWAQ+ENxzN+TcG2yK2lGKafd/tBJWdP1ofuu+9kNbAru0WNbkEHLwRLT/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947465; c=relaxed/simple;
	bh=24pwxplLu2pNqegIfZEnskQ8ssAEuDf12zFX5HGZLME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZZG398k9LmY9Bv2P2Yz94EO1NhfhB/iPzChzKPb2fFyACXwXcwZ7ezyP1vytz2zR95i98XDuyG+crZYiF/7A8YfqwA3fSICqliqFEICbGo14G0jBvOnS1IgqBU/pL8nQp+QbnzKLIRKGJolkeXKTfO6CWC+IcOaKJgNuLQflrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06rgb/uH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06rgb/uH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D939C4CEE3;
	Tue, 29 Apr 2025 17:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947465;
	bh=24pwxplLu2pNqegIfZEnskQ8ssAEuDf12zFX5HGZLME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06rgb/uHp+etF5fbGqpfbbmlOq1nFFDkyWl3EFyjFIpXQUVen+fezwDbJYsiZ8zcJ
	 /NhpwfTilmEDdJ+u9z65lLJ19TcwaIJRSPistqcrZXdBPp7WKWZVbQ/NpncVA+mEOc
	 GOadQCYr98yjd49AE1Zws8/UaIrSfKtxnXsg4loE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/286] sched/isolation: Make CONFIG_CPU_ISOLATION depend on CONFIG_SMP
Date: Tue, 29 Apr 2025 18:42:47 +0200
Message-ID: <20250429161118.732997906@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4e7775279356d..233166e54df35 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -656,7 +656,7 @@ endmenu # "CPU/Task time and stats accounting"
 
 config CPU_ISOLATION
 	bool "CPU isolation"
-	depends on SMP || COMPILE_TEST
+	depends on SMP
 	default y
 	help
 	  Make sure that CPUs running critical tasks are not disturbed by
-- 
2.39.5



