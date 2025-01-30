Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F46AC13D;
	Thu, 30 Jan 2025 14:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245679; cv=none; b=AeIBQ3sddgRbmQl0sauLyN44F1lIz0+xw5wFjw0Fc+f6BMxmWfrgr7oh1WVkMLlBUJlPnvmLkzjddCi1Qu/7CCUd4ls5o/Np9D2Xaql+qP+uTj+4boxDgw+l+vLF6UzkuUn5bGJ0hYBoaixKArw714Qp89ZueH80IB2yTruIN1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245679; c=relaxed/simple;
	bh=9xdLL76oFrFTD25juNU3NbEeHsEblr2F81uxfT13Mpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eC4fb3k4wdo7u/1caOhhcfopbrloO5Ge6efCTber9nL/0xOq2A3iSnQQ7pAbFRcetNU26hwJR8ZQSiWoBGgFRXk2+qOb0CTmfR9bpXoy44fWgpJ+cejfk4FqpaTqTMU8ztn2HMAbbpPUsKamp74r9sk4dSLiwjJEyf+GSJavzKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaY76L3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaY76L3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19906C4CED2;
	Thu, 30 Jan 2025 14:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245679;
	bh=9xdLL76oFrFTD25juNU3NbEeHsEblr2F81uxfT13Mpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaY76L3mR9zMVbkN2jsqJG/S3QM/vp9v6cX7GP2mND5pBmT9+Qblw/j38KRpn41k0
	 tnOhip4eualijdAl4E0T089n26iXjenQQ8a9yPq/Ju7ANYtiriBG1dpB8RbWrcCzAx
	 InoFEP8pqsfXKan8arZHl2jga3PWRVP+8SMIFlxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 04/40] seccomp: Stub for !CONFIG_SECCOMP
Date: Thu, 30 Jan 2025 14:59:04 +0100
Message-ID: <20250130133459.878369628@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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
index 709ad84809e1e..8934c7da47f4c 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -50,10 +50,10 @@ struct seccomp_data;
 
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



