Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1161D0799;
	Wed,  2 Oct 2024 13:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875920; cv=none; b=NsaWD2FgGwQHg2l9fWV4wX85t6JDgTnKuSOgOUdVzypX+DZSUtSHjZxvNkKylAtqmn/m5OO70hL9tG99rfndzYhmJ52ILNnWuYT7xfVEFG+xI99iIUao2TZv/RbWGLQeEpERARl8Y3mDvI0mZIUdMFJo4xqtQ7wm39kMfF7zqnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875920; c=relaxed/simple;
	bh=+Nff7lImidNuoF5Ce+Dhca3A3U7TTexo1YDztBUkCRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRg+VmGtCqIf96Ro6HFjmYNO57k9HLEbT89b3McQuWq47q3QAdnfH17mXgj30Iv6nsrY+ilgl91O31IngypNFRJcbTKiMA+Ntkw8GDq+DbR21JADeNdwDCrfhl+i60Ieeh8dlBWdbx6NuavXmGRtKpK7TUJCGJrz4IjewCrPX9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvVHIAx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvVHIAx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB781C4CEC5;
	Wed,  2 Oct 2024 13:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875920;
	bh=+Nff7lImidNuoF5Ce+Dhca3A3U7TTexo1YDztBUkCRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvVHIAx8lbn8lGu7vVZO+WRykRW7qo6jQesauYBy1u6p1d7sw0MeyZIUCD/WhQGzx
	 xjblHP7r8cms7bLdxwjirf9BTdpu470ZUc5xP9P34Cfx4JNxzn0XJ6MtHaOKvEXTH1
	 2J8AdEV8mcu/QrBoZW4mIFei0dBJiYjFBnmF5erk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 267/695] selftests/bpf: Drop unneeded error.h includes
Date: Wed,  2 Oct 2024 14:54:25 +0200
Message-ID: <20241002125833.106942628@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 69f409469c9b1515a5db40d5a36fda372376fa2d ]

The addition of general support for unprivileged tests in test_loader.c
breaks building test_verifier on non-glibc (e.g. musl) systems, due to the
inclusion of glibc extension '<error.h>' in 'unpriv_helpers.c'. However,
the header is actually not needed, so remove it to restore building.

Similarly for sk_lookup.c and flow_dissector.c, error.h is not necessary
and causes problems, so drop them.

Fixes: 1d56ade032a4 ("selftests/bpf: Unprivileged tests for test_loader.c")
Fixes: 0ab5539f8584 ("selftests/bpf: Tests for BPF_SK_LOOKUP attach point")
Fixes: 0905beec9f52 ("selftests/bpf: run flow dissector tests in skb-less mode")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/5664367edf5fea4f3f4b4aec3b182bcfc6edff9c.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 1 -
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c      | 1 -
 tools/testing/selftests/bpf/unpriv_helpers.c            | 1 -
 3 files changed, 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index 9e5f38739104b..9625e6d217913 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 #include <network_helpers.h>
-#include <error.h>
 #include <linux/if_tun.h>
 #include <sys/uio.h>
 
diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index ae87c00867ba4..dcb2f62cdec6c 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -18,7 +18,6 @@
 #include <arpa/inet.h>
 #include <assert.h>
 #include <errno.h>
-#include <error.h>
 #include <fcntl.h>
 #include <sched.h>
 #include <stdio.h>
diff --git a/tools/testing/selftests/bpf/unpriv_helpers.c b/tools/testing/selftests/bpf/unpriv_helpers.c
index b6d016461fb02..220f6a9638134 100644
--- a/tools/testing/selftests/bpf/unpriv_helpers.c
+++ b/tools/testing/selftests/bpf/unpriv_helpers.c
@@ -2,7 +2,6 @@
 
 #include <stdbool.h>
 #include <stdlib.h>
-#include <error.h>
 #include <stdio.h>
 #include <string.h>
 #include <unistd.h>
-- 
2.43.0



