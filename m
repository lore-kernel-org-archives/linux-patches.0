Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5971773A;
	Thu, 21 Sep 2023 19:50:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 09DBE1F37C;
	Thu, 21 Sep 2023 19:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1695325815; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F9fNT393+ZwmVQgjbtj+WOmx+WURCS26K1KA4ErkEyw=;
	b=mqcnorfwtHQ0g5Unuh4IiRrgaXgqTarwt+Enc/GQ7uXAOuTk0wPklV0ATRXsu7vc4ioTIQ
	JKrO736zI5g7fWJyxINphvPj1Gfy3XHxQYA54fhbRRAq6WoEwDzVPg22wkc9x226AYVzov
	2cf+NVbpnmo8qJp3WLg+1HlgL9tO+Io=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D8E48134B0;
	Thu, 21 Sep 2023 19:50:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id fXiKMnaeDGW5eQAAMHmgww
	(envelope-from <mhocko@suse.com>); Thu, 21 Sep 2023 19:50:14 +0000
Date: Thu, 21 Sep 2023 21:50:14 +0200
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
Message-ID: <ZQyedkYIp2L+S2jm@dhcp22.suse.cz>
References: <ZQr3+YfcBM2Er6F7@dhcp22.suse.cz>
 <CALvZod7E_Jm9y+40OKtLs5EFA0ptKGjoe2BU58SY29pUiPc93g@mail.gmail.com>
 <ZQskGGAwlsr1YxAp@dhcp22.suse.cz>
 <CALvZod6b3=+=xXEUeWOQW3t_URJpeeVX46WjBHv5BS+436KoFA@mail.gmail.com>
 <ZQtRKzUOfdaVKRCF@dhcp22.suse.cz>
 <CALvZod5DSMoEGY0CwGz=P-2=Opbr4SmMfwHhZRROBx7yCaBdDA@mail.gmail.com>
 <ZQv2MXOynlEPW/bX@dhcp22.suse.cz>
 <f01b5d93-0f43-41c8-b3d8-40ef9696dcf8@linux.microsoft.com>
 <ZQwnUpX7FlzIOWXP@dhcp22.suse.cz>
 <CALvZod7fs_K3807N1=-5bmXbA=vhAk+zcF+VHS=T5ycK1eeMfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALvZod7fs_K3807N1=-5bmXbA=vhAk+zcF+VHS=T5ycK1eeMfg@mail.gmail.com>

On Thu 21-09-23 10:25:11, Shakeel Butt wrote:
> On Thu, Sep 21, 2023 at 4:21 AM Michal Hocko <mhocko@suse.com> wrote:
[...]
> With one request below:
> 
> Acked-by: Shakeel Butt <shakeelb@google.com>

Thanks.

> > @@ -3107,6 +3108,10 @@ static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
> >                 goto out;
> >
> >         memcg_account_kmem(memcg, nr_pages);
> > +
> > +       /* There is no way to set up kmem hard limit so this operation cannot fail */
> > +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > +               WARN_ON(!page_counter_try_charge(&memcg->kmem, nr_pages, &counter));
> 
> WARN_ON_ONCE() please.

Sure. This shouldn't really trigger, but it is true that if something
unexpected happens then it is likly to flood the log so _ONCE is safer.

I will wait for others to comment before I send the official patch.
To be completely honest I am not super happy about this way of handling
stuff, but considering the level of brokenness this seems like the
safest option. Especially when nobody really want to use the kernel
memory hard limit AFAIU.
-- 
Michal Hocko
SUSE Labs
