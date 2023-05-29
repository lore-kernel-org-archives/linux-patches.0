Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341A21115
	for <patches@lists.linux.dev>; Mon, 29 May 2023 11:00:46 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-510d6b939bfso5696259a12.0
        for <patches@lists.linux.dev>; Mon, 29 May 2023 04:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685358044; x=1687950044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=83jhJNkWMwv2xEBpts8kpySt/1KhQx2X32FHoz9hyjw=;
        b=OiywrWMOeb+v9DQlE73IRz4YdmiFzkEjsLqXxqF+F9y7IKE4qFJTapiPBXidk5yslL
         AwlISE/uUvhlbnnWkWaB9w4yfQe+J9tNL/c3DmH8Xwt2Oj0VIFswUdpQgvAqDiPRBULI
         5+bREM9vA9B9Ln0sZ8mvpvMKlxqNULZ2XoSWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685358044; x=1687950044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=83jhJNkWMwv2xEBpts8kpySt/1KhQx2X32FHoz9hyjw=;
        b=HNgrO553xVAV3N/6EZBV6xR0tbAoLnJ1q0H/Bmugmi/w1DWo/rBESA6cnnrjYpseMK
         /TIwFE2C7ZRKcigh+NQBQufrheSVEmFVzAJDCVjw8Q4ZPlhIt5t9fIGEO5PJ5esSW3EM
         4krGUTWvZ9daXO+WLAVsUC7NAHACx8oYmAxn01C7KCfusiB5KWPu50FivbXiX9ShDQR4
         ObHD9ORSNhTj4z5lH69+gcTkQB0aq/NE7gQdvxdTfyEgr43e44IioS++NE2RUUIEjMru
         gTT03GI71ragiKbijF4rQtVoI2oEBEf8xFf7LBz4u5w8sAw8GFNPRROgBVVrJlmSMMIS
         7NBQ==
X-Gm-Message-State: AC+VfDztJexqie43sVuwryK5ga8/pmvAJ2TFiqiX9+Is3IqtbEQL9Yj3
	J+jGxlmjZ3R2lq7vm67mYLytXWAZ2G/f/5FjjUp7pCXO
X-Google-Smtp-Source: ACHHUZ4IwHuucEOGhWEmdFMhFvqTlZIfDfhajvw5oQ8/69jaIuyvPxL+CKtGk7HUIkWOr9QZPxL0yA==
X-Received: by 2002:a50:fb19:0:b0:514:8d88:7b70 with SMTP id d25-20020a50fb19000000b005148d887b70mr6233917edq.6.1685358044213;
        Mon, 29 May 2023 04:00:44 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id p3-20020aa7cc83000000b0050bc7c882bfsm2979577edt.65.2023.05.29.04.00.43
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 04:00:43 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-51458187be1so5509041a12.2
        for <patches@lists.linux.dev>; Mon, 29 May 2023 04:00:43 -0700 (PDT)
X-Received: by 2002:a17:907:987:b0:96a:6723:da47 with SMTP id
 bf7-20020a170907098700b0096a6723da47mr9992607ejc.43.1685358023375; Mon, 29
 May 2023 04:00:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230524213620.3509138-1-mcgrof@kernel.org> <20230524213620.3509138-3-mcgrof@kernel.org>
 <8fc5b26b-d2f6-0c8f-34a1-af085dbef155@suse.com> <CAHk-=wiPjcPL_50WRWOi-Fmi9TYO6yp_oj63a_N84FzG-rxGKQ@mail.gmail.com>
 <6gwjomw6sxxmlglxfoilelswv4hgygqelomevb4k4wrlrk3gtm@wrakbmwztgeu>
 <CAHk-=whu8Wh4JP1hrc80ZvGgVW4GV6hw1vwzSiwOo9-1=Y1dWw@mail.gmail.com>
 <ZG/a+nrt4/AAUi5z@bombadil.infradead.org> <CAHk-=whiXzqprmQNRui3LbKQwvM8fg4nyAzWcU5qZs+kxBVzrA@mail.gmail.com>
 <ZHRpH-JXAxA6DnzR@hovoldconsulting.com>
In-Reply-To: <ZHRpH-JXAxA6DnzR@hovoldconsulting.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 May 2023 07:00:05 -0400
X-Gmail-Original-Message-ID: <CAHk-=wh6sXSO63kka+EWEqq0tGwtOnXYFWMXPQ6T_wZa+Np3MQ@mail.gmail.com>
Message-ID: <CAHk-=wh6sXSO63kka+EWEqq0tGwtOnXYFWMXPQ6T_wZa+Np3MQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
To: Johan Hovold <johan@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Lucas De Marchi <lucas.demarchi@intel.com>, 
	Petr Pavlu <petr.pavlu@suse.com>, gregkh@linuxfoundation.org, rafael@kernel.org, 
	song@kernel.org, lucas.de.marchi@gmail.com, christophe.leroy@csgroup.eu, 
	peterz@infradead.org, rppt@kernel.org, dave@stgolabs.net, willy@infradead.org, 
	vbabka@suse.cz, mhocko@suse.com, dave.hansen@linux.intel.com, 
	colin.i.king@gmail.com, jim.cromie@gmail.com, catalin.marinas@arm.com, 
	jbaron@akamai.com, rick.p.edgecombe@intel.com, yujie.liu@intel.com, 
	david@redhat.com, tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev, 
	linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com, 
	lennart@poettering.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 29, 2023 at 4:58=E2=80=AFAM Johan Hovold <johan@kernel.org> wro=
te:
>
> I have not tried to figure out exactly why things break, but it does
> seem like this one should be reverted.

Yes, I have done so.

However, can I ask you to just verify that it was purely the exclusive
open part, and it wasn't that I messed up something else. IOW, can you
replace the

        return exclusive_deny_write_access(file);

in prepare_file_for_module_load() with just a "return 0", and remove the

                allow_write_access(f.file);

line in finit_module()?

That's obviously _instead_ of the revert that I already pushed out,
just to verify that "yup, it's that part, not something silly
elsewhere"

I do wonder what it is that is different in your setup, and maybe you
could also enable the

        pr_debug("finit_module: fd=3D%d, uargs=3D%p, flags=3D%i\n", fd, uar=
gs, flags);

in finit_module() while you are at it? Since you'd be editing that
file anyway for the test, just change the pr_debug() to a printk() and
then do

    dmesg | grep finit_module

to see what it all results in (on a working kernel, of course).

                    Linus
