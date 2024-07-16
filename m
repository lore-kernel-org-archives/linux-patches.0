Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CBCE54C;
	Tue, 16 Jul 2024 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144098; cv=none; b=bYORj5Zvtz8SL5cnl2uA4xbeYy1GA1X0jWpSXMe9Ao9BfcBXKbX203LfCdO5fp4230f9VcvqJP+fSLFFjRkK29QYW8RXVy1IoLVncz6XtHfictKHlE4xhImPUDcnBB/YOqxIsk7N9akx5bxaUGu4wsKv2XchWC6Y2utxaTkNO44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144098; c=relaxed/simple;
	bh=mHJbkLY23Wj93pv7xdVBWSmFeVAywJKtXGn/4OUs6k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9E6Frrf5Bko8H39wNUIn1pfwTQLLB30VIh/RrgrBkIqQYf5bqXIY2Rvda8f0kl0yY0uo32gNVSSyBPDrVVGD3W+AbWcpwNf5k1ku7jrOEqYyjLwFOmnYE9OJ3c+k/y+QPLAddA+FD9OJwA+3M+geXEHCSXy9AyFs6R0OStY8IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4oM7qOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4oM7qOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE65C116B1;
	Tue, 16 Jul 2024 15:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144097;
	bh=mHJbkLY23Wj93pv7xdVBWSmFeVAywJKtXGn/4OUs6k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4oM7qOmSYHpCq9amF6nOR8dvqkZ9sJlvLZi+4fz7HDC7udOZTNTAMqGT5QI4UJ9Y
	 fA0HgBPCxCMwofTIqVfrREkDERaMxROcFzZdxAF/I0Hgb1+s74kDNmWfSUY7q+wYMi
	 P/x3rpoCsgJvumwaeqdoqAuERfAaEvS3BMrHNpSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Xiaochun Lu <xiaochun.lu@bytedance.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/66] selftests: make order checking verbose in msg_zerocopy selftest
Date: Tue, 16 Jul 2024 17:31:02 +0200
Message-ID: <20240716152739.201117254@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit 7d6d8f0c8b700c9493f2839abccb6d29028b4219 ]

We find that when lock debugging is on, notifications may not come in
order. Thus, we have order checking outputs managed by cfg_verbose, to
avoid too many outputs in this case.

Fixes: 07b65c5b31ce ("test: add msg_zerocopy test")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Signed-off-by: Xiaochun Lu <xiaochun.lu@bytedance.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240701225349.3395580-3-zijianzhang@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/msg_zerocopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/msg_zerocopy.c b/tools/testing/selftests/net/msg_zerocopy.c
index b7dc9f3617572..67fa124c06864 100644
--- a/tools/testing/selftests/net/msg_zerocopy.c
+++ b/tools/testing/selftests/net/msg_zerocopy.c
@@ -438,7 +438,7 @@ static bool do_recv_completion(int fd, int domain)
 	/* Detect notification gaps. These should not happen often, if at all.
 	 * Gaps can occur due to drops, reordering and retransmissions.
 	 */
-	if (lo != next_completion)
+	if (cfg_verbose && lo != next_completion)
 		fprintf(stderr, "gap: %u..%u does not append to %u\n",
 			lo, hi, next_completion);
 	next_completion = hi + 1;
-- 
2.43.0



