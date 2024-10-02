Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5ED1D14F5;
	Wed,  2 Oct 2024 14:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878056; cv=none; b=HLJMKkbn1V9FCgJdoZONu9v4OZkXWeSPK/Lt/lA5+vtMzStMk8xHkui31GAJWx4xEbE9GXb1NNSyhIglk4+WwRJyUwb+DeMVuSk5iSU2j0EJqDgacAIBpI6Ln6NC3KtSvNiZ2w4tWnS14Q9taIvz4lWLOc2Tmxj4SE8ROBxOu/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878056; c=relaxed/simple;
	bh=ZVBQrMkWtgt04QDsI2aOy4xUPSywQsglFhuXFYrKJng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfC2gMAvcayHF+EAFFIDc0HbwGWuBW5xZl6a76hwGuaa3tjbHvBzrqTzvBSYWM2jQJs/LSoBCkFTw5Y2Nl5h9jAQ4h6+ACYTtFEJYbC/H/rm2URErn7gG8IejXj6ZG1HbiTpUZc7j1rwrjI5xJ84yENuTRzLULUn5kjY+5/OqyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbUPSdgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbUPSdgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB282C4CEC2;
	Wed,  2 Oct 2024 14:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878056;
	bh=ZVBQrMkWtgt04QDsI2aOy4xUPSywQsglFhuXFYrKJng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbUPSdgGoNhr0wZQlBdWAy6SjX+HhcESG2HV4qpMOJFo9muDCKHVAJO+7fDTXZ5Pn
	 PAocojy5j7p82IdJeyVvIlYlWxD2N/Xq+Becavq4GfHL7gQNt+yhc1k/5WwrE7dWnW
	 aanKKFtKY1S9kDqz6zTSkAdGqrP6fpbNnCmoYq44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hao Ge <gehao@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 269/634] selftests/bpf: Fix incorrect parameters in NULL pointer checking
Date: Wed,  2 Oct 2024 14:56:09 +0200
Message-ID: <20241002125821.718532599@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <gehao@kylinos.cn>

[ Upstream commit c264487e5410e5a72db8a414566ab7d144223e6c ]

Smatch reported the following warning:
    ./tools/testing/selftests/bpf/testing_helpers.c:455 get_xlated_program()
    warn: variable dereferenced before check 'buf' (see line 454)

It seems correct,so let's modify it based on it's suggestion.

Actually,commit b23ed4d74c4d ("selftests/bpf: Fix invalid pointer
check in get_xlated_program()") fixed an issue in the test_verifier.c
once,but it was reverted this time.

Let's solve this issue with the minimal changes possible.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/1eb3732f-605a-479d-ba64-cd14250cbf91@stanley.mountain/
Fixes: b4b7a4099b8c ("selftests/bpf: Factor out get_xlated_program() helper")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Link: https://lore.kernel.org/r/20240820023622.29190-1-hao.ge@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/testing_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/testing_helpers.c b/tools/testing/selftests/bpf/testing_helpers.c
index 4230420ef2940..680e452583a78 100644
--- a/tools/testing/selftests/bpf/testing_helpers.c
+++ b/tools/testing/selftests/bpf/testing_helpers.c
@@ -451,7 +451,7 @@ int get_xlated_program(int fd_prog, struct bpf_insn **buf, __u32 *cnt)
 
 	*cnt = xlated_prog_len / buf_element_size;
 	*buf = calloc(*cnt, buf_element_size);
-	if (!buf) {
+	if (!*buf) {
 		perror("can't allocate xlated program buffer");
 		return -ENOMEM;
 	}
-- 
2.43.0



