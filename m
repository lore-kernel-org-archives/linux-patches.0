Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0AF225403
	for <patches@lists.linux.dev>; Sun, 17 May 2026 05:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778997422; cv=none; b=CdYs8H4oMNIU9sonwgmgnK0Ip1ZbIq4ya2dt+jz4qNnb9Ml7GscTMRVml2R4kFkixRekFcJZjI2QduX7ElUfJgnwdiLxaEzip8ScTxN/eYYppaP6nChjuSqIbH59ueHQKbCDWVyLaFr2o9xlZhDfsw070V9QuXjN6a1t5DCZMGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778997422; c=relaxed/simple;
	bh=z5iKw7knCqvhosp6SwEAcvPLpVQIuOAThPus+wqKUcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3NAQDMUE4bdzd7rwVOV7BJ0OcBwSRwTvvIVVseweJWNvSDhrs2k4kjfa8FVGcGR/9G+ht5goekQH5OWP3E22XCqP6G3FGuFOBp0srkre2YFmP4nTYG/70hONrm2uzThwtKdBz/UC+NdfOTp9uKlEBbjJ8PPX75CTGbAiPIw7LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=SdG5msm1; arc=none smtp.client-ip=209.85.221.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="SdG5msm1"
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-449d6c68ed8so1047292f8f.0
        for <patches@lists.linux.dev>; Sat, 16 May 2026 22:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1778997415; x=1779602215; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTNBKqww0E/Ss/YTsCa1J9TnzG+c7rqJLWELtZ0os+o=;
        b=SdG5msm1jw8x9za5vjfVFO8hRaYyxhozBG99ErOIheD3/XO/iPvGD5nVpncaFjS7d6
         r6DeFljnWGxx93LIuXjLlCT8vCENRbcgCasa3F8vZ+bCXDAJ6jf2hAueVuCo2HRcaKYf
         lLb+29CQS+Iw7Qi+3LqPzgi7BLT0fO6KdC/ScFdqOsN9uiLUqoKiAqTWR68/5CwATVLk
         pzyxweEz/l9QujplsyQkHX9cxw41GkftDG5h96iObRw+8/xNojcLkPRgyQQVxVay+xI/
         2rIf90Fv6RM4LI7HNnObbcquMdcbP3+qBVIYGiEEOfgCIj+R7h5JjF/Ed7PI7pQRb7Ve
         onrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778997415; x=1779602215;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZTNBKqww0E/Ss/YTsCa1J9TnzG+c7rqJLWELtZ0os+o=;
        b=NhffSbIDjeCtGu7rXf6xz3BOX4dd6I2pun9bLUscsgGzuq48d0PEgwu1tufc+mnarQ
         OE+5VQkHDedFPQ7JSRZ7pqD6blNc94oUQD4Hw5/aNriCqEkvpDyANv8MtAJ1jSZ44D8x
         91ZZcoMRYIu1RHcLBxr6P/tSI7zk7knwr/shfGN5nWoDtugTcIGJV+JMUcC1NdHbm+zA
         N/UjGmHCjRy+eHkgwGYkmrgaQ2HcpVWTmkGeqyclnRbpnEMboOtfqKgXiC2cdo9rMqfN
         m6bpNHAXnKBZnfG2FOHD+G7MLQA6DoLoCm/9breJFCkEzBWZhdlboIQnxVGAHtxyAM9K
         erdg==
X-Forwarded-Encrypted: i=1; AFNElJ+XEytPCaBMcX1FCqw2HY1/STRjfmctFVUFY/QIDoiyl6dmn3pG1YMGYAxkrDSOXQu40ENZvg4A@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2c90EvNmlEJwNy+JAtzfkSs1nWCOBrRyPLC1UcKVrSJtQjr+5
	/WgmN6E0Zw70ce5LVQOFUScKbwM7AHpmMKPhpb4aqvbCpDLNrKRkhd3WJzfXZef3sm4=
X-Gm-Gg: Acq92OGf5a7U4vQck2OA7OLnx8/ssechaOnCcwIjkOASmoOAqSiurafY4BGuLWztdqW
	b7mhtHWin07hqvq4jeGY8rXjS1MATJt6mf2sipWSMvuZZAvig/W9DNCkUMsX1HXYad+vvCQXnk/
	6I7Jr+4JHJecU0cn4OO1+B3TD5YyYySUe6wPAAIbgW41tDBiUqzFd9ForeuKxraqy0YWSLBsIRB
	j9j194MC9JjOp5ZhqLbwSu/8YZN7bKd5WnV+oKD7yfEQwsxBOIAtBFBG4naPfjOdvR43dwVKndG
	rFznKhe6uvbTRJCwioI+KF+kw42hskgoSUd4vQu+u83vDykvSS2AG3tgeNS/JW+gI77mGNIUi6u
	k4zmUS5Gbk9srooENJnLTewkEcUekFRmQp2V58dnl7i41RcyToa/O5J87whMhXXt+aQMneIBFcZ
	2ejKu7T13vryOkkjVNXbs65nZaYgGcdolspx7+f3hpmqjtI1t48TytUA==
X-Received: by 2002:a5d:588f:0:b0:43d:77e1:6a69 with SMTP id ffacd0b85a97d-45e5c5a4dbdmr14164907f8f.38.1778997415401;
        Sat, 16 May 2026 22:56:55 -0700 (PDT)
Received: from FV6GYCPJ69 ([2001:1ae9:6084:ab00:7168:3127:200b:5d86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e768c4fsm27443706f8f.8.2026.05.16.22.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 22:56:54 -0700 (PDT)
Date: Sun, 17 May 2026 07:56:52 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, 
	patches@lists.linux.dev, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: Re: [PATCH 5/6] RDMA/core: Move ucaps into ib_uverbs_support.ko
Message-ID: <aglX-m1INAy_MfTh@FV6GYCPJ69>
References: <0-v1-045258567bd6+9fe-ib_uverbs_support_ko_jgg@nvidia.com>
 <5-v1-045258567bd6+9fe-ib_uverbs_support_ko_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v1-045258567bd6+9fe-ib_uverbs_support_ko_jgg@nvidia.com>

Wed, May 13, 2026 at 07:33:27PM +0200, jgg@nvidia.com wrote:
>mlx5 uses these move them into the support module from ib_uverbs.ko.
>
>Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

This breaks the build:

  drivers/infiniband/core/ucaps.c:59:3: error: non-void function 'ib_cleanup_ucaps' should return a value [-Wreturn-mismatch]
     59 |                 return;
        |                 ^

The signature was changed from void to int and a "return 0;" was added
at the tail, but the early return inside the !ucaps_class_is_registered
branch was missed:

	static int ib_cleanup_ucaps(void)
	{
		mutex_lock(&ucaps_mutex);
		if (!ucaps_class_is_registered) {
			mutex_unlock(&ucaps_mutex);
			return;             /* <-- needs to be "return 0;" */
		}

[..]


>@@ -265,3 +266,6 @@ int ib_get_ucaps(int *fds, int fd_count, uint64_t *idx_mask)
> 	mutex_unlock(&ucaps_mutex);
> 	return ret;
> }
>+EXPORT_SYMBOL_NS_GPL(ib_get_ucaps, "rdma_core");
>+
>+module_init(ib_cleanup_ucaps);

Shouldn't this be module_exit()?

[..]
