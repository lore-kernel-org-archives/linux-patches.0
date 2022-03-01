Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E8A7A
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 01:16:21 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id m22so12756081pja.0
        for <patches@lists.linux.dev>; Mon, 28 Feb 2022 17:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hbDElMenqUxKuXWcw4H4t6/x4qSX/Ojo3HDQmTjI6qI=;
        b=73H61EX3qX46y1OccV8hqBMSixI6Nr1JZhSMWQpyVFP6Yhw3FO1n3DzRuKR41/m6W3
         GNgUhzb48gEfFBj6KCkDdZFXcgX7dC6dxro0WWmkeDb9ZM/Ffkqfu5v9e1Mh69EwpAFt
         p4wzL2BSfsjuMw90J5kgck1o8JnSjFbcmn9F1xPfGvr65bCQNqe1lzBCP3CcZu7oYSIp
         c+2DoSrgLmQicPTR8Y1AFu8ca3RGkQZgMsBI5fPoN2o0CJ37rXU8rlK1UZIV3fzUowET
         SQaYKMq9clpotYapUyEfny+ca/pasnLnjgr021vU3QvXAG0AKDCIyieJDNdcjEBR6qEJ
         Lh7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hbDElMenqUxKuXWcw4H4t6/x4qSX/Ojo3HDQmTjI6qI=;
        b=lfBOxlwHZh8ft9kM2XuAdtu/XOAlkecGqhwM/lFzin5B9T0h1JPCL1aPRIFYCSiRjX
         qqMOh2Cw3HKxXd4nyn+Uk4P8J/tg3ivz0Et+t3XxF7I8JY+34kAbQQnE/ihAhkLwkby0
         35i8sKmGyIOPx/nliTADcQXHDav+h9nrle7mwohgHcA4zX9EmjYz1QVGHruMl/A5n7LD
         7Q0ulmD5lbPsXDEH9U+t7hN9dmWtXqTHgYALVgEqpdFWbPugDOMu3P9luy28AG0mwF7+
         a9yifs/9g12w6ckniNYom/7SIvl46Xo60JArsqZabHPTDZYpYl6yjFtCoKwo8MRBDXHE
         UCWg==
X-Gm-Message-State: AOAM532zy1QooGaT4ID90I+2Dqugy7Vp12q0hPK7vz8nGi6TWli4HK/I
	9V5vG1OsUTcSGxn7zcMmtt6ps3BHG7bQq45UmHZ+4w==
X-Google-Smtp-Source: ABdhPJyow9LRYXHLcS4M+4P/UeN4D6LV2CI3ywXv21YPpL0KkGhubhymqsx9bbtqFz2c/KC8nVV1S9uN7leLYDT/bPg=
X-Received: by 2002:a17:90a:430d:b0:1bc:f340:8096 with SMTP id
 q13-20020a17090a430d00b001bcf3408096mr18402245pjg.93.1646097381154; Mon, 28
 Feb 2022 17:16:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220225060038.1511562-1-ben.widawsky@intel.com> <20220225060038.1511562-3-ben.widawsky@intel.com>
