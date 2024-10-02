Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AD91D12EB;
	Wed,  2 Oct 2024 14:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879273; cv=none; b=JEInkeZjEIqLyvd1exf/CiMvWcgTOEl9kwCdAVscCi9RB9S8af/ELXeSbegT4yO38hr3UfbPcEbsR9DJHXQsdoMfYf0cFokYHuOst0mB1+a335zWaH88OMvoaLrO8nNssrJ47/oC0RMN263WtAdo+VEUnra7LQKH5Zzqt9aArPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879273; c=relaxed/simple;
	bh=cZDO3k9LYnusChSRZIFvMhp/fiG0KOUzPgETLRmQEKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZKubEzBh+i8s3PKgdtLeZ2yeF+OVHWLXfmpCQFUH7++iKRPRmvPTBEVigjPSadEkpNSGC8DzbobUtLzQSj/Hu0pVz4n7kRIKMR7vbEIE54mkMj3E/LTDFb57xD6cRuLI4s3Jf7oty3I/KgIS10QZ9ZgWh+k51wADYN1uP8dBtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jL2R/ZpN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jL2R/ZpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0726CC4CEC2;
	Wed,  2 Oct 2024 14:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879273;
	bh=cZDO3k9LYnusChSRZIFvMhp/fiG0KOUzPgETLRmQEKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jL2R/ZpNdqHqMZkG1Oxn/rK22F5hIIcj/415CXdY+VfxlpoEih7MQCNQg6otfGJrH
	 c1jinLNBIHBzJ5zOn7VxX7vdM23HOGxriStKVUKjfO/xN5MYfaXv7nGmn1p+PU/olH
	 0siwSnspGrg6P3rPvTg+StwC1Y8/RSuMA7UVWsqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/538] can: j1939: use correct function name in comment
Date: Wed,  2 Oct 2024 14:54:30 +0200
Message-ID: <20241002125753.252069574@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4be73de5033cb..319f47df33300 100644
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



