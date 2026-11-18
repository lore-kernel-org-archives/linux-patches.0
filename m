Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027784;
	b=DXbhO+hbwW1Mxtf+yhfaud0v/DrwOy0wzwaQ/Fdo8Aj9b371uGrf6svkx2uXBqqbXwOx
	 41SYkLTunMYHNrZVDQBwYZVFfRX5fuAbeLvjUDAAiIDEF7Z6aIRi3jYwHWDCglb6SLqBQ
	 /2Qqk9tA6nmXqWUByA5948c2zjFr9VFjmAjEu0AnwZFM4QuQN6toRr3MzJo74E+nIa13J
	 hMSwFSwg4QzZGOrHXewBpj+JCrLNDb8XPgX+OzErZy7qgSuMkuFC9NjytWybpzbtJH/Iz
	 UJEUPwzPccmcTnWbmEnrdTagwvPlWvQ3OdWon53Y5mprnEAQHgB7/Ck3kV29MjsmPAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F97yXX9BuRv6GzxHd3JCXere8XZ+L43fTQJ6fJSKjSc=;
	b=0aDZmUaLe1awvpQhMgZmHm9fO5apkoFzYUSTT2KhrBd4T/P1vo9QLYdjvmsFpK9F67VY
	 uH1ReID6TeIl3p6YJ7BDk0myTpjDk3VyCArK0YCkxveVV27sN66fCEHrVfV69jqAsfzsj
	 XK391VQh629maf8GQavuQWjiDxq5X9i4NGEkXhWC/Psz3WfMY3w/SwwWsVi7PBPBazcT5
	 4bppG3wM6zKNvb9+wq59w44ZJUAgD8bhLLyQb7xRpFyRU/xYInmDsHRuA9NX/aBV9LVzX
	 ZeqqXSMC2CbrMJFozJYsvSxPJjmJX7Cdhv/q/bDuae068sKcReaco5iPKMU9FgJM0Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q9HRS0O0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8B3606A332;
	Wed, 18 Nov 2026 18:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q9HRS0O0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688BC1F000C5;
	Wed, 18 Nov 2026 18:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027783;
	bh=F97yXX9BuRv6GzxHd3JCXere8XZ+L43fTQJ6fJSKjSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9HRS0O0CBfzJ0BpF/GJb8g5k2AX4tMsyh7Wi7Wc+MiWPJjV5irqwt8270qYkE5gS
	 YmBIb9cDZprTk8blvU0aq6DfZPjiCtjA5KnIRLurHkzOgD5negU3sd8WsuDI6C1Sf1
	 O6a3FckXQuzG7iCxcpGu/ZuJK1RMF9lpDVpvsnoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Alexandre Cassen <acassen@corp.free.fr>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1871/2151] net/mlx5: HWS, fix modify header pattern compare on big-endian
Date: Wed, 18 Nov 2026 16:00:06 +0100
Message-ID: <20261118150229.952536393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Cassen <acassen@corp.free.fr>

[ Upstream commit 7eed173447fba937a19e2f5f2dc79780793f72e7 ]

mlx5hws_pat_compare_pattern() casts each __be64 action to __be32 to
compare only its control dword. On big-endian this keeps the data dword
instead, which HWS clears from the pattern of set and add actions. Two
such actions writing the same value into different fields then share a
pattern and the second rule modifies the wrong field.

Read the first dword of each action from memory instead. Little-endian
behavior is unchanged.

Discovered by an AI code review agent [1] and confirmed by code
inspection. Not reproduced for lack of big-endian hardware running HWS.
Tested for regressions on ConnectX-7 with firmware 28.48.1000 on a
little-endian host.

Fixes: aefc15a0fa1c ("net/mlx5: HWS, added modify header pattern and args handling")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261010120147.135825-1-acassen%40corp.free.fr [1]
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Link: https://patch.msgid.link/20261019133159.1742411-2-acassen@corp.free.fr
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
index d56271a9e4f01..f5f7eebfb52de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
@@ -116,8 +116,8 @@ static bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
 				return false;
 		} else {
 			/* Compare just the control, not the values */
-			if ((__force __be32)actions[i] !=
-			    (__force __be32)cur_actions[i])
+			if (*(__be32 *)&actions[i] !=
+			    *(__be32 *)&cur_actions[i])
 				return false;
 		}
 	}
-- 
2.53.0



