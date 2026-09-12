Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE9C2F0673;
	Sat, 12 Sep 2026 19:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240152; cv=none; b=WkR2pvuZ/NBMimFUV2U0Sguw0tGFtvRSMO/VJwdchTSyVR7SmyYy+XBrrbxaKiNWCmfnRw20horauPBkHAK4nSCtX6XAx4RXR2u3firLsjYewF/z06E17lkcNRW16TZZJ53AE2l52SJFvBqpfoQq3qlUAy1JRBfKQv6cjqTcyu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240152; c=relaxed/simple;
	bh=pmghGp0ZN5kc9Wi49Wx3BZWin1zJtn0DsczB4fg/UJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTaH9Kjtnj9dNqtjiGq1BMzI+MrrVIhw+MSNlRR3Q4ZhWTmTLp+j39QKIaJ2lA82MVy1noWPtt6E+iq+zZvGtL8i8v/e9nXt1wlJ/SEXsvrca4DXP05ZHzQ7JRsLIdWUPZFbPBuO3wKco3kqIDTjsTMx3UdsMviQsnJP3eFtwO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jaEAqgV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jaEAqgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E148C1F000FF;
	Sat, 12 Sep 2026 19:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240151;
	bh=Hat+KH/S3cJVo3iSITel4q4PdRYhH4IYkMq6zb3T8uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1jaEAqgVn78G+ybekK4Q4oFm1jQxl0l6SZqFEUfoQm3xaKAOOvbruzP0WvDfn7NVD
	 wcXeiutTRVkejcMsVxlxwyD6Whdzgj9J/Crmi59TaX9P5CubC2fh5IWW9n25HJDTRO
	 XhYZ51/a3dBDVGUSppRgEijh3AXg5PmxIEQKu29M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 808/935] selftests/bpf: Add description for running vmtest on RV64
Date: Sat, 12 Sep 2026 09:03:58 +0200
Message-ID: <20260912065545.372212615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 95b1c5d17832f61d0438cd5060a997bafaf75f2c ]

Add description in tools/testing/selftests/bpf/README.rst
for running vmtest on RV64.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/r/20240905081401.1894789-11-pulehui@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 3a59f11e0f98 ("selftests/bpf: vmtest.sh: Preserve command quoting when running in the VM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/README.rst | 32 ++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/testing/selftests/bpf/README.rst b/tools/testing/selftests/bpf/README.rst
index b0b5b323583df..14a2cd45c78fe 100644
--- a/tools/testing/selftests/bpf/README.rst
+++ b/tools/testing/selftests/bpf/README.rst
@@ -36,6 +36,38 @@ For more information on about using the script, run:
           If you want to change pahole and llvm, you can change `PATH` environment
           variable in the beginning of script.
 
+Running vmtest on RV64
+======================
+To speed up testing and avoid various dependency issues, it is recommended to
+run vmtest in a Docker container. Before running vmtest, we need to prepare
+Docker container and local rootfs image. The overall steps are as follows:
+
+1. Create Docker container as shown in link [0].
+
+2. Use mkrootfs_debian.sh script [1] to build local rootfs image:
+
+.. code-block:: console
+
+  $ sudo ./mkrootfs_debian.sh --arch riscv64 --distro noble
+
+3. Start Docker container [0] and run vmtest in the container:
+
+.. code-block:: console
+
+  $ PLATFORM=riscv64 CROSS_COMPILE=riscv64-linux-gnu- \
+    tools/testing/selftests/bpf/vmtest.sh \
+    -l <path of local rootfs image> -- \
+    ./test_progs -d \
+        \"$(cat tools/testing/selftests/bpf/DENYLIST.riscv64 \
+            | cut -d'#' -f1 \
+            | sed -e 's/^[[:space:]]*//' \
+                  -e 's/[[:space:]]*$//' \
+            | tr -s '\n' ',' \
+        )\"
+
+Link: https://github.com/pulehui/riscv-bpf-vmtest.git [0]
+Link: https://github.com/libbpf/ci/blob/main/rootfs/mkrootfs_debian.sh [1]
+
 Additional information about selftest failures are
 documented here.
 
-- 
2.53.0



