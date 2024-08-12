Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12D729CA;
	Mon, 12 Aug 2024 16:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479657; cv=none; b=a8Vd71Mish5P1YcKITBFhDo7CfXasC7zu4DouLJBdIiGqMcrPKc3ju3WtM9NdUlA45BEAl+K7CtzRTfOyMi51E0E7fpTSFyYh05cnc59QaemDu7F/P5leBz+z4Z+xUXQ8YXBc02xDFVShscNiagGtlu+LUNUxu2+0fVbHVEupQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479657; c=relaxed/simple;
	bh=1RLaM06z6pgwgThRikRClgAJlrlBIFDWbe8SqCPz534=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mc6duKQmLltX4/xqX4jAx3p/2dVLPCpNHvIWKG1rSEIs6ttZZ9N6dhU8/Y2sFJLbzsyMr7J8Y1D/Uq3imHZDm7bXNBsIH5J+4HB75uaJus+wul/nv+n/3B1xCCMEn4MwL2k+DohajrH6xWrAUqvyYzUSulsNgggF/x69NahGiIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IT6dCqN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IT6dCqN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEDBC32782;
	Mon, 12 Aug 2024 16:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479657;
	bh=1RLaM06z6pgwgThRikRClgAJlrlBIFDWbe8SqCPz534=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IT6dCqN8hc0ec1zs07J4EvX/nofLpJKKLjcDED3Ryi/uPgsvvj8GDXZ3AZue7IoWJ
	 cH+Tq7YSmdVUTiVSe2EVw2HRCBG1VzciUw5nqGqcVzazmUkQapSQqEKwzgJoQaENfV
	 7HvrDD5fYpyRO+2M81qxYnc2zYh1fFoWNqGpRZx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nico Pache <npache@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 153/189] selftests: mm: add s390 to ARCH check
Date: Mon, 12 Aug 2024 18:03:29 +0200
Message-ID: <20240812160138.031535824@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nico Pache <npache@redhat.com>

commit 30b651c8bc788c068a978dc760e9d5f824f7019e upstream.

commit 0518dbe97fe6 ("selftests/mm: fix cross compilation with LLVM")
changed the env variable for the architecture from MACHINE to ARCH.

This is preventing 3 required TEST_GEN_FILES from being included when
cross compiling s390x and errors when trying to run the test suite.  This
is due to the ARCH variable already being set and the arch folder name
being s390.

Add "s390" to the filtered list to cover this case and have the 3 files
included in the build.

Link: https://lkml.kernel.org/r/20240724213517.23918-1-npache@redhat.com
Fixes: 0518dbe97fe6 ("selftests/mm: fix cross compilation with LLVM")
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -101,7 +101,7 @@ endif
 
 endif
 
-ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 powerpc riscv64 s390x sparc64 x86_64))
+ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 powerpc riscv64 s390x sparc64 x86_64 s390))
 TEST_GEN_FILES += va_high_addr_switch
 TEST_GEN_FILES += virtual_address_range
 TEST_GEN_FILES += write_to_hugetlbfs


