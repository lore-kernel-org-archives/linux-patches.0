Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BF51FA178;
	Tue,  3 Dec 2024 15:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240773; cv=none; b=DN/pCUHzLE2YQWPGCft9PF3I8ju7voUFD62rRvevAXoQl9nHlJV+PX7OGtc+42NDdJy/e17sONvzBq/u2yMbneu1QC0FQJR3iF4QKPELqsbeMhhjWAg0Jk1s59rFWx4/BDj8mMPG325ULlPiNvfCTo0LS/e/K+3sWdgkG9QguCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240773; c=relaxed/simple;
	bh=XCtz3qoFBZG/Dq+cHzvqg6I4FDHnYXnXBiPxcG722Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eA8wtm8on0Su58Eg1v204Xrl+s9DZg7VtldLxeiYEPJSui2kp+pM435txOf5yPbShk4w6laIJaYsMaXJjDn1nyN98hd9gMYPWuSAihCY8RcTJhyI/w2Rc56Wtnz3h2FnTVF9MELHG7WzTtsdaRQ3M/Kk7/FVaIhhe6+MIXy9gJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvW6y7Xu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvW6y7Xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE5EC4CED6;
	Tue,  3 Dec 2024 15:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240772;
	bh=XCtz3qoFBZG/Dq+cHzvqg6I4FDHnYXnXBiPxcG722Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvW6y7Xund4ATd5RjYTPSaMNZtNkSjRH+K3xcxnmi2YnkVcBH4GxBbl3fMg1u2kgw
	 tf1ydZcnLimyImwxTQFgDhv7g0wLr0zRVO7jmDaAsnSyQKE1fKW8YEYo3NrxcWWhoL
	 bGmys+c1gWfI2Dhl0ocnVRwovuJ3XD+47Dl8GUFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 230/826] selftests: bpf: Add missing per-arch include path
Date: Tue,  3 Dec 2024 15:39:17 +0100
Message-ID: <20241203144752.717491485@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@rivosinc.com>

[ Upstream commit 19090f0306f1748980596c6c71f1c4b128639cff ]

The prog_tests programs do not include the per-arch tools include
path, e.g. tools/arch/riscv/include. Some architectures depend those
files to build properly.

Include tools/arch/$(SUBARCH)/include in the selftests bpf build.

Fixes: 6d74d178fe6e ("tools: Add riscv barrier implementation")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240927131355.350918-2-bjorn@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 75016962f7956..43a0293184785 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -10,6 +10,7 @@ TOOLSDIR := $(abspath ../../..)
 LIBDIR := $(TOOLSDIR)/lib
 BPFDIR := $(LIBDIR)/bpf
 TOOLSINCDIR := $(TOOLSDIR)/include
+TOOLSARCHINCDIR := $(TOOLSDIR)/arch/$(SRCARCH)/include
 BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
 APIDIR := $(TOOLSINCDIR)/uapi
 ifneq ($(O),)
@@ -44,7 +45,7 @@ CFLAGS += -g $(OPT_FLAGS) -rdynamic					\
 	  -Wall -Werror -fno-omit-frame-pointer				\
 	  $(GENFLAGS) $(SAN_CFLAGS) $(LIBELF_CFLAGS)			\
 	  -I$(CURDIR) -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR)		\
-	  -I$(TOOLSINCDIR) -I$(APIDIR) -I$(OUTPUT)
+	  -I$(TOOLSINCDIR) -I$(TOOLSARCHINCDIR) -I$(APIDIR) -I$(OUTPUT)
 LDFLAGS += $(SAN_LDFLAGS)
 LDLIBS += $(LIBELF_LIBS) -lz -lrt -lpthread
 
-- 
2.43.0



