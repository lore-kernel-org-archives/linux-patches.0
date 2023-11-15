Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94BA2FB3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzkhn/7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B168C433C8;
	Wed, 15 Nov 2023 19:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076083;
	bh=oYhAJ6fpWc+1X99dmGMNbmwHcd/XnszLb5STI4lWuxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzkhn/7kl7r1n3hKF9TSbwDOi3dMMNcFWVPe2M55/2WSQvTr9QN0Yb/bLi9P/RBR/
	 YYjtB+K43hIBN4a2JBtKL36mT20k+mlT/LHya0IQUCj+UraLVq17s3594ZCWtdrRKc
	 brXsbkGfAJu3HwW7TTY3bEyjNp4nliFQ7yPiY4zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Savkov <asavkov@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 066/550] selftests/bpf: Skip module_fentry_shadow test when bpf_testmod is not available
Date: Wed, 15 Nov 2023 14:10:50 -0500
Message-ID: <20231115191605.266922852@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Savkov <asavkov@redhat.com>

[ Upstream commit 971f7c32147f2d0953a815a109b22b8ed45949d4 ]

This test relies on bpf_testmod, so skip it if the module is not available.

Fixes: aa3d65de4b900 ("bpf/selftests: Test fentry attachment to shadowed functions")
Signed-off-by: Artem Savkov <asavkov@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20230914124928.340701-1-asavkov@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/module_fentry_shadow.c  | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/module_fentry_shadow.c b/tools/testing/selftests/bpf/prog_tests/module_fentry_shadow.c
index c7636e18b1ebd..aa9f67eb1c95b 100644
--- a/tools/testing/selftests/bpf/prog_tests/module_fentry_shadow.c
+++ b/tools/testing/selftests/bpf/prog_tests/module_fentry_shadow.c
@@ -61,6 +61,11 @@ void test_module_fentry_shadow(void)
 	int link_fd[2] = {};
 	__s32 btf_id[2] = {};
 
+	if (!env.has_testmod) {
+		test__skip();
+		return;
+	}
+
 	LIBBPF_OPTS(bpf_prog_load_opts, load_opts,
 		.expected_attach_type = BPF_TRACE_FENTRY,
 	);
-- 
2.42.0



