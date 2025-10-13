Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305B6316187;
	Mon, 13 Oct 2025 15:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369258; cv=none; b=Rp29TJj0WXrznlLG76DMQ3Lx3AUnRb3veLUaixGxsweK9iBCc8YQ0xTZnG3gqBICFvVAyqeN6/zpKhUAhQj2BKZQJWD6gCU2aEJSxXFW4ELKa3ciDt1ySjDAPy8+P0Xquz7A/CYC9HQTAiaTuFW0prejcudI/eSwMlXYT2ol4Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369258; c=relaxed/simple;
	bh=AygGbg/wa4BoXEJ1N63ufYMRyAdSGW81OAAc/oWYi6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e5y8/9Cj4A4y3rexoJnX2gVKP62mp7rXfkeQN6/lek7G3MBUzJShHasgSZgJR3lZF7J6OSxIliRoIZ+OzEdLENwuAwVVMQA2yqFhQls2UCfxLQstswXo/Gbfu/tByblSnBqK1rL9cbRyFU3Nee7Xb1/G2sU7WSVSeL7DfDiZTHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHUy2f+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHUy2f+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE38C4CEE7;
	Mon, 13 Oct 2025 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369258;
	bh=AygGbg/wa4BoXEJ1N63ufYMRyAdSGW81OAAc/oWYi6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHUy2f+CqLASogDUYW+tVh1tdZYy20fkiQyWyk12tdjEHv5XgDsje/+A2cahEOM1b
	 aEmL7zXbjCDzXAYiBDubNROh1Gc67NOysirSjBmCAlKbtgLBr6pZSXsGukvGUpDk9B
	 Cy3pUqW1PhPT10HLRde2ayJcqfS+zNeAM/62YobI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 183/563] selftests: always install UAPI headers to the correct directory
Date: Mon, 13 Oct 2025 16:40:44 +0200
Message-ID: <20251013144417.913289732@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 2c55daf7de07158df2ab3835321086beca25a691 ]

Currently the UAPI headers are always installed into the source directory.
When building out-of-tree this doesn't work, as the include path will be
wrong and it dirties the source tree, leading to complains by kbuild.

Make sure the 'headers' target installs the UAPI headers in the correctly.

The real target directory can come from multiple places. To handle them all
extract the target directory from KHDR_INCLUDES.

Link: https://lore.kernel.org/r/20250918-kselftest-uapi-out-of-tree-v1-1-f4434f28adcd@linutronix.de
Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Closes: https://lore.kernel.org/lkml/20250917153209.GA2023406@nvidia.com/
Fixes: 1a59f5d31569 ("selftests: Add headers target")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lib.mk | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 5303900339292..a448fae57831d 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -228,7 +228,10 @@ $(OUTPUT)/%:%.S
 	$(LINK.S) $^ $(LDLIBS) -o $@
 endif
 
+# Extract the expected header directory
+khdr_output := $(patsubst %/usr/include,%,$(filter %/usr/include,$(KHDR_INCLUDES)))
+
 headers:
-	$(Q)$(MAKE) -C $(top_srcdir) headers
+	$(Q)$(MAKE) -f $(top_srcdir)/Makefile -C $(khdr_output) headers
 
 .PHONY: run_tests all clean install emit_tests gen_mods_dir clean_mods_dir headers
-- 
2.51.0



