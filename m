Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0651465AA
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 16:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718383325; cv=none; b=l5s5vnAcfRBILYOIokSQdfXbT2wOcQHf87CdObx1kLmNZ3jHHCYL4xueiB655BmYKeZPJK9q9EfEoBEOMEmK/nCGs9jATAtwz+UaxcYyFHHT4xUQhIE61g1cKy1/MgOx7H1ZoP1JSxMdYB4qrJpPSlJpVUSO3H1BgS/ZLWYD2Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718383325; c=relaxed/simple;
	bh=Tu5NT+/HC6v33/UcbBllxGhe377ayPb6xdMlPgPUz4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g90MhU9m562ZxHyzMlAYpYx8ja5jntTiGtXOPoOTVG9nqF+dfYtObcYPkJrDO1TspGnG9gbIepSx7dU5FMEr7nkrm98oJ1efxNgO5XQ21W3fC4Z1OYs/H7tzrcnLDtTqbsca9VAsBFbgef2PNrNczme/jYPXshxtizePBwTcPsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g8doRzZh; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g8doRzZh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718383323; x=1749919323;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Tu5NT+/HC6v33/UcbBllxGhe377ayPb6xdMlPgPUz4Q=;
  b=g8doRzZhzm+Bq0M0dCcKSi5WgjawctXZAJgpMP2SDcBzl5rs0dASRzjN
   UFzNoFj4vEoFV7BqktEr+Xf69h75vUMrXBR1aqnnay1cjv5E+hoLs0AiJ
   2DwQixmQnIBxDaUoqUVRpwS5+mC8ePF/CHlMgjC/MDRpIgKmtLONlUeBf
   icQu3qwnxBbR9eoF1DvF4+s/Ci6oqSuOot0ZmLqgsHzMQeYpAbWkrHWCK
   55q5dYrXZyzDmUG1FvaWbkdkokdpspzKXrfs8ViQAqQ5LpN6ULGgq7SAq
   brrym7auD0t925DmdeGCdk/l8CX9nyulWL3aTgZa6hlMksJfWXLLm+oBE
   g==;
X-CSE-ConnectionGUID: RSRFJkjqSVKR3bPI+4YZrA==
X-CSE-MsgGUID: XoGCCBAZQI25ZSXQJwiszQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11103"; a="15114710"
X-IronPort-AV: E=Sophos;i="6.08,238,1712646000"; 
   d="scan'208";a="15114710"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 09:37:53 -0700
X-CSE-ConnectionGUID: xAAM0oc6R0qoOzVa51X18A==
X-CSE-MsgGUID: MWl63vUuR+mg54xeFXB5wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,238,1712646000"; 
   d="scan'208";a="44921621"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.125.111.95]) ([10.125.111.95])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 09:37:51 -0700
Message-ID: <8078be0c-58cb-4288-bbee-639483675501@intel.com>
Date: Fri, 14 Jun 2024 09:37:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] fwctl: FWCTL_INFO to return basic information about
 the device
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Itay Avraham <itayavr@nvidia.com>,
 Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 linux-doc@vger.kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>,
 Aron Silverton <aron.silverton@oracle.com>,
 Dan Williams <dan.j.williams@intel.com>, David Ahern <dsahern@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Jiri Pirko <jiri@nvidia.com>,
 Leonid Bloch <lbloch@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 linux-cxl@vger.kernel.org, patches@lists.linux.dev
References: <3-v1-9912f1a11620+2a-fwctl_jgg@nvidia.com>
 <358d2e11-59e2-46eb-a7f4-3c69e6befe02@intel.com>
 <20240613234002.GH19897@nvidia.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240613234002.GH19897@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/13/24 4:40 PM, Jason Gunthorpe wrote:
> On Thu, Jun 13, 2024 at 04:32:44PM -0700, Dave Jiang wrote:
> 
>> Are you open to pass in potential user input for the info query? I'm
>> working on plumbing fwctl for CXL. 
> 
> Neat!
> 
>> The current CXL query command [1] takes a number of commands as
>> input for its ioctl. For fwctl_cmd_info(), the current
>> implementation is when ->info() is called no information about the
>> user buffer length or an input buffer is provided. 
> 
> Right, the purpose of info is to report information about the fwctl
> driver. It is to allow the userspace to connect to the correct
> userspace driver. It shouldn't be doing much with the device.
> 
> If you want to execute a info command *to the fw* then I'd expect
> you'd execute the command through the normal RPC channel? Does
> something prevent this?

Ok that makes sense. I should be able to do it through RPC with some tweaks. 

> 
> This is how the mlx5 driver is working where there are many info
> (called CAP) commands that return data, and they all run over the rpc
> channel.
> 
> Thanks,
> Jason
