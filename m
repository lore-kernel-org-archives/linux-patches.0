Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F7A7C
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 18:34:22 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id gb21so14791287pjb.5
        for <patches@lists.linux.dev>; Tue, 01 Mar 2022 10:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A7Lb50coBfv4eaLuyXghnfX06FeXKcD89kuHAt5B8z0=;
        b=qL3PoXpzI+P/9v0ORKY5nZxFR7zyEEmtI4i6i2vJU26JSmw8JdtW6N5g3vFWswmhIg
         WOJ5FEgN0sOF7xbENADq+X/b3zRSvMeTwMoGVESdfnd2viNoDMYO4+sVkJqO3eZS12cW
         NTjLfrjUTKGzk034HpIzFTD0UmaP2x4SnicbGTqipwAnxO1AAdU1GYweQepO4UPBmCTJ
         Xg+Vo5EpfaKxGggcAYF0q4JyqMBiTWolswcIQO0MtzfTTxzVjzOaVVPxGTQk/G0eV3b/
         hUTebKcbUmly1mSzI5eGwJiYpjakyrMdnvqY/VWLXQ1g/IPcBokCAF1VQFiGv6R8iMjI
         Sa9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A7Lb50coBfv4eaLuyXghnfX06FeXKcD89kuHAt5B8z0=;
        b=yy5XVxhHO/HNOpvH5UGwMZzJu4wN1kJ2zMn81RFpvJhzZDsVk/TMAux1K9tysglBVM
         OVSrv3wu+fr2JRVbFHPh4OWrXIzm1EEusf68wivVg5LIe9o165MUyZiXVaVxSwuSQqke
         Cp3ZfpM0tj44Y/apw50Fl66YtjAOuXV4pRESsBCedcIzQQIfYc7Nmu8697/h4P1Zvd4g
         0PmX+PeeEWTdSnJHkB5N2ZRneEGKq332SMvbkbSDIskPfY32YBaEYWbCl1xKI0bY4iTd
         C/4/Ng0IidTUrYWi7bBV53xbv98Zjj9YloPaaKEk70KosmpzCSHFAa+qO5rm9eoQ7IY/
         qyYA==
X-Gm-Message-State: AOAM531IbVsNdkilX9+TtgwRF7g+IDKZ9agDUhtlpoagCuYGD3VAcoQj
	5Ioc6GIGJ/GWdy1SVZGF1/Na0jI3sbzt7KOPl3lSQg==
X-Google-Smtp-Source: ABdhPJwwqj9RSFb6QaCXqY0aFmaCSCNn+crHqbm3g8rVSR6SXshd2aZ4zZ6nQVhioq31j7/v1AYSH0kMk4PjAS+v/Wo=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr26717973pll.132.1646159661869; Tue, 01
 Mar 2022 10:34:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220225060038.1511562-1-ben.widawsky@intel.com>
 <20220225060038.1511562-3-ben.widawsky@intel.com> <CAPcyv4gVpBc_58cqZjHSK8yALf_uSx16U_A8dQBUMSp1SP81RA@mail.gmail.com>
 <20220301174324.g7ivb6pgs3bvt4j5@intel.com>
