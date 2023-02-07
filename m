Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9519528E7
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 12:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0962DC4339B;
	Tue,  7 Feb 2023 12:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774735;
	bh=wXGwYkvpdBUu194YdF296ECcm5lErTVFBmIuJRS2o7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWscCdlPeOetimZnRn6PFJgMOreh9wnhbdErQ5CwoW0uVj84F4+MMw2BSiDW/cAoC
	 Y5YI21S7+k+XLKUT8InZl3lR1MBz8maBTZhEfMw0EMjfOHUO1B5wuqpF7l82Mm6dfS
	 yXokya39aSxtZj+aPYQROStWv/j8NNkuCQoPIvk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/208] selftests/filesystems: grant executable permission to run_fat_tests.sh
Date: Tue,  7 Feb 2023 13:54:31 +0100
Message-Id: <20230207125635.103100289@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengfei Xu <pengfei.xu@intel.com>

[ Upstream commit 24b5308cf5ee9f52dd22f3af78a5b0cdc9d35e72 ]

When use tools/testing/selftests/kselftest_install.sh to make the
kselftest-list.txt under tools/testing/selftests/kselftest_install.

Then use tools/testing/selftests/kselftest_install/run_kselftest.sh to run
all the kselftests in kselftest-list.txt, it will be blocked by case
"filesystems/fat: run_fat_tests.sh" with "Warning: file run_fat_tests.sh
is not executable", so grant executable permission to run_fat_tests.sh to
fix this issue.

Link: https://lkml.kernel.org/r/dfdbba6df8a1ab34bb1e81cd8bd7ca3f9ed5c369.1673424747.git.pengfei.xu@intel.com
Fixes: dd7c9be330d8 ("selftests/filesystems: add a vfat RENAME_EXCHANGE test")
Signed-off-by: Pengfei Xu <pengfei.xu@intel.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/filesystems/fat/run_fat_tests.sh | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/filesystems/fat/run_fat_tests.sh

diff --git a/tools/testing/selftests/filesystems/fat/run_fat_tests.sh b/tools/testing/selftests/filesystems/fat/run_fat_tests.sh
old mode 100644
new mode 100755
-- 
2.39.0



