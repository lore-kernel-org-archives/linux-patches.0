Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B98134AC;
	Mon, 12 Aug 2024 16:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479824; cv=none; b=Dc0SNd2PQve7/k9VzqqPe8ENOYOvrlOxviopG2dVP0bVbvJ1NvCTIEqk1ujb9lUk9YAqOn+ZUBASOkfhrpkF6MahaWtfF4NoVzHGA0BsxOb1BflHtIC5piQxIeCt+O+SCBOvDLMT6SxTF2avggpaY9Pvarj3hMqYTw3LYu1u4Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479824; c=relaxed/simple;
	bh=WQM8fFOrL5gEF4XcZ7ITkt1XNRA+UqDKaB1vYuN0x70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P13U2XxKn+NjQZTaDbANT7zBWYFbmJl2rNCMBoSHRKYCvIir6Fa/Oh3ywK6DdHzyKZBrPrBlKF29IJGuAqlHHd2Q5FnbprBU0Ciz3QMKHLdEUz9h1oNrTWlFghboId3LuOZEUjLQzAL6MtUlFwxcuMH0g/hR+PkY0bBy/HVLw14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XFlinwuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFlinwuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2113C32782;
	Mon, 12 Aug 2024 16:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479824;
	bh=WQM8fFOrL5gEF4XcZ7ITkt1XNRA+UqDKaB1vYuN0x70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFlinwuoIascr8UqWZljB1PO3ZLPJZm4QBbeH4Mb9SxieVlTuG1bzaZmgB89e0aFA
	 3LstYflhSAlhc/MWKVS+at1lr9MygbaB+I73ysOv5hsTASDCRkAqt4rw1qMnPa/Mzt
	 7Bq0ircp6zs7wf4y8nAgu6wtsA0Hf8GMjFAEEgTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Uros Bizjak <ubizjak@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 002/263] locking/pvqspinlock: Correct the type of "old" variable in pv_kick_node()
Date: Mon, 12 Aug 2024 18:00:03 +0200
Message-ID: <20240812160146.615918815@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit 6623b0217d0c9bed80bfa43b778ce1c0eb03b497 ]

"enum vcpu_state" is not compatible with "u8" type for all targets,
resulting in:

error: initialization of 'u8 *' {aka 'unsigned char *'} from incompatible pointer type 'enum vcpu_state *'

for LoongArch. Correct the type of "old" variable to "u8".

Fixes: fea0e1820b51 ("locking/pvqspinlock: Use try_cmpxchg() in qspinlock_paravirt.h")
Closes: https://lore.kernel.org/lkml/20240719024010.3296488-1-maobibo@loongson.cn/
Reported-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/20240721164552.50175-1-ubizjak@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/qspinlock_paravirt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/qspinlock_paravirt.h b/kernel/locking/qspinlock_paravirt.h
index f5a36e67b5935..ac2e225027410 100644
--- a/kernel/locking/qspinlock_paravirt.h
+++ b/kernel/locking/qspinlock_paravirt.h
@@ -357,7 +357,7 @@ static void pv_wait_node(struct mcs_spinlock *node, struct mcs_spinlock *prev)
 static void pv_kick_node(struct qspinlock *lock, struct mcs_spinlock *node)
 {
 	struct pv_node *pn = (struct pv_node *)node;
-	enum vcpu_state old = vcpu_halted;
+	u8 old = vcpu_halted;
 	/*
 	 * If the vCPU is indeed halted, advance its state to match that of
 	 * pv_wait_node(). If OTOH this fails, the vCPU was running and will
-- 
2.43.0



