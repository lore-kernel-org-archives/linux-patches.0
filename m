Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704423;
	b=QZUUxmLku0Pv3KRIV2TAnffZyVFnh6pb9ayp5JuSpM1doPPG88wOR4/sbdXDgOF8tNKV
	 KEtO/Ck3DOqpZ9LFSZl3+HjV0sTkXSwFa1MPVKl0cDLLn2lfUfmGsFyG+LAkMXUXqoXu0
	 tPs8L2lMdontuVmDqOhzdgqo9AxKVtoF9v5KBlWkdxvjumR9TmsqUw3ZpJr9DvbVcPuRZ
	 CT8y2rf7jP7kvc39bK2NItqs4156F28DO0K7/ZLbQd7uvwiX3iNoeIpHies4HMEGQ+SSu
	 1qyWDVSMQhuNJOD6QO1/wLdBLSXwWa3XQ2mr7woiaj1Iv9U7Dkj6gTBHObrq7DLxBFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TR2o1Jk5RWc2WwXmdNaM5CYnFmzkrt7YnBvB/BGXw7Q=;
	b=Nz5nDTuZkGzWNeUWKd/xhHvlOZkqHdkqTCQYwndmGFgb+DtPbv6VZtbeg6oT+7tIM47g
	 ZW5ZsdYFTzIezUPC9yVYMlmJn9U2+ViJR5k/TaZV8v9wLoZIgcdCm5yAOiCzBNA2LHWl/
	 abivmhGD6eNLbHD93qDwWzJ7miupSOlSev444uLssAMkg/EPBTKorIYvEfb06JtYyPg4Z
	 izHJCOVynq4Ppgd8gm3NdKeyy9aXYa5WB/TloiJaN0gK1P7F6+JpUlrCyiu+nJJmVRXBw
	 fAAdtdhcQKemjzNDtdfbUmrjagI4yvwGeewfNjw0FGBd2QrrjNv7ziGqk/5Db1rairg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iIn1tzYQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933B3606A31C;
	Thu, 26 Nov 2026 14:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iIn1tzYQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99651F000C0;
	Thu, 26 Nov 2026 14:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704423;
	bh=TR2o1Jk5RWc2WwXmdNaM5CYnFmzkrt7YnBvB/BGXw7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIn1tzYQbE+96ytKTLm0erhU/eNpjU6CAiLe5dFX79Am7UYuCE811Wj9onwJeZ6xu
	 E2O9zUl1BSUoHlrYueXxpmNR13g7YTnfU7qnSVdFI67mAch4FVcjzG+z2qZgKd6ndU
	 u5sgPEXr7QyhpJDjHTGRyQXwUp4dmvJndVdQW3Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikola Z. Ivanov" <zlatistiv@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/265] team: Add matching error label for failed action
Date: Thu, 26 Nov 2026 15:37:30 +0100
Message-ID: <20261126143613.408865370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Nikola Z. Ivanov <zlatistiv@gmail.com>

[ Upstream commit aee0f01b4f118844cb126a5f27e91c2adf087c59 ]

Follow the "action" - "err_action" pairing of labels
found across the source code of team net device.

Currently in team_port_add the err_set_slave_promisc
label is reused for exiting on error when setting
allmulti level of the new slave.

Signed-off-by: Nikola Z. Ivanov <zlatistiv@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20251128072544.223645-1-zlatistiv@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ff618cb00a64 ("team: fix promisc/allmulti leak in team_port_add error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index f39339438cdc5..98edd42ab0175 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1306,7 +1306,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		if (err) {
 			if (dev->flags & IFF_PROMISC)
 				dev_set_promiscuity(port_dev, -1);
-			goto err_set_slave_promisc;
+			goto err_set_slave_allmulti;
 		}
 	}
 
@@ -1333,6 +1333,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 	return 0;
 
 err_set_dev_type:
+err_set_slave_allmulti:
 err_set_slave_promisc:
 	__team_option_inst_del_port(team, port);
 
-- 
2.53.0



