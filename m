Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3325A24DCFD;
	Mon, 23 Jun 2025 13:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685057; cv=none; b=DX3fXsXPw0iR7mofyacquk+cq+HAIqSa9oEyu5q5cQjZJGbUMPMWssyPhJPLIUTCPy5sohsLJReBIzt79HNt8S1LGXNQw29coRqCI3Q6p3mMMFTEFg0joovjkIIS1Y0HLNtCQOUkU+Ii5oT2BIwj16so8EeIVQDuhm6ozSZr+3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685057; c=relaxed/simple;
	bh=o4vPKN4nHmtr5Y3zNWdDGESFQbTpujHD9C1bOGuhQMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkLwlVaRrEXwEJE+8fHfmwTOfNWLbPBaToS9npy8kFyPVp2rxBORNw+6IMK2UiZmncJgavQW67wAfysVSuNpW4sax6KX6A3BpqmWNo9w5U9NhuKSniugyWkMoewnWnIu4fhpzormnD15dq8B9b+uJeSDEXUA4mVIPUeoz6eU9l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESiL1PXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESiL1PXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA75C4CEEA;
	Mon, 23 Jun 2025 13:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685057;
	bh=o4vPKN4nHmtr5Y3zNWdDGESFQbTpujHD9C1bOGuhQMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESiL1PXTnyQSg33vCYlnjIO4pu9q2Zzo7HvgFe74KpLecQjV6RwXWElyhLBuoGF1e
	 UD59JRJoYzJdbvEKLCzbHWMnzvfrihbT2cQe15244shYrsK5IQMk0gvvKIHt5xnjoF
	 IsbHCiH8CJenH2XaHs3ua7qJcWGcokuXJJDQ3S3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 090/222] drm/amd/display: Do not add -mhard-float to dml_ccflags for clang
Date: Mon, 23 Jun 2025 15:07:05 +0200
Message-ID: <20250623130614.807611126@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -24,7 +24,8 @@
 # It provides the general basic services required by other DAL
 # subcomponents.
 
-dml_ccflags := -mhard-float -msse
+dml_ccflags-$(CONFIG_CC_IS_GCC) := -mhard-float
+dml_ccflags := $(dml_ccflags-y) -msse
 
 ifdef CONFIG_CC_IS_GCC
 ifeq ($(call cc-ifversion, -lt, 0701, y), y)


