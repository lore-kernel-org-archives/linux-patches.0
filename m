Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B223E61FA9;
	Thu, 30 Nov 2023 22:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EM07ojKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2FBC433C9;
	Thu, 30 Nov 2023 22:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385109;
	bh=GNdAEOCip3i8vg7nOoBtjnTsPMJcCPD+RgVTLmzP9xM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EM07ojKP+3FsPmxu7V3i4rAxnkJgTs4dCkWCiSTYAVlbzem0IOIc74n/SuQxd58x4
	 IGOj+cwOaieYEE/meeGD4e1T2jK2/M1OSZpdZZHRbVvZbpDHdtD8FfZhgGRynpAgzi
	 YgL4FpSFXn5tMBm3Da/BAexPOYbt2oM7letsrUrLkgwo8kXf0BNsDfgGDl0MBFbfKt
	 ELLvqgU7MT2Z/SkLl6WO/R6oVbMUwePzdUWkWfwWR39ZHriOnQRpFidgZl9pSmi+fr
	 XeVRJF2K5+1wdzExXpK4vi6jdT+ErIk5Akjrso/q+AFZ4na8/LPycLC+CD+LXk6cRf
	 TeSpfsDJPfflA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:22 -0700
Subject: [PATCH 09/19] hexagon: time: Mark time_init_deferred() as static
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-9-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1250; i=nathan@kernel.org;
 h=from:subject:message-id; bh=GNdAEOCip3i8vg7nOoBtjnTsPMJcCPD+RgVTLmzP9xM=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwn3tB7qn1FzLm2WnkZzKMn/av+Y6ZUbFUBaeqCtcj
 1KeOk3oKGVhEONikBVTZKl+rHrc0HDOWcYbpybBzGFlAhnCwMUpABP5VcXw3+XIYcbWQJO7h5ac
 17P3fMVyVXy5+wqLEOPzGv1ZMzceesDIsMKUr/hAxrNk+Y3z7m54udHZsi5KXObRUbdIDXGm7i3
 SvAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/kernel/time.c:163:13: warning: no previous prototype for function 'time_init_deferred' [-Wmissing-prototypes]
    163 | void __init time_init_deferred(void)
        |             ^
  arch/hexagon/kernel/time.c:163:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    163 | void __init time_init_deferred(void)
        | ^
        | static

This function is not used outside of this translation unit so mark it as
static to resolve the warning.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/kernel/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
index 59f00bf54fe9..f04dbe4f8a4c 100644
--- a/arch/hexagon/kernel/time.c
+++ b/arch/hexagon/kernel/time.c
@@ -161,7 +161,7 @@ static irqreturn_t timer_interrupt(int irq, void *devid)
  * This runs just before the delay loop is calibrated, and
  * is used for delay calibration.
  */
-void __init time_init_deferred(void)
+static void __init time_init_deferred(void)
 {
 	struct resource *resource = NULL;
 	struct clock_event_device *ce_dev = &hexagon_clockevent_dev;

-- 
2.43.0

