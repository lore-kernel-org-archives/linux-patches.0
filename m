Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8BE5EC5
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 21:49:34 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id e6so13977480pgn.2
        for <patches@lists.linux.dev>; Tue, 01 Mar 2022 13:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S5jf5dNyVT0xkskad+gbE9MVCMGnIHINsSVg9gHFpnk=;
        b=XEUOEZbvPo17abhmoL+h4XaljTLdYxQqKbJELOvOrKWvDiJ4PoZdBYC2ic0X2tW0qZ
         EAdDjG9lRIFmbQXxUv9h9wtzwclyTfqXKN3vcxvcX1Q7bRa1dsBQciStEswi8PMgQWpE
         jdzkH6klBB+TrsgmKE6g/Wa6h3EwRJhXq0g6J/EVXUyZTYyAeZt3NUcww6eLs1J7/Rzd
         8blkGHsD5pqjL2VwIPt0fNFJQt4hXuor5+f9PRlnzZjTqVAUEUgfbnB1MrVi51r3ob8n
         a8mC+PTXH5uGA8KCE7RiaoMyPP4DSQzMueGocSPGBmOVeweijrppMoqYpfeKos6Fu45f
         RH/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S5jf5dNyVT0xkskad+gbE9MVCMGnIHINsSVg9gHFpnk=;
        b=p3hPw4SKVAvrudynTUWTxipSdY5gfbP7d59oahbKf1HC7OlrHVTSRjxThUPdjZDTt6
         7y0gaMpxSO/DldGPlsD5YpsJ2ZnCDi9cfNZwS6g1Hi/4KL6RKTi0d4OiF2hsLp5Wr8Zc
         fwPWm+ld01z3SZgzuKEEOq8gM3enNm7TfcGZgsu6ebQfjPgETuBMuVmyaM707pgjaYgB
         HjBdMoRr32hnamrtDucJi8y68Fg7WD8QpcRtk0bgfR/RHUrM1p48pnmzIIPndp6KZME1
         KIHC5nwJkbtng7NtZKjmprdIXwZLDU5MGbKF+0OV4XTP9GItb6jdPn3iQP6IyxsfhFQI
         UN6g==
X-Gm-Message-State: AOAM532EjAd95zzZYHVuKH/gd3Pvcxv+etp4Ji8b+WkUJVeYD5EMAVQc
	jGcq8+CXlsK/lpaRr6dc9+IC9Z9AllzQcLIC42Mjqw==
X-Google-Smtp-Source: ABdhPJzqrFEGpfhENnlyjtKRFFzMAZW5Gkiy42U6DAY7mxGGtGz9o0KmMRZjipQw7wME268Otu6V/n8jW1kOekp2vN0=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr23785651pgb.74.1646171373714; Tue, 01
 Mar 2022 13:49:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220225060038.1511562-1-ben.widawsky@intel.com>
 <20220225060038.1511562-2-ben.widawsky@intel.com> <CAPcyv4iqNEtbvL35tPFD_jDLB8t-1zetGfsRMXT_oNU8si6fAg@mail.gmail.com>
 <20220301212251.leoflc2ia5ddhwyn@intel.com>
In-Reply-To: <20220301212251.leoflc2ia5ddhwyn@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Mar 2022 13:49:22 -0800
Message-ID: <CAPcyv4jDZ0XokktW5MJnb2QQnFbMO7Jcmo1kgQKkcmYJoeitNg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] cxl/region: Add region creation ABI
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 1, 2022 at 1:23 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
[..]
> > > +       INIT_WORK(&cxlr->unregister_work, unregister_region);
> >
> > Perhaps name it "detach_work" to match the same for memdevs, or second
> > choice, go rename the memdev one to "unregister_work". Keep the naming
> > consistent for data structures that fill the same role.
> >
>
> Okay. Do you want me to rename schedule_cxl_region_unregister() also? I assume
> yes.

Of course.

