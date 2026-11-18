Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021603;
	b=4s9PlPe54NZTAytgnUFt5GB0XgdB+tNMwK0BHR8aOqT+KIC07lkL86h09JRmGoAcAcAo
	 xAMCs3+dxMXkhcEx6q2IKUBDXhQDvfeVjHfbKiHNLWuwofCp2IxeNASuToDj719FRDrfz
	 W5wXn7IiAEAJ4owin5DmTEUsBR1IGnDtqaw7PSZRVjAsft22gEVXZnGWNId1kjbtaA9ni
	 S+3zOtJaMMG+PXaswFDdAshoGi2SOLlwMlBgd0jPFdd9BIVnlcysvyzasDtgNPhjA0J7D
	 WUq1pVFLw9O1e0TMX6Yv4FxbGwBO7CQVszDBzmmqTIg8YBaqvmA2/pYCI9MrWtZp/5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OS+RhHK/JPkd+OwXy2igRkkK0f4GFNGvvYRKE6nldGU=;
	b=mFJkwSJ1aLfZup3ya59T51DCQTKrLVwSUYpPjeCVxyTN9XqA4AyGJTp/VuuUUk1fHU+c
	 tXNqSRKjcRam6WUYs7W/zRQaZt6DSUaUph3rKUzpEzwnbasIUw0WmYhwcVRmbYz8L9+NC
	 Rxq0tQiXO4l+vhUc/tj24KTwxiRrcFmG212JL2mRlDnuP0uVVhs4tKjNQoykECeRe+6LY
	 XtyjlPvX+b2awoZwtkdHSck0uBIZwbWihT7WESxW9w8uP/xjDeej31VYyURXa6+roCiAN
	 5KPWyE2E9S+KxAhII5Z/9WZPOgnGisFocXQkB2dsb6MK46WhEDQmYXG+SkrGQnVZpEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fExgxk/H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC6160A380E;
	Wed, 18 Nov 2026 17:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fExgxk/H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C25D1F000C6;
	Wed, 18 Nov 2026 17:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021603;
	bh=OS+RhHK/JPkd+OwXy2igRkkK0f4GFNGvvYRKE6nldGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fExgxk/HcHRNYhIKuyqlpnFhwcFV+1QUldPr3pn89gfecpxHBQqmAN2BNsC5OwDY4
	 rZqvI3i0zjuDdpEhouF9+vkx7xodbi1fDTr5VKLrs4bar0tUzPES2Ep3t2rxSik3AT
	 K79HemPYpDNK+euqZbnrnrXXw+wrr8+WiC7X2Ijc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Alexandre Cassen <acassen@corp.free.fr>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2315/2651] net/mlx5: HWS, fix modify header pattern compare on big-endian
Date: Wed, 18 Nov 2026 15:59:15 +0100
Message-ID: <20261118150408.544064687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 9af449c2b4d5a..512299b59fd0d 100644
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



