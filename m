Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3356912E58;
	Sat,  3 Feb 2024 04:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933766; cv=none; b=e5qgy4ioUZr4KCLP41IWpyzwHKWalSyxJumIV4qGywIMaq6MCE/1uiVK7fl34npljpMXLv0KSRC0lm6bAyktusf7IpS0Suv+R6S0YSC87Sigb1bnnwLZ/YSQ1yOFVbrps02BWj7uvZqJioneZ0l1UpeppaEVGAPOOhvH2E2NFVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933766; c=relaxed/simple;
	bh=4W7Vw6/LU2Bj4qc+/Mz70MKoe+n22hXzvn8dLE6wpZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfHh+LGTwXa17+ZETMP2aaqsogwHNrtaqfeOw5vFd0qALpduPHf/bJ8bAsha+GgjmLPYuB3etFVPIg5DGFpR/wTfgukMqCAAx5t934BpPa8/v4ts9FgRjAKgFr+k+Nzyjo7JF6daH13a/Z8GyF5jsSHdTDEAY3BBklfTHYMvZLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtfUvlMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtfUvlMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E226C43394;
	Sat,  3 Feb 2024 04:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933765;
	bh=4W7Vw6/LU2Bj4qc+/Mz70MKoe+n22hXzvn8dLE6wpZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtfUvlMB7WUWa2DaWKxBaIfCNbF4YaBQ2wMPublwf2xIG96aK/nP/9GeQZQfdIzbQ
	 W3v1p4kQyH1naYO5Sjgxn12n/k/PypowoKRWtWrSFlhDcxNUoeeeXX/GPCoW0FiF66
	 zvjm95E8trSuzYE8iYJMLqxdPT45TtZRUghxR/fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 066/353] selftests/bpf: satisfy compiler by having explicit return in btf test
Date: Fri,  2 Feb 2024 20:03:04 -0800
Message-ID: <20240203035405.898323569@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit f4c7e887324f5776eef6e6e47a90e0ac8058a7a8 ]

Some compilers complain about get_pprint_mapv_size() not returning value
in some code paths. Fix with explicit return.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231102033759.2541186-3-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/btf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index 92d51f377fe5..8fb4a04fbbc0 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -5265,6 +5265,7 @@ static size_t get_pprint_mapv_size(enum pprint_mapv_kind_t mapv_kind)
 #endif
 
 	assert(0);
+	return 0;
 }
 
 static void set_pprint_mapv(enum pprint_mapv_kind_t mapv_kind,
-- 
2.43.0



