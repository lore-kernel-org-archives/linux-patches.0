Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C553C461
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2TjOHfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD283C433C7;
	Wed, 15 Nov 2023 19:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077101;
	bh=mRLGl0NOfWGDfFqSttyZBE+SCVhEas1W7R+Rrv8DFIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2TjOHfHbiFwDGZYkT3ed51pJVZviz4fIJ8VM0HiDaO9A1TPnSpHwxKuPLpLIovPQ
	 rD23bHzMoLf/oJnu4X4gvHPFTHLXdT/oY3Ryj6KSelD0lRhBbFYpdd2Awv/kvELpTf
	 vmJAYCdFzMS837qpV1UeOSbpJYGdj3jEUD2b/1Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/603] selftests/bpf: Define SYS_NANOSLEEP_KPROBE_NAME for riscv
Date: Wed, 15 Nov 2023 14:10:53 -0500
Message-ID: <20231115191620.685603598@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@rivosinc.com>

[ Upstream commit b55b775f03166b8da60af80ef33da8bf83ca96c1 ]

Add missing sys_nanosleep name for RISC-V, which is used by some tests
(e.g. attach_probe).

Fixes: 08d0ce30e0e4 ("riscv: Implement syscall wrappers")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Link: https://lore.kernel.org/bpf/20231004110905.49024-4-bjorn@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 77bd492c60248..2f9f6f250f171 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -417,6 +417,8 @@ int get_bpf_max_tramp_links(void);
 #define SYS_NANOSLEEP_KPROBE_NAME "__s390x_sys_nanosleep"
 #elif defined(__aarch64__)
 #define SYS_NANOSLEEP_KPROBE_NAME "__arm64_sys_nanosleep"
+#elif defined(__riscv)
+#define SYS_NANOSLEEP_KPROBE_NAME "__riscv_sys_nanosleep"
 #else
 #define SYS_NANOSLEEP_KPROBE_NAME "sys_nanosleep"
 #endif
-- 
2.42.0



