Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53C8173
	for <patches@lists.linux.dev>; Fri,  7 Jan 2022 19:20:21 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso5609620pjo.5
        for <patches@lists.linux.dev>; Fri, 07 Jan 2022 11:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0KUHdYWZrNQNGd+wqJYrVbHFyI10Jcy+xpDfU5P3J28=;
        b=VniaEUOJjfHFUTU+bdguSmbz3nDd7hjAGjCTcSZwPzluLWmAaLu/IEMmu16Hjkv6mX
         5kgSvqc8NZdVqCQaI4eYeT4HTQzfckR9gHjXko3ouU4O/KOqkJSKQNR/8KpMDEJZ8y9A
         0G8Fuxu5OZQCYkVMWTADPiX528ASEDm0nSeR6vWg/wI4SFsYwVFSRgb8dPKbiXQXokPY
         xVCoqY61Q0uo2s9KWkxWznmHemXlIojSHUULCCDSclaNX9rBTwIn5eKIvmmC/35T3sLx
         uZTohww8udIskzgZZdtor7Iriq01DGywF01j+2cga7sFEBocYwYMulZIbnR/Zlla5qA0
         AMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0KUHdYWZrNQNGd+wqJYrVbHFyI10Jcy+xpDfU5P3J28=;
        b=3YXUtgrFuFsT+7n0BwvJcA3TRsr4Q/e+QIQbMRMLzpRyVvlRYkGffzppEebyeKuG8V
         /+WbFKLDBIjGzlIgJbq6noFUoLQR9lqaJB4ufHsL0ht/WiYP2UmBqSYS/MtBe58BkC+W
         7aBkXqKZdliX8UHJ6JBEdkfabWDlMjdjsyhaZkKHYtof4bf2zZXYEDtfvLT4E5ucpYm0
         2evTVyKYnreFwJ5VQZDPYdBXD85Jow/af0r96v7EkAYIqyxgvgzq/JxGxLQ1vNuBbCi+
         6ZxfX27KI4yvMyr4xi+5MV+HsS8II6JC3QHB/M7TZpRm096Oy6B7Sgl5xYtIEU5NOHAM
         hm9w==
X-Gm-Message-State: AOAM532r5mzzIWnIXZn18195J90LBAhNA5J4GICH+H4PL9mMyBHlnzk3
	K3CyeCEa6Gfg5rSO0iSu2Z8+FLyf9tVzg+RETItTJw==
X-Google-Smtp-Source: ABdhPJyJf8RMwf7gYVJ0h6mf+V2vkE5ytFqOUl5SZvDR+zFeHtA7ne8qbFO9vjyorkThp60xVYTI+LFqhXMZEYfLiSo=
X-Received: by 2002:a17:90a:7101:: with SMTP id h1mr17108928pjk.93.1641583221168;
 Fri, 07 Jan 2022 11:20:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220107003756.806582-1-ben.widawsky@intel.com>
 <20220107003756.806582-13-ben.widawsky@intel.com> <20220107181454.00004a1b@huawei.com>
In-Reply-To: <20220107181454.00004a1b@huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 7 Jan 2022 11:20:10 -0800
Message-ID: <CAPcyv4hmt0mJ9Bek7R0dOeX1aQm_yKkv6JhXcTzG36Zs7xVRYg@mail.gmail.com>
Subject: Re: [PATCH 12/13] cxl/region: Record host bridge target list
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-cxl@vger.kernel.org, 
	linux-nvdimm <linux-nvdimm@lists.01.org>, Linux PCI <linux-pci@vger.kernel.org>, 
	patches@lists.linux.dev, Bjorn Helgaas <helgaas@kernel.org>, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 7, 2022 at 10:15 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Thu,  6 Jan 2022 16:37:55 -0800
> Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> > Part of host bridge verification in the CXL Type 3 Memory Device
> > Software Guide calculates the host bridge interleave target list (6th
> > step in the flow chart). With host bridge verification already done, it
> > is trivial to store away the configuration information.
> >
> > TODO: Needs support for switches (7th step in the flow chart).
> >
> > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > ---
> >  drivers/cxl/region.c | 41 +++++++++++++++++++++++++++++++----------
> >  1 file changed, 31 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/cxl/region.c b/drivers/cxl/region.c
> > index eafd95419895..3120b65b0bc5 100644
> > --- a/drivers/cxl/region.c
> > +++ b/drivers/cxl/region.c
> > @@ -385,6 +385,7 @@ static bool region_hb_rp_config_valid(struct cxl_region *region,
> >       }
> >
> >       for (i = 0; i < hb_count; i++) {
> > +             struct cxl_decoder *cxld;
> >               int idx, position_mask;
> >               struct cxl_dport *rp;
> >               struct cxl_port *hb;
> > @@ -422,10 +423,8 @@ static bool region_hb_rp_config_valid(struct cxl_region *region,
> >                               if (get_rp(ep) != rp)
> >                                       continue;
> >
> > -                             if (port_grouping == -1) {
> > +                             if (port_grouping == -1)
> >                                       port_grouping = idx & position_mask;
> > -                                     continue;
> > -                             }
> >
> >                               /*
> >                                * Do all devices in the region connected to this CXL
> > @@ -436,10 +435,32 @@ static bool region_hb_rp_config_valid(struct cxl_region *region,
> >                                                         "One or more devices are not connected to the correct Host Bridge Root Port\n");
> >                                       return false;
> >                               }
> > +
> > +                             if (!state_update)
> > +                                     continue;
> > +
> > +                             if (dev_WARN_ONCE(&cxld->dev,
> > +                                               port_grouping >= cxld->nr_targets,
> > +                                               "Invalid port grouping %d/%d\n",
> > +                                               port_grouping, cxld->nr_targets))
> > +                                     return false;
> > +
> > +                             cxld->interleave_ways++;
> > +                             cxld->target[port_grouping] = get_rp(ep);
>
> Hi Ben,
>
> Just one more based on debug rather than review.
>
> The reason is across 2 patches so not necessary obvious from what is visible here,
> but port_grouping here for a 2hb, 2rp on each and 1 ep on each of those
> case goes 0,1,2,3 resulting in us setting one of the host bridges to have
> a decoder with targets 2 and 3 rather than 0 and 1 set.
>
> I haven't figured out a particularly good solution yet...  If everything is nice and symmetric
> and power of 2 then you can simply change the mask on the index to reflect num_root_ports / num_host_bridges
>
> With that change in place my decoders all look good on this particular configuration :)
> Note this is eyeball based testing only and on just one configuration so far.
>
> I'll have to try your tool as it is really annoying that the mem devices change order on every
> boot as my script is dumb currently so have to edit it every run.

I have support pending for cxl-cli that lets memdevs be filtered by
serial number so you don't need to worry about dynamic kernel device
names.

Should be posted later today.
