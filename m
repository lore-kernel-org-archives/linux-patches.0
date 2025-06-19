Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F9D221704
	for <patches@lists.linux.dev>; Thu, 19 Jun 2025 09:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750326565; cv=none; b=uJa0JPSqSovQ0efvMWPG1h9kA+FFd9GTY5bs6n5YR7TgT9kj/IG9NQgl7T7RKlYqkkgdRaSi2w2sfLG5+BI6sHyj4stAQ9irBfevWWfWx39mRF55/21AcIapuRMKX9o9Q6Z6J0KsH26yqmh4/t7BwnMYy6uS4Hwz9C8tS4C66e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750326565; c=relaxed/simple;
	bh=3LkyeQl0t9LM+cj52xpO+Ax9lI0k6dCYkCdTOXS+hWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q7C2OBZA+k9Lar2EslzUEgHbi402qmXXwyAVs7WYC5MbF23VrsrQZCqT/vWfHpDWrFGHDCwgjN6xK76PHT/qLNSMyqKT1IzW0L49Hsw9BuBsf8mP5ek48R/+utuHysElID6Sk629YFNxixV92dSWFH+n7pQZt+FspZxzzwpH0uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JGgcvCRf; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JGgcvCRf"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2348ac8e0b4so111125ad.1
        for <patches@lists.linux.dev>; Thu, 19 Jun 2025 02:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750326562; x=1750931362; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=17oxjeeFsHFeG65L770MNpFPAUdse/NuAwqFBcFBF84=;
        b=JGgcvCRfTC4wEkUcctXxlsxIBZXG1zlYPKMy9JqFi7UTwp5+0Hkvu7cIlGZ0UCoelX
         TChjqncu94js1E0fqy+cJiOT82plxZ7uf0zUX5N0OFwCoZDuktmaZ0dre0tkgiNV6Hgp
         PIDyFJzxL6yC3GAQnvhd6dK32EkQjlJ0tcwZ6qAqqtdzgVxiS9ps6tGLlx4AjCZMEZtu
         yXOGXG63Yy1wQmSI6C8qyL/TdPYxvO1AXqfmdw3Iopl61+3fJdYgvBNxtcegLzLnWBMh
         Wvx7e2tNgqZ5ctptECKKYizsguV2RFO7EMKYviVXXIBt/mxsTpdmZZnmWelsSK2R+6Ii
         oqcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750326562; x=1750931362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17oxjeeFsHFeG65L770MNpFPAUdse/NuAwqFBcFBF84=;
        b=toBvNW3/udXOkge5YgZLj7YFpUdK61Q28mbLwP3Vr+Y3zNA3u5PWrLC5MD7dOD1VaS
         RBalB1ssJMg6JeJJn+8LKuSYztyB8FUbQD7ygtIUM42rjm18IqxA5dGA8twYGAcFZeUp
         1Ccb5ANomDPzwC5bj1adcVvNtFKBA8rwKxqfXAXRl1GZV7KT2r36vM/9pkpQACoq6kiq
         egZ/qdQptL2W1ERAEZxPSbRDjCO7/IjfVquKoLsDCvtGPc+EbLmok8YgQU6dUZqkl02E
         qCBIHchrxSaWnhSLbixtlTulbgO11X5Vv++ys2lZXXQ4vSc0eWca3rUBMEy+BcpCGube
         XgMw==
X-Forwarded-Encrypted: i=1; AJvYcCXF3WzTUcf76QA9iTTEfgj3cq/71gBh7bevpWlwXMySrx8YL2fq57P6bH727T8pIlI3HuVpRyF6@lists.linux.dev
X-Gm-Message-State: AOJu0YzK/ZTr50lH285vX4xOmseuNGNVUXgJyrGSnLW2fLjc/P4khUQj
	yCWoPodzUYJKMcZ3NsyCyIeiZlBSAeuG2pMI/u5nRaL8ft6CwOLaEYR83VJeDj3bZA==
X-Gm-Gg: ASbGncuFrC65bf5oym4xVqxwTA/dRzyEYePHLjA9/XWOHsW7ePFNJ6EA+g53i6HcdfZ
	KstlhvlXJdEdAPtdNgyqMlAND5EzAoGmIg5vfim9upQXsJe0g69D/DmVgjS4wLfRP0TCXw6AzR6
	3JEn74tJ4Pr5lUUWBniMp+xrRALmqCyHYIva70WYsH9GKmimQaVdoki0TwYiie1Zew5IGgwTGve
	0c2SuKFgmmjYoisbBo8eopOAqoLi8T4cnjJJrFTAXwer/K7dHQ7YHAZ3RofotcF+4AurA9DbwGa
	OCthiZ1hgccjiTqUsFxYhsyuUU38io9ZMHjEaQW6H7zvMwwztt0yfIwc5JWnbUBHmMYW4vTw9/7
	OorNcz1aSZYzSySDc+Pr5
