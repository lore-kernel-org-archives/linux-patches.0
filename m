Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CD1BE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B463DC433C0;
	Mon, 19 Jun 2023 10:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171702;
	bh=dt4rOr8OdxNG36Kv5PYAvPVKG9VFG5qjHfzcIkWV2uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCLsKj5K/Mv8PAToqMl3xewwqMGfn3xtA8l+p1lLin4rjyHLRrPLdwBazaS2wYIe9
	 FjA8R9jtp59+ODhTmd89H62he31L8PaeHaSzdGIbwIbLzkkGxftsd5pr1I+wk7oJPZ
	 OnCloG0x1P9d8F0cYhdgCUzh6/kg2BV0o32ilrsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/166] sctp: fix an error code in sctp_sf_eat_auth()
Date: Mon, 19 Jun 2023 12:30:03 +0200
Message-ID: <20230619102200.929507353@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 75e6def3b26736e7ff80639810098c9074229737 ]

The sctp_sf_eat_auth() function is supposed to enum sctp_disposition
values and returning a kernel error code will cause issues in the
caller.  Change -ENOMEM to SCTP_DISPOSITION_NOMEM.

Fixes: 65b07e5d0d09 ("[SCTP]: API updates to suport SCTP-AUTH extensions.")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index f6ee7f4040c14..5383b6a9da61c 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4484,7 +4484,7 @@ enum sctp_disposition sctp_sf_eat_auth(struct net *net,
 				    SCTP_AUTH_NEW_KEY, GFP_ATOMIC);
 
 		if (!ev)
-			return -ENOMEM;
+			return SCTP_DISPOSITION_NOMEM;
 
 		sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP,
 				SCTP_ULPEVENT(ev));
-- 
2.39.2



