Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063805;
	b=DzJhziufiI9cNtOU5FdEQHbClbD4feItYQwSIy3mqDbLMuFa4rLoSJ1v/aloHD1Zxayl
	 xmxZJgN/3KDBILuhlNy0xhGuH0FeGOKxJGFhF62e7914wZ2nDW7emVhgxNyV1wEiX05d7
	 Z6VNIpI6EC1jueYGbeuxnl5QEqVIbMMfrKoMZO3D+yeVN7GOjsq1+6VoJ5J1Y/oGKTe8/
	 zjgYII1b9nYuk+5gemZrgDOqMVHx+r9CO0PQgQ2Rf99c94/M6ZmA/4uaGinfvRQwJHRQq
	 eDf/Gs6F01W+aDoULrQZrvzpCrY2C9XhcbdD/Y5BF//B1a4mG9G0xaxorvuNNaD9fMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=js6AVdqAWOl693gZgEOu1Kt1ZfpQUC5wjXAYBj2eFaU=;
	b=DeGOiHVufo+8FK4B6uugfSc0wSfuT4yGRIK+IOiYMEAqhmd/F3NakAZLIgJfnCZdTDK/
	 hlMlUef0vm2Ph9DHIvLYR3CIqZpNvP7ng4s+vBgMpFxky5B/HfS6hsRT3ZwMmuugoVfGf
	 eVzgY8xhTRZLqCsuK5erB9KL0MUgNOkybgw/ZvZGRaTCv6ukIqKMeJzxmjlBzyYEfILQX
	 V1yI0KQQ4Ml9hEzD15n3vJaXfor8VL22WDGCf92tidNZ2uab+I3OA1fX+1fsV1Cu+6irz
	 09tOsICIdCMzGFW2zX0Kc1lm9jmcTLSht5hSqvENLHrQwgFtPVSl+Jyjh7/7F0PqwZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzrymY+8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865DB606EE81;
	Sat,  7 Nov 2026 15:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzrymY+8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EF61F0089F;
	Sat,  7 Nov 2026 15:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063805;
	bh=js6AVdqAWOl693gZgEOu1Kt1ZfpQUC5wjXAYBj2eFaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzrymY+8UWLZgEsERSSp1SPeCbsSWk9SG95cH6GF0oS5ksLktUiXqfunOP6daOrXK
	 uz5GFPfyfOVYdLXW/JNbAgj7f3RV2jYACDpStxc02c2NWG69mjVi6hfXz6uR1myQzz
	 5p6Z5XKhrjmTq1C7H74gr3rnhWAWI9IYlMxH4bUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0025/1257] media: streamzap: Add missing rc_unregister_device()
Date: Sat,  7 Nov 2026 08:38:41 -0500
Message-ID: <20261107134940.103985807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 3982d2eeb1bdf7a9c14e4ff69015cb456f11da51 ]

If usb_submit_urb() fails during probe, then the error path is missing a
call to rc_unregister_device(), which will leak various things like the
input device.

Fixes: 42844992664f ("media: rc: streamzap: Error handling in probe")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/streamzap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 307985d74fe8a..41195ad82734f 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -365,6 +365,7 @@ static int streamzap_probe(struct usb_interface *intf,
 
 	return 0;
 rc_submit_fail:
+	rc_unregister_device(sz->rdev);
 	rc_free_device(sz->rdev);
 	usb_set_intfdata(intf, NULL);
 rc_dev_fail:
-- 
2.53.0



