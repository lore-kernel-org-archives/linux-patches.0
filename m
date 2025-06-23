Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222DB222576;
	Mon, 23 Jun 2025 21:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715961; cv=none; b=R7xLeQ9v6btquD+TJq6ezcxx5KjXOucdbjI/2/fwn1Z4yN5Pzwx3nVP0INJFs47e1LMzGKzFiWeJlnvNRWlyz4PQQOsS+B/SNCcWaJmxJxV3xoLA5NlqHqhtNbKdF+f/6i3LHSCnzhMOurA/tA8IXEc84cqPRHqpZr2Yf7cYuQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715961; c=relaxed/simple;
	bh=QHVH3yquZ2VgtO5Rn3QYSqC1jYpy1IrR8z0SSVo3CDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1ZfMMm58GOXLnGkVdOqwN0S3ikIl59s+LZeZ+7rliNtRHcdCmFFmjPCbRzce2wNz4fh8wYD6pngmSx1mV9etjq+FINkgpis3MlOIIipwl2ECGTjqsXGDQSZ4C2Nm1iR2WRGFRzv63rGAFP4d7V3gvdPNqn58EUEJPUENDmogYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSh6xzXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSh6xzXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6561C4CEEA;
	Mon, 23 Jun 2025 21:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715961;
	bh=QHVH3yquZ2VgtO5Rn3QYSqC1jYpy1IrR8z0SSVo3CDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSh6xzXhDidQu4gQ69EGmhHmem/1egf3WxgaRQU20FhU8W51pSiPjG8QzXCjY22nP
	 QHe197aPoeAl5U5EdDnjuPelgmjL351V7l98kEFBKm/Sg8WxY/W7s3v6S28Wf603NW
	 QoveI0URV+2txrQlbAzd+mHhoShfl2Ba14iYvgTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.1 271/508] drm/amd/display: Do not add -mhard-float to dml_ccflags for clang
Date: Mon, 23 Jun 2025 15:05:16 +0200
Message-ID: <20250623130651.913043524@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 7db038d9790eda558dd6c1dde4cdd58b64789c47 upstream.

When clang's -Qunused-arguments is dropped from KBUILD_CPPFLAGS, it
warns:

  clang-16: error: argument unused during compilation: '-mhard-float' [-Werror,-Wunused-command-line-argument]

Similar to commit 84edc2eff827 ("selftest/fpu: avoid clang warning"),
just add this flag to GCC builds. Commit 0f0727d971f6 ("drm/amd/display:
readd -msse2 to prevent Clang from emitting libcalls to undefined SW FP
routines") added '-msse2' to prevent clang from emitting software
floating point routines.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -26,7 +26,8 @@
 # subcomponents.
 
 ifdef CONFIG_X86
-dml_ccflags := -mhard-float -msse
+dml_ccflags-$(CONFIG_CC_IS_GCC) := -mhard-float
+dml_ccflags := $(dml_ccflags-y) -msse
 endif
 
 ifdef CONFIG_PPC64


