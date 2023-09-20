Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7014120C;
	Wed, 20 Sep 2023 20:08:14 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E8F8E202D0;
	Wed, 20 Sep 2023 20:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1695240492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zacjS2oDob3p7eHr2oY8UG1OkZiVCpmrl6tk1i02zBw=;
	b=D7iEZ49EnDc3Ssg0WXscpTKL66CU7apcB4NXqQ+nGJae9wBgMTDFMU3IykgutBmSGmR8B6
	HAp9/8RiSDyuLK9loyOPpFQ57NUrP/COR3vQSm0M0cmBwhkQWvBoO5i/x4Ab/h1Orf7aw9
	g7zegnpkCusd4lHjtKshjQ5a6+jY2p0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C6250132C7;
	Wed, 20 Sep 2023 20:08:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id gtZWLSxRC2XKUQAAMHmgww
	(envelope-from <mhocko@suse.com>); Wed, 20 Sep 2023 20:08:12 +0000
Date: Wed, 20 Sep 2023 22:08:11 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeelb@google.com>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	mathieu.tortuyaux@gmail.com
Subject: Re: [REGRESSION] Re: [PATCH 6.1 033/219] memcg: drop
 kmem.limit_in_bytes
Message-ID: <ZQtRKzUOfdaVKRCF@dhcp22.suse.cz>
References: <20230917191042.204185566@linuxfoundation.org>
 <20230920081101.GA12096@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ZQqwzK/fDm+GLiKM@dhcp22.suse.cz>
 <101987a1-b1ab-429d-af03-b6bdf6216474@linux.microsoft.com>
 <ZQrSXh+riB7NnZuE@dhcp22.suse.cz>
 <4eb47d6a-b127-4aad-af30-896c3b9505b4@linux.microsoft.com>
 <ZQr3+YfcBM2Er6F7@dhcp22.suse.cz>
 <CALvZod7E_Jm9y+40OKtLs5EFA0ptKGjoe2BU58SY29pUiPc93g@mail.gmail.com>
 <ZQskGGAwlsr1YxAp@dhcp22.suse.cz>
 <CALvZod6b3=+=xXEUeWOQW3t_URJpeeVX46WjBHv5BS+436KoFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALvZod6b3=+=xXEUeWOQW3t_URJpeeVX46WjBHv5BS+436KoFA@mail.gmail.com>

On Wed 20-09-23 12:46:23, Shakeel Butt wrote:
> On Wed, Sep 20, 2023 at 9:55 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Wed 20-09-23 08:32:42, Shakeel Butt wrote:
> > > Also I don't think reverting 58056f77502f would give any benefit.
> >
> > Not reverting 58056f77502f would re-introduce the regression in some
> > non-patched versions of Docker runtimes which cannot handle ENOTSUPP.
> > So I think we need to revert both or none of them. I would prefer the
> > later (option 1) as the fix is trivial but I do understand headache
> > of chasing all those outdated deployments or vendor code forks.
> 
> I think that would be too much conservative an approach but I don't

Well, TBH I do not really see any sifference between one set of broken
userspace or the other. Both are making assumptions on our interfaces
and they do not overlap unfortunately.

> have a strong opinion against it. Also just to be clear we are not
> talking about full revert of 58056f77502f but just the returning of
> EOPNOTSUPP, right?

If we allow the limit to be set without returning a failure then we
still have options 2 and 3 on how to deal with that. One of them is to
enforce the limit.

-- 
Michal Hocko
SUSE Labs
