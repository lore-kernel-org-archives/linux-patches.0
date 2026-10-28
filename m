Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208872;
	b=khVms2pIDMrXErTevt+0pcsPKD3WLMQ835KKIKkkxKbB4gzzs7oKmtN+rzhLVQqor2Ju
	 rPHThav4C+KCdPflqb/AMB6uZPNx6d9bYhTRMQl8zTasZ169JbxxAFdvjMZkdfaJzIqxm
	 pCIO/xzJ+XXG6jjXtxG18E0cLZIIs7R6MCF7Q1ahOmiSFac9KcwnmUVZHXjnG9prn5PhU
	 +LBg2x3gRzcPoGw5iPKzQpLv/PyGfPAtNH5C2nlzjqDtyZYFWglyheVLzvnfq9MO/hcgo
	 bKDDlQ9ZzXgKDdZuMy8raVPV11SfTS0J4QVhapbe+60PZ+u7AjusZgN8O4wHOF+h4kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MuHZSGnpFBK8sUjpVAwR47e3KjswNE+CCZeOuC/bnG8=;
	b=xSe1qsfzDlS5a6ktD7CZn+DkTH31sZPgPJHNFr/BFtgGYFfGx6WLDlSGGM/l16Ycj46G
	 vvprUC0ZYFg3Y3qZi08ddQpGN9nHZU0CgR91TEzV0Z4Txen2AG8Mb3eXlabkXL1PsE+Me
	 gXKBytXGD2PXuypfZN1ReCJGn22A5mxmBTHkznbL2IXZ0oVkm3b0eKMPzYS6YAqCl+XXV
	 Sf8LFnQ+Ut577aqtNop7US+jnCqAos7J3/EFd1AW/oremhT9P31XP3gNYbOtHXx+X83G8
	 0PRI5uP+ye8gGXD9TJb0jJbdwFmgZhD1xLRGzRAo8OuUCC9lD5/i0qf1jLNSIw/z7+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sqZpY9NK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D8E606A31D;
	Wed, 28 Oct 2026 17:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sqZpY9NK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7970C1F01825;
	Wed, 28 Oct 2026 17:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208872;
	bh=MuHZSGnpFBK8sUjpVAwR47e3KjswNE+CCZeOuC/bnG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sqZpY9NKGbHbG6kXbP8AHJbsxGYJsjCVWIh1RNCdSZ5I32zhuG9ieE0ausE3aaOhy
	 IcN9NFvWUOMjxHdCPHxO7EC8Fsn67PPgsOcjXe5JVYdY+dygxhnZdq6WryL4baD86w
	 3N6Z9JHosbBvlRSGcs3Y2sgultG+olOh4WFVoBuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 271/516] perf: Require kernel access for text poke events
Date: Wed, 28 Oct 2026 17:57:03 +0100
Message-ID: <20261028170009.912510220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchuan Liang <zcliangcn@gmail.com>

[ Upstream commit 357e8a77a501d96c9517f01f4a211eed5e9c9184 ]

Perf events with exclude_kernel=1 can be opened without kernel perf
access. However, exclude_kernel does not suppress text-poke sideband
records. Every PERF_RECORD_TEXT_POKE is marked PERF_RECORD_MISC_KERNEL
and contains a raw kernel instruction address.

An unprivileged task can therefore open and mmap a task-local software
event with text_poke=1. Both opening a count-only tracepoint event and
configuring UDP GRO for ESP-in-UDP cause updates to inline static calls;
the observer receives the relocated addresses of the modified instructions.
For a known kernel image, any such address reveals the runtime kernel
text base despite KASLR.

Call perf_allow_kernel() whenever attr.text_poke is set, regardless of
exclude_kernel. Events that neither monitor kernel execution nor request
text-poke records retain their existing permissions.

Fixes: e17d43b93e54 ("perf: Add perf text poke event")
Assisted-by: LLM
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/99131354c41e23188f778b92f90363775b482395.1790573390.git.zcliangcn@gmail.com
[ sashal: Adapted the condition to the existing exclude_kernel check without callchain checks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 68df0d569f4c2..d08c276dffa83 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11936,7 +11936,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (err)
 		return err;
 
-	if (!attr.exclude_kernel) {
+	if (!attr.exclude_kernel || attr.text_poke) {
 		err = perf_allow_kernel(&attr);
 		if (err)
 			return err;
-- 
2.53.0