In-Reply-To: <20220301174324.g7ivb6pgs3bvt4j5@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Mar 2022 10:34:09 -0800
Message-ID: <CAPcyv4i9jC5JabNMp+ZQG2NXRs4AEDi6m9YzatMdH0f-6rM6-w@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] cxl/region: Introduce concept of region configuration
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	kernel test robot <lkp@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 1, 2022 at 9:43 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 22-02-28 17:16:10, Dan Williams wrote:
> > On Thu, Feb 24, 2022 at 10:01 PM Ben Widawsky <ben.widawsky@intel.com> =
wrote:
> > >
> > > The region creation APIs create a vacant region. Configuring the regi=
on
> > > works in the same way as similar subsystems such as devdax. Sysfs att=
rs
> > > will be provided to allow userspace to configure the region.  Finally
> > > once all configuration is complete, userspace may activate the region=
.
> > >
> > > Introduced here are the most basic attributes needed to configure a
> > > region. Details of these attribute are described in the ABI
> > > Documentation.
> > >
> > > A example is provided below:
> > >
> > > /sys/bus/cxl/devices/region0.0:0
> > > =E2=94=9C=E2=94=80=E2=94=80 devtype
> > > =E2=94=9C=E2=94=80=E2=94=80 interleave_granularity
> > > =E2=94=9C=E2=94=80=E2=94=80 interleave_ways
> > > =E2=94=9C=E2=94=80=E2=94=80 modalias
> > > =E2=94=9C=E2=94=80=E2=94=80 offset
> > > =E2=94=9C=E2=94=80=E2=94=80 size
> > > =E2=94=9C=E2=94=80=E2=94=80 subsystem -> ../../../../../../bus/cxl
> > > =E2=94=9C=E2=94=80=E2=94=80 target0
> > > =E2=94=9C=E2=94=80=E2=94=80 uevent
> > > =E2=94=94=E2=94=80=E2=94=80 uuid
> > >
> > > Reported-by: kernel test robot <lkp@intel.com> (v2)
> > > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > > ---
> > > Changes since v3:
> > > - Make target be a decoder
> > > - Use device_lock for protecting config/probe race
> > > - Teardown region on decoder removal
> > >
> > > Size is still not handled.
> > > ---
> > >  Documentation/ABI/testing/sysfs-bus-cxl |  59 ++++
> > >  drivers/cxl/core/port.c                 |   8 +
> > >  drivers/cxl/core/region.c               | 351 ++++++++++++++++++++++=
+-
> > >  drivers/cxl/cxl.h                       |  16 +-
> > >  drivers/cxl/region.h                    |  65 +++++
> > >  5 files changed, 495 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/=
ABI/testing/sysfs-bus-cxl
> > > index e5db45ea70ad..c447826e8286 100644
> > > --- a/Documentation/ABI/testing/sysfs-bus-cxl
> > > +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> > > @@ -186,3 +186,62 @@ Description:
> > >                 Deletes the named region.  The attribute expects a re=
gion in the
> > >                 form "regionX.Y:Z". The region's name, allocated by r=
eading
> > >                 create_region, will also be released.
> > > +               Deletes the named region. A region must be unbound fr=
om the
> > > +               region driver before being deleted.
> >
> > This is not enforced by patch1, and I don't see why this would be
> > required, the kernel will do that as a part of device_unregister,
> > right?
> >
>
> This predates my understanding that unbind can't fail. I was planning to =
use
> unbind to support managed hot remove. I will [try to remember] to change =
this.
>
> > >   The attributes expects a
> > > +               region in the form "regionX.Y:Z". The region's name, =
allocated
> > > +               by reading create_region, will also be released.
> >
> > This can also be dropped, userspace does not have any sensitivity to
> > when / how the region name memory allocation is managed.
> >
>
> Okay.
>
> > > +
> > > +What:          /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/resource
> > > +Date:          January, 2022
> > > +KernelVersion: v5.18
> > > +Contact:       linux-cxl@vger.kernel.org
> > > +Description:
> > > +               A region is a contiguous partition of a CXL Root deco=
der address
> > > +               space. Region capacity is allocated by writing to the=
 size
> > > +               attribute, the resulting physical address base determ=
ined by the
> > > +               driver is reflected here.
> > > +
> > > +What:          /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/size
> > > +Date:          January, 2022
> > > +KernelVersion: v5.18
> > > +Contact:       linux-cxl@vger.kernel.org
> > > +Description:
> > > +               System physical address space to be consumed by the r=
egion.
> >
> > s/to be//
> >
> > > +
> > > +What:          /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/interleav=
e_ways
> > > +Date:          January, 2022
> > > +KernelVersion: v5.18
> > > +Contact:       linux-cxl@vger.kernel.org
> > > +Description:
> > > +               Configures the number of devices participating in the=
 region is
> > > +               set by writing this value. Each device will provide
> > > +               1/interleave_ways of storage for the region.
> > > +
> > > +What:          /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/interleav=
e_granularity
> > > +Date:          January, 2022
> > > +KernelVersion: v5.18
> > > +Contact:       linux-cxl@vger.kernel.org
> > > +Description:
> > > +               Set the number of consecutive bytes each device in th=
e
> > > +               interleave set will claim. The possible interleave gr=
anularity
> > > +               values are determined by the CXL spec and the partici=
pating
> > > +               devices.
> > > +
> > > +What:          /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/uuid
> > > +Date:          January, 2022
> > > +KernelVersion: v5.18
> > > +Contact:       linux-cxl@vger.kernel.org
> > > +Description:
> > > +               Write a unique identifier for the region. This field =
must be set
> > > +               for persistent regions and it must not conflict with =
the UUID of
> > > +               another region. If this field is set for volatile reg=
ions, the
> > > +               value is ignored.
> >
> > Hmm, could this attribute just be hidden via is_visible() if the
> > region type is not persistent? Although that opens up new questions
> > like, what about root decoders that can simultaneously support
> > volatile and pmem? Encode the type in the create ABI? I.e. have
> > create_pmem_region and create_volatile_region I like the idea that the
> > region type is unambiguous at create time.
> >
>
> Right. Originally I was thinking the decoder implicitly determines the ty=
pe,
> however as you point out decoders can support both. I'm okay to create tw=
o
> nodes. We could also utilize a string for single create: volatileX, or
> persistentY. My preference is two nodes, I'm just offering an alternative=
.

