Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9258826B087;
	Thu, 13 Feb 2025 15:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460955; cv=none; b=FBcb4jwmED3Z3HtB+JamRLeAKDeuir6m0rRtnpqfrA8m+Nj//WcQ0mCpELJV8D6wJ0NDFSdus1/knomSMw498wbCOqWPUNC7AeRmAyEN5Mbe+jpoKYi9SJTotKFkn1Vatwlr++xBN+PZjS2Uyz5j5XHZNOutOEtFdsK3E3CVQbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460955; c=relaxed/simple;
	bh=bJoEObKifVVsgGUWhvo7+NtdLtdfswy0DQ0EBy6jGoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iv1LScGWD9iyTS4WnFvmaKJ5SIxvSRKod6JLaYwKfXamZGlS2AHiBEUMgB1cw6UXw7z55iTnY5yDQNcMbg8Y+HS+FXJjWuhoXw7NJdUu9bSTTW14t+lL0lb6/T9dqOrGElD2baRXxhLLmQM+8VCfGqYdGTrMWEAfHd2z2raKP6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhI2lU10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhI2lU10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187D7C4CED1;
	Thu, 13 Feb 2025 15:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460955;
	bh=bJoEObKifVVsgGUWhvo7+NtdLtdfswy0DQ0EBy6jGoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhI2lU10gOcie/stArjvo+ucZYVFVnOBoshtGI4w1gYe/omErPDu4fH7WVsjcPFsb
	 OmRGBbjR/V3Fa0+VBfLPcgVghnOf61gx7wSoU7z+TXZXoh16sazIW8soXIKp85HnnS
	 bDScWx3l2X+JPoOfsG3uqbZUsqaMlWw1sACNlZ3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 259/273] MIPS: ftrace: Declare ftrace_get_parent_ra_addr() as static
Date: Thu, 13 Feb 2025 15:30:31 +0100
Message-ID: <20250213142417.654093826@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


