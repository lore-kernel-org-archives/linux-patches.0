Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38023D413B
	for <patches@lists.linux.dev>; Wed, 13 May 2026 06:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778654149; cv=pass; b=EF4sKQKR+Q+qD2WOeRqntuHTh5MFtOhc9w4B7MR1gZMd7nUAARGAGlpfUQpN0AozLBt0e/3klcA4OybOdgMbk46vzs7A5VPzrHWe1U3kUAFgMtxG4T30cipl85rgxJR9OUnLUktNA+gS8Zkt2v5/LqYZhTia54B2EOa8GMOxHCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778654149; c=relaxed/simple;
	bh=uhwAHbNn994yD69fS9MOINtdMaAwobwvE5EDbdcH+LM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oe/YzlglE+3Dhe+wRK7K1kZXmhd984rYCjsPVWrqWO+WzehG8WXLQ52XO51/pHOerWsaCbZfOUzqMITnIIjT2p2U9L2Bf85Fe/nPTN5/Lp8PeHMNyaWhmRZ+Y0qgpTEULMh0kUbeoJ7Y0r7c5v+k4oYmkoAgKoTiumkNq+ubXUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net; spf=fail smtp.mailfrom=hartkopp.net; dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=d61Jp6MW; dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=UmIQQytb; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="d61Jp6MW";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="UmIQQytb"
ARC-Seal: i=1; a=rsa-sha256; t=1778654116; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=YUpB8l3NrO08fFcw9ldbUkh2b6+hKqoiSe6G7jFtn7ke8jyiW6j2F0ZAv1HD4oYkti
    1YeNjlVX+6knQJjpbGfZO5D/Q207mW4RD/SoykXWLaQwdXTscCzu+Qbmt9ufHfhy4nHv
    2P1EvjUhEvnz5WvyhiDlmw6YidAcCwquj5w1xeDfCsIDX6Ot+74jqY/ZihRaucuOzDyG
    n4I+L78a4CDkRuwLNRsMASGCZK7X03hdZgLOPyNQ3LRw7Bl1REQ7/vgWrcXYfHElacfq
    OpceMdTp+mPPX+bxiiiSIMy17aZEb0MUMy2VwzK+DEOlkVRv1zUSuFAwPwMO/WYK7OU1
    QPQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1778654116;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=UqDc0ZWgKlbYGD/0a/63ZGYz6DA/sViimk9z4rFSOFU=;
    b=Nfv7qgMU35rWJYRpXHzhDI1qxKdBByYQmgnRjlvYOQYLOxawJ0OJWci0++Vay+pVdw
    oni+Hhg2+F1OPim8Iw/eZbue33EC6lIoywz5w+Ljf1x2xjpFfqvXKkDh2Hp+lpC4EyFU
    EyH9+8YKyyDb96UtqOdONZCrhYzcglA3U10dAmvJ8zcYEyy0kP/BpY8rAC+HKIsF/RD3
    4t7Oc0t45IWcZdZXg+T2730hv/ZgpaWTfpn2e9+/BHd3lAkqfJ1kv2UiixyZCv8gQKJB
    i9Ccnwh+DfvleML4onqhq+cMsOw99gM2siaKoqnzxWSFJLPpKArT7OMc8jtiNDE8SxD2
    FynQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1778654116;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=UqDc0ZWgKlbYGD/0a/63ZGYz6DA/sViimk9z4rFSOFU=;
    b=d61Jp6MWsZGq+1wxFoTAbGkhtCWrkzUkx0e6o2GwddeQV+kmeGlKzd/tq+LEZ/IYGw
    5sAP4oexozBTT1dCVI+gRe/8Iy8Fh/IWKZkrZhXKeqw0iRQFgR9QzeqYOkUemy83j6Oa
    VQ4r9szK9M8yLi4p84ACai5NgCv2rxJAVoaade47woglvhsX/9091XmU2rm01c+6hOKK
    8SOBDUvwRsaXbjUbsu3mRdC64kMmiCHKEj3hepWsYAFF8tpLIvnlicSJpoHl6zq+nwfK
    wmasTFp3hKq2a0qbLSII+ZXYOcloTCjclb2MtHr6/mG1XTlDQnUS+/V1IeSAtc+uNR+3
    vPjA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1778654116;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=UqDc0ZWgKlbYGD/0a/63ZGYz6DA/sViimk9z4rFSOFU=;
    b=UmIQQytbCw/lbgLwnWzZPbyrG1Rtfncj7l02rTNSLCFpxio1Nr0ysf0b10vfaEhetk
    6bCicL1x1tPuAl/4hgBQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjH4JKvMdQv2tTUsMrZpkO3Mw3lZ/t54cFxeEQ7tnMDLztswwlyqon4XDpA0w0c7HaA=="
