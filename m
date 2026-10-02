Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338BD46983E;
	Fri,  2 Oct 2026 08:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790930908; cv=none; b=PcUm3BLZd1E0iSxeuQ5Y+jlrqP0m5FLouU03ZaI13XUVVQPHpUwMiO9qdSiS5GkGCKoTCraN6VVpzfY3XcvqskwRytSG32RxZ52/8Au1AjBRbueFIAfpJi3Mpq3A7fGo1phS2JH0yYZwcA1Gn53kEuXiDryD1+HSrCtxNes0UR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790930908; c=relaxed/simple;
	bh=Na7ttsROGIgypamFd07Z45vJtly4uZhd+l6H3RrKkl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E3YviujihhzcIpIgzcNhBhyjnx4lpPlW/Lnn+xY95p0X2Xv625BVEjLOXZTzIOwLfqnwrM2oYbkrYZzwWeitj+1Jr0d9qOQtZmYn5ty3DpygBgoNFbOjXnY+3zWO+Bwmr4BbCRxt9Q3FC4bSMpmnujamXmnO/HuhN1HabDqwynA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JY3PY1sn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JY3PY1sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C4B1F000FF;
	Fri,  2 Oct 2026 08:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790930902;
	bh=HEGs9kHa0TiHGf66DJlVENZUH1Lhub3FFh1B/94+6gs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JY3PY1sn9BvQSNCiE8xRA+B3lRWTLO3uf9f79hEg7wCW1Iibe2Nc/L5eAncUHu2SB
	 U27no90dJLRH4pZgDGVG2TccVQGd0Db9g+SEhGKG3cWx/8MLGmIR0s2Ptd6JD0VDuZ
	 zLThX2wWrJuJCOIf+gx6LEWapzf5B5KMHU7Nrj54=
Date: Fri, 2 Oct 2026 10:48:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 092/877] neighbour: Use rtnl_register_many().
Message-ID: <2026100206-eloquence-mortality-a0e8@gregkh>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152416.722458210@linuxfoundation.org>
 <d26d9da3-5d91-41f5-9270-863f34c772bd@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d26d9da3-5d91-41f5-9270-863f34c772bd@oracle.com>

On Fri, Oct 02, 2026 at 12:49:41AM +0530, Harshit Mogalapalli wrote:
> 
> 
> On 30/09/26 8:46 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Kuniyuki Iwashima <kuniyu@amazon.com>
> > 
> > [ Upstream commit d0d14aef50a6184426c5a05b9815fb2697d6d42c ]
> > 
> > We will remove rtnl_register() in favour of rtnl_register_many().
> > 
> > When it succeeds, rtnl_register_many() guarantees all rtnetlink types
> > in the passed array are supported, and there is no chance that a part
> > of message types is not supported.
> > 
> > Let's use rtnl_register_many() instead.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
> > Link: https://patch.msgid.link/20241014201828.91221-4-kuniyu@amazon.com
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   net/core/neighbour.c | 19 ++++++++++---------
> >   1 file changed, 10 insertions(+), 9 deletions(-)
> > 
> > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> > index bf07438d6dfa5..1dd9f85b74997 100644
> > --- a/net/core/neighbour.c
> > +++ b/net/core/neighbour.c
> > @@ -3898,17 +3898,18 @@ EXPORT_SYMBOL(neigh_sysctl_unregister);
> >   #endif	/* CONFIG_SYSCTL */
> > +static const struct rtnl_msg_handler neigh_rtnl_msg_handlers[] __initconst = {
> > +	{.msgtype = RTM_NEWNEIGH, .doit = neigh_add},
> > +	{.msgtype = RTM_DELNEIGH, .doit = neigh_delete},
> > +	{.msgtype = RTM_GETNEIGH, .doit = neigh_get, .dumpit = neigh_dump_info,
> > +	 .flags = RTNL_FLAG_DUMP_UNLOCKED},
> > +	{.msgtype = RTM_GETNEIGHTBL, .dumpit = neightbl_dump_info},
> > +	{.msgtype = RTM_SETNEIGHTBL, .doit = neightbl_set},
> > +};
> > +
> 
> I ran an AI-assisted backport review and it flagged this; I independently
> checked the upstream code and 6.12.y at f4ffa8dc360b.
> 
> Upstream __rtnl_register_many() at
> d0d14aef50a6184426c5a05b9815fb2697d6d42c, net/core/rtnetlink.c:
> 
> if (err) {
>     if (!handler->owner)
>         panic("Unable to register rtnetlink message "
>               "handlers, %pS\n", handlers);
> 
>     __rtnl_unregister_many(handlers, i);
>     break;
> }
> 
> 6.12.y's net/core/rtnetlink.c:
> 
> if (err) {
>     __rtnl_unregister_many(handlers, i);
>     break;
> }
> 
> neigh_init() ignores the helper's return value. On allocation failure,
> the helper rolls back the batch, so boot can continue with none of the
> five neighbour handlers. Previously, failures were logged and the
> other registrations continued. This boot-time failure path remains at
> the review tip; upstream makes failed built-in registration fatal.
> 
> I think 6.12 should take 09aec57d8379f14ffde566621b920d97cc0c46e1
> ("rtnetlink: Panic when __rtnl_register_many() fails for builtin
> callers.") before this conversion so the ignored failure cannot silently
> continue, thoughts?
> 
> Lets drop this until we also take a prereq ?

I've dropped the whole series now, thanks.

greg k-h
