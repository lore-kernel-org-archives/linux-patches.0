Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF3E111A4;
	Sat,  3 Feb 2024 04:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933522; cv=none; b=sWo2aG5JfKkFXvjc981JoHUbyrl+CrTL6M9+tnPUlOr4HZUuKHiVsBqpSvMhSrGhfRrc7SLuYNOgMlyVJoPLDHH+cFqeogAS9xzBg0sXr7hf3rxywOpEMFTvNJXCrr17kCFn1h9p/bwkg2tDKaPk8iKtKE98Q3U8vPUo+9Ts6cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933522; c=relaxed/simple;
	bh=a3rCCqO9Q2a9L6VVUgsejM8/fyLpVMkwIFPQjAljLmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHG+zm9R0Fbnc/dXongfVAKYMytwgz8wOWm0hUo8Gwn8VJ70doRDbTKevV/kniMFjoItD1Jc9JpZudq20DqDon9v3Ldd/W6j5FknExl6qDKx37pQ3weRX4LhM9yq+axAZa2yX/tK1YGC2Vr/J45/7LXFz6E92dMAkiQM2fzLcN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3KbQGv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3KbQGv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73A0C43390;
	Sat,  3 Feb 2024 04:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933521;
	bh=a3rCCqO9Q2a9L6VVUgsejM8/fyLpVMkwIFPQjAljLmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3KbQGv4V91lEdKSktOfX8r2OSyw7U22f6EjD27QeD/pOJiOLpJoNTY8jSu2ULg4i
	 6N5NwPoiWsWUWZqc8EgiAkGHV9iFAhevp3WAJz+1pM3Xeot4Cq6mPDss4WU0BbAtLe
	 5B9uL7sTGB76kvLF/2hWGPZjydax/pxuoMs4bU0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/322] selftests/bpf: satisfy compiler by having explicit return in btf test
Date: Fri,  2 Feb 2024 20:02:38 -0800
Message-ID: <20240203035401.108606401@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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
index 4e0cdb593318..1b8e967f2604 100644
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



