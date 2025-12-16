Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A1539FD9;
	Tue, 16 Dec 2025 12:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888019; cv=none; b=UWLmiIIzpdP2ekK/ie5R2iyYzLs2X6BaazfiAqIUl7+IvEhMW7E7hQpg26uguUa2HVA3lLW5at2oJ2oyKBsQcmk+AR3lH5kR/wrCrARx4JHvL7ModRJYL90nks0uP0MUGKUFbkUmsvmbdknNwrCN0NxeaH5eLf3I7rjqofmBQSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888019; c=relaxed/simple;
	bh=4DXXR/PNw87izYd8qOGh3YbVMvqx4hZA2YYuxzdGWjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/fx+cWfv2GKvGjvtpcEmgGQXsLVvxjO6y05NxaaQn+1yEPQAPvEYeFShE+V3nSgk7hgPI5rT89igy2fj7ACFfsSIePNqJpq7nvIkByF0YvLcoLMXgLjTf3gPj8g6ks9PztpovbVV4jEWM4RHdjaTEUhzCyRUyCxTwPOXT+NRso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YluuPNcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YluuPNcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9959C4CEF1;
	Tue, 16 Dec 2025 12:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888019;
	bh=4DXXR/PNw87izYd8qOGh3YbVMvqx4hZA2YYuxzdGWjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YluuPNcsET4DU5JvT4Gf+ddElWhIx6U46TtYk18LW4sKASXq2dxM4+HJ7MywJro2j
	 QbThOciUbdqAsnHYqxiviB6mIBxcYotNUV5iP2xcI8zWI0j0y8QFscAOszwiC4/DkW
	 FpQZvAEbiSzxTIyjs8OkWJnrGQ2UNVPXeA7K3W1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <alan.maguire@oracle.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 407/614] selftests/bpf: Allow selftests to build with older xxd
Date: Tue, 16 Dec 2025 12:12:54 +0100
Message-ID: <20251216111416.119802360@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit ad93ba02678eda5fc8e259cf4b52997e6fa570cf ]

Currently selftests require xxd with the "-n <name>" option
which allows the user to specify a name not derived from
the input object path.  Instead of relying on this newer
feature, older xxd can be used if we link our desired name
("test_progs_verification_cert") to the input object.

Many distros ship xxd in vim-common package and do not have
the latest xxd with -n support.

Fixes: b720903e2b14d ("selftests/bpf: Enable signature verification for some lskel tests")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/r/20251120084754.640405-3-alan.maguire@oracle.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/.gitignore | 1 +
 tools/testing/selftests/bpf/Makefile   | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index be1ee7ba7ce03..ca557e5668fd8 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -23,6 +23,7 @@ test_tcpnotify_user
 test_libbpf
 xdping
 test_cpp
+test_progs_verification_cert
 *.d
 *.subskel.h
 *.skel.h
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index f00587d4ede68..e59b2bbf8d920 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -721,7 +721,8 @@ $(VERIFICATION_CERT) $(PRIVATE_KEY): $(VERIFY_SIG_SETUP)
 	$(Q)$(VERIFY_SIG_SETUP) genkey $(BUILD_DIR)
 
 $(VERIFY_SIG_HDR): $(VERIFICATION_CERT)
-	$(Q)xxd -i -n test_progs_verification_cert $< > $@
+	$(Q)ln -fs $< test_progs_verification_cert && \
+	xxd -i test_progs_verification_cert > $@
 
 # Define test_progs test runner.
 TRUNNER_TESTS_DIR := prog_tests
@@ -893,7 +894,8 @@ EXTRA_CLEAN := $(SCRATCH_DIR) $(HOST_SCRATCH_DIR)			\
 	$(addprefix $(OUTPUT)/,*.o *.d *.skel.h *.lskel.h *.subskel.h	\
 			       no_alu32 cpuv4 bpf_gcc			\
 			       liburandom_read.so)			\
-	$(OUTPUT)/FEATURE-DUMP.selftests
+	$(OUTPUT)/FEATURE-DUMP.selftests				\
+	test_progs_verification_cert
 
 .PHONY: docs docs-clean
 
-- 
2.51.0



