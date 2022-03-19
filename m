Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5303218D
	for <patches@lists.linux.dev>; Sat, 19 Mar 2022 02:08:29 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id s42so11069478pfg.0
        for <patches@lists.linux.dev>; Fri, 18 Mar 2022 19:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2ThlxC3pJoHy+P2zAiJWxTBl3XjxcwoW5kKsQBZMObU=;
        b=B4A8ZRVm7r1mgbgBYe3benfYZ9VOws89uJDvJX+WW/yLGJG9K1icUs5OWmTrSDERIl
         KA1fWXe7tTdyw+0u6X28VPdFmHty+S3Oc/843OdRGDZ0CYsE9w7nRPYeDWu0cUl2CXVZ
         jkh+Nbl1iNkEhZYiOOh59tG09uw9xpCY14mSVznO0xiEnjG1yvZSxjNDKD42bEwzZMyz
         +nooakBItdZyE3ATlly0efEGFqZVr7Ep80BF0eKmv+UYK9a/2JKMlK2PWMxLNuewnAPk
         DE1uH3iA/dPtAUHomQ9sbs4NQ6QJljFsnt1KLp7TPL2i8ksIVIWdfrLh07vZ/Vaw+sOM
         qxvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2ThlxC3pJoHy+P2zAiJWxTBl3XjxcwoW5kKsQBZMObU=;
        b=tW4iYlmahmEv+SguCdnKb6OsmQjo5SJu29wKUp7P4lTIYkAnZYcxabvGNWw5hU0ARK
         pEhk/HI4PWhurcm/EI1ugR9xph5DMmiQ9ac+mXxzq8+87ZmDq9Ea/XUyxDKJS066ephL
         CroK62mfWY8bAYdIpnORukm7gx6iN77130MIj9LcJ0q31zKVxvjXHjWqBj/i62KSC1Gg
         82Lvogbs+VMKE8AlLQiQst5RKkCe6l1f7FKP90VtY60GWlSqz0S5sFF/9hPcalU89992
         Et+Vn3xq/31q2zDGKyCIz6En1qHPp/QKOM2gsuf36ccRiDE+LM+XiVylnmp7sJ0ZQyCj
         pGIA==
X-Gm-Message-State: AOAM532esHzokb+L0e4R/uNJFm/5uWSbBJ7xLDVCWeFiqa2hbkv1qUPp
	HbMd6EjzBdmQsigVGXCWOY+fvfoytFMBTAVuk98Jwtm5e5AUjA==
X-Google-Smtp-Source: ABdhPJwmSuEa78Kit3HbK+9kqzKzM4dyQht5oHRSK3Xz1bcUh3sND9zssru1ydE/aK3LJ9+0yUqPxHoPvjAmItrJPeI=
X-Received: by 2002:a05:6a00:2290:b0:4f9:f8b8:3603 with SMTP id
 f16-20020a056a00229000b004f9f8b83603mr12764954pfe.61.1647655708406; Fri, 18
 Mar 2022 19:08:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220316230303.1813397-1-ben.widawsky@intel.com>
 <20220316230303.1813397-3-ben.widawsky@intel.com> <CAPcyv4j60_puoCe6q2KqWo8f-HzfwumRtgXqyj1Jr9ht+SBhKg@mail.gmail.com>
 <20220318221200.2zj3b7paamsecshb@intel.com>
