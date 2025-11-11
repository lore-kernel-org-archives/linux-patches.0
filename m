Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17521F5F6;
	Tue, 11 Nov 2025 01:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822958; cv=none; b=j7j6cPpZe+NACVKi5QB5AUcLP9c3Uo1BHi/leAj1qd1mED/bm4n8vClesZ9yWjyWdw3irHLPSjmWOzsPLK7EeN97QBb+VDlAoU6JGBQ7+BblBG13qUR+dWBwGh/lPDYaeUtZpLc4/51uscoEVRv143Cmcgi8l6UzznN9pnDkjwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822958; c=relaxed/simple;
	bh=r/JDgMjqQdW94k3Ey/MQ4LBcrOHUAzNNANSXNx5bbrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VhT2U0FS5mo2bSM4GwEK+JtxWwk+YeHu5YvUB+hQaEJkBpmdEaolZOwB+/UaiAlvsx3FdS6Puz+/qUa11BGe6AqxZm/K+mRI6BKF6+p/TCptNqExi4e2Ei4WIGLE5TKTYSQVe5W68msIkMo47nclLSUHpJQ7W0jKf33xPJUlSOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y++O7mQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y++O7mQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BACC2BCB0;
	Tue, 11 Nov 2025 01:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822957;
	bh=r/JDgMjqQdW94k3Ey/MQ4LBcrOHUAzNNANSXNx5bbrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y++O7mQpfaf0xoYaDWj6e1SEXpXW5U/mIFQh1sJVMOvQgfZYPneUGY7XQp15W4mUv
	 mjcQCcf+0Mw8kUghL36mkUdrGEQNxe+t6Gztmr1zR/RAIQxQDiED0f/sV2BEqw0WRO
	 UH5cWf97yy5Dk8xiG1ruFd8tpXRrfscPUJ0e6UnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/565] selftests/bpf: Fix bpf_prog_detach2 usage in test_lirc_mode2
Date: Tue, 11 Nov 2025 09:39:21 +0900
Message-ID: <20251111004529.319050347@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit 98857d111c53954aa038fcbc4cf48873e4240f7c ]

Commit e9fc3ce99b34 ("libbpf: Streamline error reporting for high-level
APIs") redefined the way that bpf_prog_detach2() returns. Therefore, adapt
the usage in test_lirc_mode2_user.c.

Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250828-selftests-bpf-v1-1-c7811cd8b98c@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_lirc_mode2_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_lirc_mode2_user.c b/tools/testing/selftests/bpf/test_lirc_mode2_user.c
index 4694422aa76c3..88e4aeab21b7b 100644
--- a/tools/testing/selftests/bpf/test_lirc_mode2_user.c
+++ b/tools/testing/selftests/bpf/test_lirc_mode2_user.c
@@ -74,7 +74,7 @@ int main(int argc, char **argv)
 
 	/* Let's try detach it before it was ever attached */
 	ret = bpf_prog_detach2(progfd, lircfd, BPF_LIRC_MODE2);
-	if (ret != -1 || errno != ENOENT) {
+	if (ret != -ENOENT) {
 		printf("bpf_prog_detach2 not attached should fail: %m\n");
 		return 1;
 	}
-- 
2.51.0



