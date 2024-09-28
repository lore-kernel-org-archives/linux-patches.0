Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B073C0C;
	Sat, 28 Sep 2024 18:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727547213; cv=none; b=K3zW1JTpXKL+dEAIA117t6zk7YZBowUY+ZUy+d2szLAbZWQgoYQlgvIKmGReyT9dajY3jNlCT0spJ4hhgkt2fLDYz3oQZ8lwiEbTmTDvWp7PoxL9LUhgfbb16NVJ9JahZpmeWoHUgQPezWTT2J4rkaYm8pFcTHCRTn/R+Sq4gzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727547213; c=relaxed/simple;
	bh=z9u/5R0H+PXeJBVI3DAKu0pG2StfN1rEt4oJ5d3APac=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=iix34a6J41J571B0wak5SiUyFmILne+j6uV9Ky5TVkAaOdORNrsNRwgg2Rx6i7ceU/5lk+Qx9FR1/Z9vE4mfWNItT3nv+yWV2xx0uUMIbHo/uxy/WKmwmJQygKejJp/lV6as2h7HYDx12wkaZwGOY9ptPtAtgEJSrvZZytSXRYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bvCncro+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bvCncro+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D50FC4CEC3;
	Sat, 28 Sep 2024 18:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727547212;
	bh=z9u/5R0H+PXeJBVI3DAKu0pG2StfN1rEt4oJ5d3APac=;
	h=From:Date:Subject:To:Cc:From;
	b=bvCncro+ON+B4BwXIk9HyXCWwFn8Vi25Oo/eFKWVpASEiLVs9JKTCBE/PYckDOjvr
	 m55s2DZ9S+R3lbJwsWXcPz3xjTln1TmL6YJMed6ZU2o9d4Ju+Gl4cMNbF4Hex54mYT
	 dURYv1WN+X6O/YEY57t29QPd+zkLX+OZ4KAef5VT3y+mKh07EI6bkcgtGmae3HZT67
	 f1a5uFepZhGa7HoSjBm513japzUZWQuyldFUmvfqpHQvwPX5r0+Nur3nlzMx0p1AkB
	 5fZ+Hcp0l7cjZYcGwOwdrLiHMICeH1vaQy/qMn1kyARf+K7Bf8uu5dJZ+0JxtAPdzW
	 p4fohmhiXqwng==
From: Nathan Chancellor <nathan@kernel.org>
Date: Sat, 28 Sep 2024 11:13:13 -0700
Subject: [PATCH] hardening: Adjust dependencies in selection of MODVERSIONS
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240928-fix-randstruct-modversions-kconfig-warning-v1-1-27d3edc8571e@kernel.org>
X-B4-Tracking: v=1; b=H4sIADhH+GYC/x2NSQ7CMAwAv1L5jKU0rdi+gnoIiRMshIPsUpCq/
 p3AcQ4zs4KRMhmcuxWUFjau0qDfdRBvQQohp8bgnR/dyR8x8wc1SLJZX3HGR00L6c8yvMcqmQu
 +gwpLQdcPVxqDy/vDAC34VGr2f3aZtu0LUroeRXwAAAA=
X-Change-ID: 20240928-fix-randstruct-modversions-kconfig-warning-013be4a0f673
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-hardening@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2094; i=nathan@kernel.org;
 h=from:subject:message-id; bh=z9u/5R0H+PXeJBVI3DAKu0pG2StfN1rEt4oJ5d3APac=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGk/3L1F//1ek/X5RFvh9jXXw6wXVcjFTBE1tdL8tqVg8
 +sQS/erHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiG70ZGe6ec99fn/z8vt+J
 s9zl9V9XLq0vruKuYL5svrxsWfiZ3BWMDI+WCDDLROkvYb1y67GzWmlQaNtWH8Nq920rakQMF3k
 zcQIA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

MODVERSIONS recently grew a dependency on !COMPILE_TEST so that Rust
could be more easily tested. However, this introduces a Kconfig warning
when building allmodconfig with a clang version that supports RANDSTRUCT
natively because RANDSTRUCT_FULL and RANDSTRUCT_PERFORMANCE select
MODVERSIONS when MODULES is enabled, bypassing the !COMPILE_TEST
dependency:

  WARNING: unmet direct dependencies detected for MODVERSIONS
    Depends on [n]: MODULES [=y] && !COMPILE_TEST [=y]
    Selected by [y]:
    - RANDSTRUCT_FULL [=y] && (CC_HAS_RANDSTRUCT [=y] || GCC_PLUGINS [=n]) && MODULES [=y]

Add the !COMPILE_TEST dependency to the selections to clear up the
warning.

Fixes: 1f9c4a996756 ("Kbuild: make MODVERSIONS support depend on not being a compile test build")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 security/Kconfig.hardening | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index 2cff851ebfd7e13b955693be9f5818ac6f8bbf03..c9d5ca3d8d08de237102f1ffe3f310636ae0d6ff 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -340,7 +340,7 @@ choice
 	config RANDSTRUCT_FULL
 		bool "Fully randomize structure layout"
 		depends on CC_HAS_RANDSTRUCT || GCC_PLUGINS
-		select MODVERSIONS if MODULES
+		select MODVERSIONS if MODULES && !COMPILE_TEST
 		help
 		  Fully randomize the member layout of sensitive
 		  structures as much as possible, which may have both a
@@ -356,7 +356,7 @@ choice
 	config RANDSTRUCT_PERFORMANCE
 		bool "Limit randomization of structure layout to cache-lines"
 		depends on GCC_PLUGINS
-		select MODVERSIONS if MODULES
+		select MODVERSIONS if MODULES && !COMPILE_TEST
 		help
 		  Randomization of sensitive kernel structures will make a
 		  best effort at restricting randomization to cacheline-sized

---
base-commit: 3efc57369a0ce8f76bf0804f7e673982384e4ac9
change-id: 20240928-fix-randstruct-modversions-kconfig-warning-013be4a0f673

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