Received: from [IPV6:2a00:6020:4a38:6810:ae1c:f386:228b:f98a]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id Kba96d24D6ZGyDw
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 13 May 2026 08:35:16 +0200 (CEST)
Message-ID: <cddb23c3-8c07-461b-b6c2-3d9a62d5179b@hartkopp.net>
Date: Wed, 13 May 2026 08:35:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1.y] can: raw: fix ro->uniq use-after-free in raw_rcv()
To: Jianqiang kang <jianqkang@sina.cn>, gregkh@linuxfoundation.org,
 stable@vger.kernel.org, sam@bynar.io
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 mkl@pengutronix.de, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
 netdev@vger.kernel.org
References: <20260513061828.3671533-1-jianqkang@sina.cn>
Content-Language: en-US
From: Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20260513061828.3671533-1-jianqkang@sina.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 13.05.26 08:18, Jianqiang kang wrote:
> From: Samuel Page <sam@bynar.io>
> 
> [ Upstream commit a535a9217ca3f2fccedaafb2fddb4c48f27d36dc ]
> 
> raw_release() unregisters raw CAN receive filters via can_rx_unregister(),
> but receiver deletion is deferred with call_rcu(). This leaves a window
> where raw_rcv() may still be running in an RCU read-side critical section
> after raw_release() frees ro->uniq, leading to a use-after-free of the
> percpu uniq storage.
> 
> Move free_percpu(ro->uniq) out of raw_release() and into a raw-specific
> socket destructor. can_rx_unregister() takes an extra reference to the
> socket and only drops it from the RCU callback, so freeing uniq from
> sk_destruct ensures the percpu area is not released until the relevant
> callbacks have drained.
> 
> Fixes: 514ac99c64b2 ("can: fix multiple delivery of a single CAN frame for overlapping CAN filters")
> Cc: stable@vger.kernel.org # v4.1+

This fix is not only missing in 6.1.y but also for older stable kernels. 
It has only be applied to 6.18.y so far.

Best regards,
Oliver

> Assisted-by: Bynario AI
> Signed-off-by: Samuel Page <sam@bynar.io>
> Link: https://patch.msgid.link/26ec626d-cae7-4418-9782-7198864d070c@bynar.io
> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
> [mkl: applied manually]
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
> ---
>   net/can/raw.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/net/can/raw.c b/net/can/raw.c
> index 488320738e31..bcd6061f43d8 100644
> --- a/net/can/raw.c
> +++ b/net/can/raw.c
> @@ -336,6 +336,14 @@ static int raw_notifier(struct notifier_block *nb, unsigned long msg,
>   	return NOTIFY_DONE;
>   }
>   
> +static void raw_sock_destruct(struct sock *sk)
> +{
> +	struct raw_sock *ro = raw_sk(sk);
> +
> +	free_percpu(ro->uniq);
> +	can_sock_destruct(sk);
> +}
> +
>   static int raw_init(struct sock *sk)
>   {
>   	struct raw_sock *ro = raw_sk(sk);
> @@ -362,6 +370,8 @@ static int raw_init(struct sock *sk)
>   	if (unlikely(!ro->uniq))
>   		return -ENOMEM;
>   
> +	sk->sk_destruct = raw_sock_destruct;
> +
>   	/* set notifier */
>   	spin_lock(&raw_notifier_lock);
>   	list_add_tail(&ro->notifier, &raw_notifier_list);
> @@ -409,7 +419,6 @@ static int raw_release(struct socket *sock)
>   	ro->bound = 0;
>   	ro->dev = NULL;
>   	ro->count = 0;
> -	free_percpu(ro->uniq);
>   
>   	sock_orphan(sk);
>   	sock->sk = NULL;