The right sysfs-answer is 2 nodes.

> You do end up with asymmetry because there will be only one delete node f=
or 2
> create nodes. Not sure if you care about that.

Nope, don't care. sysfs interfaces are meant to be utilitarian, not
necessarily user-friendly.

>
> > > +
> > > +What: /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/endpoint_decoder[0=
..interleave_ways]
> > > +Date:          January, 2022
> > > +KernelVersion: v5.18
> > > +Contact:       linux-cxl@vger.kernel.org
> > > +Description:
> > > +               Write a decoder object that is unused and will partic=
ipate in
> > > +               decoding memory transactions for the interleave set, =
ie.
> > > +               decoderX.Y. All attributes must be populated.
> >
> > Feels like this wants a lead-in patch describing / implementing the
> > writable decoder attributes.
>
> Agreed.
>
> >
> > > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > > index f3e1313217a8..0eff36f748c3 100644
> > > --- a/drivers/cxl/core/port.c
> > > +++ b/drivers/cxl/core/port.c
> > > @@ -1415,6 +1415,14 @@ EXPORT_SYMBOL_NS_GPL(cxl_decoder_add, CXL);
> > >
> > >  static void cxld_unregister(void *dev)

Let's not use local variable shorthand names in function identifiers.
This should be called cxl_decoder_unregister(), I had misread this as
cxlr_unregister(), apologies.

> > >  {
> > > +       struct cxl_decoder *cxld =3D to_cxl_decoder(dev);
> > > +
> > > +       if (cxld->cxlr) {
> > > +               mutex_lock(&cxld->cxlr->remove_lock);
> >
> > I don't understand what this lock is for? Perhaps if it was named
> > after the data it is locking rather than the code it would be more
> > obvious.
> >
>
> It was trying to prevent racing decoders removal with the region's remova=
l.

It's naming suggested to me that it was locking code rather than data,
let's call it targets_lock.

> > > +               device_release_driver(&cxld->cxlr->dev);
> >
> > I would expect device_release_driver() to only be used in scenarios
> > where the region is being disabled, but if it is being unregistered
> > just let the device core detach the driver naturally.
>
> What's the proposal then to make it work? I don't see how the region driv=
er is
> notified that a decoder went away without something like this.

Perhaps with the naming fixed up I would not have confused this for
the cxl_region unregister path. I think this can work, but it needs a
paired check in the probe path to take the targets_lock to prevent the
region from going enabled again between dropping the targets_lock and
unregistering the decoder.

>
> >
> > > +               mutex_unlock(&cxld->cxlr->remove_lock);
> > > +       }
> > > +
> > >         device_unregister(dev);
> > >  }
> > >
> > > diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> > > index a934938f8630..2b17b0af48de 100644
> > > --- a/drivers/cxl/core/region.c
> > > +++ b/drivers/cxl/core/region.c
> > > @@ -2,9 +2,12 @@
> > >  /* Copyright(c) 2022 Intel Corporation. All rights reserved. */
> > >  #include <linux/device.h>
> > >  #include <linux/module.h>
> > > +#include <linux/sizes.h>
> > >  #include <linux/slab.h>
> > > +#include <linux/uuid.h>
> > >  #include <linux/idr.h>
> > >  #include <region.h>
> > > +#include <cxlmem.h>
> > >  #include <cxl.h>
> > >  #include "core.h"
> > >
> > > @@ -16,28 +19,367 @@
> > >   * Memory ranges, Regions represent the active mapped capacity by th=
e HDM
> > >   * Decoder Capability structures throughout the Host Bridges, Switch=
es, and
> > >   * Endpoints in the topology.
> > > + *
> > > + * Region configuration has some ordering constraints:
> >
> > Add some "why" commentary to supplement the what.
> >
> > > + * - Size: Must be set after all targets
> >
> > I would expect the other way around so that decoder capacity can be
> > validated as they are registered to the region?
>
> When size is set, I need to confirm both root decoder capacity exists as =
well as
> individual device capacity. I could flip it around and not allow targets =
that do
> not have enough capacity left. Either is fine really, but ordering is exp=
licit
> either way.
>
> If we mandate that the decoders themselves are first configured via sysfs=
 (which
> I think we did say but I forgot to add), then this should work fine.

