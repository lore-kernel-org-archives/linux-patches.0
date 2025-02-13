Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943612A1CF;
	Thu, 13 Feb 2025 15:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460022; cv=none; b=tw9LPMTvGti1l7vwqI8xGH21j+sj9a+4TfrxCsMTWd9L8Zb4lm+Rnhdf838KVmcpe+Rk9yYmE5sszhCJh7QVU2srO1vNtMA3gCAA8zpfzSK0zxHuspFKA2SQXeTfSN7yrMsGWmIsl+vqsNUAJCfBjPyBtF0l0fzONmzQI6bkEMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460022; c=relaxed/simple;
	bh=+9fUBj1pFnTmt1XKZJ+mfsNde2QQHvda7L/RSYuHBSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WzPdQr5smiBrA0cULEFyyRNj7FtScCOMRebSkEvzdxwf6b0GvH9IxBrbbKqk8QEm8DXMK+poSA8gGnLQhS9Me1v+J3rJEOZlm6wFiy3vE+yas1hg3jkux88AmTbMTqdm3/OZLfdCQTOxmIa554pEcVqItcuDM96zOqE/7cMaGjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0xJL3wL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0xJL3wL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A68C4CED1;
	Thu, 13 Feb 2025 15:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460022;
	bh=+9fUBj1pFnTmt1XKZJ+mfsNde2QQHvda7L/RSYuHBSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0xJL3wLsoqapQ404h8KZyb7GMHOVV8gCfi9agWgDgF/P9Zx/xHLs78p8IQ4hKcEt
	 hVq1wB5pLaq2P7z4TOJrLXsxJMgvCgyZRh7RqC2ptCKx+EKsCAL0s+Mwf237C7fD0j
	 wkqQ3cBorGFHJ0oxmD3U9O2JExQe04dKk+atqrGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.13 434/443] MIPS: ftrace: Declare ftrace_get_parent_ra_addr() as static
Date: Thu, 13 Feb 2025 15:29:59 +0100
Message-ID: <20250213142457.365582332@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit ddd068d81445b17ac0bed084dfeb9e58b4df3ddd upstream.

Declare ftrace_get_parent_ra_addr() as static to suppress clang
compiler warning that 'no previous prototype'. This function is
not intended to be called from other parts.

Fix follow error with clang-19:

arch/mips/kernel/ftrace.c:251:15: error: no previous prototype for function 'ftrace_get_parent_ra_addr' [-Werror,-Wmissing-prototypes]
  251 | unsigned long ftrace_get_parent_ra_addr(unsigned long self_ra, unsigned long
      |               ^
arch/mips/kernel/ftrace.c:251:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
  251 | unsigned long ftrace_get_parent_ra_addr(unsigned long self_ra, unsigned long
      | ^
      | static
1 error generated.

Signed-off-by: WangYuli <wangyuli@uniontech.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -248,7 +248,7 @@ int ftrace_disable_ftrace_graph_caller(v
 #define S_R_SP	(0xafb0 << 16)	/* s{d,w} R, offset(sp) */
 #define OFFSET_MASK	0xffff	/* stack offset range: 0 ~ PT_SIZE */
 
-unsigned long ftrace_get_parent_ra_addr(unsigned long self_ra, unsigned long
+static unsigned long ftrace_get_parent_ra_addr(unsigned long self_ra, unsigned long
 		old_parent_ra, unsigned long parent_ra_addr, unsigned long fp)
 {
 	unsigned long sp, ip, tmp;


