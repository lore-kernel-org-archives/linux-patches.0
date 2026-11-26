Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795678858;
	b=36TrxODTF24E4r0ZnW/0sHniPSWFv1HuPOapl8LJigW9GE6d5dtzibeTmjRtNzonJEGZ
	 3aBnbmkWrYCmD/gvvxVvQTx0/Lv/ImBYzM8hTsB3u2bGtroLbj8vVXr3wFHpdu1v9GNj1
	 F4iUtT4c0lCsmeHPFjP8iCCyJoHNCV8EqjwJsAxofM1cW6m8MAC4vZoZ4E+IGk3CrQyQT
	 lEOW7jIVOXWG2H0i2iNK9au+A/ot6dLkkuVM7zCM6PRUBQ0HnGEDWvIMUMhJrYJ5b44sw
	 UmeJteSFiiaxkK46bN6ooZJix1edoO8X3Ygg/VkrugUwkE1r9AyTBiwLwkFfcTH9whw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795678858;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=juJqpQkwJyoO/Hv1+4ZAcxpgZmO1t2pSKM+EEldO6zU=;
	b=AdyE5fcM3UHK1VTtS1JihGwxTcpnG22hnxV2SvezK9HIb+QmI3dLrVLBCg7YdIN9XTGE
	 CUA/4JLh/NBjVhPhvF4Q6Jb/uapKcl4Yg3FMniOYbjMrtnp0rvCguiKUfLveB5e0FmWxQ
	 KvGyPJRW6P7DURJcPIy0wgrS0+J9nqSrbNcttDgTNV+f5PaaCTDG62Epr2rP874h7KjBg
	 SQcLtvHj/tw96PfqBzu3NpDfliwT7vBMtsCLgYKtEfvHouYc4hWUqSURBqkqk2OSqqyRt
	 9fdY8+r5CaC9GfvBP/73WrLO+zPxw370eyfacZa3/vWau6XdWJ93+8EfT/3enH3gjdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PPpBreAO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18E2606A68C;
	Thu, 26 Nov 2026 07:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PPpBreAO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710081F000C0;
	Thu, 26 Nov 2026 07:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795678858;
	bh=juJqpQkwJyoO/Hv1+4ZAcxpgZmO1t2pSKM+EEldO6zU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PPpBreAOknJ9HVtVdapWaRbmlwZW0l5Z2RfgGAxOg2yVLveO6Cz6EZY2m1W2Y1R51
	 L580LQDXz0bRYj9g0Cs+cN5cW/UOdXEM/+sVk+WB4sQPYzOiB6S81fWSU79eeRob8c
	 JfCdNW6nyR5nJxvDBvAf9cSRqeK9BEo9DP7FiikE=
Date: Thu, 26 Nov 2026 08:40:55 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Rahad Bhuiya <rahadbhuiya2021@gmail.com>,
	Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.3 0361/1005] sched_ext: Reset task fields on exit of an
 SCX_TASK_READY task
Message-ID: <2026112630-cadillac-unsliced-1ef8@gregkh>
References: <20261125143821.729802100@linuxfoundation.org>
 <20261125143830.189554233@linuxfoundation.org>
 <0782adf7-20af-45a3-a09b-2a34c76afbac@kernel.org>
 <2026112640-recite-tipping-891f@gregkh>
 <dc5dc970-d7d5-46e4-8b2e-327c7e31a90b@kernel.org>
 <2026112625-skittle-retouch-c4bd@gregkh>
 <60eaa0ee-adbd-4bdb-bc7f-63f4631e022f@w6rz.net>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <60eaa0ee-adbd-4bdb-bc7f-63f4631e022f@w6rz.net>

On Wed, Nov 25, 2026 at 11:16:13PM -0800, Ron Economos wrote:
> On 11/25/26 23:00, Greg Kroah-Hartman wrote:
> > On Thu, Nov 26, 2026 at 07:53:04AM +0100, Jiri Slaby wrote:
> > > On 26. 11. 26, 7:36, Greg Kroah-Hartman wrote:
> > > > On Thu, Nov 26, 2026 at 07:19:47AM +0100, Jiri Slaby wrote:
> > > > > On 25. 11. 26, 15:28, Greg Kroah-Hartman wrote:
> > > > > > 7.3-stable review patch.  If anyone has any objections, please let me know.
> > > > > > 
> > > > > > ------------------
> > > > > > 
> > > > > > From: Rahad Bhuiya <rahadbhuiya2021@gmail.com>
> > > > > > 
> > > > > > [ Upstream commit 564405c424f49d70b13debe7fe5b550234ad6b84 ]
> > > > > ...
> > > > > > --- a/kernel/sched/ext/ext.c
> > > > > > +++ b/kernel/sched/ext/ext.c
> > > > > > @@ -4198,6 +4198,7 @@ void __scx_disable_and_exit_task(struct scx_sched *sch, struct task_struct *p)
> > > > > >     		args.cancelled = true;
> > > > > >     		break;
> > > > > >     	case SCX_TASK_READY:
> > > > > > +		scx_reset_task_fields(task_rq(p), p);
> > > > > This fails to build:
> > > > > ../kernel/sched/ext/ext.c:4223:17: error: implicit declaration of function
> > > > > ‘scx_reset_task_fields’; did you mean ‘scx_set_task_sched’?
> > > > Ugh, I wonder why this code never hits my build tests...
> > > We seem to have:
> > > CONFIG_SCHED_CLASS_EXT=y
> > > maybe you don't?
> > I don't, and 'make allmodconfig' doesn't select it due to the
> > CONFIG_DEBUG_INFO_BTF dependancy which does not get set either for some
> > other reason perhaps.  That explains it, and we've tripped over this
> > before...
> > 
> > thanks,
> > 
> > greg k-h
> 
> CONFIG_DEBUG_INFO_BTF requires that pahole is installed on your system.

It is:

bob ~ $ pahole --version
v1.32