In-Reply-To: <20220225060038.1511562-3-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 28 Feb 2022 17:16:10 -0800
Message-ID: <CAPcyv4gVpBc_58cqZjHSK8yALf_uSx16U_A8dQBUMSp1SP81RA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] cxl/region: Introduce concept of region configuration
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	kernel test robot <lkp@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 24, 2022 at 10:01 PM Ben Widawsky <ben.widawsky@intel.com> wrot=
e:
>
> The region creation APIs create a vacant region. Configuring the region
> works in the same way as similar subsystems such as devdax. Sysfs attrs
> will be provided to allow userspace to configure the region.  Finally
> once all configuration is complete, userspace may activate the region.
>
> Introduced here are the most basic attributes needed to configure a
> region. Details of these attribute are described in the ABI
> Documentation.
>
> A example is provided below:
>
> /sys/bus/cxl/devices/region0.0:0
> =E2=94=9C=E2=94=80=E2=94=80 devtype
> =E2=94=9C=E2=94=80=E2=94=80 interleave_granularity
> =E2=94=9C=E2=94=80=E2=94=80 interleave_ways
> =E2=94=9C=E2=94=80=E2=94=80 modalias
> =E2=94=9C=E2=94=80=E2=94=80 offset
> =E2=94=9C=E2=94=80=E2=94=80 size
> =E2=94=9C=E2=94=80=E2=94=80 subsystem -> ../../../../../../bus/cxl
> =E2=94=9C=E2=94=80=E2=94=80 target0
> =E2=94=9C=E2=94=80=E2=94=80 uevent
> =E2=94=94=E2=94=80=E2=94=80 uuid
>
> Reported-by: kernel test robot <lkp@intel.com> (v2)
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
> Changes since v3:
> - Make target be a decoder
> - Use device_lock for protecting config/probe race
> - Teardown region on decoder removal
>
> Size is still not handled.
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl |  59 ++++
>  drivers/cxl/core/port.c                 |   8 +
>  drivers/cxl/core/region.c               | 351 +++++++++++++++++++++++-
>  drivers/cxl/cxl.h                       |  16 +-
>  drivers/cxl/region.h                    |  65 +++++
>  5 files changed, 495 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/=
testing/sysfs-bus-cxl
> index e5db45ea70ad..c447826e8286 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -186,3 +186,62 @@ Description:
>                 Deletes the named region.  The attribute expects a region=
 in the
>                 form "regionX.Y:Z". The region's name, allocated by readi=
ng
>                 create_region, will also be released.
> +               Deletes the named region. A region must be unbound from t=
he
> +               region driver before being deleted.

This is not enforced by patch1, and I don't see why this would be
required, the kernel will do that as a part of device_unregister,
right?

>   The attributes expects a
> +               region in the form "regionX.Y:Z". The region's name, allo=
cated
> +               by reading create_region, will also be released.

This can also be dropped, userspace does not have any sensitivity to
when / how the region name memory allocation is managed.

> +
> +What:          /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/resource
> +Date:          January, 2022
> +KernelVersion: v5.18
> +Contact:       linux-cxl@vger.kernel.org
> +Description:
> +               A region is a contiguous partition of a CXL Root decoder =
address
> +               space. Region capacity is allocated by writing to the siz=
e
> +               attribute, the resulting physical address base determined=
 by the
> +               driver is reflected here.
> +
> +What:          /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/size
> +Date:          January, 2022
> +KernelVersion: v5.18
> +Contact:       linux-cxl@vger.kernel.org
> +Description:
> +               System physical address space to be consumed by the regio=
n.

s/to be//

> +
> +What:          /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/interleave_wa=
ys
> +Date:          January, 2022
> +KernelVersion: v5.18
> +Contact:       linux-cxl@vger.kernel.org
> +Description:
> +               Configures the number of devices participating in the reg=
ion is
> +               set by writing this value. Each device will provide
> +               1/interleave_ways of storage for the region.
> +
> +What:          /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/interleave_gr=
anularity
> +Date:          January, 2022
> +KernelVersion: v5.18
> +Contact:       linux-cxl@vger.kernel.org
> +Description:
> +               Set the number of consecutive bytes each device in the
> +               interleave set will claim. The possible interleave granul=
arity
> +               values are determined by the CXL spec and the participati=
ng
> +               devices.
> +
> +What:          /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/uuid
> +Date:          January, 2022
> +KernelVersion: v5.18
> +Contact:       linux-cxl@vger.kernel.org
> +Description:
> +               Write a unique identifier for the region. This field must=
 be set
> +               for persistent regions and it must not conflict with the =
UUID of
> +               another region. If this field is set for volatile regions=
, the
> +               value is ignored.

Hmm, could this attribute just be hidden via is_visible() if the
region type is not persistent? Although that opens up new questions
like, what about root decoders that can simultaneously support
volatile and pmem? Encode the type in the create ABI? I.e. have
create_pmem_region and create_volatile_region I like the idea that the
region type is unambiguous at create time.

