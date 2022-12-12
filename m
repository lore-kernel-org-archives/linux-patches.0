Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BE428ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139F8C433EF;
	Mon, 12 Dec 2022 13:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852184;
	bh=jKM45OyExbfPU5Q6hFu9MoABJsMbDce7lX335EsUz5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPHu6rBdUP9j3IzXBj7oe8vWDvto35JUIcejgshNtFoKrQZ78LLNdcpGVou6z8/v9
	 K3yDkA0L2MAE4HtwjgZLYtxetz1AKePwQukd3YYXSsopPpYyt2vMR2XV4xhd5vBx/K
	 hAETfa/lYM3hWfa8gZQCjnohq+UIYWtmTF0Mf5DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KaiLong Wang <wangkailong@jari.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 028/157] LoongArch: Fix unsigned comparison with less than zero
Date: Mon, 12 Dec 2022 14:16:16 +0100
Message-Id: <20221212130935.649804395@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: KaiLong Wang <wangkailong@jari.cn>

[ Upstream commit b96e74bb439f096168c78ba3ba1599e0b85cfd73 ]

Eliminate the following coccicheck warning:

./arch/loongarch/kernel/unwind_prologue.c:84:5-13: WARNING: Unsigned
expression compared with zero: frame_ra < 0

Signed-off-by: KaiLong Wang <wangkailong@jari.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/unwind_prologue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/unwind_prologue.c b/arch/loongarch/kernel/unwind_prologue.c
index b206d9159205..4571c3c87cd4 100644
--- a/arch/loongarch/kernel/unwind_prologue.c
+++ b/arch/loongarch/kernel/unwind_prologue.c
@@ -43,7 +43,8 @@ static bool unwind_by_prologue(struct unwind_state *state)
 {
 	struct stack_info *info = &state->stack_info;
 	union loongarch_instruction *ip, *ip_end;
-	unsigned long frame_size = 0, frame_ra = -1;
+	long frame_ra = -1;
+	unsigned long frame_size = 0;
 	unsigned long size, offset, pc = state->pc;
 
 	if (state->sp >= info->end || state->sp < info->begin)
-- 
2.35.1



