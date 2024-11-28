Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AAF83CC7;
	Thu, 28 Nov 2024 03:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732763409; cv=none; b=kQbX0ZjucaqcU43pPu4EGxu5+j17tNJsrnOuouHITwCl4YtEV1CzA2/iGZ6uPCL4Vb8zh71EXGLAGA06jNBFFs/+2qPlA2o9tShQN+XwQpUHaNigafPUKVE04qmkO6yiP5U0veQIFrxVZVVn9axjjgE+iIbE/EsghlNHsO5QvCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732763409; c=relaxed/simple;
	bh=qIK1SvnQUxdoZe8eJG9ukh6hA1OfmlyLSzxG5Dma0mM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f6fF/x4TmZieZVZRZo3BPcS3xPQ5CtgUDKF4XnU1aF6gLlvLCyDoCXJJlTYBNlH/6htsLrU3f0Sc+AJsbPsUbtVNP3FI8OPwlqXeZdnX3823GTe240so72mgV1jGiZ61laq7PeZgHspsreMk/tzTCXZuWowcu+tJ28pLo06C8mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=phb73X4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="phb73X4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74910C4CECC;
	Thu, 28 Nov 2024 03:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732763408;
	bh=qIK1SvnQUxdoZe8eJG9ukh6hA1OfmlyLSzxG5Dma0mM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=phb73X4e2znCne8425GbrRHvae4q9X1GIBuzrmreaW8Q5AIU5KibJzZ9ECXm8MikN
	 84qKbUIBS+jgPcZ9CbxQYe6JOD0fJZneIOs4NLo8UlulixrAjsTcABQCgc1BiYhVbg
	 xkLk/XdW52KI8Ix14crdfIMX2BZUHt0sdYhEd6WvQrOaXWBvfgQ4Eo+PQ30XHPsEz+
	 VwoHXTE6qy2gFSXaj92a/vopyTQRFqtn3aT3P/6/Mz6mm+TeEZmHNmGZqcMi6Mn2kn
	 ccRcpbrztn/S7emKURI+G4NavetAse2zhh7HVKPDF9SJvmyhDYDhLSMaca8YBjHMIA
	 yCnvx7H6Clbig==
Date: Wed, 27 Nov 2024 19:10:07 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, samitolvanen@google.com,
	petr.pavlu@suse.com, da.gomez@samsung.com,
	linux-modules@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, mmaurer@google.com, arnd@arndb.de,
	deller@gmx.de, song@kernel.org
Subject: Re: [GIT PULL] Modules changes for v6.13-rc1
Message-ID: <Z0ffD62YLuVVrCGR@bombadil.infradead.org>
References: <Z0ZxiLw9hauUynTS@bombadil.infradead.org>
 <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>
 <Z0eeuCyUGcKgsc5h@bombadil.infradead.org>
 <Z0eqiayuv1w4a_dc@bombadil.infradead.org>
 <CAHk-=wj+imfGvW73XoYn60bAMzRtPfXFqwFTUqBoEq4=u5_oUg@mail.gmail.com>
 <Z0fT4hC30NISjmi_@bombadil.infradead.org>
 <Z0fYqZutUzDdxTGf@bombadil.infradead.org>
 <CAK7LNARDwBmvKY4fDmr5K=WLEvWLhFgg50ibu7etJykiRxohOA@mail.gmail.com>
 <Z0fdX6i3inNVJf-e@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0fdX6i3inNVJf-e@bombadil.infradead.org>

On Wed, Nov 27, 2024 at 07:02:55PM -0800, Luis Chamberlain wrote:
> I did. Multiple times.

I've split this up now in 2 parts, one with your fixes and then the
other boundary fixes which are not related.

From 8e4c903fa3079e1c05c9585f78c57e8067024d99 Mon Sep 17 00:00:00 2001
From: Luis Chamberlain <mcgrof@kernel.org>
Date: Wed, 27 Nov 2024 14:10:57 -0800
Subject: [PATCH 1/2] selftests: kallsyms: fix double build stupidity

The current arrangement will have the test modules rebuilt on
any make without having the script or code actually change.
Take Masahiro Yamada's suggested fix and cleanups on the Makefile
to fix this.

Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 lib/tests/module/Makefile | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/lib/tests/module/Makefile b/lib/tests/module/Makefile
index af5c27b996cb..2f3e1a772c2c 100644
--- a/lib/tests/module/Makefile
+++ b/lib/tests/module/Makefile
@@ -3,13 +3,12 @@ obj-$(CONFIG_TEST_KALLSYMS_B) += test_kallsyms_b.o
 obj-$(CONFIG_TEST_KALLSYMS_C) += test_kallsyms_c.o
 obj-$(CONFIG_TEST_KALLSYMS_D) += test_kallsyms_d.o
 
