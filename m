Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E28133D6EE;
	Tue, 24 Mar 2026 07:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774338266; cv=none; b=PQIiWV2J50ndhBu+BTQw5fB8kWw+ocQXND1mrhjHcSmye7q3HO6NrFtpABliN+XhJmt8DxSzMYZ1ESAANrlZwb9mFqjwb1z5NI74scv/+6b0OAc6OXZlsh3g2QZXy+aVEiR+MAv5gSHjGyHF0FUIxNgtx3XfzPcpz68xoDUCDAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774338266; c=relaxed/simple;
	bh=/TQqw6nRnkksLRRDEo5M/JPqteyg0CJ1nEhikmhwsdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EISnAbkaEfJtVUeeAUDltG1VzPqQjeg9zzwbmyWc5Ue85V2dqDvZBE3cTNjnY9GVWF+0pAc9r8XAKSjSB5b6l4ftYaBGt9AeJzNJ5XmknlkrvrpFbu49hjVcxXh2IQuSAb0SEH/skGGJuYRxdQaaviZLOrPscy1ZMa/5teQ/EhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3HnpTDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3HnpTDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6544C19424;
	Tue, 24 Mar 2026 07:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774338266;
	bh=/TQqw6nRnkksLRRDEo5M/JPqteyg0CJ1nEhikmhwsdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h3HnpTDlH4YXnva1ZGuBUtyILZjgKsMJ2pP/ruugBjB4Z0SL9Q6dQExjPVR2TB6zv
	 B1RgFECneoBR+yW+Mly2E/gv3mS0FTN473nMYkiUtjNQTEvOrxBHxopwQ6CaB2WP5b
	 BsbpEXCK/cu3pzLvdJaw6Dn7znAFW7ou6gGfAIJ8=
Date: Tue, 24 Mar 2026 08:44:03 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 6.1 095/481] selftests: mptcp: join: check removing
 signal+subflow endp
Message-ID: <2026032449-drier-crisped-ed94@gregkh>
References: <20260323134525.256603107@linuxfoundation.org>
 <20260323134527.595315873@linuxfoundation.org>
 <4628c5e1-5c27-4715-ac52-c4157a45eaa8@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4628c5e1-5c27-4715-ac52-c4157a45eaa8@kernel.org>

On Mon, Mar 23, 2026 at 07:30:52PM +0100, Matthieu Baerts wrote:
> Hi Greg,
> 
> On 23/03/2026 14:41, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> I do!
> 
> > ------------------
> > 
> > From: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> > 
> > commit 1777f349ff41b62dfe27454b69c27b0bc99ffca5 upstream.
> > 
> > This validates the previous commit: endpoints with both the signal and
> > subflow flags should always be marked as used even if it was not
> > possible to create new subflows due to the MPTCP PM limits.
> > 
> > For this test, an extra endpoint is created with both the signal and the
> > subflow flags, and limits are set not to create extra subflows. In this
> > case, an ADD_ADDR is sent, but no subflows are created. Still, the local
> > endpoint is marked as used, and no warning is fired when removing the
> > endpoint, after having sent a RM_ADDR.
> > 
> > The 'Fixes' tag here below is the same as the one from the previous
> > commit: this patch here is not fixing anything wrong in the selftests,
> > but it validates the previous fix for an issue introduced by this commit
> > ID.
> > 
> > Fixes: 85df533a787b ("mptcp: pm: do not ignore 'subflow' if 'signal' flag is also set")
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Mat Martineau <martineau@kernel.org>
> > Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> > Link: https://patch.msgid.link/20260303-net-mptcp-misc-fixes-7-0-rc2-v1-5-4b5462b6f016@kernel.org
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  tools/testing/selftests/net/mptcp/mptcp_join.sh |   13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > --- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
> > +++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
> > @@ -2389,6 +2389,19 @@ remove_tests()
> >  		chk_rst_nr 0 0
> >  	fi
> >  
> > +	# signal+subflow with limits, remove
> > +	if reset "remove signal+subflow with limits"; then
> > +		pm_nl_set_limits $ns1 0 0
> > +		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,subflow
> > +		pm_nl_set_limits $ns2 0 0
> > +		addr_nr_ns1=-1 speed=slow \
> > +			run_tests $ns1 $ns2 10.0.1.1
> 
> In this kernel version, these two lines should be replaced by:
> 
>   run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
> 
> If that's easier, you can drop this patch and I can resend it with the fix.

I'll drop and wait for a new version from you, thanks!

greg k-h
