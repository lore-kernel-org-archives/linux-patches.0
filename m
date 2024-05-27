Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174EB168C4;
	Mon, 27 May 2024 19:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837968; cv=none; b=o1t4WxFUdCataN6zFM5DPLvlEK3ZgqkPvH9FSbGHaEmZ8LoykeXD/xuPLDmY6dCAovqpb2QTuVDuYrvOEM2tXhYckVVSYEMZ0WbYUL0Tp/9GmaWqKcTbsTDnxgvE8ahYCOBNAyaii9dMtK8AJXLLzNV0e7QGj/G/dSJ/zQL/HQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837968; c=relaxed/simple;
	bh=ZD95hLP+p2HcEdhUlB34Y6eBV+jMnoxpFldzs7ijYoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbCTqA1H57rt6RzFjE2T3Hr0teM7ebX36ktD9xi1ckgZx9vL2aHVsxYkTRequmn29V66n0DBuGuFLnwoz04PkuJbiAZZzBquT9/vVydAhZpu2de9cN3iV3sQYEjNwJbMzs0cYcOPrspWHbyFwoMOo/yvIvwXYVsce/hMlkrMsV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlYYpyHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlYYpyHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0927C2BBFC;
	Mon, 27 May 2024 19:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837968;
	bh=ZD95hLP+p2HcEdhUlB34Y6eBV+jMnoxpFldzs7ijYoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlYYpyHqjB7f8ldZrdMJy1uQxjtrnFrbj+RPosiG34LPHZOvd+MY06HsL70lgRF9X
	 qQcewOZXRdnYlvLlbtu5IEbJ1kytchw/0/tZ49cq7r6KIi6ZxBs2X0Gu1/1o/5M8w/
	 fWlw6VDd+K1TSLguGRRqCOk1kKouUQCyrViJl0wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 213/493] selftests/bpf: Fix umount cgroup2 error in test_sockmap
Date: Mon, 27 May 2024 20:53:35 +0200
Message-ID: <20240527185637.281995548@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit d75142dbeb2bd1587b9cc19f841578f541275a64 ]

This patch fixes the following "umount cgroup2" error in test_sockmap.c:

 (cgroup_helpers.c:353: errno: Device or resource busy) umount cgroup2

Cgroup fd cg_fd should be closed before cleanup_cgroup_environment().

Fixes: 13a5f3ffd202 ("bpf: Selftests, sockmap test prog run without setting cgroup")
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/0399983bde729708773416b8488bac2cd5e022b8.1712639568.git.tanggeliang@kylinos.cn
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 024a0faafb3be..43612de44fbf5 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -2104,9 +2104,9 @@ int main(int argc, char **argv)
 		free(options.whitelist);
 	if (options.blacklist)
 		free(options.blacklist);
+	close(cg_fd);
 	if (cg_created)
 		cleanup_cgroup_environment();
-	close(cg_fd);
 	return err;
 }
 
-- 
2.43.0



