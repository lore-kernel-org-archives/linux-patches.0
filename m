Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4EB1EEA40;
	Wed,  9 Jul 2025 05:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752039594; cv=none; b=E0AfiZ6Xpc96IjOKudztMcWrZ1TNH7KdgIU0+c0Bn42y/A6rar7mBPuo/NDWQ1sRaSRxkW/tQ4s9ES+C9PiL1+67etPkENX4Dz9s2M9gzjmdCIgcAfmkc9cNe5E8KJfEt4vRUEfFrrwPnTnS3xv3j7opaLfSc9XEjg+8KQHQP1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752039594; c=relaxed/simple;
	bh=7zwyVyoHgAp6lLK9cesg4Iul0W95lo/nbGluCqo3G9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0oxxR7s0QIJA/1T73zxG6xf85hKa8PLJesG2scimdz2ehq8QeidqaK2F0NB01okOOHDJxmRiBNT0dsYEFPV8MOdwg1Rss6Pd0Men/4//sqwr/pVsTTwhrciarzN4gUXeCUfVelTHLGs75E1akViG25FOiQGHdTSyX4fHinSAo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JOoSWdp7; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JOoSWdp7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752039594; x=1783575594;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7zwyVyoHgAp6lLK9cesg4Iul0W95lo/nbGluCqo3G9s=;
  b=JOoSWdp7HVGji8y0HLuvzMhI+JMhf+Hop9tkt3KG3ueFktHYJzKqJg4B
   PCKWf+aSDuWi0sT4F5CfKqcfeGyV76w4I0qrEVLJKsIXI3JbXfGy5A2I8
   wHdoDCWuyQYDFSdX15YIRxBRFLbZ6lRkKkOGMFdNQ5L54iCVZPpNTr1Vh
   wn/h58SnuXXmRn1KIvcyNzENqyn/pfFjJ7kbMuvd2apt7aJl5BFAsByfe
   meHeGL+HOhyzaWuKd4StXQheJkkrJJ8En3wMy/3HnTOFzJQCxstngBevG
   Hl3QiOEjaKQkViUrOJtq5rPT9lbTDH6P4Oa3uHq2pTNKQq4vAvmv/nK4i
   A==;
X-CSE-ConnectionGUID: 3yBS+toiSCGykQO9v5+t8Q==
X-CSE-MsgGUID: wjoClcjvR3ibDhn2viUfGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54263531"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54263531"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 22:39:53 -0700
X-CSE-ConnectionGUID: 1z9kBPWUQaO4T6V0PNAAtA==
X-CSE-MsgGUID: cEmge3AYT7uhOk7zwVLTTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155303315"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa007.fm.intel.com with ESMTP; 08 Jul 2025 22:39:47 -0700
Date: Wed, 9 Jul 2025 13:31:31 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, will@kernel.org,
	robin.murphy@arm.com, joro@8bytes.org, praan@google.com,
	yi.l.liu@intel.com, peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 13/14] iommufd: Introduce iommufd_object_alloc_ucmd
 helper
Message-ID: <aG3+s8rzcjeKazG8@yilunxu-OptiPlex-7050>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <e7206d4227844887cc8dbf0cc7b0242580fafd9d.1749882255.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7206d4227844887cc8dbf0cc7b0242580fafd9d.1749882255.git.nicolinc@nvidia.com>

> @@ -61,6 +61,24 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
>  	return ERR_PTR(rc);
>  }
>  
> +struct iommufd_object *_iommufd_object_alloc_ucmd(struct iommufd_ucmd *ucmd,
> +						  size_t size,
> +						  enum iommufd_object_type type)
> +{
> +	struct iommufd_object *new_obj;
> +
> +	/* Something is coded wrong if this is hit */
> +	if (WARN_ON(ucmd->new_obj))
> +		return ERR_PTR(-EBUSY);
> +
> +	new_obj = _iommufd_object_alloc(ucmd->ictx, size, type);
> +	if (IS_ERR(new_obj))
> +		return new_obj;
> +
> +	ucmd->new_obj = new_obj;
> +	return new_obj;
> +}
> +
>  /*
>   * Allow concurrent access to the object.
>   *
> @@ -448,6 +466,13 @@ static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
>  	if (ret)
>  		return ret;
>  	ret = op->execute(&ucmd);
> +
> +	if (ucmd.new_obj) {
> +		if (ret)
> +			iommufd_object_abort_and_destroy(ictx, ucmd.new_obj);

Sorry I didn't follow this thread before and maybe missed something.

According to 70eadc7fc7ef, abort op is for the object that can assume
the caller is holding the lock. But here is for no locking, so calling
iommufd_object_abort_and_destroy() is quite confusing.

Is it better we change to:

	if (ret) {
		iommufd_object_ops[obj->type].destroy(obj);
		iommufd_object_abort(ictx, obj);
	}

Also explicitely assert iommufd_object_alloc_ucmd() and abort can't be
used at the same time.

in _iommufd_object_alloc_ucmd():

	if (WARN_ON(iommufd_object_ops[type].abort))
		return ERR_PTR(-EFAULT);

Thanks,
Yilun

> +		else
> +			iommufd_object_finalize(ictx, ucmd.new_obj);
> +	}
>  	return ret;
>  }
>  
> -- 
> 2.43.0
> 
> 