Yeah, they are 2 separate steps. It should be fine to independently
allocate HPA-capacity and DPA-capacity and then validate that the
settings are compatible at decoder-to-region association time. So no
need to have a strict order, just check compatibility when they come
together.

> > > + * - Targets: Must be set after interleave ways
> > > + * - Interleave ways: Must be set after Interleave Granularity
> > > + *
> > > + * UUID may be set at any time before binding the driver to the regi=
on.
> >
> > Did we also talk about making all properties write once? Perhaps only
> > if it simplifies some of the validation code.
>
> I never saw a response from you about that when I asked. Sorry if I misse=
d it. I
> think write once is fine and makes things easier.

Works for me, it can always be relaxed later if it proves too restrictive.

> > >   */
> > >
> > >
> > > -static struct cxl_region *to_cxl_region(struct device *dev);
> > > +static const struct attribute_group region_interleave_group;
> > > +
> > > +#define _REGION_ATTR_RO(name)                                       =
           \
> > > +       static ssize_t name##_show(struct device *dev,               =
          \
> > > +                                  struct device_attribute *attr, cha=
r *buf)   \
> > > +       {                                                            =
          \
> > > +               struct cxl_region *cxlr =3D to_cxl_region(dev);      =
            \
> > > +               if (cxlr->flags & REGION_DEAD)                       =
          \
> >
> > Per the feedback on patch1 this likely wants to be:
> >
> > if (work_pending(&cxlr->detach_work))
>
> I've already forgotten patch1 check but I can go back and check later.

It's a lot of feedback to be sure, but we need to get through it to
converge. Sometimes the feedback is based on a misunderstanding like
the clx[rd] confusion above, so I appreciate you taking the care to
reconcile it all.

> > > +                       return -ENODEV;                              =
          \
> > > +               return show_##name(to_cxl_region(dev), buf);         =
          \
> >
> > I'd rather skip this macro indirection and just open code the 'dead'
> > check in the show handler...
> >
> > > +       }
> > > +
> > > +#define REGION_ATTR_RO(name)                                        =
           \
> > > +       _REGION_ATTR_RO(name)                                        =
          \
> > > +       static DEVICE_ATTR_RO(name)
> >
> > ...because this looks exotic to me.
> >
> > > +
> > > +#define _REGION_ATTR_WO(name)                                       =
           \
> >
> > More macro that can just be C helpers / open-coded.
> >
>
> Every attribute has the same race prevention. It seemed nice to combine i=
t in a
> relatively simple macro. I can remove it however if you don't like it but=
 I do
> believe it helps guard against future errors if adding new attributes.

I don't like that it will make debugging more difficult for resolving
back traces to line numbers, and the common code can be handled with
common preamble / postamble helper functions.

>
> > > +       static ssize_t name##_store(struct device *dev,              =
          \
> > > +                                   struct device_attribute *attr,   =
          \
> > > +                                   const char *buf, size_t len)     =
          \
> > > +       {                                                            =
          \
> > > +               int ret;                                             =
          \
> > > +               if (device_lock_interruptible(dev) < 0)              =
          \
> >
> > lockdep gave the thumbs up on this? Useful lockdep reports is another
> > reason to have not this detail buried in macros.
> >
>
> I'm running your patches and I hadn't seen anything. I am confused though=
, isn't
> this what we discussed to prevent the race with remove()?

It's similar to what nvdimm is using for deadlock avoidance, but CXL
locking !=3D NVDIMM locking so it needs reverification. You would need
to update cxl_regions to have a lock_class, see cxl_set_lock_class()
in the new set.

> Looks like there is more below.
>
> > > +                       return -EINTR;                               =
          \
> > > +               if (dev->driver) {                                   =
          \
> > > +                       device_unlock(dev);                          =
          \
> > > +                       return -EBUSY;                               =
          \
> > > +               }                                                    =
          \
> > > +               ret =3D store_##name(to_cxl_region(dev), buf, len);  =
            \
> > > +               device_unlock(dev);                                  =
          \
> > > +               return ret;                                          =
          \
> > > +       }
> > > +
> > > +#define REGION_ATTR_RW(name)                                        =
           \
