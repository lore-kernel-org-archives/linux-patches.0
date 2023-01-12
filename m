Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CA979C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD1CC433F1;
	Thu, 12 Jan 2023 14:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534273;
	bh=kdLqsUXrfk98UtlspnrWQAq2559d5VmdOZ23+Wzw+ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRhkcO0f5zWlX5pnicMTPrw+fIMYDRShOlxqA6f6dFzHjYuwDlkCoh8HVyG+8XP/A
	 C8V8E+LyjUjyJCbGcAY76mkvhSTQPTiPreG2ftaB6rJYVTN7dFKd04mMzDlZX84Q//
	 3BetDj+3NGFYo/HjgxCwKp5GRl8lRjdtcmXL5d8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 753/783] drivers/net/bonding/bond_3ad: return when theres no aggregator
Date: Thu, 12 Jan 2023 14:57:49 +0100
Message-Id: <20230112135559.269077175@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit 9c807965483f42df1d053b7436eedd6cf28ece6f ]

Otherwise we would dereference a NULL aggregator pointer when calling
__set_agg_ports_ready on the line below.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_3ad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index acb6ff0be5ff..320e5461853f 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1520,6 +1520,7 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 			slave_err(bond->dev, port->slave->dev,
 				  "Port %d did not find a suitable aggregator\n",
 				  port->actor_port_number);
+			return;
 		}
 	}
 	/* if all aggregator's ports are READY_N == TRUE, set ready=TRUE
-- 
2.35.1



