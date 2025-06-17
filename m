Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C26285048;
	Tue, 17 Jun 2025 16:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178138; cv=none; b=HIwKtnrEj7XwLMPFS5P546Y5ByaChU3j1ZWPyt/2DsOLsjZXlVCdSCU9748SLSrz2SpxLcyGYTOmK8OP2bWn9oNRTM1Hg5/XdnGvDPAXjiviVUiMCYUlwRVgm0Nf/QUn7cZj6CWHsuyD51cPE42UyfYicmo/1Kp31pyN7oxidHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178138; c=relaxed/simple;
	bh=uCFfkCBAWTEAGKgSQiZ2ScyUeV0MjzvPj2+Ik8ElGZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuP4dSmQM3KKsoWp1PaCH24QcMw0lHugRUY/5N4/MKTgZA35H9glSsYLu/xr2K9re69Q+B3tSvHe0opuPOr2U2Iq3yncSjJJ9BZdCWOKyezq230Xq1T9KcD9LWN8XmUeUlPZsnS5czGqV1f2RlHdRM3e3tHi/zjswM5NuKhJQqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7DlgjZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7DlgjZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A1DC4CEE3;
	Tue, 17 Jun 2025 16:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178138;
	bh=uCFfkCBAWTEAGKgSQiZ2ScyUeV0MjzvPj2+Ik8ElGZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7DlgjZ4P3w1ymrnbOTVtZFUIi2CsAweG1tOcbtDdcITNp4KUOiulUAEAl2DqcoOx
	 rFO7+OA8zj3kJLkbo0uTP96LwZtuT9JV/wWWz8w9Twjoxp8laDZBQtWDdbrKhAS/g2
	 FX6v1zB7Vf5TGZAeUAz/ZfoYmDAA7oyBt40M2Al4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Marco Elver <elver@google.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 415/780] ubsan: integer-overflow: depend on BROKEN to keep this out of CI
Date: Tue, 17 Jun 2025 17:22:03 +0200
Message-ID: <20250617152508.374768723@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit d6a0e0bfecccdcecb08defe75a137c7262352102 ]

Depending on !COMPILE_TEST isn't sufficient to keep this feature out of
CI because we can't stop it from being included in randconfig builds.
This feature is still highly experimental, and is developed in lock-step
with Clang's Overflow Behavior Types[1]. Depend on BROKEN to keep it
from being enabled by anyone not expecting it.

Link: https://discourse.llvm.org/t/rfc-v2-clang-introduce-overflowbehaviortypes-for-wrapping-and-non-wrapping-arithmetic/86507 [1]
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202505281024.f42beaa7-lkp@intel.com
Fixes: 557f8c582a9b ("ubsan: Reintroduce signed overflow sanitizer")
Acked-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20250528182616.work.296-kees@kernel.org
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.ubsan | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index f6ea0c5b5da39..96cd896684676 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -118,6 +118,8 @@ config UBSAN_UNREACHABLE
 
 config UBSAN_INTEGER_WRAP
 	bool "Perform checking for integer arithmetic wrap-around"
+	# This is very experimental so drop the next line if you really want it
+	depends on BROKEN
 	depends on !COMPILE_TEST
 	depends on $(cc-option,-fsanitize-undefined-ignore-overflow-pattern=all)
 	depends on $(cc-option,-fsanitize=signed-integer-overflow)
-- 
2.39.5



