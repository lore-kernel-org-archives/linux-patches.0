Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4108F3A8F3;
	Wed, 15 Nov 2023 19:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+kR6N98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3693C433C8;
	Wed, 15 Nov 2023 19:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077732;
	bh=PcYrztn+GnerQs1n8YJapL++P9j6o3LBnZ3K9rK2tkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+kR6N986Emqablfp+D6+oGu34fRLgXubojvpdDMsEdQOgobcoUD7GMOTkxh1Lknf
	 JNpQgX+qJ2wIkY/Muoef7AFtHRpbOOr8hHoKKBdHvlo8uKUXJDVKaQRa49oQysW+t7
	 +20nQ+yFElJzGVcIkBTZWOn+xVo8Z6djbTL8nyEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Ian Rogers <irogers@google.com>,
	oe-kbuild-all@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 467/603] perf tools: Do not ignore the default vmlinux.h
Date: Wed, 15 Nov 2023 14:16:52 -0500
Message-ID: <20231115191644.856202067@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 1f36b190ad2dea68e3a7e84b7b2f24ce8c4063ea ]

The recent change made it possible to generate vmlinux.h from BTF and
to ignore the file.  But we also have a minimal vmlinux.h that will be
used by default.  It should not be ignored by GIT.

Fixes: b7a2d774c9c5 ("perf build: Add ability to build with a generated vmlinux.h")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310110451.rvdUZJEY-lkp@intel.com/
Cc: oe-kbuild-all@lists.linux.dev
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf_skel/vmlinux/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/perf/util/bpf_skel/vmlinux/.gitignore

diff --git a/tools/perf/util/bpf_skel/vmlinux/.gitignore b/tools/perf/util/bpf_skel/vmlinux/.gitignore
new file mode 100644
index 0000000000000..49502c04183a2
--- /dev/null
+++ b/tools/perf/util/bpf_skel/vmlinux/.gitignore
@@ -0,0 +1 @@
+!vmlinux.h
-- 
2.42.0