> > > +       _REGION_ATTR_RO(name)                                        =
          \
> > > +       _REGION_ATTR_WO(name)                                        =
          \
> > > +       static DEVICE_ATTR_RW(name)
> > > +
> > > +#define TARGET_ATTR_RW(n)                                           =
           \
> > > +       static ssize_t target##n##_show(                             =
          \
> > > +               struct device *dev, struct device_attribute *attr, ch=
ar *buf)  \
> > > +       {                                                            =
          \
> > > +               return show_targetN(to_cxl_region(dev), buf, (n));   =
          \
> > > +       }                                                            =
          \
> > > +       static ssize_t target##n##_store(struct device *dev,         =
          \
> > > +                                        struct device_attribute *att=
r,        \
> > > +                                        const char *buf, size_t len)=
          \
> > > +       {                                                            =
          \
> > > +               int ret;                                             =
          \
> > > +               if (device_lock_interruptible(dev) < 0)              =
          \
> > > +                       return -EINTR;                               =
          \
> > > +               if (dev->driver) {                                   =
          \
> > > +                       device_unlock(dev);                          =
          \
> > > +                       return -EBUSY;                               =
          \
> > > +               }                                                    =
          \
> > > +               ret =3D store_targetN(to_cxl_region(dev), buf, (n), l=
en);        \
> > > +               device_unlock(dev);                                  =
          \
> > > +               return ret;                                          =
          \
> > > +       }                                                            =
          \
> > > +       static DEVICE_ATTR_RW(target##n)
> > > +
> > > +static void remove_target(struct cxl_region *cxlr, int target)
> > > +{
> > > +       struct cxl_decoder *cxld;
> > > +
> > > +       mutex_lock(&cxlr->remove_lock);
> > > +       cxld =3D cxlr->targets[target];
> > > +       if (cxld) {
> > > +               cxld->cxlr =3D NULL;
> > > +               put_device(&cxld->dev);
> > > +       }
> > > +       cxlr->targets[target] =3D NULL;
> > > +       mutex_unlock(&cxlr->remove_lock);
> >
> > How does this synchronize with memdev ->remove() and decoders becoming
> > unregistered while still referenced by an active region? I think,
> > especially for error handling scenarios the region driver will want to
> > be able to assume that the region will go through ->remove() before
> > any targets successfully observed by ->probe() can be removed. To me
> > that means this needs a test for the memdev ->remove() flow and
> > whether memdev ->remove() could perhaps synchronously trigger region
> > remove for all associated regions. That would mean that the region
> > device lock would need to nest beneath endpoint decoder device_lock().
> > Other flows get easier if region driver flows can assume that until
> > region ->remove() the target decoder list is stable.
> >
>
> How do I enforce it goes through remove() first?

If the equivalent of remove_target() happened inside the targets_lock
(formerly remove_lock) section of cxl_decoder_unregister() (formerly
cxld_unregister) after the region had been unbound, then I think that
might be sufficient. Otherwise a standalone remove_target() outside of
the decoder unregister path does not track for me. What am I missing?

[..]
>
> > > +}
> > > +
> > > +static inline bool
> > > +cxl_is_interleave_granularity_valid(const struct cxl_decoder *rootd,=
 int ig)
> > > +{
> > > +       int rootd_hbig;
> > > +
> > > +       if (!is_power_of_2(ig))
> > > +               return false;
> > > +
> > > +       /* 16K is the max */
> > > +       if (ig >> 15)
> >
> > Why the shift instead of the more straightforward:
> >
> > if (ig > SZ_16K)
> >
>
> Okay.
>
> > > +               return false;
> > > +
> > > +       rootd_hbig =3D cxl_from_granularity(rootd->interleave_granula=
rity);
> > > +       if (rootd_hbig < cxl_from_granularity(ig))
> > > +               return false;
> >
> > Why do the comparison in CXL encoding vs ordinal:
> >
> > if (ig > rootd->interleave_granularity)
> >
> > ?
>
> It was meant to future proof in case interleave granularity becomes non-o=
rdinal.
> I had a hunch you would request this change. I'd prefer to leave this as-=
is
> unless you really hate it.

How could interleave granularity become non-ordinal in the future?
It's not about hate or taste, it does not have a logical reason to
exist that I can see.
