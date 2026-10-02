Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EE7494A19;
	Fri,  2 Oct 2026 12:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790943115; cv=none; b=XJ6zYomA+lN+0/19jJbcUNF84q7y6VuOuLoizeIb1J26VNIH/mMkqapqJRFPHRVP/pmcCL5A1sbfiGpnk6uzl6GqoqjFtN415odeORmO2xcWTWe9mzkX/hpOfXvEKG7MLnP+1rJOC9zIxxUwg9QxwEHLtjcjPUa98pmQOj0DCEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790943115; c=relaxed/simple;
	bh=CRZuu/N1CGv6fRWWGAk+IQ0kglI6UYJsQ+/pVpzqXSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sonAS07OVOmgj57eqW0CXb0YHn3j9kAn3ufvSXn1/XcIjVrRrNqSEIAkiVoyk+LUBFAi0OMoWMaXEjNZ7Ex7ILViWyVWcZJz4jsjv06MNHoc1vplolMbmbC0z83myYiPrHTbTh4JJ2oybzuWWCJOHd8GAs0ffAX2l6P27Z3Zwpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkGcV/p9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkGcV/p9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413A21F000FF;
	Fri,  2 Oct 2026 12:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790943112;
	bh=+h5D5f75qJW6zRYgVsucDQXn7U9QJbVD2wJzN81tQc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MkGcV/p9AMLgRqMjBIgJfIDULBL1BZFAD6z/DnH/BhKNf49FGLpVlsN0oPFO/+ZdP
	 VsuUMr9soLaas0B6TI7hguCrm94vecYEYHx1VsykkhwFUqPxpSXcqZ+eMYis+4piOQ
	 aDCc9aH4PtNR4iRa5bhwaPqhJjiKHucpS583vz6M=
Date: Fri, 2 Oct 2026 14:11:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 773/877] mptcp: prevent race between disconnect()
 and rtx
Message-ID: <2026100239-dork-pulmonary-c558@gregkh>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152431.395456304@linuxfoundation.org>
 <d32b4104-efef-4735-b9e5-2b07b57a2f40@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d32b4104-efef-4735-b9e5-2b07b57a2f40@oracle.com>

On Fri, Oct 02, 2026 at 02:00:40AM +0530, Harshit Mogalapalli wrote:
> 
> 
> On 30/09/26 8:58 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Paolo Abeni <pabeni@redhat.com>
> > 
> > [ Upstream commit 85c580b0d8590520ae00a15c29e9fb9c99427a3e ]
> > 
> > Sashiko noted that the two event can race, leading to inconsistent
> > status. Prevent the race using the synchronous timer stop operation.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> > Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> > Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-6-df1de70348b6@kernel.org
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   net/mptcp/protocol.c |   10 ++++++++--
> >   1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > --- a/net/mptcp/protocol.c
> > +++ b/net/mptcp/protocol.c
> > @@ -3367,6 +3367,7 @@ static void mptcp_copy_inaddrs(struct so
> >   static int mptcp_disconnect(struct sock *sk, int flags)
> >   {
> > +	struct inet_connection_sock *icsk = inet_csk(sk);
> >   	struct mptcp_sock *msk = mptcp_sk(sk);
> >   	/* We are on the fastopen error path. We can't call straight into the
> > @@ -3379,8 +3380,13 @@ static int mptcp_disconnect(struct sock
> >   	mptcp_check_listen_stop(sk);
> >   	mptcp_set_state(sk, TCP_CLOSE);
> > -	mptcp_stop_rtx_timer(sk);
> > -	mptcp_stop_tout_timer(sk);
> > +	/* The later subflow close can not kick again the tout timer,
> > +	 * as the msk is already in closed status.
> > +	 */
> > +	msk->timer_ival = icsk->icsk_rto_min;
> ^^^
> 
> Hi Greg/Sasha,
> 
> An AI-assisted review flagged the reset expression, and I checked the
> MPTCP parent-socket initialization on 6.12.
> 
> Upstream, net/mptcp/protocol.c, __mptcp_init_sock():
> 
>     icsk->icsk_rto_min =
>         usecs_to_jiffies(READ_ONCE(net->ipv4.sysctl_tcp_rto_min_us));
> 
> Then mptcp_disconnect() uses:
> 
>     msk->timer_ival = icsk->icsk_rto_min;
> 
> 6.12's initializer instead has:
> 
>     msk->timer_ival = TCP_RTO_MIN;
> 
> 6.12 never initializes the parent's icsk_rto_min or calls
> tcp_init_sock(), so disconnect reads zero; the subflow's initialized
> field does not help. Upstream's broader RTO feature,
> ea4eb2adb0d3414abeddaba72dbf8876fa66528f ("mptcp: honour configured
> min/max RTO in retransmit paths"), supplies the missing initialization.
> 
> Could we use msk->timer_ival = TCP_RTO_MIN on 6.12, matching its
> initializer while retaining the synchronous stops?
> 
> 
> should we drop this for now ?

Now dropped, thanks.

greg k-h
