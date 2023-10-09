Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7FB1A71F
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svp7+lsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78035C433C7;
	Mon,  9 Oct 2023 13:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858429;
	bh=Pu+JITH6cba+/EFHyqtoFCfPajzifns90ZUUD+YY5SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svp7+lsxyAS3+YrjqEgYG+wTSkCNMlSKczJzZiwS4zJvnEMsJ0fvdqH6Zv6VtSyUn
	 3Svjy3+YyTnpn/x7vyeF7UX0DcnImoLnhYlBCMT9u6Xatz104DtRvLPtXtym9W79T+
	 0BZfThDCdojrUFxe/M/AW/p7jqQFBNC+DUbtACtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Babrou <ivan@cloudflare.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5.4 120/131] cpupower: add Makefile dependencies for install targets
Date: Mon,  9 Oct 2023 15:02:40 +0200
Message-ID: <20231009130120.100166252@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Babrou <ivan@cloudflare.com>

commit fb7791e213a64495ec2336869b868fcd8af14346 upstream.

This allows building cpupower in parallel rather than serially.

Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/power/cpupower/Makefile       |    8 ++++----
 tools/power/cpupower/bench/Makefile |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/tools/power/cpupower/Makefile
+++ b/tools/power/cpupower/Makefile
@@ -270,14 +270,14 @@ clean:
 	$(MAKE) -C bench O=$(OUTPUT) clean
 
 
-install-lib:
+install-lib: libcpupower
 	$(INSTALL) -d $(DESTDIR)${libdir}
 	$(CP) $(OUTPUT)libcpupower.so* $(DESTDIR)${libdir}/
 	$(INSTALL) -d $(DESTDIR)${includedir}
 	$(INSTALL_DATA) lib/cpufreq.h $(DESTDIR)${includedir}/cpufreq.h
 	$(INSTALL_DATA) lib/cpuidle.h $(DESTDIR)${includedir}/cpuidle.h
 
-install-tools:
+install-tools: $(OUTPUT)cpupower
 	$(INSTALL) -d $(DESTDIR)${bindir}
 	$(INSTALL_PROGRAM) $(OUTPUT)cpupower $(DESTDIR)${bindir}
 	$(INSTALL) -d $(DESTDIR)${bash_completion_dir}
@@ -293,14 +293,14 @@ install-man:
 	$(INSTALL_DATA) -D man/cpupower-info.1 $(DESTDIR)${mandir}/man1/cpupower-info.1
 	$(INSTALL_DATA) -D man/cpupower-monitor.1 $(DESTDIR)${mandir}/man1/cpupower-monitor.1
 
-install-gmo:
+install-gmo: create-gmo
 	$(INSTALL) -d $(DESTDIR)${localedir}
 	for HLANG in $(LANGUAGES); do \
 		echo '$(INSTALL_DATA) -D $(OUTPUT)po/$$HLANG.gmo $(DESTDIR)${localedir}/$$HLANG/LC_MESSAGES/cpupower.mo'; \
 		$(INSTALL_DATA) -D $(OUTPUT)po/$$HLANG.gmo $(DESTDIR)${localedir}/$$HLANG/LC_MESSAGES/cpupower.mo; \
 	done;
 
-install-bench:
+install-bench: compile-bench
 	@#DESTDIR must be set from outside to survive
 	@sbindir=$(sbindir) bindir=$(bindir) docdir=$(docdir) confdir=$(confdir) $(MAKE) -C bench O=$(OUTPUT) install
 
--- a/tools/power/cpupower/bench/Makefile
+++ b/tools/power/cpupower/bench/Makefile
@@ -27,7 +27,7 @@ $(OUTPUT)cpufreq-bench: $(OBJS)
 
 all: $(OUTPUT)cpufreq-bench
 
-install:
+install: $(OUTPUT)cpufreq-bench
 	mkdir -p $(DESTDIR)/$(sbindir)
 	mkdir -p $(DESTDIR)/$(bindir)
 	mkdir -p $(DESTDIR)/$(docdir)


