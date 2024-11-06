Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14551F585A;
	Wed,  6 Nov 2024 12:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897844; cv=none; b=Y84sg0YSFsziLuVWbLtXtVxWKkcZsmaXlMjBni87NbQR2L31lP7jOoUHmIFO6npUZRLGenLmgWxxl7nXG2CzaPqqoXkIcyxL1evXxhZQCBa+0codYawMZB2qwAT7l50vgJG8ms4oSU+sohlfZCTNw5rtbnwksBXJn2ksGk5ec3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897844; c=relaxed/simple;
	bh=+uq8T4+TLs2NZ3uEzZhhmt8c5JYQ3TIPQmjla3MSHgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKD7q/S2o/5p69q2llp5wZ2q8hjDcJTVEY0ksrBRSTnbiLD8s1ns57ovZp6SlXvUI6ns+qFG9ix0zrCZodm7TZbtmINua8fWd8KoF6OXi3yh1IHrzLC7iLnNXcf+oEaazg76pFfSab3Wn2ro0NhZtSHOcS/m6eoodSNOjZCpaeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKzqaVzG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKzqaVzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5577EC4CED3;
	Wed,  6 Nov 2024 12:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897844;
	bh=+uq8T4+TLs2NZ3uEzZhhmt8c5JYQ3TIPQmjla3MSHgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKzqaVzGHRhQjqmyIqxRvjOJdfrtphiae4PI9fpFQ6soyowQfNgWr54MntexNdH+k
	 LAU3Ggv2VQ4VVOfR7vVt8NhXqaBLWAsl/tXNU0WUGQ1LxDWdr5lWWtb2MXXbY8dBQR
	 2jjYijZYA6JjDm7PZe9hYnU98GB8gxswnbrRqEr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/462] can: j1939: use correct function name in comment
Date: Wed,  6 Nov 2024 12:58:52 +0100
Message-ID: <20241106120332.488059442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 009c5a67cfbdc..1d926a0372e61 100644
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



