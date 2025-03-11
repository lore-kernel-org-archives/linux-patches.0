Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886B225B676;
	Tue, 11 Mar 2025 15:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706944; cv=none; b=JEaz/bcI9/hFNK1w9K3sRWGBb3JzuT1XuB3OzAAeQSmUHzXzPfPNrrXW+wFrbCASRPac5W8k/sWmzkMdKeGznS+znmVb/J0BAN2/2qDBaHus0iUrn47tpsNCKRoGEpxnHECNDYyRdTrgFU4Xh5pUzgj3M+q1wtmeCZ/eOzCOs2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706944; c=relaxed/simple;
	bh=4bum8QGfOH1o57SL4cozCi/YEtO/jXU+m8ZZz2nyVyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AOVvrPZGPL3Ek2OFLf/UtwKFNmdvIsI76IXvHMBPtWBa7AVYPEKIzMkM9+Tq8lemszvVEXVrgiR5oVKNUJbdoPuEMFkGqGS94P7+NSWdiK4oumN27tLII6Mnlv7NCfDw19StSbiSLEMJaMi32mH3qHwX40/zfr709+O3J/pVmNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/9e5fNZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/9e5fNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0413FC4CEED;
	Tue, 11 Mar 2025 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706944;
	bh=4bum8QGfOH1o57SL4cozCi/YEtO/jXU+m8ZZz2nyVyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/9e5fNZxs0AMQESnNdo2yv1I61ypT0bTH1SkEGtYBku3j9PBWlQZ9Hqk9XG/BfQI
	 vRkz8+nwu59pWf1NLg0/UUE+VYeuY7sPI7rKmwLvuH0b53vlIzUPwHQOq10y7uG5an
	 pZ3wU2eaAiP5gfJOhiG6AZZD3Dv38H3t06XivNoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 222/462] MIPS: ftrace: Declare ftrace_get_parent_ra_addr() as static
Date: Tue, 11 Mar 2025 15:58:08 +0100
Message-ID: <20250311145807.132506688@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -260,7 +260,7 @@ int ftrace_disable_ftrace_graph_caller(v
 #define S_R_SP	(0xafb0 << 16)	/* s{d,w} R, offset(sp) */
 #define OFFSET_MASK	0xffff	/* stack offset range: 0 ~ PT_SIZE */
 
-unsigned long ftrace_get_parent_ra_addr(unsigned long self_ra, unsigned long
+static unsigned long ftrace_get_parent_ra_addr(unsigned long self_ra, unsigned long
 		old_parent_ra, unsigned long parent_ra_addr, unsigned long fp)
 {
 	unsigned long sp, ip, tmp;


