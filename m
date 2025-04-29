Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3E7229B05;
	Tue, 29 Apr 2025 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946349; cv=none; b=tpyOZywZT4hcnMNWLE9S930wyjmKQDaXX56IgfDh9FyLbhNM87duRqG0DtaoCQRTMUuSK+gSFMgVKzh/5YEH0bLpO4Z4QUhY1cx+nHUXipQx0l+ohqSt7D0sgm8DtTcioMZud0mHy2BY5CLVi+wWgjGEEiO96/lvBCoRfHa4UiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946349; c=relaxed/simple;
	bh=Z+yMLDaoJqFAjCeNsaj9OqT8rDhGLgohoIA5P0SqG2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSnPamp4x+Xkdd838SDyqzdv4MyPLiVt6GZ5i+dOuow45gdlH5QhsyYHmSAjqJ9f4iLloyHuwg7bgtJcsvncDN1qAI5kaNaIDgFawfmwi0UvZ36QtLcDe35pijlf7p9DaRhswLY5C/eY/Vopnug3S/oyfHiHECN/p/IttxfKzzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gENi1PFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gENi1PFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943A2C4CEEF;
	Tue, 29 Apr 2025 17:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946349;
	bh=Z+yMLDaoJqFAjCeNsaj9OqT8rDhGLgohoIA5P0SqG2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gENi1PFbMpwqfx5+tIat1iXZeH1lMxiNO07R41bYTS6ida6HWNl7K35/g+NyrH7NI
	 jLdmMgIGiPRkQQzIh+A5ftfYh0cj6cG0XM/ao3e/YflZ5txyomOOvVapqoys5K1w+l
	 6f0I4rKiaxBNN6XY9gnUUECCG9u+RO2t2obVJo3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 237/311] sched/isolation: Make CONFIG_CPU_ISOLATION depend on CONFIG_SMP
Date: Tue, 29 Apr 2025 18:41:14 +0200
Message-ID: <20250429161130.733080826@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 5ab47c346ef93..dc7b10a1fad2b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -711,7 +711,7 @@ endmenu # "CPU/Task time and stats accounting"
 
 config CPU_ISOLATION
 	bool "CPU isolation"
-	depends on SMP || COMPILE_TEST
+	depends on SMP
 	default y
 	help
 	  Make sure that CPUs running critical tasks are not disturbed by
-- 
2.39.5



