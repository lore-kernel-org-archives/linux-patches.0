Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3FA2511B
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 18:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="OdrR0WPF";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="Fm0bmcYH"
ARC-Seal: i=1; a=rsa-sha256; t=1698172477; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=n2YzjC4uF+3fBqX14R4lLu+X+5Efv0qpsvwUCqSQ5Nm7YPUGYLPqUITFSHJW7FkQ0k
    GuMQ4cKlXw7Zz+L/XZE9UMzJliHoqVj4QJjGdW4RkgWai9kIGmC3fPK00ucOmStJsFQq
    9rYVU3sqWncPo6HUgsf+lDm1+pgolQxg5jKGqTmnImJ1IGZXLaOMM5bG3sTVeximjqHP
    ZWcWJtU2vtnF4xKJ5YWkZQlgMO2vuE+ERWBv25yYkh28VOdiDEBaCaaOEsA4a2PcADBd
    Jd9s7Gvab4Ba/FUzYy7eyZoTjpAlgZ53y7iVo1STMx5sZnhlb0hfiKF5Xikq03AQQaKt
    1h1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1698172477;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=irgnW47MlS2Q3xCqUkAQJFUtWndQeeYVGNA2HNDBznw=;
    b=htDyC3LI/QMBTb4e6hNBoO16brfn6hnbgdy27ra5QOQKLonO7pbmSOz20zPuV1Z2Gl
    kXT6uApptfQyEBJMGTrVeUUcd/iagc7ahZOjTwiQdxQNMsgB1NpybTMPDtlkmEZprm0i
    7Xd20Ah3fj9UqfYtktdejX6VlmRIi4CTd24uLj19Y193Ds0g+fpAujzxZ6+gS6yn32fK
    ax3W3QefYRPLWZ6qLP69xyBU/YhpLYPG0BY5sogEWy7DBvAdzrKsRN3rU8cYrHx+BoSn
    8+TFRw+AmTlgXaapSUGL5DvzzetdJhA/79BTmA2x/fRPkesqewIA1YbUwOL4pc85yUXu
    ltjA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1698172477;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=irgnW47MlS2Q3xCqUkAQJFUtWndQeeYVGNA2HNDBznw=;
    b=OdrR0WPFKYTYeB5dz4ycnzOkkUtXvJ9Bcbs7DimiXV6JbHYYWeihh3HghWJmqk7yHo
    esZay3B1KtEz1x3hmp97mposiQWNRWEuYXEPfI8oYB9R2pmUcgSCw3XrdO0kIn4nuu7o
    SteVFMngkAe3mqnhs2dM6zTiT2zqlKna35TgA7uos8AZGpw/5RMwMBxrwkhMFRGn/Nx/
    Tiy98B/B0BiC3dxBBk+OuU9LFpQW1fWn1QPMIRL/2xlRKWg9tXBy0zxj1Mka/Kj0hUDH
    83JonFJUAUt3zyKQswc8//xsUgvJdFTDRmsU1FROCQBmtbAr+ROEwp2JSumn2CU8Yzgd
    UxkA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1698172477;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=irgnW47MlS2Q3xCqUkAQJFUtWndQeeYVGNA2HNDBznw=;
    b=Fm0bmcYHoP7YPaHSMTfdNXh3NY98cRR6cQNaDtkHenvcktzGjtYnnCWq6mnGlb2l0Y
    KSwpyMwprv7OSAoVV4AQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq1USEbMhpqw=="
Received: from [IPV6:2a00:6020:4a8e:5004::923]
    by smtp.strato.de (RZmta 49.9.0 AUTH)
    with ESMTPSA id K48ab2z9OIYaTOF
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 24 Oct 2023 20:34:36 +0200 (CEST)
Message-ID: <b4a1bdc2-54f8-428a-a82a-0308a4bc7f92@hartkopp.net>
Date: Tue, 24 Oct 2023 20:34:30 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 043/131] can: isotp: isotp_sendmsg(): fix TX state
 detection and wait behavior
To: Lukas Magel <lukas.magel@posteo.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, Maxime Jayat <maxime.jayat@mobile-devices.fr>,
 Marc Kleine-Budde <mkl@pengutronix.de>, Sasha Levin <sashal@kernel.org>,
 stable@vger.kernel.org, Michal Sojka <michal.sojka@cvut.cz>
