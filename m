Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F3261FB1;
	Thu, 30 Nov 2023 22:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXgb79YE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161CFC433CA;
	Thu, 30 Nov 2023 22:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385106;
	bh=cE93qPc+TjkFJWRjZGLzm6CFGksiAcruGei8mpVZOJw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fXgb79YElIVht4ZGgRqB8gigVokiVVDK4rKTkmfwF6gTAwjSuLG6tHTvgQ4i6+d7h
	 N0djJj5dDKNwsHCACHi0uQ0mV9a9xJ8UJzh8k7ZzWyCPyOxpKzVLq3pP6voQe+RslS
	 jat1viUGIsj+4AE7/8H+SBwE49n/6y6rwBI6+9pf89m0R/ULj7Ay7cx4pkgoMoO1fT
	 6u51XnW4pJ8unwC4wDg9uFWDB2a591ZeS/kTdECmEzwtoSz5dVOscf0dt1b8frMJyn
	 5gdCj6Q+UGE9rTuMXyryqHk4zXjafZxlaUqAd5w1u3jc0axSA97o/QxKzOvYqVhfZp
	 avDILe1TrhBsQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:17 -0700
Subject: [PATCH 04/19] hexagon: smp: Mark handle_ipi() and
 start_secondary() as static
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-4-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1810; i=nathan@kernel.org;
 h=from:subject:message-id; bh=cE93qPc+TjkFJWRjZGLzm6CFGksiAcruGei8mpVZOJw=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwr1b9ExfJxrImUpGHPgs1hXmcrWk9/kJ5ofdCzon7
 19o5mvaUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACZi8pfhf1HRkxhZxZO+OjrB
 SnzC3324vs1NEf+dGa3YkTddpI25kOG/xza1VcrqXxzWZvc/WvxD9UF0vmdxnhVH9VwvMZWTDik
 sAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/kernel/smp.c:82:13: warning: no previous prototype for function 'handle_ipi' [-Wmissing-prototypes]
     82 | irqreturn_t handle_ipi(int irq, void *desc)
        |             ^
  arch/hexagon/kernel/smp.c:82:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     82 | irqreturn_t handle_ipi(int irq, void *desc)
        | ^
        | static
  arch/hexagon/kernel/smp.c:127:6: warning: no previous prototype for function 'start_secondary' [-Wmissing-prototypes]
    127 | void start_secondary(void)
        |      ^
  arch/hexagon/kernel/smp.c:127:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    127 | void start_secondary(void)
        | ^
        | static
  2 warnings generated.

These functions are not used outside of this translation unit, so mark
them as static.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/kernel/smp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index 4e8bee25b8c6..608884bc3396 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -79,7 +79,7 @@ void smp_vm_unmask_irq(void *info)
  * Specifically, first arg is irq, second is the irq_desc.
  */
 
-irqreturn_t handle_ipi(int irq, void *desc)
+static irqreturn_t handle_ipi(int irq, void *desc)
 {
 	int cpu = smp_processor_id();
 	struct ipi_data *ipi = &per_cpu(ipi_data, cpu);
@@ -124,7 +124,7 @@ void __init smp_prepare_boot_cpu(void)
  * to point to current thread info
  */
 
-void start_secondary(void)
+static void start_secondary(void)
 {
 	unsigned long thread_ptr;
 	unsigned int cpu, irq;

-- 
2.43.0

