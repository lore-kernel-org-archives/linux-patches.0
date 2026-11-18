Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029095;
	b=R9jc47iyX6bX4SDTMV8zH3gwPHoDr+XsSY7gpwOuVJf5ct5gsX18+4rzZZ7UCMThvLLr
	 4dt5Y8X3fX/rs7/d8RVAXUnBSbUPji833l/hladO8qQWnbeJmQ+VUUZO4QcTW2+iAPQFj
	 kmAMTbyJwBC4hKWtS4qZCIKiI7I4Jv6fATojWY+K545DVhHrf4+hJo4dbDyCRKf7VrCGq
	 U66ybsykcAvqSopWQInQg+AD9pt1mVXiT4EiQIhWadMaWNYsXdY6CgHwzLmxNmNfVCIDv
	 IQht/QvzRPqFhmn0mVIeuN4R1FwON67db09fCytXnTQj8negem/LghzxXb0L42S9aAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DOb7m0qBpEnqhJVA2jddhJlorZFDX4Wh9KLh5QhODY0=;
	b=st7son+Poa93+K/OrgqTOJ0j4jG+47WnHasAFOkr1NPVZxLAI6ud0z7/1cgEBBBMYbuu
	 AAj8s18TI5/zZlY8XtYArtI/lfTJFWUjwA9MeywGSovILK5BX3wy/aTEjAryBYIA6O20T
	 9IrW44wW9wkr8OcDYVNSexiF1e8KbeuIIGkiA0P2ktOAi7SNnRpZv2phuv1m7bHYsPcrR
	 3QIlCn3ubJpb11zO6Zi7RjPhho6clixiAVtgUgGC66UlChELIvskwR7aKfHDe/ubWJS3w
	 0nutTUVkpECN0na44YOqcDbv9H3fCuRLT6K3M/guqS5oTqF1C5CPm8MOGY1rSLXlILA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PsGwZzvv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AFA606A32C;
	Wed, 18 Nov 2026 19:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PsGwZzvv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDF51F000C6;
	Wed, 18 Nov 2026 19:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029095;
	bh=DOb7m0qBpEnqhJVA2jddhJlorZFDX4Wh9KLh5QhODY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PsGwZzvvJpSRa2Le6jDrvWleolUPNxgp5hfeXGZ0RrCTwQnZXiRnMHIk/Fdq6IENw
	 tZ1kik4rFs6ucU9cJNea2OVnXj/1ICaPGLUW3lv7P2tyTSMOTPF67cTfmSQtJvdNvv
	 BSGHj64w4dAnTlS+7nsm0LmX9zNuQMR5ragu4sXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Julius Bairaktaris <julius@bairaktaris.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0229/1756] wifi: mac80211: fix swapped fq_overlimit/fq_overmemory in aqm debugfs
Date: Wed, 18 Nov 2026 15:39:16 +0100
Message-ID: <20261118150017.391249830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Bairaktaris <julius@bairaktaris.de>

[ Upstream commit 25f3f2ff88ae604a3b473b501fc55d58fcb0f5eb ]

The two scnprintf arguments for fq_overlimit and fq_overmemory are in the
wrong order, which results in the aqm debugfs file showing the overmemory
count under the fq_overlimit label and vice versa.

Fixes: 2a4e675d887b ("mac80211: Export fq memory limit information in debugfs")
Reviewed-by: Toke Høiland-Jørgensen <toke@toke.dk>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Link: https://patch.msgid.link/20260904090626.92727-1-julius@bairaktaris.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 28b1355cc062f..610acecd45f8b 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -98,8 +98,8 @@ static ssize_t aqm_read(struct file *file,
 			"RW fq_quantum %u\n",
 			fq->flows_cnt,
 			fq->backlog,
-			fq->overmemory,
 			fq->overlimit,
+			fq->overmemory,
 			fq->collisions,
 			fq->memory_usage,
 			fq->memory_limit,
-- 
2.53.0



