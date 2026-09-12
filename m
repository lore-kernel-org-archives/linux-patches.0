Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE20033ADB9;
	Sat, 12 Sep 2026 07:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199334; cv=none; b=fNFp7rI7vTUJx3AGZ9oWJJzLDG76DF315PLEiw6rteQdBbqx91G2SG4/ftkNOPKkLBBGbkaNWSMlwOuqrjnVUyxTXH86eeT5fmOCtG1RoyQ7ocT86wWte3BEWxXdfFFKozb78oMwAyxSUlU3kRk2895h4jGX18yPNhZXA0Gne1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199334; c=relaxed/simple;
	bh=Lf1MvUUpXdtNnaZfd6D0oGU/c8wBhactFwtPfp2WO6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a0zWsWeO6SGL2SbGWrBXxZWn6SS3M4vhfoOeyLY3RrqQqHNxOcmt9TlePqkbH4NcOUBFMK58jrauCW/8RagsYi1FPjXwzKi1Z60LLAXRpiOcZ+ivdTcpZShj09/O/ljWA7TJqzKutPCvdekLUeKdF9PEruB+sKvZEYUgovsFEKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWKd4XOm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWKd4XOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA7D1F000FF;
	Sat, 12 Sep 2026 07:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199332;
	bh=vvJ/Y75J2+1H4bmSeCqZT8gvUjZWvHB/SERv39917tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWKd4XOmLqi0pBivJxgZLcaoYLP5pycz95opjF7e+Y4HwZ3DJIra0PMifTQPFD6q7
	 tGOw/CJyOwHWGJkFr1slIoeKx3dNUXhGRuT+I0M2uY6CGgZOwvTDb4ZfbloaEsEZuJ
	 d80II31zh6VWGNFT49cV6IWOYMZBkTw90966QONo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0564/1815] selftests/bpf: Fix make install target
Date: Sat, 12 Sep 2026 08:38:34 +0200
Message-ID: <20260912065702.123311871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit 0b236ac75d04a235f3574a2208941b22c1e7a965 ]

After "make install", test_progs fails because two files end up in the
wrong place:

- bpftool: TEST_GEN_PROGS_EXTENDED flattens it into $(INSTALL_PATH), losing
  the tools/sbin/ prefix that detect_bpftool_path() expects. Remove it from
  TEST_GEN_PROGS_EXTENDED and install it explicitly under tools/sbin/
  instead.

- *.BTF: resolve_btfids writes resolve_btfids.test.o.BTF as a side-effect
  of the build but INSTALL_RULE never copies it over. Install all *.BTF
  files alongside the rest of the per-flavor output.

Fixes: f21fae577446 ("selftests/bpf: Add a few helpers for bpftool testing")
Fixes: 522397d05e7d ("resolve_btfids: Change in-place update with raw binary output")
Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/bpf/20260720-selftests-bpf_fixes-v2-1-b450eda93dfe@suse.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index b642ee489ea64..55d394438705a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -324,8 +324,6 @@ TRUNNER_BPFTOOL := $(DEFAULT_BPFTOOL)
 USE_BOOTSTRAP := "bootstrap/"
 endif
 
-TEST_GEN_PROGS_EXTENDED += $(TRUNNER_BPFTOOL)
-
 $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(BPFOBJ)
 
 TESTING_HELPERS	:= $(OUTPUT)/testing_helpers.o
@@ -1055,10 +1053,13 @@ endif
 DEFAULT_INSTALL_RULE := $(INSTALL_RULE)
 override define INSTALL_RULE
 	$(DEFAULT_INSTALL_RULE)
+	@mkdir -p $(INSTALL_PATH)/tools/sbin
+	@rsync -a $(if $(PERMISSIVE),--ignore-missing-args) $(TRUNNER_BPFTOOL) $(INSTALL_PATH)/tools/sbin/
+	@rsync -a $(if $(PERMISSIVE),--ignore-missing-args) $(OUTPUT)/*.BTF $(INSTALL_PATH)/
 	@for DIR in $(TEST_INST_SUBDIRS); do				  \
 		mkdir -p $(INSTALL_PATH)/$$DIR;				  \
 		rsync -a $(if $(PERMISSIVE),--ignore-missing-args)	  \
-			$(OUTPUT)/$$DIR/*.bpf.o				  \
+			$(OUTPUT)/$$DIR/*.bpf.o $(OUTPUT)/$$DIR/*.BTF \
 			$(INSTALL_PATH)/$$DIR;				  \
 	done
 endef
-- 
2.53.0