>
> > > +
> > > +       return cxlr;
> > > +}
> > > +
> > > +/**
> > > + * devm_cxl_add_region - Adds a region to a decoder
> > > + * @cxld: Parent decoder.
> > > + * @cxlr: Region to be added to the decoder.
> > > + *
> > > + * This is the second step of region initialization. Regions exist within an
> > > + * address space which is mapped by a @cxld. That @cxld must be a root decoder,
> > > + * and it enforces constraints upon the region as it is configured.
> > > + *
> > > + * Return: 0 if the region was added to the @cxld, else returns negative error
> > > + * code. The region will be named "regionX.Y.Z" where X is the port, Y is the
> > > + * decoder id, and Z is the region number.
> > > + */
> > > +static struct cxl_region *devm_cxl_add_region(struct cxl_decoder *cxld)
> > > +{
> > > +       struct cxl_port *port = to_cxl_port(cxld->dev.parent);
> > > +       struct cxl_region *cxlr;
> > > +       struct device *dev;
> > > +       int rc;
> > > +
> > > +       cxlr = cxl_region_alloc(cxld);
> > > +       if (IS_ERR(cxlr))
> > > +               return cxlr;
> > > +
> > > +       dev = &cxlr->dev;
> > > +
> > > +       cxlr->id = cxld->next_region_id;
> > > +       rc = dev_set_name(dev, "region%d.%d:%d", port->id, cxld->id, cxlr->id);
> > > +       if (rc)
> > > +               goto err_out;
> > > +
> > > +       /* affirm that release will have access to the decoder's region ida  */
> >
> > s/affirm that release will/arrange for cxl_region_release to/
> >
> > > +       get_device(&cxld->dev);
> > > +
> > > +       rc = device_add(dev);
> > > +       if (rc)
> > > +               goto err_put;
> > > +
> > > +       rc = devm_add_action_or_reset(port->uport, schedule_unregister, cxlr);
> > > +       if (rc)
> > > +               goto err_put;
> > > +
> > > +       return cxlr;
> > > +
> > > +err_put:
> > > +       put_device(&cxld->dev);
> > > +
> > > +err_out:
> > > +       put_device(dev);
> > > +       return ERR_PTR(rc);
> > > +}
> > > +
> > > +static ssize_t create_region_show(struct device *dev,
> > > +                                 struct device_attribute *attr, char *buf)
> > > +{
> > > +       struct cxl_port *port = to_cxl_port(dev->parent);
> > > +       struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > > +
> > > +       return sysfs_emit(buf, "region%d.%d:%d\n", port->id, cxld->id,
> > > +                         cxld->next_region_id);
> >
> > To cut down on userspace racing itself this should acquire the id_lock
> > to synchronize against the store side. i.e. no point in returning
> > known bad answers when the lock is held on the store side, even though
> > the answer given here may be immediately invalidated as soon as the
> > lock is dropped it's still useful to throttle readers in the presence
> > of writers.
> >
> > > +}
> > > +
> > > +static ssize_t create_region_store(struct device *dev,
> > > +                                  struct device_attribute *attr,
> > > +                                  const char *buf, size_t len)
> > > +{
> > > +       struct cxl_port *port = to_cxl_port(dev->parent);
> > > +       struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > > +       struct cxl_region *cxlr;
> > > +       int d, p, r, rc = 0;
> > > +
> > > +       if (sscanf(buf, "region%d.%d:%d", &p, &d, &r) != 3)
> > > +               return -EINVAL;
> > > +
> > > +       if (port->id != p || cxld->id != d)
> > > +               return -EINVAL;
> > > +
> > > +       rc = mutex_lock_interruptible(&cxld->id_lock);
> > > +       if (rc)
> > > +               return rc;
> > > +
> > > +       if (cxld->next_region_id != r) {
> > > +               rc = -EINVAL;
> > > +               goto out;
> > > +       }
> > > +
> > > +       cxlr = devm_cxl_add_region(cxld);
> > > +       rc = 0;
> > > +       dev_dbg(dev, "Created %s\n", dev_name(&cxlr->dev));
> > > +
> > > +out:
> > > +       mutex_unlock(&cxld->id_lock);
> > > +       if (rc)
> > > +               return rc;
> > > +       return len;
> > > +}
> > > +DEVICE_ATTR_RW(create_region);
> > > +
> > > +static struct cxl_region *cxl_find_region_by_name(struct cxl_decoder *cxld,
> > > +                                                 const char *name)
> > > +{
> > > +       struct device *region_dev;
> > > +
> > > +       region_dev = device_find_child_by_name(&cxld->dev, name);
> > > +       if (!region_dev)
> > > +               return ERR_PTR(-ENOENT);
> > > +
> > > +       return to_cxl_region(region_dev);
> > > +}
> > > +
> > > +static ssize_t delete_region_store(struct device *dev,
> > > +                                  struct device_attribute *attr,
> > > +                                  const char *buf, size_t len)
> > > +{
> > > +       struct cxl_port *port = to_cxl_port(dev->parent);
> > > +       struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > > +       struct cxl_region *cxlr;
> > > +
> > > +       cxlr = cxl_find_region_by_name(cxld, buf);
> > > +       if (IS_ERR(cxlr))
> > > +               return PTR_ERR(cxlr);
> > > +
> > > +       if (!test_and_set_bit(REGION_DEAD, &cxlr->flags))
> > > +               devm_release_action(port->uport, schedule_unregister, cxlr);
> >
> > Where is the synchronization against port ->remove()? That could have
> > started before this sysfs file was deleted and trigger double
> > device_unregister().
>
> Maybe I'm missing something obvious, but I don't see a way to do this without
> adding another lock. I need the root port's device lock for this, but when the
> port goes away, so does that device, right?

When you say "goes away" I can not tell if you are talking about
release or unregister?

Not sure it matters for this case. In this case, all that is needed is
synchronization, not necessarily locking. Synchronization can be
achieved the single threaded workqueue by just scheduling the
unregistration from each place it needs to be scheduled from and then
use the REGION_DEAD flag to make sure that even if multiple
unregistrations are scheduled only one will succeed in calling
device_unregister().

> > Given that the work is only related to unregistration this can fail
> > requests to delete something that has already been deleted. If
> > userspace sees that error and wants to synchronize it can use the
> > bus/flush attribute for that. I.e.
> >
> > if (work_pending(&cxlr->detach_work))
> >    return -EBUSY;
> >
>
> I'm not following, you mean to put this in flush_store?

No, if 2 threads race to delete a region, one will successfully
schedule and the other will see -EBUSY. If either thread wants to know
when the deletion has actually happened it can do "echo 1 >
/sys/bus/cxl/flush".

I forgot that the explicit work_pending() check is not needed. This
can simply use the return code from queue_work() to indicate if the
deletion is now in-flight.
