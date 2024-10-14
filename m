Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F901AB508;
	Mon, 14 Oct 2024 14:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917516; cv=none; b=LOZkFvdJaQPPq3qpR1WZXckZWhnZP4iD8CCGmHIQqIk7zr8DQDJBOF+yMIwCFJhO89SBo7QGJVx14uc6Z3EgwuAJie5b7RShmo3L5LC/A2GB+O+igXWsQKi94ltJgwm1UhvVm3wnrNk60lCjD5UMKPToUxqU3+gB5IJcVeIEylc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917516; c=relaxed/simple;
	bh=GFa1QXdYvexfrURIX/p1746lGq+r/DGycB2sC+c1kJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HE1LtVnOrXpPHROJEWW7GvBaNclYoagEkANVtEoHft8Y4gONXWFzOTgVg6fZudiEFlyFW95fo08G88XFcbpeacC9+gN6Tjy8ccI8aHe83Fu6Hpw6p7OJAikklK3HvMHuUsqkJ4I4bU0ZSbhz0UQu9Sa/w5r7YUqZKda83nVbMO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMryVM9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMryVM9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734B5C4CEC3;
	Mon, 14 Oct 2024 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917515;
	bh=GFa1QXdYvexfrURIX/p1746lGq+r/DGycB2sC+c1kJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMryVM9YJEERKMN0e7h4luIB/OeKQ2X9mdcc+LSugmnWtTrMTMiykcupAlSnNRD5E
	 qBr7rXYGSF83535X4GPp4bl3YJahI6CqVMp20mG7MvtjdbDXc6f3n9WCxY67OGLmtU
	 bR9axFvjzyKN8xTTXYxhii9/Psq8zRwpXrW8Dg4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/798] can: j1939: use correct function name in comment
Date: Mon, 14 Oct 2024 16:09:39 +0200
Message-ID: <20241014141218.938661974@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit dc2ddcd136fe9b6196a7dd01f75f824beb02d43f ]

The function j1939_cancel_all_active_sessions() was renamed to
j1939_cancel_active_session() but name in comment wasn't updated.

Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://patch.msgid.link/1724935703-44621-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 25e7339834670..5d2097e5ca3a8 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1179,10 +1179,10 @@ static enum hrtimer_restart j1939_tp_txtimer(struct hrtimer *hrtimer)
 		break;
 	case -ENETDOWN:
 		/* In this case we should get a netdev_event(), all active
-		 * sessions will be cleared by
-		 * j1939_cancel_all_active_sessions(). So handle this as an
-		 * error, but let j1939_cancel_all_active_sessions() do the
-		 * cleanup including propagation of the error to user space.
+		 * sessions will be cleared by j1939_cancel_active_session().
+		 * So handle this as an error, but let
+		 * j1939_cancel_active_session() do the cleanup including
+		 * propagation of the error to user space.
 		 */
 		break;
 	case -EOVERFLOW:
-- 
2.43.0