In-Reply-To: <20220318221200.2zj3b7paamsecshb@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 Mar 2022 19:08:18 -0700
Message-ID: <CAPcyv4ihDJ8FToFej7b_v9w9tOZCp=7Q_Pw5+z05Famc0ESpoQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/7] cxl/core: Distinguish cxl_decoder into types
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 18, 2022 at 3:12 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 22-03-18 14:03:41, Dan Williams wrote:
> > On Wed, Mar 16, 2022 at 4:03 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > >
> > > CXL HDM decoders have distinct properties at each level in the
> > > hierarchy. Root decoders manage host physical address space. Switch
> > > decoders manage demultiplexing of data to downstream targets. Endpoint
> > > decoders must be aware of physical media size constraints. To properly
> > > support these unique needs, create these unique structures. As endpoint
> > > decoders don't handle media size accounting, that is saved for a later
> > > patch.
> > >
> > > CXL HDM decoders do have similar architectural properties at all levels:
> > > interleave properties, flags and types. Those are retained and when
> > > possible, still utilized.
> >
> > This looks slightly more invasive than I was expecting for example, I
> > don't think the targets array needs to move and the direct assignment
> > of resources and ranges didn't seem to need fixing. An outline of my
> > thinking below if you want to consider it:
> >
> > >
> > > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > > ---
> > >  drivers/cxl/acpi.c           |   9 ++-
> > >  drivers/cxl/core/hdm.c       |   8 +--
> > >  drivers/cxl/core/port.c      |  99 ++++++++++++++++++++---------
> > >  drivers/cxl/cxl.h            | 118 +++++++++++++++++++++++++++++++----
> > >  tools/testing/cxl/test/cxl.c |   7 +--
> > >  5 files changed, 186 insertions(+), 55 deletions(-)
> > >
> > > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > > index 09d6811736f2..822b615a25f4 100644
> > > --- a/drivers/cxl/acpi.c
> > > +++ b/drivers/cxl/acpi.c
> > > @@ -108,8 +108,7 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
> > >
> > >         cxld->flags = cfmws_to_decoder_flags(cfmws->restrictions);
> > >         cxld->target_type = CXL_DECODER_EXPANDER;
> > > -       cxld->platform_res = (struct resource)DEFINE_RES_MEM(cfmws->base_hpa,
> > > -                                                            cfmws->window_size);
> > > +       cxl_set_decoder_extent(cxld, cfmws->base_hpa, cfmws->window_size);
> > >         cxld->interleave_ways = CFMWS_INTERLEAVE_WAYS(cfmws);
> > >         cxld->interleave_granularity = CFMWS_INTERLEAVE_GRANULARITY(cfmws);
> > >
> > > @@ -120,12 +119,12 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
> > >                 rc = cxl_decoder_autoremove(dev, cxld);
> > >         if (rc) {
> > >                 dev_err(dev, "Failed to add decoder for %pr\n",
> > > -                       &cxld->platform_res);
> > > +                       &to_cxl_root_decoder(cxld)->res);
> > >                 return 0;
> > >         }
> > >         dev_dbg(dev, "add: %s node: %d range %pr\n", dev_name(&cxld->dev),
> > > -               phys_to_target_node(cxld->platform_res.start),
> > > -               &cxld->platform_res);
> > > +               phys_to_target_node(to_cxl_root_decoder(cxld)->res.start),
> > > +               &to_cxl_root_decoder(cxld)->res);
> > >
> > >         return 0;
> > >  }
> > > diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> > > index 808b19215425..83404cdb846b 100644
> > > --- a/drivers/cxl/core/hdm.c
> > > +++ b/drivers/cxl/core/hdm.c
> > > @@ -6,6 +6,7 @@
> > >
> > >  #include "cxlmem.h"
> > >  #include "core.h"
> > > +#include "cxl.h"
> > >
> > >  /**
> > >   * DOC: cxl core hdm
> > > @@ -165,10 +166,7 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
> > >                 return -ENXIO;
> > >         }
> > >
> > > -       cxld->decoder_range = (struct range) {
> > > -               .start = base,
> > > -               .end = base + size - 1,
> > > -       };
> > > +       cxl_set_decoder_extent(cxld, base, size);
> > >
> > >         /* switch decoders are always enabled if committed */
> > >         if (ctrl & CXL_HDM_DECODER0_CTRL_COMMITTED) {
> > > @@ -235,7 +233,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
> > >                 struct cxl_decoder *cxld;
> > >
> > >                 if (is_cxl_endpoint(port))
> > > -                       cxld = cxl_endpoint_decoder_alloc(port);
> > > +                       cxld = &cxl_endpoint_decoder_alloc(port)->base;
> > >                 else
> > >                         cxld = cxl_switch_decoder_alloc(port, target_count);
> > >                 if (IS_ERR(cxld)) {
> > > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > > index bda40e91af2b..c46f0b01ce3c 100644
> > > --- a/drivers/cxl/core/port.c
> > > +++ b/drivers/cxl/core/port.c
> > > @@ -73,14 +73,8 @@ static ssize_t start_show(struct device *dev, struct device_attribute *attr,
> > >                           char *buf)
> > >  {
> > >         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > > -       u64 start;
> > >
> > > -       if (is_root_decoder(dev))
> > > -               start = cxld->platform_res.start;
> > > -       else
> > > -               start = cxld->decoder_range.start;
> > > -
> > > -       return sysfs_emit(buf, "%#llx\n", start);
> > > +       return sysfs_emit(buf, "%#llx\n", cxl_get_decoder_extent(cxld).start);
> > >  }
> > >  static DEVICE_ATTR_ADMIN_RO(start);
> > >
> > > @@ -88,14 +82,9 @@ static ssize_t size_show(struct device *dev, struct device_attribute *attr,
> > >                         char *buf)
> > >  {
> > >         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > > -       u64 size;
> > > +       struct range r = cxl_get_decoder_extent(cxld);
> > >
> > > -       if (is_root_decoder(dev))
> > > -               size = resource_size(&cxld->platform_res);
> > > -       else
> > > -               size = range_len(&cxld->decoder_range);
> > > -
> > > -       return sysfs_emit(buf, "%#llx\n", size);
> > > +       return sysfs_emit(buf, "%#llx\n", range_len(&r));
> > >  }
> > >  static DEVICE_ATTR_RO(size);
> > >
> > > @@ -152,18 +141,19 @@ static DEVICE_ATTR_RO(target_type);
> > >
> > >  static ssize_t emit_target_list(struct cxl_decoder *cxld, char *buf)
> > >  {
> > > +       struct cxl_decoder_targets *t = cxl_get_decoder_targets(cxld);
> > >         ssize_t offset = 0;
> > >         int i, rc = 0;
> > >
> > >         for (i = 0; i < cxld->interleave_ways; i++) {
> > > -               struct cxl_dport *dport = cxld->target[i];
> > > +               struct cxl_dport *dport = t->target[i];
> > >                 struct cxl_dport *next = NULL;
> > >
> > >                 if (!dport)
> > >                         break;
> > >
> > >                 if (i + 1 < cxld->interleave_ways)
> > > -                       next = cxld->target[i + 1];
> > > +                       next = t->target[i + 1];
> > >                 rc = sysfs_emit_at(buf, offset, "%d%s", dport->port_id,
> > >                                    next ? "," : "");
> > >                 if (rc < 0)
> > > @@ -178,14 +168,15 @@ static ssize_t target_list_show(struct device *dev,
> > >                                 struct device_attribute *attr, char *buf)
> > >  {
> > >         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > > +       struct cxl_decoder_targets *t = cxl_get_decoder_targets(cxld);
> > >         ssize_t offset;
> > >         unsigned int seq;
> > >         int rc;
> > >
> > >         do {
> > > -               seq = read_seqbegin(&cxld->target_lock);
> > > +               seq = read_seqbegin(&t->target_lock);
> > >                 rc = emit_target_list(cxld, buf);
> > > -       } while (read_seqretry(&cxld->target_lock, seq));
> > > +       } while (read_seqretry(&t->target_lock, seq));
> > >
> > >         if (rc < 0)
> > >                 return rc;
> > > @@ -297,6 +288,7 @@ bool is_endpoint_decoder(struct device *dev)
> > >  {
> > >         return dev->type == &cxl_decoder_endpoint_type;
> > >  }
> > > +EXPORT_SYMBOL_NS_GPL(is_endpoint_decoder, CXL);
> > >
> > >  bool is_root_decoder(struct device *dev)
> > >  {
> > > @@ -1167,6 +1159,7 @@ EXPORT_SYMBOL_NS_GPL(cxl_find_dport_by_dev, CXL);
> > >  static int decoder_populate_targets(struct cxl_decoder *cxld,
> > >                                     struct cxl_port *port, int *target_map)
> > >  {
> > > +       struct cxl_decoder_targets *t = cxl_get_decoder_targets(cxld);
> > >         int i, rc = 0;
> > >
> > >         if (!target_map)
> > > @@ -1177,21 +1170,70 @@ static int decoder_populate_targets(struct cxl_decoder *cxld,
> > >         if (list_empty(&port->dports))
> > >                 return -EINVAL;
> > >
> > > -       write_seqlock(&cxld->target_lock);
> > > -       for (i = 0; i < cxld->nr_targets; i++) {
> > > +       write_seqlock(&t->target_lock);
> > > +       for (i = 0; i < t->nr_targets; i++) {
> > >                 struct cxl_dport *dport = find_dport(port, target_map[i]);
> > >
> > >                 if (!dport) {
> > >                         rc = -ENXIO;
> > >                         break;
> > >                 }
> > > -               cxld->target[i] = dport;
> > > +               t->target[i] = dport;
> > >         }
> > > -       write_sequnlock(&cxld->target_lock);
> > > +       write_sequnlock(&t->target_lock);
> > >
> > >         return rc;
> > >  }
> > >
> > > +static struct cxl_decoder *__cxl_decoder_alloc(struct cxl_port *port,
> > > +                                              unsigned int nr_targets)
> > > +{
> > > +       struct cxl_decoder *cxld;
> > > +
> > > +       if (is_cxl_endpoint(port)) {
> > > +               struct cxl_endpoint_decoder *cxled;
> > > +
> > > +               cxled = kzalloc(sizeof(*cxled), GFP_KERNEL);
> > > +               if (!cxled)
> > > +                       return NULL;
> > > +               cxld = &cxled->base;
> > > +       } else if (is_cxl_root(port)) {
> > > +               struct cxl_root_decoder *cxlrd;
> > > +
> > > +               cxlrd = kzalloc(sizeof(*cxlrd), GFP_KERNEL);
> > > +               if (!cxlrd)
> > > +                       return NULL;
> > > +
> > > +               cxlrd->targets =
> > > +                       kzalloc(struct_size(cxlrd->targets, target, nr_targets), GFP_KERNEL);
> > > +               if (!cxlrd->targets) {
> > > +                       kfree(cxlrd);
> > > +                       return NULL;
> > > +               }
> > > +               cxlrd->targets->nr_targets = nr_targets;
> > > +               seqlock_init(&cxlrd->targets->target_lock);
> > > +               cxld = &cxlrd->base;
> > > +       } else {
> > > +               struct cxl_switch_decoder *cxlsd;
> > > +
> > > +               cxlsd = kzalloc(sizeof(*cxlsd), GFP_KERNEL);
> > > +               if (!cxlsd)
> > > +                       return NULL;
> > > +
> > > +               cxlsd->targets =
> > > +                       kzalloc(struct_size(cxlsd->targets, target, nr_targets), GFP_KERNEL);
> > > +               if (!cxlsd->targets) {
> > > +                       kfree(cxlsd);
> > > +                       return NULL;
> > > +               }
> > > +               cxlsd->targets->nr_targets = nr_targets;
> > > +               seqlock_init(&cxlsd->targets->target_lock);
> > > +               cxld = &cxlsd->base;
> > > +       }
> > > +
> > > +       return cxld;
> > > +}
> > > +
> > >  /**
> > >   * cxl_decoder_alloc - Allocate a new CXL decoder
> > >   * @port: owning port of this decoder
> > > @@ -1217,9 +1259,10 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
> > >         if (nr_targets > CXL_DECODER_MAX_INTERLEAVE)
> > >                 return ERR_PTR(-EINVAL);
> > >
> > > -       cxld = kzalloc(struct_size(cxld, target, nr_targets), GFP_KERNEL);
> > > +       cxld = __cxl_decoder_alloc(port, nr_targets);
> > >         if (!cxld)
> > >                 return ERR_PTR(-ENOMEM);
> > > +       ;
> > >
> > >         rc = ida_alloc(&port->decoder_ida, GFP_KERNEL);
> > >         if (rc < 0)
> > > @@ -1229,8 +1272,6 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
> > >         get_device(&port->dev);
> > >         cxld->id = rc;
> > >
> > > -       cxld->nr_targets = nr_targets;
> > > -       seqlock_init(&cxld->target_lock);
> > >         dev = &cxld->dev;
> > >         device_initialize(dev);
> > >         device_set_pm_not_required(dev);
> > > @@ -1247,7 +1288,7 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
> > >         cxld->interleave_ways = 1;
> > >         cxld->interleave_granularity = PAGE_SIZE;
> > >         cxld->target_type = CXL_DECODER_EXPANDER;
> > > -       cxld->platform_res = (struct resource)DEFINE_RES_MEM(0, 0);
> > > +       cxl_set_decoder_extent(cxld, 0, 0);
> > >
> > >         return cxld;
> > >  err:
> > > @@ -1302,12 +1343,12 @@ EXPORT_SYMBOL_NS_GPL(cxl_switch_decoder_alloc, CXL);
> > >   *
> > >   * Return: A new cxl decoder to be registered by cxl_decoder_add()
> > >   */
> > > -struct cxl_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port)
> > > +struct cxl_endpoint_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port)
> > >  {
> > >         if (!is_cxl_endpoint(port))
> > >                 return ERR_PTR(-EINVAL);
> > >
> > > -       return cxl_decoder_alloc(port, 0);
> > > +       return to_cxl_endpoint_decoder(cxl_decoder_alloc(port, 0));
> > >  }
> > >  EXPORT_SYMBOL_NS_GPL(cxl_endpoint_decoder_alloc, CXL);
> > >
> > > @@ -1366,7 +1407,7 @@ int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map)
> > >          * other resources are just sub ranges within the main decoder resource.
> > >          */
> > >         if (is_root_decoder(dev))
> > > -               cxld->platform_res.name = dev_name(dev);
> > > +               to_cxl_root_decoder(cxld)->res.name = dev_name(dev);
> > >
> > >         cxl_set_lock_class(dev);
> > >         return device_add(dev);
> > > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > > index 4a93d409328f..f523268060fd 100644
> > > --- a/drivers/cxl/cxl.h
> > > +++ b/drivers/cxl/cxl.h
> > > @@ -210,6 +210,18 @@ enum cxl_decoder_type {
> > >   */
> > >  #define CXL_DECODER_MAX_INTERLEAVE 16
> > >
> > > +/**
> > > + * struct cxl_decoder_targets - Target information for root and switch decoders.
> > > + * @target_lock: coordinate coherent reads of the target list
> > > + * @nr_targets: number of elements in @target
> > > + * @target: active ordered target list in current decoder configuration
> > > + */
> > > +struct cxl_decoder_targets {
> > > +       seqlock_t target_lock;
> > > +       int nr_targets;
> > > +       struct cxl_dport *target[];
> > > +};
> > > +
> > >  /**
> > >   * struct cxl_decoder - CXL address range decode configuration
> > >   * @dev: this decoder's device
> > > @@ -220,26 +232,60 @@ enum cxl_decoder_type {
> > >   * @interleave_granularity: data stride per dport
> > >   * @target_type: accelerator vs expander (type2 vs type3) selector
> > >   * @flags: memory type capabilities and locking
> > > - * @target_lock: coordinate coherent reads of the target list
> > > - * @nr_targets: number of elements in @target
> > > - * @target: active ordered target list in current decoder configuration
> > >   */
> > >  struct cxl_decoder {
> > >         struct device dev;
> > >         int id;
> > > -       union {
> > > -               struct resource platform_res;
> > > -               struct range decoder_range;
> > > -       };
> > >         int interleave_ways;
> > >         int interleave_granularity;
> > >         enum cxl_decoder_type target_type;
> > >         unsigned long flags;
> > > -       seqlock_t target_lock;
> > > -       int nr_targets;
> > > -       struct cxl_dport *target[];
> > >  };
> > >
> > > +/**
> > > + * struct cxl_endpoint_decoder - An decoder residing in a CXL endpoint.
> > > + * @base: Base class decoder
> > > + * @range: Host physical address space consumed by this decoder.
> > > + */
> > > +struct cxl_endpoint_decoder {
> > > +       struct cxl_decoder base;
> > > +       struct range range;
> > > +};
> > > +
> > > +/**
> > > + * struct cxl_switch_decoder - A decoder in a switch or hostbridge.
> > > + * @base: Base class decoder
> > > + * @range: Host physical address space consumed by this decoder.
> > > + * @targets: Downstream targets for this switch.
> > > + */
> > > +struct cxl_switch_decoder {
> > > +       struct cxl_decoder base;
> > > +       struct range range;
> > > +       struct cxl_decoder_targets *targets;
> > > +};
> > > +
> > > +/**
> > > + * struct cxl_root_decoder - A toplevel/platform decoder
> > > + * @base: Base class decoder
> > > + * @res: host address space owned by this decoder
> > > + * @targets: Downstream targets (ie. hostbridges).
> > > + */
> > > +struct cxl_root_decoder {
> > > +       struct cxl_decoder base;
> > > +       struct resource res;
> > > +       struct cxl_decoder_targets *targets;
> > > +};
> >
> > This is what I had started to mock up, I think the only differences
> > are no out of line allocations, and the concept that endpoint decoders
> > need to track hpa, dpa, and skip. What do you think?
>
> If we're going through the effort to separate them, I do think it's beneficial
> to pull out target also. Are you so much opposed to that part? What part of the
> out of line allocation do you dislike? It seems fine to me and keeps the alloc
> function fitting on one screen, for me.
>
> >
> > struct cxl_root_decoder {
> >        struct resource hpa;
> >        struct cxl_decoder decoder;
> > };
> >
> > struct cxl_switch_decoder {
> >        struct range hpa_range;
> >        struct cxl_decoder decoder;
> > };
> >
> > struct cxl_endpoint_decoder {
> >        struct resource *hpa_res;
>
> I thought we had decided that the region is the entity that creates the child
> resources of the HPA range. The problem with this is every decoder in a set will
> have the same HPA range.

Either way works... and I was inconsistent in this example wrt switch
decoders. So, either this is just a straight link to the resource
allocated to the region. I.e. the region driver does res =
request_region(&cxlrd->hpa), and then at some point else there is a
"for_each_decoder(cxled) cxled->res = res" or it's just a range that
copies the region span. I'm leaning towards range.

>
> >        struct range dpa_range;
>
> Oh, I thought you were going to make dpa be resource based as well. Range is a
> little of a better fit IMO.

In my request_dpa() poc I do:

+       res = __request_region(&eport->dpa, start, size, dev_name(&cxld->dev),
+                              0);
+       if (!res)
+               goto err;
+
+       cxld->decoder_range.start = res->start;
+       cxld->decoder_range.end = res->end;
+       if (devm_add_action_or_reset(&eport->port.dev, release_dpa, cxld))

i.e. the resource tree tracks the res and the decoder tracks the range

...and then release does:

+       mutex_lock(&eport->dpa_lock);
+       __release_region(&eport->dpa, cxld->decoder_range.start,
+                        range_len(&cxld->decoder_range));
+       mutex_unlock(&eport->dpa_lock);
+

>
> >        struct range dpa_skip;
>
> You don't mean range here, do you? DPA us just a u64. Anything else can be
> constructed with dpa_range.

It's a range so it can indicate the inactive dpa span that this
decoder depends on being unallocated anywhere else and skipped. It
will be tracked in the resource tree such that if someone allocates a
pmem decoder and pmem decoder also marks busy all the remaining free
volatile capacity since there is no architectural support for sparse
decoders. I didn't get around to adding this to the poc, but this lets
you just trust the resource tree to block new volatile region creation
after a pmem region masks off the capacity.

>
> >        struct cxl_decoder decoder;
> > };
> >
> > Then at allocation it would be something like:
> >
> >         if (is_cxl_root(port)) {
> >                 struct cxl_root_decoder *cxlrd;
> >
> >                 cxlrd = kzalloc(struct_size(cxlrd, decoder.target, nr_targets),
> >                                 GFP_KERNEL);
> >                 if (!cxlrd)
> >                         return ERR_PTR(-ENOMEM);
> >
> >                 cxlrd->hpa = (struct resource)DEFINE_RES_MEM(0, 0);
> >                 cxld = &cxlrd->decoder;
> >                 cxld->dev.type = &cxl_decoder_root_type;
> >         } else if (is_cxl_endpoint(port)) {
> >                 struct cxl_endpoint_decoder *cxled;
> >
> >                 cxled = kzalloc(struct_size(cxled, decoder.target, nr_targets),
> >                                 GFP_KERNEL);
> >                 if (!cxled)
> >                         return ERR_PTR(-ENOMEM);
> >
> >                 cxled->dpa_range = (struct range) {
> >                         .start = 0,
> >                         .end = -1,
> >                 };
> >                 cxled->dpa_skip = (struct range) {
> >                         .start = 0,
> >                         .end = -1,
> >                 };
> >
> >                 cxld = &cxled->decoder;
> >                 cxld->dev.type = &cxl_decoder_endpoint_type;
> >         } else {
> >                 struct cxl_switch_decoder *cxlsd;
> >
> >                 cxlsd = kzalloc(struct_size(cxlsd, decoder.target, nr_targets),
> >                                 GFP_KERNEL);
> >                 if (!cxlsd)
> >                         return ERR_PTR(-ENOMEM);
> >
> >                 cxled->hpa_range = (struct range) {
> >                         .start = 0,
> >                         .end = -1,
> >                 };
> >
> >                 cxld->dev.type = &cxl_decoder_switch_type;
> >                 if (!cxld)
> >                         return ERR_PTR(-ENOMEM);
> >         }
> >
> >
> > > +
> > > +#define _to_cxl_decoder(x)                                                     \
> > > +       static inline struct cxl_##x##_decoder *to_cxl_##x##_decoder(          \
> > > +               struct cxl_decoder *cxld)                                      \
> > > +       {                                                                      \
> > > +               return container_of(cxld, struct cxl_##x##_decoder, base);     \
> > > +       }
> > > +
> > > +_to_cxl_decoder(root)
> > > +_to_cxl_decoder(switch)
> > > +_to_cxl_decoder(endpoint)
> >
> > I notice no is_{root,switch,endpoint}_decoder() sanity checking like
> > our other to_$object() helpers, deliberate?
> >
>
> I'm not sure how you can do this and do a sanity check. I'm open to suggestions.

The type indication is in the object so if you're starting from a
'struct device *' it would convert to a plain 'struct cxl_decoder *'
and check type before upcasting to the final result.

>
> > >
> > >  /**
> > >   * enum cxl_nvdimm_brige_state - state machine for managing bus rescans
> > > @@ -364,11 +410,61 @@ struct cxl_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
> > >  struct cxl_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
> > >                                              unsigned int nr_targets);
> > >  int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map);
> > > -struct cxl_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port);
> > > +struct cxl_endpoint_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port);
> > >  int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map);
> > >  int cxl_decoder_autoremove(struct device *host, struct cxl_decoder *cxld);
> > >  int cxl_endpoint_autoremove(struct cxl_memdev *cxlmd, struct cxl_port *endpoint);
> > >
> > > +static inline struct cxl_decoder_targets *
> > > +cxl_get_decoder_targets(struct cxl_decoder *cxld)
> > > +{
> > > +       if (is_root_decoder(&cxld->dev))
> > > +               return to_cxl_root_decoder(cxld)->targets;
> > > +       else if (is_endpoint_decoder(&cxld->dev))
> > > +               return NULL;
> > > +       else
> > > +               return to_cxl_switch_decoder(cxld)->targets;
> > > +}
> > > +
> > > +static inline void cxl_set_decoder_extent(struct cxl_decoder *cxld,
> > > +                                         resource_size_t base,
> > > +                                         resource_size_t size)
> > > +{
> > > +       if (is_root_decoder(&cxld->dev))
> > > +               to_cxl_root_decoder(cxld)->res =
> > > +                       (struct resource)DEFINE_RES_MEM(base, size);
> > > +       else if (is_endpoint_decoder(&cxld->dev))
> > > +               to_cxl_endpoint_decoder(cxld)->range = (struct range){
> > > +                       .start = base,
> > > +                       .end = base + size - 1
> > > +               };
> > > +       else
> > > +               to_cxl_switch_decoder(cxld)->range = (struct range){
> > > +                       .start = base,
> > > +                       .end = base + size - 1
> > > +               };
> > > +}
> > > +
> > > +static inline struct range cxl_get_decoder_extent(struct cxl_decoder *cxld)
> > > +{
> > > +       struct range ret;
> > > +
> > > +       if (is_root_decoder(&cxld->dev)) {
> > > +               struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxld);
> > > +
> > > +               ret = (struct range) {
> > > +                       .start = cxlrd->res.start,
> > > +                       .end = cxlrd->res.end
> > > +               };
> > > +       } else if (is_endpoint_decoder(&cxld->dev)) {
> > > +               ret = to_cxl_endpoint_decoder(cxld)->range;
> > > +       } else {
> > > +               ret = to_cxl_switch_decoder(cxld)->range;
> > > +       }
> > > +
> > > +       return ret;
> > > +}
> >
> > The caller context will know what decoder type it is operating on, so
> > the conversion to a generic type only to convert back into the
> > specific type somewhat defeats the purpose of having distinct types in
> > the first place.
>
> This was just to save typing for decoder attrs (size and start). You can get to
> the type, but then you have an if ladder for each of those. It's not my favorite
> solution, but neither was the repetitive typing.

Perhaps there should just be an hpa_range in all decoder types so that
the sysfs code can mostly just look at the base type for the common
bits. Yes, it would mean that the root decoder would have a resource
tree head and a range for the same, but otherwise seems clean since
the root decoder hpa_range will never change.
