Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92837C
	for <patches@lists.linux.dev>; Mon, 13 Jun 2022 19:02:57 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id l2-20020a05600c4f0200b0039c55c50482so5084310wmq.0
        for <patches@lists.linux.dev>; Mon, 13 Jun 2022 12:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mH2Ozc7vMDdov6awFdZkb28XDYXs+pc/Kj4sGvxaIss=;
        b=qklH4NQKDQbRIpUUWVJtxeVuhF8FRjK4L/NjNFqxXoH6l2HjERK8TB80/tnuhJvwMw
         2bEedUr6juXWRkThZagMaar/6V3Jy6sOaAGDKMD151x3Tl2tVhcBkE062fLRLYaSgAgw
         YPFxzx8aONKizMg3UxzpxrOjcffAnFB/YLnicMNHboxh0LN63aBh3yfUj6IW0+WfvoyP
         KfFAb1xeUoJTlB8BrDY6wLWeYZEhECjkcPFOY0CIzZzAy5kUG0z3T52nkJYc/Ir6zVEd
         QB83IXLuLvHyBEkziiMroRwSlIKST4uAnEowdN/weQqpODlLCqyu1SDc4uyTW64GwKg5
         Kdiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mH2Ozc7vMDdov6awFdZkb28XDYXs+pc/Kj4sGvxaIss=;
        b=4y8GFkI35fl3GnCWEddrPtNnDEueVK9RcASZSpLmvTrHIoirozrKoKiDMYbfjIm/yH
         THga+0sVE/5N+aYVPKkOGIE/y0pae4Jz5QxAvKuWIDKG+XCV9xwwVVwla1ZkuyebPRag
         dq+b6XffjBVbbciWOS11wdPunH02bYFQ0CkaOzzYJbo4he/VTLOv+hKqnIpeO9xot60J
         /vw/7hA+NhMtEAJlNtaGvF/YxAdUB1U1ixbx1h78nGpABGWS8GttHmC5mYxf22P7tJq0
         7dGH/o6w1xTHoaifakvlsocmxvVGSeE5cEIExhH4EiOIgA9Zf/HvbFTORqqWfpRRHGj6
         I88w==
X-Gm-Message-State: AOAM533uwhSedcHEZNH4dTFhdpRuamvKjKwavYkKETs2Hm3tYwMKciBn
	P3vnlrYxu0fRni7cLg5K61PPwnh9qi75FWdcCCfb
X-Google-Smtp-Source: ABdhPJwIVdlXZUG+b0oYW3vmcFS1npPovHkBAqvGSJkQxxWnGw7dzfbuSFb15EczDUQwmfXU3vwinPoA2tGzIH0j5tI=
X-Received: by 2002:a05:600c:1c94:b0:39c:55a2:af25 with SMTP id
 k20-20020a05600c1c9400b0039c55a2af25mr120868wms.155.1655146976099; Mon, 13
 Jun 2022 12:02:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220301041454.18960-1-rdunlap@infradead.org> <CAHC9VhSuzpuEm437SCYC8pf0mU6qdWXRU38sb2+JjVtj-8T4Kw@mail.gmail.com>
In-Reply-To: <CAHC9VhSuzpuEm437SCYC8pf0mU6qdWXRU38sb2+JjVtj-8T4Kw@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 13 Jun 2022 15:02:45 -0400
Message-ID: <CAHC9VhSa74OFVV=XcceO12kVOxivm5cnyvBo-yeMbyPT8+t5Kg@mail.gmail.com>
Subject: Re: [PATCH] docs: selinux: add '=' signs to kernel boot options
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, patches@lists.linux.dev, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Eric Paris <eparis@parisplace.org>, 
	selinux@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 1, 2022 at 12:34 PM Paul Moore <paul@paul-moore.com> wrote:
> On Mon, Feb 28, 2022 at 11:14 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> >
> > Provide the full kernel boot option string (with ending '=' sign).
> > They won't work without that and that is how other boot options are
> > listed.
> >
> > If used without an '=' sign (as listed here), they cause an "Unknown
> > parameters" message and are added to init's argument strings,
> > polluting them.
> >
> >   Unknown kernel command line parameters "enforcing checkreqprot
> >     BOOT_IMAGE=/boot/bzImage-517rc6", will be passed to user space.
> >
> >  Run /sbin/init as init process
> >    with arguments:
> >      /sbin/init
> >      enforcing
> >      checkreqprot
> >    with environment:
> >      HOME=/
> >      TERM=linux
> >      BOOT_IMAGE=/boot/bzImage-517rc6
> >
> > Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Paul Moore <paul@paul-moore.com>
> > Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
> > Cc: Eric Paris <eparis@parisplace.org>
> > Cc: selinux@vger.kernel.org
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > ---
> >  Documentation/admin-guide/kernel-parameters.txt |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Thanks Randy.
>
> Acked-by: Paul Moore <paul@paul-moore.com>

I assumed the doc folks would have picked this up but I don't see it
in the tree so I'm going to pull it into the selinux/next tree right
now.  Thanks again Randy, I'm sorry for the delay.

-- 
paul-moore.com
