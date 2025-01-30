Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77501E5738;
	Thu, 30 Jan 2025 14:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246507; cv=none; b=Zi7hW84tVg0HnPf3idjWnr95Fhm8Nlty3TZ7FJdtNi73ORPRjjeOcu4buVQl4y2wSQ7PCVhtZ7d0/duNlp80LnOB1SljntSeaUcfxIA4HGPaaWUmrVakoJ3IplRYnLlOmnN8DOv2nCUzHOuON+azcfchlJbeG30fYH8UPmRMJOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246507; c=relaxed/simple;
	bh=1/WUzDwTzeIGcTLrxv6r4jn5++8cbE3RLFGzdexet3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOdixU/NyzhdAKfKuYMDUbdNKfujQbuh+pL1zcyJ3HApwS+2D4vJpF+odhMtsJ72h5ExwMSb4e5Po/Re8VlCdq76RbkjIT+zKkME2pYAef5zRhPKPJhvo2MYAOmWtejMiXdcGCDpzzLiplNnrIpf1lWD3p1SxI91/j6gRnS/wyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hA4LnEjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hA4LnEjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C1AC4CED2;
	Thu, 30 Jan 2025 14:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246507;
	bh=1/WUzDwTzeIGcTLrxv6r4jn5++8cbE3RLFGzdexet3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hA4LnEjowAWDVzXIayB3U6dUgNjPYp78AoiEvsv16zM3aGh5FuDvE3jL5q3esC3j/
	 Ok7nELZ4tB0Cwm9mluMyqAiisKBtq3K3xVbAGoqi3xL2cg0Vb23EqPIxri+KHCyo/G
	 71Yv6yyDbrkGzCcthIbk1k+XLynv5tEKPps7sf1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 03/43] seccomp: Stub for !CONFIG_SECCOMP
Date: Thu, 30 Jan 2025 14:59:10 +0100
Message-ID: <20250130133459.040357953@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit f90877dd7fb5085dd9abd6399daf63dd2969fc90 ]

When using !CONFIG_SECCOMP with CONFIG_GENERIC_ENTRY, the
randconfig bots found the following snag:

   kernel/entry/common.c: In function 'syscall_trace_enter':
>> kernel/entry/common.c:52:23: error: implicit declaration
   of function '__secure_computing' [-Wimplicit-function-declaration]
      52 |                 ret = __secure_computing(NULL);
         |                       ^~~~~~~~~~~~~~~~~~

Since generic entry calls __secure_computing() unconditionally,
fix this by moving the stub out of the ifdef clause for
CONFIG_HAVE_ARCH_SECCOMP_FILTER so it's always available.

Link: https://lore.kernel.org/oe-kbuild-all/202501061240.Fzk9qiFZ-lkp@intel.com/
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250108-seccomp-stub-2-v2-1-74523d49420f@linaro.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seccomp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 175079552f68d..8cf31bb887198 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -70,10 +70,10 @@ struct seccomp_data;
 
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 static inline int secure_computing(void) { return 0; }
-static inline int __secure_computing(const struct seccomp_data *sd) { return 0; }
 #else
 static inline void secure_computing_strict(int this_syscall) { return; }
 #endif
+static inline int __secure_computing(const struct seccomp_data *sd) { return 0; }
 
 static inline long prctl_get_seccomp(void)
 {
-- 
2.39.5



