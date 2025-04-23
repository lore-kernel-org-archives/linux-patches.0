Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93682BD5A8;
	Wed, 23 Apr 2025 15:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422380; cv=none; b=TD8tJMHrhKl/MH/75PLeCy5tba+c2Y4OkyUlFBpQJJ7ieHicAUthvEeenb1Rvyg0JzoKXHnQ9cadXdJ7kOSiMyVP7DqfwZFrDBNLx71DBJytCAdD/YwgRx3+rH47MGEZGJsTzz+atrzmKzI/IzSENU1S/SVtNcQJOmYEo52SLZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422380; c=relaxed/simple;
	bh=ethsZm+BiQTf+bkbSJ0TqDn9/Oj0s5SqbgOANyM7jPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nA5huf7aGuL3vOXxuJuhU2hNDgzvNc8JqriAOQiLqNFfzD12xlzMx7uZg+RhMQaN7HLrAgdMuisc2Ao75bl0lan4ztFj7p+xzjham89c/Uya4ZMSnTur2S0jLbPuVjiWVVq/HHrj/yaiXHUA12Qg5MraqhCBHPF1yajKGY1G92E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zj/yRDFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zj/yRDFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEEAC4CEE2;
	Wed, 23 Apr 2025 15:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422380;
	bh=ethsZm+BiQTf+bkbSJ0TqDn9/Oj0s5SqbgOANyM7jPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zj/yRDFhFAKnMay3jy35VJHK/bWz4mhof5OOnNtW9Rb6U6fb0/W7AyJUAq8fwk7hc
	 j5QAz+OTlR9t9kjd6XTD/bBuca8d5JmV520toMNux5NSTG7Tb1SM2ao52deHWhF5iF
	 m/q1v2XH3uzJ4mnzL94O7q0bo1Mssk5qOCHNDjmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 289/291] MIPS: dec: Declare which_prom() as static
Date: Wed, 23 Apr 2025 16:44:38 +0200
Message-ID: <20250423142636.240966905@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit 55fa5868519bc48a7344a4c070efa2f4468f2167 upstream.

Declare which_prom() as static to suppress gcc compiler warning that
'missing-prototypes'. This function is not intended to be called
from other parts.

Fix follow error with gcc-14 when -Werror:

arch/mips/dec/prom/init.c:45:13: error: no previous prototype for ‘which_prom’ [-Werror=missing-prototypes]
   45 | void __init which_prom(s32 magic, s32 *prom_vec)
      |             ^~~~~~~~~~
cc1: all warnings being treated as errors
make[6]: *** [scripts/Makefile.build:207: arch/mips/dec/prom/init.o] Error 1
make[5]: *** [scripts/Makefile.build:465: arch/mips/dec/prom] Error 2
make[5]: *** Waiting for unfinished jobs....

Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/dec/prom/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/dec/prom/init.c
+++ b/arch/mips/dec/prom/init.c
@@ -42,7 +42,7 @@ int (*__pmax_close)(int);
  * Detect which PROM the DECSTATION has, and set the callback vectors
  * appropriately.
  */
-void __init which_prom(s32 magic, s32 *prom_vec)
+static void __init which_prom(s32 magic, s32 *prom_vec)
 {
 	/*
 	 * No sign of the REX PROM's magic number means we assume a non-REX