> +
> +What: /sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/endpoint_decoder[0..in=
terleave_ways]
> +Date:          January, 2022
> +KernelVersion: v5.18
> +Contact:       linux-cxl@vger.kernel.org
> +Description:
> +               Write a decoder object that is unused and will participat=
e in
> +               decoding memory transactions for the interleave set, ie.
> +               decoderX.Y. All attributes must be populated.

Feels like this wants a lead-in patch describing / implementing the
writable decoder attributes.

> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index f3e1313217a8..0eff36f748c3 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -1415,6 +1415,14 @@ EXPORT_SYMBOL_NS_GPL(cxl_decoder_add, CXL);
>
>  static void cxld_unregister(void *dev)
>  {
> +       struct cxl_decoder *cxld =3D to_cxl_decoder(dev);
> +
> +       if (cxld->cxlr) {
> +               mutex_lock(&cxld->cxlr->remove_lock);

I don't understand what this lock is for? Perhaps if it was named
after the data it is locking rather than the code it would be more
obvious.

> +               device_release_driver(&cxld->cxlr->dev);

I would expect device_release_driver() to only be used in scenarios
where the region is being disabled, but if it is being unregistered
just let the device core detach the driver naturally.

> +               mutex_unlock(&cxld->cxlr->remove_lock);
> +       }
> +
>         device_unregister(dev);
>  }
>
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index a934938f8630..2b17b0af48de 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2,9 +2,12 @@
>  /* Copyright(c) 2022 Intel Corporation. All rights reserved. */
>  #include <linux/device.h>
>  #include <linux/module.h>
> +#include <linux/sizes.h>
>  #include <linux/slab.h>
> +#include <linux/uuid.h>
>  #include <linux/idr.h>
>  #include <region.h>
> +#include <cxlmem.h>
>  #include <cxl.h>
>  #include "core.h"
>
> @@ -16,28 +19,367 @@
>   * Memory ranges, Regions represent the active mapped capacity by the HD=
M
>   * Decoder Capability structures throughout the Host Bridges, Switches, =
and
>   * Endpoints in the topology.
> + *
> + * Region configuration has some ordering constraints:

Add some "why" commentary to supplement the what.

> + * - Size: Must be set after all targets

I would expect the other way around so that decoder capacity can be
validated as they are registered to the region?

> + * - Targets: Must be set after interleave ways
> + * - Interleave ways: Must be set after Interleave Granularity
> + *
> + * UUID may be set at any time before binding the driver to the region.

Did we also talk about making all properties write once? Perhaps only
if it simplifies some of the validation code.

>   */
>
>
> -static struct cxl_region *to_cxl_region(struct device *dev);
> +static const struct attribute_group region_interleave_group;
> +
> +#define _REGION_ATTR_RO(name)                                           =
       \
> +       static ssize_t name##_show(struct device *dev,                   =
      \
> +                                  struct device_attribute *attr, char *b=
uf)   \
> +       {                                                                =
      \
> +               struct cxl_region *cxlr =3D to_cxl_region(dev);          =
        \
> +               if (cxlr->flags & REGION_DEAD)                           =
      \

Per the feedback on patch1 this likely wants to be:

if (work_pending(&cxlr->detach_work))

> +                       return -ENODEV;                                  =
      \
> +               return show_##name(to_cxl_region(dev), buf);             =
      \

I'd rather skip this macro indirection and just open code the 'dead'
check in the show handler...

> +       }
> +
> +#define REGION_ATTR_RO(name)                                            =
       \
> +       _REGION_ATTR_RO(name)                                            =
      \
> +       static DEVICE_ATTR_RO(name)

...because this looks exotic to me.

> +
> +#define _REGION_ATTR_WO(name)                                           =
       \

More macro that can just be C helpers / open-coded.

> +       static ssize_t name##_store(struct device *dev,                  =
      \
> +                                   struct device_attribute *attr,       =
      \
