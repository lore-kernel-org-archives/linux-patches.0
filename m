Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032673;
	b=LfjggV595gw2Fva8jXQpj9QejyUWu9U1DS92tLaKWqPRgle77VtBplNeduvlz8b87PcV
	 DIX6vtCvOSU9SYfWiB6Se8U7E10R+ECcH/3r1EZntwYgELJQ41+0NgZ/qDscmXQgHbAlf
	 Iv35wh9oL5f5jpwR47IjpZs9pqM6AD8WyvyaifCJDoKqZ8mZJ7t/8Fv8tsTBw5ChyTwWN
	 mcn0DH55PWR5J9BHWITK1YGKIIDxxOCYimmoko9SqrVFFAsidXWBb+ZAyUOBiexoHX3m1
	 Ex0Fh0QFu8O5xTfheGXPkxVZwu6aZfkH652AA2HBjqYtbrLC9bMvDqkdkB0FhWVInZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+vHg/q3rPxgsLhLfOkSO5vaLCTyMUFA/iTAkdEp8E98=;
	b=cmdmayhEmQvSks3EUgA3ORnOTUcEG444lXZDYib2U9JtwHk3AkK8yNIzCWdVza+QgFLX
	 9kXAsqyLCd65bHFvxGssVqcHMUk4G1vQa7WACuKJr863v+2RMZwS+V6ulwLiJJCRrwxe3
	 ofg9LBl+6DxMM4GZtzFrgbvPp+N7W1xT/76vV9Oy2XhoUpHEyMxF6vAvLSat8/MRPmNGr
	 Dc/yv0iKOsMz4C0Yt/4gOtAq0F59zeupWygvOfb/Wbvi3QpP9kp1u6cvQVLtMt2dzS/Rb
	 PJy5gWVqCxdEWWOBDpoC2bd192DcGzSCwMNek8P3LnJhpIusrOZaYgdSRgFeTLEHlWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fIqQCIkK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6D5606A31C;
	Wed, 18 Nov 2026 20:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fIqQCIkK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FC11F000C4;
	Wed, 18 Nov 2026 20:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032673;
	bh=+vHg/q3rPxgsLhLfOkSO5vaLCTyMUFA/iTAkdEp8E98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fIqQCIkKZsufv+WuoF7dnPn96yxHGmKGFbbFRVRKQf3xf5T9dmYiua5z7tzt0sK3N
	 lnpb/XMwHcei/huvIkl1Hk0YEMyhHtKCbADwbmteG+j7UnThkweoOoLhT0KL+YSr7O
	 9g00TZQxXTtD1iqb4E6H5qXbxjnBpZhi1JNF1mRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Alexandre Cassen <acassen@corp.free.fr>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1494/1756] net/mlx5: HWS, fix modify header pattern compare on big-endian
Date: Wed, 18 Nov 2026 16:00:21 +0100
Message-ID: <20261118150108.444912488@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 .../mellanox/mlx5/core/steering/hws/mlx5hws_pat_arg.c         | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pat_arg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pat_arg.c
index e084a5cbf81fd..887a9c3633a15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pat_arg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pat_arg.c
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



