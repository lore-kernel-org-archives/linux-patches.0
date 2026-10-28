Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217212;
	b=RSTEnAPX55r+aJ/XwbZCDWnoK0MKnOQUUypo6C7HMBBIdMmsRHpO8Deu6hT9IvI7fScR
	 ufCdzIOrorxY4bTR67X8PrjewtnTmFg1AJPvgXdOTmXF0QTdaF/WpXFitsug7Eswa/v99
	 TMvamADYzLQzu5lSGAxhdm5bZntJp65Ifc/iE1jBZCR39TJl+cVC1fFZc4zMz0BiPYcmE
	 QZQ/IYWFxJcpxwViQZQBKzd/6G+xeONL5a9MI41B3Z4UkWMYel51+6k0SKDRpEwBFX2Au
	 KNvw3POHwFb7JS7ZjlHTPxpuYIgBXsH5VELxHPiKIPmlgJtPIWEyWn5HYlp+JHfHB5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ep0tUK/grM9S4nBmJQdlINu4Hfs5mWsbcJdNvmX50fU=;
	b=ASRFVTOFqnVVxhT07X00+AmsHSqxu7GCfpakRevkUjW4D2HOzy0UJdUUtR+TS40c7a7S
	 5YJFjn8c4e0/4Sv+XAabRjgW+0sEwQGHStCvP81sFH9VLp2c1OpusKBfp4AopEYa3CGV9
	 ajK//tF8EvrKgYP+B0tutqWGhpbkaMHyi6Uo00B2TZIKtCmFlkgAb6QbYhVY7zSdNNhbp
	 O3Pdz0uBVd6JhVJNCqVZiDL6BsL7E9BYAu0rOnq0v78wLQy0W0T/ULbXClcxUOnjZi1kL
	 SwnBVnub9+jixU+c5ocL/VxLasmTsrlC4mmLxRVxrVWgKYJNDSI8FX9MccsK36kmPAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HW78Gn7u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1759C606A31A;
	Wed, 28 Oct 2026 19:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HW78Gn7u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4591F01825;
	Wed, 28 Oct 2026 19:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217211;
	bh=Ep0tUK/grM9S4nBmJQdlINu4Hfs5mWsbcJdNvmX50fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HW78Gn7uL9OHK8Y7I3Ni290Qi/2GyVgESXSJUEpLTMvc6MtF0P4m9MLa1/uQFu3V2
	 nDXWPZGjNp+tjlCW9pBXiGbqvZH2QCC8eFQhxUiC24NhCfcs1wZHFJrDCtiO8dy8f4
	 51HXKuJLKLRYKUneIYyEub74TRry1qXmOg0JBExw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1824/1887] net/sched: initialize noop_qdisc owner
Date: Wed, 28 Oct 2026 18:05:20 +0100
Message-ID: <20261028170540.950631371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 44180feaccf266d9b0b28cc4ceaac019817deb5c ]

When the noop_qdisc owner isn't initialized, then it will be 0,
so packets will erroneously be regarded as having been subject
to recursion as long as only CPU 0 queues them. For non-SMP,
that's all packets, of course. This causes a change in what's
reported to userspace, normally noop_qdisc would drop packets
silently, but with this change the syscall returns -ENOBUFS if
RECVERR is also set on the socket.

Fix this by initializing the owner field to -1, just like it
would be for dynamically allocated qdiscs by qdisc_alloc().

Fixes: 0f022d32c3ec ("net/sched: Fix mirred deadlock on device recursion")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240607175340.786bfb938803.I493bf8422e36be4454c08880a8d3703cea8e421a@changeid
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 9b95e6b120e63..3d5f86be5a954 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -703,6 +703,7 @@ struct Qdisc noop_qdisc = {
 		.qlen = 0,
 		.lock = __SPIN_LOCK_UNLOCKED(noop_qdisc.skb_bad_txq.lock),
 	},
+	.owner = -1,
 };
 EXPORT_SYMBOL(noop_qdisc);
 
-- 
2.53.0