> +                                   const char *buf, size_t len)         =
      \
> +       {                                                                =
      \
> +               int ret;                                                 =
      \
> +               if (device_lock_interruptible(dev) < 0)                  =
      \

lockdep gave the thumbs up on this? Useful lockdep reports is another
reason to have not this detail buried in macros.

> +                       return -EINTR;                                   =
      \
> +               if (dev->driver) {                                       =
      \
> +                       device_unlock(dev);                              =
      \
> +                       return -EBUSY;                                   =
      \
> +               }                                                        =
      \
> +               ret =3D store_##name(to_cxl_region(dev), buf, len);      =
        \
> +               device_unlock(dev);                                      =
      \
> +               return ret;                                              =
      \
> +       }
> +
> +#define REGION_ATTR_RW(name)                                            =
       \
> +       _REGION_ATTR_RO(name)                                            =
      \
> +       _REGION_ATTR_WO(name)                                            =
      \
> +       static DEVICE_ATTR_RW(name)
> +
> +#define TARGET_ATTR_RW(n)                                               =
       \
> +       static ssize_t target##n##_show(                                 =
      \
> +               struct device *dev, struct device_attribute *attr, char *=
buf)  \
> +       {                                                                =
      \
> +               return show_targetN(to_cxl_region(dev), buf, (n));       =
      \
> +       }                                                                =
      \
> +       static ssize_t target##n##_store(struct device *dev,             =
      \
> +                                        struct device_attribute *attr,  =
      \
> +                                        const char *buf, size_t len)    =
      \
> +       {                                                                =
      \
> +               int ret;                                                 =
      \
> +               if (device_lock_interruptible(dev) < 0)                  =
      \
> +                       return -EINTR;                                   =
      \
> +               if (dev->driver) {                                       =
      \
> +                       device_unlock(dev);                              =
      \
> +                       return -EBUSY;                                   =
      \
> +               }                                                        =
      \
> +               ret =3D store_targetN(to_cxl_region(dev), buf, (n), len);=
        \
> +               device_unlock(dev);                                      =
      \
> +               return ret;                                              =
      \
> +       }                                                                =
      \
