Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439EB10F3
	for <patches@lists.linux.dev>; Wed, 20 Apr 2022 00:48:08 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id bg24so409161pjb.1
        for <patches@lists.linux.dev>; Tue, 19 Apr 2022 17:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b/5Xml3UsJfHYBkyrgplWoxnlJfCyQ6iKbQrUrhsxdY=;
        b=WQM1KpmZa/Li49Mvjul50ifbFCTGPBMHsjM/qAceg4TINtaTSNT7PkJXaQZIixo+SU
         QW8mlmWkkWIP6R19l6cQKaN46E0zF4tFPSoezEJJuxGZtWvu5sxER8BqD98OfxCFxxI6
         dkAHhpOviVI1cMCU3TAPF44Oa8ZzueQtLqDUZITq59UU7fCYeK/XxNYmukoy59QbybjF
         aVt0pvrNrxWnvKM82uu1m7LNMI42/GRdi5Saa5fV5yfYYzDSyvW351ApdzHh4vVemotd
         WkUaAHRPpBk0Uw7lLYc+dWSLNVz30Rnv3nPzSW7mrZwX4hJKRSUYtm5TqkLG4vx0lqwj
         Xwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b/5Xml3UsJfHYBkyrgplWoxnlJfCyQ6iKbQrUrhsxdY=;
        b=PInxmZ2PAriGtDZ/nk1HHLL+CXmLUEvdaOhjc6H2CY+AXU5RwbX45mXH1VDVOBnsJQ
         iehaReaYKnM8RrJX/UGQb24H+qRQd8m0P0MDL1V/GN348FOfjPZNgj2Zfo9C1eNF8mDk
         57FmLHuUWYpsr7oNDJedgQ3VxaHAAL4wZ5eq2wHt+KqkPfY4AyV8Xao4LPzGOSagiJpE
         W/BqPFeM/ZGAbjBGpJVE6gjsjLfkfSqs1lLOlxcYOkF7QPJimReW6mscuWycB9nwJ1gK
         os1jHRCJXLJc/AD1YPAddMNeP3Ld58BMgbcSr/NjS5mMvWIRacOmecMmyJTDQJvYqAuq
         iclg==
X-Gm-Message-State: AOAM532WEdIHqRVaJlyIu0+rSPHkVLCqLrIJVm0jKRpT3GH330/LurjA
	Cd5CmYVL8vuCc+RdF2QuSiG6DrHT8l9zW6VO0Oyibg==
X-Google-Smtp-Source: ABdhPJyF+Bogu+uAQK3/2kFuuJbnmsTKAy9Yr/FlQVt4ejHuUy1JqvwMPYiX9u0okDB9A+3YW6CIQu0QYoxYpTXD+XQ=
X-Received: by 2002:a17:90b:1e0e:b0:1d2:8906:cffe with SMTP id
 pg14-20020a17090b1e0e00b001d28906cffemr1449388pjb.220.1650415687743; Tue, 19
 Apr 2022 17:48:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-6-ben.widawsky@intel.com> <CAPcyv4iM13nzCpnF5S4oHSWF769t4Av96gQM_3n4E=RAPSnSig@mail.gmail.com>
 <20220419164313.GT2120790@nvidia.com> <CAPcyv4hPBw0yJmu7qzSZ_gsbVuj+_R7-_r3+_W9-JsLTD6Uscw@mail.gmail.com>
 <CAPcyv4hyTRm7K8gu4wdL_gaMm2C+Agg1V2-BbnmJ8Kf0OH4sng@mail.gmail.com> <20220419230412.GU2120790@nvidia.com>
In-Reply-To: <20220419230412.GU2120790@nvidia.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Apr 2022 17:47:56 -0700
Message-ID: <CAPcyv4i5MZcMcCq8V7sZQjqup6MPOoOj2Zuu8HEECADfFi2Tcg@mail.gmail.com>
Subject: Re: [RFC PATCH 05/15] cxl/acpi: Reserve CXL resources from request_free_mem_region
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-cxl@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Christoph Hellwig <hch@infradead.org>, John Hubbard <jhubbard@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 19, 2022 at 4:04 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Tue, Apr 19, 2022 at 02:59:46PM -0700, Dan Williams wrote:
>
> > ...or are you suggesting to represent CXL free memory capacity in
> > iomem_resource and augment the FW list early with CXL ranges. That
> > seems doable, but it would only represent the free CXL ranges in
> > iomem_resource as the populated CXL ranges cannot have their resources
> > reparented after the fact, and there is plenty of code that expects
> > "System RAM" to be a top-level resource.
>
> Yes, something more like this. iomem_resource should represent stuff
> actually in use and CXL shouldn't leave behind an 'IOW' for address
> space it isn't actually able to currently use.

So that's the problem, these gigantic windows need to support someone
showing up unannounced with a stack of multi-terabyte devices to add
to the system. The address space is idle before that event, but it
needs to be reserved for CXL because the top-level system decode makes
mandates like "CXL cards of type X performance Y inserted underneath
CXL host-bridge Z can only use CXL address ranges 1, 4 and 5".

> Your whole description sounds like the same problems PCI hotplug has
> adjusting the bridge windows.

...but even there the base bounds (AFAICS) are coming from FW (_CRS
entries for ACPI described PCIe host bridges). So if CXL follows that
model then the entire unmapped portion of the CXL ranges should be
marked as an idle resource in iomem_resource.

The improvement that offers over this current proposal is that it
allows for global visibility of CXL hotplug resources, but it does set
up a discontinuity between FW mapped and OS mapped CXL. FW mapped will
have top-level "System RAM" resources indistinguishable from typical
DRAM while OS mapped CXL will look like this:

100000000-1ffffffff : CXL Range 0
  108000000-1ffffffff : region5
    108000000-1ffffffff : System RAM (CXL)

...even though to FW "range 0" spans across a BIOS mapped portion and
"free for OS to use" portion.
