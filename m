Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8A019F411;
	Wed,  2 Oct 2024 14:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878013; cv=none; b=T95zIsGZI5t+r6eGLj2EYhlj3HmlEPMpM05a3AQxX5LbYJx8XszACWcNW8SUC6NaBE210Uk57BOro1NvI2ZbiXIa03fEtHLC5ab/WvIQU5kNBsiZD2F3EmOJ0OXDscUPPZP5+/2icEVmydzwXABqLh7ZtwwMLXY0WYBiFZhGF2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878013; c=relaxed/simple;
	bh=/AlohaC9M0xaWlzgvmGv/g58xFAXvBjgIaquBQocN1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTpQi7bhy8wOC7jRiLV+wMGGA7Pj4W83rPyv9ESL2FUaAt3CvNHbNxN8tZuzuD7lHcrMZPg/x5p02o26Cd8S+Q/YWWGGwz8pibF2gfWV/TFDAFPi3r8CUfeNvYw6HvRJrR/q8V2cjPD5HF/Cwuu1SMrhqFRrmOUjm4mdShbHsgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNB9h3Lx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNB9h3Lx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0B6C4CECE;
	Wed,  2 Oct 2024 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878012;
	bh=/AlohaC9M0xaWlzgvmGv/g58xFAXvBjgIaquBQocN1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNB9h3LxyTa/HSPkMTKlElT8/koV9NrgaUv9xAhEI1Rv338O8EZ0QJZgCi9pSifWD
	 Yj0mFxmmx5RHjKokQ080zDQWxKk9y0xkg85vVYdyihlqdRY8ZMoi0ckdLgpMqfFZnf
	 aM7L4pg+U38seLaafTgVc3/e2NocAegjeDhpN/+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 240/634] selftests/bpf: Drop unneeded error.h includes
Date: Wed,  2 Oct 2024 14:55:40 +0200
Message-ID: <20241002125820.573081238@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index de2466547efe0..a1ab0af004549 100644
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



