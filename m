Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76771E9073;
	Tue, 15 Oct 2024 11:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992413; cv=none; b=A/1gCDuaFB7ReVyNaQHhTQX44ZwWcEVQNHrI+6HmRobu/kPRTX4E9xQUD51NRPOuxMOm5P/l9HpN1kgBJAFtQM0In+VkSPslZPZVu+4TqnkzJmX/GC+fjeENx7B7xkYAmARI3GSf7YcOBi5ig6iVjsCYluECYLAwUoaUjBDRenE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992413; c=relaxed/simple;
	bh=fy35LpdTdnLigSMZs+Yuj09yGjjfFMZbjxj3RTovbRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTNNEKnB1WV7ARyvUdQaFL0/n1FSq/sVZB1HYtUfAaUg5DLGW/KqTlopWhRamtMmCoH/ib0BgVGgKruKg1ZbzH4kwAYvzyh/UDFPObXyWsBXQmIYVZxo4ggWwuPqV1zQ9vXqmI04T7eFZcFE97LCxMSdy6GifJwtXBSYHjWJioE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPZBVzVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPZBVzVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EC2C4CEC6;
	Tue, 15 Oct 2024 11:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992413;
	bh=fy35LpdTdnLigSMZs+Yuj09yGjjfFMZbjxj3RTovbRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPZBVzVXxnjgZZvPVCq2Cs2Vojzo7O48im6eY77qXEk7SZlfEorKpLoFnQnCWsKeO
	 WTQsnoZIzaPnlpBQx42DDHFTdGu9gyhYZdUXnhvGjD6Ow7aD+QG0BU1gsM4oxElVrR
	 eQqP61LFq6ldiB/Kh18VqimntXR8i94n4/HEgSJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/691] can: j1939: use correct function name in comment
Date: Tue, 15 Oct 2024 13:20:56 +0200
Message-ID: <20241015112444.646029084@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