> +       static DEVICE_ATTR_RW(target##n)
> +
> +static void remove_target(struct cxl_region *cxlr, int target)
> +{
> +       struct cxl_decoder *cxld;
> +
> +       mutex_lock(&cxlr->remove_lock);
> +       cxld =3D cxlr->targets[target];
> +       if (cxld) {
> +               cxld->cxlr =3D NULL;
> +               put_device(&cxld->dev);
> +       }
> +       cxlr->targets[target] =3D NULL;
> +       mutex_unlock(&cxlr->remove_lock);

How does this synchronize with memdev ->remove() and decoders becoming
unregistered while still referenced by an active region? I think,
especially for error handling scenarios the region driver will want to
be able to assume that the region will go through ->remove() before
any targets successfully observed by ->probe() can be removed. To me
that means this needs a test for the memdev ->remove() flow and
whether memdev ->remove() could perhaps synchronously trigger region
remove for all associated regions. That would mean that the region
device lock would need to nest beneath endpoint decoder device_lock().
Other flows get easier if region driver flows can assume that until
region ->remove() the target decoder list is stable.

> +}
>
>  static void cxl_region_release(struct device *dev)
>  {
>         struct cxl_decoder *cxld =3D to_cxl_decoder(dev->parent);
>         struct cxl_region *cxlr =3D to_cxl_region(dev);
> +       int i;
>
>         dev_dbg(&cxld->dev, "Releasing %s\n", dev_name(dev));
>         ida_free(&cxld->region_ida, cxlr->id);
> +       for (i =3D 0; i < cxlr->interleave_ways; i++)
> +               remove_target(cxlr, i);
>         kfree(cxlr);
>         put_device(&cxld->dev);
>  }
>
> +static ssize_t show_interleave_ways(struct cxl_region *cxlr, char *buf)
> +{
> +       return sysfs_emit(buf, "%d\n", cxlr->interleave_ways);
> +}
> +
> +static ssize_t store_interleave_ways(struct cxl_region *cxlr, const char=
 *buf,
> +                                    size_t len)
> +{
> +       struct cxl_decoder *rootd;
> +       int ret, val;
> +
> +       ret =3D kstrtoint(buf, 0, &val);
> +       if (ret)
> +               return ret;
> +       if (!cxlr->interleave_granularity) {
> +               dev_dbg(&cxlr->dev, "IG must be set before IW\n");
> +               return -ENXIO;
> +       }
> +       if (cxlr->interleave_ways)
> +               return -EOPNOTSUPP;
> +
> +       rootd =3D to_cxl_decoder(cxlr->dev.parent);
> +       if (!cxl_is_interleave_ways_valid(cxlr, rootd, val))
> +               return -EINVAL;
> +
> +       cxlr->interleave_ways =3D val;
> +
> +       ret =3D sysfs_update_group(&cxlr->dev.kobj, &region_interleave_gr=
oup);
> +       if (ret < 0) {
> +               cxlr->interleave_ways =3D 0;
> +               return ret;
> +       }
> +
> +       return len;
> +}
> +REGION_ATTR_RW(interleave_ways);
> +
> +static ssize_t show_interleave_granularity(struct cxl_region *cxlr, char=
 *buf)
> +{
> +       return sysfs_emit(buf, "%d\n", cxlr->interleave_granularity);
> +}
> +
> +static ssize_t store_interleave_granularity(struct cxl_region *cxlr,
> +                                           const char *buf, size_t len)
> +{
> +       struct cxl_decoder *rootd;
> +       int val, ret;
> +
> +       ret =3D kstrtoint(buf, 0, &val);
> +       if (ret)
> +               return ret;
> +       rootd =3D to_cxl_decoder(cxlr->dev.parent);
> +       if (!cxl_is_interleave_granularity_valid(rootd, val))
> +               return -EINVAL;
> +
> +       cxlr->interleave_granularity =3D val;
> +
> +       return len;
> +}
> +REGION_ATTR_RW(interleave_granularity);
> +
> +static ssize_t show_offset(struct cxl_region *cxlr, char *buf)
> +{
> +       if (!cxlr->res)
> +               return sysfs_emit(buf, "\n");
> +
> +       return sysfs_emit(buf, "%pa\n", &cxlr->res->start);
> +}
> +REGION_ATTR_RO(offset);
> +
> +static ssize_t show_size(struct cxl_region *cxlr, char *buf)
> +{
> +       return sysfs_emit(buf, "%llu\n", cxlr->size);
> +}
> +
> +static ssize_t store_size(struct cxl_region *cxlr, const char *buf, size=
_t len)
> +{
> +       unsigned long long val;
> +       ssize_t rc;
> +
> +       rc =3D kstrtoull(buf, 0, &val);
> +       if (rc)
> +               return rc;
> +
> +       cxlr->size =3D val;
> +       return len;
> +}
> +REGION_ATTR_RW(size);
> +
> +static ssize_t show_uuid(struct cxl_region *cxlr, char *buf)
> +{
> +       return sysfs_emit(buf, "%pUb\n", &cxlr->uuid);
> +}
> +
> +static int is_dupe(struct device *match, void *_cxlr)
> +{
> +       struct cxl_region *c, *cxlr =3D _cxlr;
> +
> +       if (!is_cxl_region(match))
> +               return 0;
> +
> +       if (&cxlr->dev =3D=3D match)
> +               return 0;
> +
> +       c =3D to_cxl_region(match);
> +       if (uuid_equal(&c->uuid, &cxlr->uuid))
> +               return -EEXIST;
> +
> +       return 0;
> +}
> +
> +static ssize_t store_uuid(struct cxl_region *cxlr, const char *buf, size=
_t len)
> +{
> +       ssize_t rc;
> +       uuid_t temp;
> +
> +       if (len !=3D UUID_STRING_LEN + 1)
> +               return -EINVAL;
> +
> +       rc =3D uuid_parse(buf, &temp);
> +       if (rc)
> +               return rc;
> +
> +       rc =3D bus_for_each_dev(&cxl_bus_type, NULL, cxlr, is_dupe);
> +       if (rc < 0)
> +               return false;
> +
> +       cxlr->uuid =3D temp;
> +       return len;
> +}
> +REGION_ATTR_RW(uuid);
> +
> +static struct attribute *region_attrs[] =3D {
> +       &dev_attr_interleave_ways.attr,
> +       &dev_attr_interleave_granularity.attr,
> +       &dev_attr_offset.attr,
> +       &dev_attr_size.attr,
> +       &dev_attr_uuid.attr,
> +       NULL,
> +};
> +
> +static const struct attribute_group region_group =3D {
> +       .attrs =3D region_attrs,
> +};
> +
> +static size_t show_targetN(struct cxl_region *cxlr, char *buf, int n)
> +{
> +       if (!cxlr->targets[n])
> +               return sysfs_emit(buf, "\n");
> +
> +       return sysfs_emit(buf, "%s\n", dev_name(&cxlr->targets[n]->dev));
> +}
> +
> +static size_t store_targetN(struct cxl_region *cxlr, const char *buf, in=
t n,
> +                           size_t len)
> +{
> +       struct cxl_decoder *cxld;
> +       struct device *cxld_dev;
> +
> +       if (len =3D=3D 1 || cxlr->targets[n])
> +               remove_target(cxlr, n);
> +
> +       /* Remove target special case */
> +       if (len =3D=3D 1) {
> +               device_unlock(&cxlr->dev);
> +               return len;
> +       }
> +
> +       cxld_dev =3D bus_find_device_by_name(&cxl_bus_type, NULL, buf);
> +       if (!cxld_dev)
> +               return -ENOENT;
> +
> +       if (!is_cxl_decoder(cxld_dev)) {
> +               put_device(cxld_dev);
> +               return -EPERM;
> +       }
> +
> +       if (!is_cxl_endpoint(to_cxl_port(cxld_dev->parent))) {
> +               put_device(cxld_dev);
> +               return -EINVAL;
> +       }
> +
> +       /* decoder reference is held until teardown */
> +       cxld =3D to_cxl_decoder(cxld_dev);
> +       cxlr->targets[n] =3D cxld;
> +       cxld->cxlr =3D cxlr;
> +
> +       return len;
> +}
> +
> +TARGET_ATTR_RW(0);
> +TARGET_ATTR_RW(1);
> +TARGET_ATTR_RW(2);
> +TARGET_ATTR_RW(3);
> +TARGET_ATTR_RW(4);
> +TARGET_ATTR_RW(5);
> +TARGET_ATTR_RW(6);
> +TARGET_ATTR_RW(7);
> +TARGET_ATTR_RW(8);
> +TARGET_ATTR_RW(9);
> +TARGET_ATTR_RW(10);
> +TARGET_ATTR_RW(11);
> +TARGET_ATTR_RW(12);
> +TARGET_ATTR_RW(13);
> +TARGET_ATTR_RW(14);
> +TARGET_ATTR_RW(15);
> +
> +static struct attribute *interleave_attrs[] =3D {
> +       &dev_attr_target0.attr,
> +       &dev_attr_target1.attr,
> +       &dev_attr_target2.attr,
> +       &dev_attr_target3.attr,
> +       &dev_attr_target4.attr,
> +       &dev_attr_target5.attr,
> +       &dev_attr_target6.attr,
> +       &dev_attr_target7.attr,
> +       &dev_attr_target8.attr,
> +       &dev_attr_target9.attr,
> +       &dev_attr_target10.attr,
> +       &dev_attr_target11.attr,
> +       &dev_attr_target12.attr,
> +       &dev_attr_target13.attr,
> +       &dev_attr_target14.attr,
> +       &dev_attr_target15.attr,
> +       NULL,
> +};
> +
> +static umode_t visible_targets(struct kobject *kobj, struct attribute *a=
, int n)
> +{
> +       struct device *dev =3D container_of(kobj, struct device, kobj);
> +       struct cxl_region *cxlr =3D to_cxl_region(dev);
> +
> +       if (n < cxlr->interleave_ways)
> +               return a->mode;
> +       return 0;
> +}
> +
> +static const struct attribute_group region_interleave_group =3D {
> +       .attrs =3D interleave_attrs,
> +       .is_visible =3D visible_targets,
> +};
> +
> +static const struct attribute_group *region_groups[] =3D {
> +       &region_group,
> +       &region_interleave_group,
> +       &cxl_base_attribute_group,
> +       NULL,
> +};
> +
>  static const struct device_type cxl_region_type =3D {
>         .name =3D "cxl_region",
>         .release =3D cxl_region_release,
> +       .groups =3D region_groups
>  };
>
> -static struct cxl_region *to_cxl_region(struct device *dev)
> +bool is_cxl_region(struct device *dev)
> +{
> +       return dev->type =3D=3D &cxl_region_type;
> +}
> +EXPORT_SYMBOL_NS_GPL(is_cxl_region, CXL);
> +
> +struct cxl_region *to_cxl_region(struct device *dev)
>  {
>         if (dev_WARN_ONCE(dev, dev->type !=3D &cxl_region_type,
>                           "not a cxl_region device\n"))
> @@ -45,6 +387,7 @@ static struct cxl_region *to_cxl_region(struct device =
*dev)
>
>         return container_of(dev, struct cxl_region, dev);
>  }
> +EXPORT_SYMBOL_NS_GPL(to_cxl_region, CXL);
>
>  static void unregister_region(struct work_struct *work)
>  {
> @@ -79,6 +422,8 @@ static struct cxl_region *cxl_region_alloc(struct cxl_=
decoder *cxld)
>                 return ERR_PTR(-ENOMEM);
>         }
>
> +       cxlr->id =3D cxld->next_region_id;
> +
>         cxld->next_region_id =3D rc;
>
>         dev =3D &cxlr->dev;
> @@ -88,6 +433,7 @@ static struct cxl_region *cxl_region_alloc(struct cxl_=
decoder *cxld)
>         dev->bus =3D &cxl_bus_type;
>         dev->type =3D &cxl_region_type;
>         INIT_WORK(&cxlr->unregister_work, unregister_region);
> +       mutex_init(&cxlr->remove_lock);
>
>         return cxlr;
>  }
> @@ -118,7 +464,6 @@ static struct cxl_region *devm_cxl_add_region(struct =
cxl_decoder *cxld)
>
>         dev =3D &cxlr->dev;
>
> -       cxlr->id =3D cxld->next_region_id;
>         rc =3D dev_set_name(dev, "region%d.%d:%d", port->id, cxld->id, cx=
lr->id);
>         if (rc)
>                 goto err_out;
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index d5397f7dfcf4..26351ed0ba65 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -81,6 +81,19 @@ static inline int cxl_to_interleave_ways(u8 eniw)
>         }
>  }
>
> +static inline int cxl_from_ways(u8 ways)
> +{
> +       if (is_power_of_2(ways))
> +               return ilog2(ways);
> +
> +       return ways / 3 + 8;
> +}
> +
> +static inline int cxl_from_granularity(u16 g)
> +{
> +       return ilog2(g) - 8;
> +}
> +
>  /* CXL 2.0 8.2.8.1 Device Capabilities Array Register */
>  #define CXLDEV_CAP_ARRAY_OFFSET 0x0
>  #define   CXLDEV_CAP_ARRAY_CAP_ID 0
> @@ -223,6 +236,7 @@ enum cxl_decoder_type {
>   * @target_lock: coordinate coherent reads of the target list
>   * @region_ida: allocator for region ids.
>   * @next_region_id: Cached region id for next region.
> + * @region: The region this decoder is associated with.
>   * @nr_targets: number of elements in @target
>   * @target: active ordered target list in current decoder configuration
>   */
> @@ -241,11 +255,11 @@ struct cxl_decoder {
>         struct mutex id_lock;
>         struct ida region_ida;
>         int next_region_id;
> +       struct cxl_region *cxlr;
>         int nr_targets;
>         struct cxl_dport *target[];
>  };
>
> -
>  /**
>   * enum cxl_nvdimm_brige_state - state machine for managing bus rescans
>   * @CXL_NVB_NEW: Set at bridge create and after cxl_pmem_wq is destroyed
> diff --git a/drivers/cxl/region.h b/drivers/cxl/region.h
> index 7025f6785f83..e78a049a5729 100644
> --- a/drivers/cxl/region.h
> +++ b/drivers/cxl/region.h
> @@ -13,6 +13,14 @@
>   * @id: This region's id. Id is globally unique across all regions.
>   * @flags: Flags representing the current state of the region.
>   * @unregister_work: Async unregister to allow attrs to take device_lock=
.
> + * @remove_lock: Coordinates region removal against decoder removal
> + * @list: Node in decoder's region list.
> + * @res: Resource this region carves out of the platform decode range.
> + * @size: Size of the region determined from LSA or userspace.
> + * @uuid: The UUID for this region.
> + * @interleave_ways: Number of interleave ways this region is configured=
 for.
> + * @interleave_granularity: Interleave granularity of region
> + * @targets: The memory devices comprising the region.
>   */
>  struct cxl_region {
>         struct device dev;
> @@ -20,9 +28,66 @@ struct cxl_region {
>         unsigned long flags;
>  #define REGION_DEAD 0
>         struct work_struct unregister_work;
> +       struct mutex remove_lock;
>
> +       struct list_head list;
> +       struct resource *res;
> +
> +       u64 size;
> +       uuid_t uuid;
> +       int interleave_ways;
> +       int interleave_granularity;
> +       struct cxl_decoder *targets[CXL_DECODER_MAX_INTERLEAVE];
>  };
>
> +bool is_cxl_region(struct device *dev);
> +struct cxl_region *to_cxl_region(struct device *dev);
>  bool schedule_cxl_region_unregister(struct cxl_region *cxlr);
>
> +static inline bool cxl_is_interleave_ways_valid(const struct cxl_region =
*cxlr,
> +                                               const struct cxl_decoder =
*rootd,
> +                                               u8 ways)
> +{
> +       int root_ig, region_ig, root_eniw;
> +
> +       switch (ways) {
> +       case 0 ... 4:
> +       case 6:
> +       case 8:
> +       case 12:
> +       case 16:
> +               break;
> +       default:
> +               return false;
> +       }
> +
> +       if (rootd->interleave_ways =3D=3D 1)
> +               return true;
> +
> +       root_ig =3D cxl_from_granularity(rootd->interleave_granularity);
> +       region_ig =3D cxl_from_granularity(cxlr->interleave_granularity);
> +       root_eniw =3D cxl_from_ways(rootd->interleave_ways);
> +
> +       return ((1 << (root_ig - region_ig)) * (1 << root_eniw)) <=3D way=
s;

Some comments for this math please.

> +}
> +
> +static inline bool
> +cxl_is_interleave_granularity_valid(const struct cxl_decoder *rootd, int=
 ig)
> +{
> +       int rootd_hbig;
> +
> +       if (!is_power_of_2(ig))
> +               return false;
> +
> +       /* 16K is the max */
> +       if (ig >> 15)

Why the shift instead of the more straightforward:

if (ig > SZ_16K)

> +               return false;
> +
> +       rootd_hbig =3D cxl_from_granularity(rootd->interleave_granularity=
);
> +       if (rootd_hbig < cxl_from_granularity(ig))
> +               return false;

Why do the comparison in CXL encoding vs ordinal:

if (ig > rootd->interleave_granularity)

?

> +
> +       return true;
> +}
> +
>  #endif
> --
> 2.35.1
>
