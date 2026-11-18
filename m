Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044142;
	b=M5siYVCPUTEpT5kha44CFSEN8W2hW/vhliQxZ/kmzXCTHLUhX+RCf4Zx4KRD+hoc7feW
	 P3jt2nQ6WExo22FAFCojBuFKvAN2iV7v2nXmduglzaIfEQ+V010d6gCxHD3qqyStCw7Ic
	 /YL4vI3TNKq96gcI6s2esS//NvI2Z+UmeZ6PAdgVMZ8c8sv6daVsA16wrcuW5dSy2igaV
	 cLfIL8tBhLm0NDnHXgo/ep5RPhLvMz+zZdikxVxKBTFAZDH/giq0qqrpTOEjkcAbFwIkZ
	 c8kNh3Yuc7oJYsRO7B9nOdiW+BGfcB6LeUlVP6qECUVgXmwieq7O5caknTpyAk03idA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OxZ0ygxspjcMbiumNQShodQyaZCHKS7lZ8p/ccDyevg=;
	b=t7vOdnwBAIA7cGkOyeQWRzbRk2N5kx2xI9r2NywZkbQGX0pUl+1zjS2yJmWsd6Y7RT6r
	 SdmkYOeTORz1/j1z3L+bIQgc88zm7BFM3VZQSjYw3XElHCPqotdQtiRfriGMGFGAeVKtl
	 N4lXvOyBoO6JPqGEgcB5bRx3EKKzHRe3KGc3QpmQPK7a/RkmSeRNHjMClJTjhuVym20qo
	 ma3M4GXSEBxFgzbHTnuge1jhjEQDOekPEvXE5SSp9bJNlwECnUltFKJGblNWkDwFuM6nP
	 GvAkzUEKC3R0Ghb56FTf6FtnTNMjgSwIzHUrQYWhi3e/1LVGI84jDuYRQHmoCfgqRtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hyd6fGI3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3427E606A32A;
	Wed, 18 Nov 2026 23:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hyd6fGI3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B741F000C4;
	Wed, 18 Nov 2026 23:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044142;
	bh=OxZ0ygxspjcMbiumNQShodQyaZCHKS7lZ8p/ccDyevg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyd6fGI3mYbmqXFa8e2BizvdCEPsFgL5a/MG5ZFbXVmHTfzkE/NSiQrLN6TMOuvDI
	 Uz+Mxkr25YNtILq27hYnL7Hq0uj74kXCwwFXG2iP5PphjMtEujDvB7y4jeoLpMy4yT
	 nUe/jMiBZIAJafyz3aoGhreY1/AeTxZvL4enVNtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Lipski <ivan.lipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0460/2857] drm/amd/display: Bump frame warning limit for clang builds of dml
Date: Wed, 18 Nov 2026 15:24:54 +0100
Message-ID: <20261118150217.982614321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Lipski <ivan.lipski@amd.com>

[ Upstream commit 18779dd84515db093fedb4ebaf0998c9b165a5fb ]

[Why&How]
When building the DML files with clang without any sanitizer or LTO,
the following -Wframe-larger-than errors break the build under
CONFIG_WERROR:

  display_mode_vba_30.c: error: stack frame size (2512) exceeds limit
    (2048) in 'dml30_ModeSupportAndSystemConfigurationFull'
  display_mode_vba_31.c: error: stack frame size (2416) exceeds limit
    (2048) in 'dml31_ModeSupportAndSystemConfigurationFull'
  display_mode_vba_314.c: error: stack frame size (2392) exceeds limit
    (2048) in 'dml314_ModeSupportAndSystemConfigurationFull'

Clang consistently spills more than gcc, pushing the frame past the 2048
byte limit.

Apply an existing approach of increasing the warn stack size to the
non-sanitizer path so plain clang builds use a 3072 byte limit.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5642
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 21711b6e66bb7b41b1aec67b2d99aafe768c8fcb)
Cc: stable@vger.kernel.org
[ sashal: Added a nested clang check in the older flat frame_warn_flag logic to set the 3072 limit, since the newer frame_warn_limit and test-lt structure is missing. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile b/drivers/gpu/drm/amd/display/dc/dml/Makefile
index 948e28648f42f..9267600a1deba 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -55,9 +55,13 @@ ifneq ($(CONFIG_FRAME_WARN),0)
 ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
 frame_warn_flag := -Wframe-larger-than=3072
 else
+ifeq ($(CONFIG_CC_IS_CLANG),y)
+frame_warn_flag := -Wframe-larger-than=3072
+else
 frame_warn_flag := -Wframe-larger-than=2048
 endif
 endif
+endif
 
 CFLAGS_$(AMDDALPATH)/dc/dml/display_mode_lib.o := $(dml_ccflags)
 
-- 
2.53.0



