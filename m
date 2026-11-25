Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618355;
	b=5CjLF2ledNFcnnbNeoWbwl73OOwAz6z065DbXwvcw0m0SUMa7eyX28LadMI+h7QBI7Cg
	 kYgxtJdtV6y8e9S6F/N0VpgeWOwBkcU77z+zHAZ2ohCSbH8ViQg0GuJC4/VWiq+dUiywQ
	 qZ1MQ0tmqAbeX3mEBYkuDAB/nHaNXI5rGlNhll8W6TT1TP3zW2O7SVvXDVVXSV/Y7m+mm
	 t/oe0UpqYlI0tKvUipSd1QP6EmAemjKjkK0c9YJ9RTpxvMdWXT3qcIwqkSMYSDBJtD9F+
	 S/4w+/ghOU0fvkNQJUgqxJrXN9SfqFTYze2ZxYo1Jr1YpLLeNB2JbgxUmaahCGuSQhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DxysbBRi4XimAFT73YeaiuSRxKseeL/VfPWArlLR7b8=;
	b=qHdXHba/rDzPAXQJJcRddJMCb1RboPGhJwICAIYUZrG6MY9Gm736wKpmPnpuNqyZ9tBh
	 KNmwabS6+5nCs4JggN58qt3Uwz6OR68XNNCua74jnRk8OvBRGOLk6L5gWVIbNtwRst58g
	 0tG2sPWs+NO0A9iTPRtqODpZqd06dsHb0nUHlsHyd27+UclKIRg1M4V8OBc3O411cK+HB
	 DA3U+VFtR5y/6l0JyBJkHaOOQmvpXQQtgjzUXWEz3sNXYqsmTu2+OIUS2U5xa+MV8gxDi
	 1iI5jSp6Is04rKC74wbDcYBCTSa5/A0XcTZV3nNef3K+RGKJ3tsnA9jwXx03xokwN9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lhex7EZO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D8D606A321;
	Wed, 25 Nov 2026 14:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lhex7EZO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B701F000C4;
	Wed, 25 Nov 2026 14:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618355;
	bh=DxysbBRi4XimAFT73YeaiuSRxKseeL/VfPWArlLR7b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lhex7EZO6Jsj1zmYAipj0gSbNbc0BuKai4U7GA6op1YenrjmICBKKgX4es95Pz0IY
	 N3ryWat4IHo281IMpzROwHVHmk0sRqMDGVe1ELvjVsZ+I0Q0mvv/TDOhpPsB2C3bdp
	 tysK4un+ubBbdydz13/fJXQ4ZgTGGat+K+Y45szg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yunxiang <xyx2021@mail.ustc.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0217/1005] bpf: Propagate scalar precision through stack arguments
Date: Wed, 25 Nov 2026 15:25:55 +0100
Message-ID: <20261125143826.824314849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yunxiang <xyx2021@mail.ustc.edu.cn>

[ Upstream commit d537252cc8a53b6ed6a3e7d0d895cb1cdd3ba42c ]

Outgoing stack arguments retain scalar verifier state separately from
registers and ordinary spills. State comparison uses their precision
marks, but propagate_precision() does not carry those dependencies from
a reused state to the current path's ancestors. A path can consequently
reuse a state without making earlier checkpoints distinguish scalar
values that will later be used as memory offsets.

Seed the existing backtracking batch with precise scalar argument slots
from every frame. Incoming arguments live in the caller's outgoing
slots, so include caller frames as well as the current frame.

Also cover scalar argument slots in bpf_mark_all_scalars_precise(), so
conservative fallback preserves the same invariant. Keep its existing
ancestor-only traversal and leave pointer and uninitialized slots alone.

AI assistance was used in preparing this patch.

Fixes: 0f6bd5e7a804 ("bpf: Support stack arguments for bpf functions")
Signed-off-by: Xu Yunxiang <xyx2021@mail.ustc.edu.cn>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261102190350.788433-2-xyx2021@mail.ustc.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/backtrack.c | 11 +++++++++++
 kernel/bpf/states.c    | 14 ++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/kernel/bpf/backtrack.c b/kernel/bpf/backtrack.c
index 50c66115ab45e..cdf96ef68f7e4 100644
--- a/kernel/bpf/backtrack.c
+++ b/kernel/bpf/backtrack.c
@@ -711,6 +711,17 @@ void bpf_mark_all_scalars_precise(struct bpf_verifier_env *env,
 						i, -(j + 1) * 8);
 				}
 			}
+			for (j = 0; j < func->out_stack_arg_cnt; j++) {
+				reg = &func->stack_arg_regs[j];
+				if (reg->type != SCALAR_VALUE || reg->precise)
+					continue;
+				reg->precise = true;
+				if (env->log.level & BPF_LOG_LEVEL2) {
+					verbose(env,
+						"force_precise: frame%d: forcing r11%d to be precise\n",
+						i, -(j + 1) * BPF_REG_SIZE);
+				}
+			}
 		}
 	}
 }
diff --git a/kernel/bpf/states.c b/kernel/bpf/states.c
index f28b11c189085..4b407b629c995 100644
--- a/kernel/bpf/states.c
+++ b/kernel/bpf/states.c
@@ -1066,6 +1066,20 @@ static int propagate_precision(struct bpf_verifier_env *env,
 			bpf_bt_set_frame_slot(&env->bt, fr, i);
 			first = false;
 		}
+		for (i = 0; i < state->out_stack_arg_cnt; i++) {
+			state_reg = &state->stack_arg_regs[i];
+			if (state_reg->type != SCALAR_VALUE || !state_reg->precise)
+				continue;
+			if (env->log.level & BPF_LOG_LEVEL2) {
+				if (first)
+					verbose(env, "frame %d: propagating r11%d",
+						fr, -(i + 1) * BPF_REG_SIZE);
+				else
+					verbose(env, ",r11%d", -(i + 1) * BPF_REG_SIZE);
+			}
+			bt_set_frame_stack_arg_slot(&env->bt, fr, i);
+			first = false;
+		}
 		if (!first && (env->log.level & BPF_LOG_LEVEL2))
 			verbose(env, "\n");
 	}
-- 
2.53.0



