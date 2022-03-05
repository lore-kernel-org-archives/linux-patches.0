Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B637E
	for <patches@lists.linux.dev>; Sat,  5 Mar 2022 04:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52087C004E1;
	Sat,  5 Mar 2022 04:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1646454551;
	bh=Ba6bPHTW4yYgrzle9tTjMeLQGIHPn5To0kO7awLkKaE=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=2ROiaIi+fIrjXajdE6EgR+VeJnnO4ppHrysqfpSpTgXpbEn+d0MWa+MR+iEdUtgvt
	 N5EFUePhr1Evoy/+ss6uElBSaCBxurSjE4uPHN7vQ1AUgDzHXU6aSUCi9/VhX86sOr
	 BFslu5TDTRNKQmrzYuq7HgAg6fifMfmEXt5MjHsQ=
Date: Fri, 04 Mar 2022 20:29:10 -0800
To: quic_qiancai@quicinc.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220304202822.d47f8084928321c83070d7d7@linux-foundation.org>
Subject: [patch 8/8] configs/debug: set CONFIG_DEBUG_INFO=y properly
Message-Id: <20220305042911.52087C004E1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Qian Cai <quic_qiancai@quicinc.com>
Subject: configs/debug: set CONFIG_DEBUG_INFO=y properly

CONFIG_DEBUG_INFO can't be set by user directly, so set
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y instead.  Otherwise, we end up
with no debuginfo in vmlinux which is a big no-no for kernel debugging.

Link: https://lkml.kernel.org/r/20220301202920.18488-1-quic_qiancai@quicinc.com
Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/debug.config |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/configs/debug.config~configs-debug-set-config_debug_info=y-properly
+++ a/kernel/configs/debug.config
@@ -16,7 +16,7 @@ CONFIG_SYMBOLIC_ERRNAME=y
 #
 # Compile-time checks and compiler options
 #
-CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_DEBUG_SECTION_MISMATCH=y
 CONFIG_FRAME_WARN=2048
 CONFIG_SECTION_MISMATCH_WARN_ONLY=y
_
