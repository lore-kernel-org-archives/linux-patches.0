Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0452C30C36E;
	Mon, 13 Oct 2025 15:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368864; cv=none; b=G61LrzTo16RsjMHFQHIyjwLdpvWZ0GUzjXs3AUhV9qxYB4A2fJAKEdKbywcfvu/MNI7/skYp/XjypF00MQAP1mA9iuKWb88/0bEHNqw+qTSFqbfbNBsYL9gtlRoM50btY6j2U4oe2YYJv/sqIqgtaJG32R1gNYUMXQsMB7BXLX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368864; c=relaxed/simple;
	bh=6CKmgAoG5Gno3El2rMEmzJBkvQmrpXjewvjXEeITqeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyuLtgKOVXY17uY1gBwsRlxnaiHTtHZmf/53slXwELEPYTXpBOHz5mDkUA/fQoE0zyjNrWkwkW77EciZIzEDYtajpYw5XrhQTrwsPKm9zGtGV5JoteC3EZxieu9WCQfjxSwtdii6pDaQdBYRNULrPT7HHbnYBW7C1MzwG7EQzes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/GJTWLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/GJTWLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E68C4CEE7;
	Mon, 13 Oct 2025 15:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368863;
	bh=6CKmgAoG5Gno3El2rMEmzJBkvQmrpXjewvjXEeITqeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/GJTWLoEgge9d3UExELLENe1aCuB5bcvQljKHhwP5fGf9Ka5FigWZ+YU6thCeEw8
	 5kMfjuu43CYkzVmMI+ciD65twcQ5tZD2a0R52WrjtyPDoZh83e9C36tjKPll9Po3F/
	 jR+PmUeX3IbGXGEMflBInhVO4vPSbKmSU7rwk4Rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <ameryhung@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 045/563] selftests/bpf: Copy test_kmods when installing selftest
Date: Mon, 13 Oct 2025 16:38:26 +0200
Message-ID: <20251013144412.925780209@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amery Hung <ameryhung@gmail.com>

[ Upstream commit 07866544e410e4c895a729971e4164861b41fad5 ]

Commit d6212d82bf26 ("selftests/bpf: Consolidate kernel modules into
common directory") consolidated the Makefile of test_kmods. However,
since it removed test_kmods from TEST_GEN_PROGS_EXTENDED, the kernel
modules required by bpf selftests are now missing from kselftest_install
when "make install". Fix it by adding test_kmod to TEST_GEN_FILES.

Fixes: d6212d82bf26 ("selftests/bpf: Consolidate kernel modules into common directory")
Signed-off-by: Amery Hung <ameryhung@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250812175039.2323570-1-ameryhung@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 4863106034dfb..77794efc020ea 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -137,7 +137,7 @@ TEST_GEN_PROGS_EXTENDED = \
 	xdping \
 	xskxceiver
 
-TEST_GEN_FILES += liburandom_read.so urandom_read sign-file uprobe_multi
+TEST_GEN_FILES += $(TEST_KMODS) liburandom_read.so urandom_read sign-file uprobe_multi
 
 ifneq ($(V),1)
 submake_extras := feature_display=0
-- 
2.51.0