X-Google-Smtp-Source: AGHT+IEuCYASVN8j1eZMJIcAvoBEAqstpKSSgGIYZ2iYQuSQhTyrI+a8+/330LWZVAAW9AYW4syqlA==
X-Received: by 2002:a17:902:fc46:b0:234:bcd0:3d6f with SMTP id d9443c01a7336-237cdfe9619mr1746815ad.1.1750326562236;
        Thu, 19 Jun 2025 02:49:22 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365deb04a6sm116435595ad.178.2025.06.19.02.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 02:49:21 -0700 (PDT)
Date: Thu, 19 Jun 2025 09:49:10 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, kevin.tian@intel.com, corbet@lwn.net,
	will@kernel.org, bagasdotme@gmail.com, robin.murphy@arm.com,
	joro@8bytes.org, thierry.reding@gmail.com, vdumpa@nvidia.com,
	jonathanh@nvidia.com, shuah@kernel.org, jsnitsel@redhat.com,
	nathan@kernel.org, peterz@infradead.org, yi.l.liu@intel.com,
	mshavit@google.com, zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com
Subject: Re: [PATCH v6 07/25] iommufd/access: Add internal APIs for HW queue
 to use
Message-ID: <aFPdFnKvus57cGOU@google.com>
References: <cover.1749884998.git.nicolinc@nvidia.com>
 <64145b184a0fa7c9b60532c9b475a51625edb77c.1749884998.git.nicolinc@nvidia.com>
 <20250616133719.GC1174925@nvidia.com>
 <aFDSNYOTToFSbFA2@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFDSNYOTToFSbFA2@nvidia.com>

On Mon, Jun 16, 2025 at 07:25:57PM -0700, Nicolin Chen wrote:
> On Mon, Jun 16, 2025 at 10:37:19AM -0300, Jason Gunthorpe wrote:
> > On Sat, Jun 14, 2025 at 12:14:32AM -0700, Nicolin Chen wrote:
> > > Now, access->ops can be NULL, to support an internal use case for the new
> > > HW queue object. Since an access object in this case will be allocated by
> > > an inernal iommufd object, the refcount on the ictx should be skipped, so
> > > as not to deadlock the release of the ictx as it would otherwise wait for
> > > the release of the access first during the release of the internal object
> > > that could wait for the release of ictx:
> > >     ictx --releases--> hw_queue --releases--> access
> > >       ^                                         |
> > >       |_________________releases________________v
> > > 
> > > Add a set of lightweight internal APIs to unlink access and ictx:
> > >     ictx --releases--> hw_queue --releases--> access
> > > 
> > > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > > ---
> > >  drivers/iommu/iommufd/iommufd_private.h |  8 ++++
> > >  drivers/iommu/iommufd/device.c          | 59 +++++++++++++++++++++----
> > >  2 files changed, 58 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> > > index 4a375a8c9216..468717d5e5bc 100644
> > > --- a/drivers/iommu/iommufd/iommufd_private.h
> > > +++ b/drivers/iommu/iommufd/iommufd_private.h
> > > @@ -484,6 +484,14 @@ void iopt_remove_access(struct io_pagetable *iopt,
> > >  			struct iommufd_access *access, u32 iopt_access_list_id);
> > >  void iommufd_access_destroy_object(struct iommufd_object *obj);
> > >  
> > > +/* iommufd_access for internal use */
> > > +struct iommufd_access *iommufd_access_create_internal(struct iommufd_ctx *ictx);
> > > +#define iommufd_access_destroy_internal(ictx, access) \
> > > +	iommufd_object_destroy_user(ictx, &(access)->obj)
> > 
> > Use a static inline please
> > 
> > > +int iommufd_access_attach_internal(struct iommufd_access *access,
> > > +				   struct iommufd_ioas *ioas);
> > > +#define iommufd_access_detach_internal(access) iommufd_access_detach(access)
> > 
> > 
> > >  struct iommufd_eventq {
> > >  	struct iommufd_object obj;
> > >  	struct iommufd_ctx *ictx;
> > > diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> > > index 9293722b9cff..ad33f1e41a24 100644
> > > --- a/drivers/iommu/iommufd/device.c
> > > +++ b/drivers/iommu/iommufd/device.c
> > > @@ -1084,7 +1084,39 @@ void iommufd_access_destroy_object(struct iommufd_object *obj)
> > >  	if (access->ioas)
> > >  		WARN_ON(iommufd_access_change_ioas(access, NULL));
> > >  	mutex_unlock(&access->ioas_lock);
> > > -	iommufd_ctx_put(access->ictx);
> > > +	if (access->ops)
> > > +		iommufd_ctx_put(access->ictx);
> > 
> > I was hoping we could null the ictx to signal internal? That didn't
> > work out?
> 
> access->ictx should be NULL for internal. It should have been:
> +	if (access->ictx)
> +		iommufd_ctx_put(access->ictx);
> 

Ohh sorry, just saw this. +1, I too believe this is better than relying
on access->ops being NULL.

> > I would at least add a comment here this is filtering internal that
> > doesn't have ictx. Maybe a little inline 'iommufd_access_is_internal'
> > is appropriate. We'll be sad down the road if we need ops for
> > internal.
> 
> Yea, an inline will be cleaner. Will add that.
> 

Ack.

Thanks,
Praan
