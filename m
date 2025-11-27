Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6486F3115A6;
	Thu, 27 Nov 2025 15:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255874; cv=none; b=e9uBOWeBK1qrFKSiizF0PR6UGsCX4tk0iqzGRVpWW8cZBqXx936OWzEKj57Vb8DEa6ZwlEsECcceqCSGq2An1S2JbqrqAosAdIaDAS3TvQqNrazBtiLEoDdC1ABI3tF6WOsPeXjOyaoYESIx0LJ8VYn9S4vz+rETEXCRB2g4yB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255874; c=relaxed/simple;
	bh=5X93YG0TRr5mwvDlfAPKksWBUuWKQc1FOPsuQ/Kv8ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTmXHgWhHDYr+fYevOc6tE82f/UOrB3AR4gBH+nyP32SLhBIOMXf6jVoLHoFM2bnLfTCbKp6rcZUOGi7xdy8RDJHmVxsx2zlg3JcbS4zk6rRSd3CTXdjaKeYzZRzLKqOkXT/7vjTfK2m10JSppZcar2gIMzG8TVcOR/I2hUv/eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0o+EEVHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0o+EEVHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD33C4CEF8;
	Thu, 27 Nov 2025 15:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255874;
	bh=5X93YG0TRr5mwvDlfAPKksWBUuWKQc1FOPsuQ/Kv8ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0o+EEVHDi+UKT40Lf3jqOU3X9ZgYVoHtk4Xuqp+zACKGPYCLDzJ9E7xgxMHMj8tmX
	 I0/T1O9aJcPhdrCqsHI4MdzSuOmyhGEakk1q41/42h4rfJVCcfjkhs9LWTJBaQB0rS
	 b5lip/gFU3BRtcqXCaZMJzLXQImC0xIhYvLath4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidharth Seela <sidharthseela@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	wang lian <lianux.mm@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 145/175] selftests: cachestat: Fix warning on declaration under label
Date: Thu, 27 Nov 2025 15:46:38 +0100
Message-ID: <20251127144048.251299660@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Sidharth Seela <sidharthseela@gmail.com>

[ Upstream commit 920aa3a7705a061cb3004572d8b7932b54463dbf ]

Fix warning caused from declaration under a case label. The proper way
is to declare variable at the beginning of the function. The warning
came from running clang using LLVM=1; and is as follows:

-test_cachestat.c:260:3: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
  260 |                 char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
      |

Link: https://lore.kernel.org/r/20250929115405.25695-2-sidharthseela@gmail.com
Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cachestat/test_cachestat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/testing/selftests/cachestat/test_cachestat.c
index c952640f163b5..ab838bcb9ec55 100644
--- a/tools/testing/selftests/cachestat/test_cachestat.c
+++ b/tools/testing/selftests/cachestat/test_cachestat.c
@@ -226,7 +226,7 @@ bool run_cachestat_test(enum file_type type)
 	int syscall_ret;
 	size_t compute_len = PS * 512;
 	struct cachestat_range cs_range = { PS, compute_len };
-	char *filename = "tmpshmcstat";
+	char *filename = "tmpshmcstat", *map;
 	struct cachestat cs;
 	bool ret = true;
 	int fd;
@@ -257,7 +257,7 @@ bool run_cachestat_test(enum file_type type)
 		}
 		break;
 	case FILE_MMAP:
-		char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
+		map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
 				 MAP_SHARED, fd, 0);
 
 		if (map == MAP_FAILED) {
-- 
2.51.0



