Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7732584
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DCBB61F396
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CF0F213A8D
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id dK2kMWVnE2LWIAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <37ee1cce-b983-7fdb-2e16-791d57506c6a@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id sMp6LYWPDWIkcwAAMHmgww
	(envelope-from <shakeelb@google.com>)
	for <vbabka>; Wed, 16 Feb 2022 23:57:57 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id 2FNwLIWPDWIQOAAApTUePA
	(envelope-from <shakeelb@google.com>)
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 23:57:57 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id B100DA3B84
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 23:57:57 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at relay2.suse.de
X-Spam-Flag: NO
X-Spam-Score: -6.912
X-Spam-Level:
X-Spam-Status: No, score=-6.912 tagged_above=-9999 required=5
	tests=[BAYES_50=0.8, DKIMWL_WL_MED=-0.001, DKIM_SIGNED=0.1,
	DKIM_VALID=-0.1, DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1,
	RCVD_IN_DNSWL_NONE=-0.0001, RCVD_IN_MSPIKE_H2=-0.001,
	T_SCC_BODY_TEXT_LINE=-0.01, USER_IN_DEF_DKIM_WL=-7.5]
	autolearn=no autolearn_force=no
Received: from relay2.suse.de ([127.0.0.1])
	by relay2.suse.de (relay2.suse.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ifjBtKBDJb6z for <vbabka@imap.suse.de>;
	Wed, 16 Feb 2022 23:57:52 +0000 (UTC)
Received: from mx1.suse.de (unknown [149.44.161.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 6B1DDA3B83
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 23:57:52 +0000 (UTC)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTPS id 3A7CCAD35
	for <vbabka@suse.cz>; Wed, 16 Feb 2022 23:57:52 +0000 (UTC)
Received: by mail-lj1-f181.google.com with SMTP id bn33so5784125ljb.6
        for <vbabka@suse.cz>; Wed, 16 Feb 2022 15:57:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uWK5whONmmnAoDJkRJYYxU0Rm8PPAQNrqFAdJzOzSlk=;
        b=teZU8RI5u/MRYYqxMnO85Y3iDYFaWV2EA5S5SZ8rZPrXAgDeBl/AEuX5+YSX3wAoLg
         LCmk37yNh2J6p8WKHQbcO0j1+jtGnL9eSIf91xUPamzZiREJAZXtt25tY7kD0gRUWNUO
         Pxa5osNKHAAvQ8PeNxsUK0o8NIImmJKv6dG4C5lFdkcnlBJllTB74vw1kk7PguT6CVHa
         mDop93SZOhiZEAZhAX3bRQmDstEKOI2/o1HaC+n8C8KPVMOKwnpoHXGkVaQaV5oXZ/XN
         XU2TZRdcCctQdyYwRIbWnGQ2dFLWZRJH9gOdRnL/r8C7tSPEdmojJNR5iMgIRkDyiZje
         Ql5Q==
X-Gm-Message-State: AOAM532O/0YyoLkBP6sSU2y0yCQyCl0tqhhXVJHa7fyxHGKedXoND5EY
	JLEwVuBM7CgdFJo+ifyrU1ZY0s8ME7qJ3sJIABRK7A==
X-Google-Smtp-Source: ABdhPJwyAf/VMAEPlG6E2SmCP++2oqmX45Yel7NDqSR4h60J4n8MWwUGK3ROfnDeo3uiZrE/h2nRNqAPC74lvgKZstg=
X-Received: by 2002:a2e:bd83:0:b0:246:14d6:ccea with SMTP id
 o3-20020a2ebd83000000b0024614d6cceamr342059ljq.35.1645055871232; Wed, 16 Feb
 2022 15:57:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <327b9e92-88bb-d66f-e07c-526161db539b@virtuozzo.com>
 <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com> <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
 <Yg1kFH3umdrvOhu1@carbon.dhcp.thefacebook.com> <Yg1ooYmX54j8l+Fz@casper.infradead.org>
 <Yg1wKkIJxIdN43qU@carbon.dhcp.thefacebook.com> <Yg1y0ax5bnjGLAqz@casper.infradead.org>
 <Yg16ClVQj8SLSlqV@carbon.DHCP.thefacebook.com> <Yg2EwqE07d97gmms@casper.infradead.org>
In-Reply-To: <Yg2EwqE07d97gmms@casper.infradead.org>
From: Shakeel Butt <shakeelb@google.com>
Date: Wed, 16 Feb 2022 15:57:39 -0800
Message-ID: <CALvZod5nqqt_9Xn0Yq4wiue_QePY5wz6BX6Vk2dH3P9qc92yPw@mail.gmail.com>
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
To: Matthew Wilcox <willy@infradead.org>
Cc: Roman Gushchin <guro@fb.com>, Vasily Averin <vvs@virtuozzo.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 16, 2022 at 3:12 PM Matthew Wilcox <willy@infradead.org> wrote:
>
[...]
> > Here I'd keep _page (or _folio, if you want), because
> > it makes it clear that the function goes over all pages
> > (and is expensive therefore).
>
> But there's no intrinsic reason that it should.  If that's a
> performance problem, you could keep slabs on a separate list
> from, eg, file or anon memory.
>

Is there enough space in the struct slab for that list or do you mean
something different?
