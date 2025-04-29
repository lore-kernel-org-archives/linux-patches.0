Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC65253334;
	Tue, 29 Apr 2025 18:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950618; cv=none; b=rceUD+v6pyp4YY9Xt+sAxgS/NTqW8gRoSpnkf5V0uREIZF0bfz0yApuBgSCb9z2Y4OIPTTk77uTAYBFbPYLZ8x78TbWcswV5uvTme8XDYYwTRx9xIXqFTmBrNi6un6MyzFIo57ve/SG31e35dPgfPl4oBcGRoVwo7pm1oxjhz+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950618; c=relaxed/simple;
	bh=zJOCUCcMDayc2RYoepOeO1eOzyaBT8qac+nb7vSVsnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJmRYE6nDXyLEMD/RqsnoLtpFiMl+/SvozBUN5a9FKgBpB65luI0y7CLfuUfrsXeX2ryA9qx3rWmD7XPro7+gy9m8HRfId79RiM3kihA6duRSxDXXAQH191IYpQ8lwJeOhMsgLpl44U2fw13B0pkvA1F+lZ8MrrUt3IyPmN1rHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjjAD6Fo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjjAD6Fo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9425FC4CEE3;
	Tue, 29 Apr 2025 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950618;
	bh=zJOCUCcMDayc2RYoepOeO1eOzyaBT8qac+nb7vSVsnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjjAD6FoCdYIb06bdnWixnheCFcZ2Hytxm2XoQWPZCUK3tflN9mR4lupvtj+Bb5oF
	 0rhcLWna7DzgOAlY3KFutjn+5MSBUnl+bz+kw0w3YM+2CNQrj4Gof2ofFg8H/2fBhy
	 rXWZ9LDXfRlQfxrf061qYBPbAFuyHXEgRKIA8Ms0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/204] sched/isolation: Make CONFIG_CPU_ISOLATION depend on CONFIG_SMP
Date: Tue, 29 Apr 2025 18:44:00 +0200
Message-ID: <20250429161105.638813566@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1105cb53f391a..8b630143c720f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -689,7 +689,7 @@ endmenu # "CPU/Task time and stats accounting"
 
 config CPU_ISOLATION
 	bool "CPU isolation"
-	depends on SMP || COMPILE_TEST
+	depends on SMP
 	default y
 	help
 	  Make sure that CPUs running critical tasks are not disturbed by
-- 
2.39.5



