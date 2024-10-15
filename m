Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB00A1C07C8;
	Tue, 15 Oct 2024 12:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997133; cv=none; b=d8LKhjDZizE5J5W9K1xJatSivnjaA5JFdRCcWWYnykFcP35snxr72AzyQMfbYrkmsIh0/I1lPrvXs8eoEpbhsX6k3sMNNOYtfbEl9tAOgpy4EQDXZZhO5kvaBLfVU7JC6r/pWM8WG1/piz1oGdky0btTAaf/n/BMoTex6TZ5x1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997133; c=relaxed/simple;
	bh=ZTxQL38oauiyBBLlCJI9LE3Bf5hYYeLt6u16KsieSuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pV7Ke5h5+B+NeZlatCvYJCRkVAryGLyya0ipM9Vc5vukBn7u7zZIjyvWCq/0DA+fZuGkMnJKThkiEBeJlXFVqEllbuEgbPdbhbCb0P98vFT3PakwCtOmj8M+2ucukmBmtfhxQXkWQFCT3v0t61FJ2aWppYPfoH5IwPOQx/pPT7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o77CqAsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o77CqAsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AD1C4CEC6;
	Tue, 15 Oct 2024 12:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997133;
	bh=ZTxQL38oauiyBBLlCJI9LE3Bf5hYYeLt6u16KsieSuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o77CqAsbiowK5XejDDxneuQmOAe2LtTF3wqBzxgE1vmst8lyxr78PG/8qFub8VdKZ
	 Y3WQLpxW1aTcqo32GSphJFyb2Y1jF/0tADVedfWw56nlgC4YT0mmGeLCcApY/Qy2fV
	 8fWFrxJESAWCQLmFPGeh9ElXSy+aaqRe8knbT/y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/518] can: j1939: use correct function name in comment
Date: Tue, 15 Oct 2024 14:39:30 +0200
Message-ID: <20241015123919.553070410@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 478dafc738571..a86256ab14022 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1171,10 +1171,10 @@ static enum hrtimer_restart j1939_tp_txtimer(struct hrtimer *hrtimer)
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