References: <20231016084000.050926073@linuxfoundation.org>
 <20231016084001.142952122@linuxfoundation.org>
Content-Language: en-US
From: Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20231016084001.142952122@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Lukas, hello Greg,

this patch fixed the issue introduced with

79e19fa79cb5 ("can: isotp: isotp_ops: fix poll() to not report false 
EPOLLOUT events")

for Linux 6.1 and Linux 6.5 which is fine.

Unfortunately the problematic patch has also been applied to 5.15 and 
5.10 (referencing another upstream commit as it needed a backport).

@Lukas: The 5.x code is much more similar to the latest code, so would 
it probably fix the issue to remove the "wq_has_sleeper(&so->wait)" 
condition?

@Greg: I double checked the changes and fixes from the latest 6.6 kernel 
compared to the 5.10 when isotp.c was introduced in the mainline kernel.
Would it be ok, to "backport" the latest 6.6 code to the 5.x LTS trees?
It really is the same isotp code but only some kernel API functions and 
names have been changed.

Best regards,
Oliver

On 16.10.23 10:40, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Lukas Magel <lukas.magel@posteo.net>
> 
> [ Upstream commit d9c2ba65e651467de739324d978b04ed8729f483 ]
> 
> With patch [1], isotp_poll was updated to also queue the poller in the
> so->wait queue, which is used for send state changes. Since the queue
> now also contains polling tasks that are not interested in sending, the
> queue fill state can no longer be used as an indication of send
> readiness. As a consequence, nonblocking writes can lead to a race and
> lock-up of the socket if there is a second task polling the socket in
> parallel.
> 
> With this patch, isotp_sendmsg does not consult wq_has_sleepers but
> instead tries to atomically set so->tx.state and waits on so->wait if it
> is unable to do so. This behavior is in alignment with isotp_poll, which
> also checks so->tx.state to determine send readiness.
> 
> V2:
> - Revert direct exit to goto err_event_drop
> 
> [1] https://lore.kernel.org/all/20230331125511.372783-1-michal.sojka@cvut.cz
> 
> Reported-by: Maxime Jayat <maxime.jayat@mobile-devices.fr>
> Closes: https://lore.kernel.org/linux-can/11328958-453f-447f-9af8-3b5824dfb041@munic.io/
> Signed-off-by: Lukas Magel <lukas.magel@posteo.net>
> Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Fixes: 79e19fa79cb5 ("can: isotp: isotp_ops: fix poll() to not report false EPOLLOUT events")
> Link: https://github.com/pylessard/python-udsoncan/issues/178#issuecomment-1743786590
> Link: https://lore.kernel.org/all/20230827092205.7908-1-lukas.magel@posteo.net
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/can/isotp.c | 19 ++++++++-----------
>   1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/net/can/isotp.c b/net/can/isotp.c
> index 8c97f4061ffd7..545889935d39c 100644
> --- a/net/can/isotp.c
> +++ b/net/can/isotp.c
> @@ -925,21 +925,18 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   	if (!so->bound || so->tx.state == ISOTP_SHUTDOWN)
>   		return -EADDRNOTAVAIL;
>   
> -wait_free_buffer:
> -	/* we do not support multiple buffers - for now */
> -	if (wq_has_sleeper(&so->wait) && (msg->msg_flags & MSG_DONTWAIT))
> -		return -EAGAIN;
> +	while (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE) {
> +		/* we do not support multiple buffers - for now */
> +		if (msg->msg_flags & MSG_DONTWAIT)
> +			return -EAGAIN;
>   
> -	/* wait for complete transmission of current pdu */
> -	err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
> -	if (err)
> -		goto err_event_drop;
> -
> -	if (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE) {
>   		if (so->tx.state == ISOTP_SHUTDOWN)
>   			return -EADDRNOTAVAIL;
>   
> -		goto wait_free_buffer;
> +		/* wait for complete transmission of current pdu */
> +		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
> +		if (err)
> +			goto err_event_drop;
>   	}
>   
>   	if (!size || size > MAX_MSG_LENGTH) {
