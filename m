Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF4924BD02;
	Tue, 29 Apr 2025 16:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945602; cv=none; b=NPU+a9IqFcoDa/u4SoM4R8XXeNwlbsCrOwxv21940GzzP82rQ/SRAkMbo0lCipWaEXStsXiv9lHEXBUIKmchpJjyvsn8R6CBUyKWyDqTlwvgQrR2gnF41lbpNwZKI1/H3aay/tJ9UerN4s/waJ5KqA4IHsloofvFUtYTLVIUyUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945602; c=relaxed/simple;
	bh=nEHwnORHmKIRRroxuBWAgo1RXOUvTwh1OMZl8hb8bQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcNwl3LVh2HI6uDnN6gcSl1+li7+VQaFA85xEMamRfk74PrgNdp9fXi2ql0uFrnKb5KZKcm2D0yFzmJDRVbofCrjx6pMjvD9SQWVsleVqcLF0ebFzquMIL0Elmb3XYDe9p75E4blUJQJ+eE1AK1Rfs+Nhms6RrDmyrrTU0wNtbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWKJVN1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWKJVN1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CB5C4CEE3;
	Tue, 29 Apr 2025 16:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945601;
	bh=nEHwnORHmKIRRroxuBWAgo1RXOUvTwh1OMZl8hb8bQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWKJVN1BSYZ23E0c/s9L65/3PHREpyHS0fuJ6qRC5csmykCiTB5JtOo1sKZHt7D1b
	 879KnxohT3qKaIzNlmh//5l54mSP/46M2DzX6Opz4jS1EzGbO/H02umqjZwg6Ldzd/
	 WBEkmMaF2MbK2eo7xKXf//SQ1q6QaiIAeXvLKbb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/179] sched/isolation: Make CONFIG_CPU_ISOLATION depend on CONFIG_SMP
Date: Tue, 29 Apr 2025 18:41:49 +0200
Message-ID: <20250429161056.189212085@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 293da9b0bea6b..41e87e8a5c6c1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -559,7 +559,7 @@ endmenu # "CPU/Task time and stats accounting"
 
 config CPU_ISOLATION
 	bool "CPU isolation"
-	depends on SMP || COMPILE_TEST
+	depends on SMP
 	default y
 	help
 	  Make sure that CPUs running critical tasks are not disturbed by
-- 
2.39.5