-$(obj)/%.c: FORCE
-	@$(kecho) "  GEN     $@"
-	$(Q)$(srctree)/lib/tests/module/gen_test_kallsyms.sh $@\
-		$(CONFIG_TEST_KALLSYMS_NUMSYMS) \
-		$(CONFIG_TEST_KALLSYMS_SCALE_FACTOR)
+quiet_cmd_gen_test_kallsyms = GEN     $@
+	cmd_gen_test_kallsyms = $< $@ \
+	$(CONFIG_TEST_KALLSYMS_NUMSYMS) \
+	$(CONFIG_TEST_KALLSYMS_SCALE_FACTOR)
 
-clean-files += test_kallsyms_a.c
-clean-files += test_kallsyms_b.c
-clean-files += test_kallsyms_c.c
-clean-files += test_kallsyms_d.c
+$(obj)/%.c: $(src)/gen_test_kallsyms.sh FORCE
+	$(call if_changed,gen_test_kallsyms)
+
+targets += $(foreach x, a b c d, test_kallsyms_$(x).c)
-- 
2.45.2


From e76c869f4f37eff4d91c749572104e2eb0953986 Mon Sep 17 00:00:00 2001
From: Luis Chamberlain <mcgrof@kernel.org>
Date: Wed, 27 Nov 2024 19:06:03 -0800
Subject: [PATCH 2/2] selftests: kallsyms: fix and clarify current test
 boundaries

Provide and clarify the existing ranges and what you should expect.
Fix the gen_test_kallsyms.sh script to accept different ranges.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 lib/Kconfig.debug                     | 32 ++++++++++++++++++++++++++-
 lib/tests/module/gen_test_kallsyms.sh |  9 ++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b5929721fc63..88fc93f4b142 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2986,9 +2986,39 @@ config TEST_KALLSYMS_D
 	tristate
 	depends on m
 
+choice
+	prompt "Kallsym test range"
+	default TEST_KALLSYMS_LARGE
+	help
+	  Selecting something other than "Fast" will enable tests which slow
+	  down the build and may crash your build.
+
+config TEST_KALLSYMS_FAST
+	bool "Fast builds"
+	help
+	  You won't really be testing kallsysms, so this just helps fast builds
+	  when allmodconfig is used..
+
+config TEST_KALLSYMS_LARGE
+	bool "Enable testing kallsyms with large exports"
+	help
+	  This will enable larger number of symbols. This will slow down
+	  your build considerably.
+
+config TEST_KALLSYMS_MAX
+	bool "Known kallsysms limits"
+	help
+	  This will enable exports to the point we know we'll start crashing
+	  builds.
+
+endchoice
+
 config TEST_KALLSYMS_NUMSYMS
 	int "test kallsyms number of symbols"
-	default 100
+	range 2 10000
+	default 2 if TEST_KALLSYMS_FAST
+	default 100 if TEST_KALLSYMS_LARGE
+	default 10000 if TEST_KALLSYMS_MAX
 	help
 	  The number of symbols to create on TEST_KALLSYMS_A, only one of which
 	  module TEST_KALLSYMS_B will use. This also will be used
diff --git a/lib/tests/module/gen_test_kallsyms.sh b/lib/tests/module/gen_test_kallsyms.sh
index 3f2c626350ad..561dcac0f359 100755
--- a/lib/tests/module/gen_test_kallsyms.sh
+++ b/lib/tests/module/gen_test_kallsyms.sh
@@ -7,6 +7,11 @@ NUM_SYMS=$2
 SCALE_FACTOR=$3
 TEST_TYPE=$(echo $TARGET | sed -e 's|lib/tests/module/test_kallsyms_||g')
 TEST_TYPE=$(echo $TEST_TYPE | sed -e 's|.c||g')
+FIRST_B_LOOKUP=1
+
+if [[ $NUM_SYMS -gt 2 ]]; then
+	FIRST_B_LOOKUP=$((NUM_SYMS/2))
+fi
 
 gen_template_module_header()
 {
@@ -52,10 +57,10 @@ ____END_MODULE
 
 gen_template_module_data_b()
 {
-	printf "\nextern int auto_test_a_%010d;\n\n" 28
+	printf "\nextern int auto_test_a_%010d;\n\n" $FIRST_B_LOOKUP
 	echo "static int auto_runtime_test(void)"
 	echo "{"
-	printf "\nreturn auto_test_a_%010d;\n" 28
+	printf "\nreturn auto_test_a_%010d;\n" $FIRST_B_LOOKUP
 	echo "}"
 }
 
-- 
2.45.2

