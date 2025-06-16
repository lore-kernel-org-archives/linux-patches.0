Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878BA26A0B1;
	Mon, 16 Jun 2025 03:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750044302; cv=none; b=MFf19TZXpTYqaaGJnO3UadvtY4qnNrZc+0oqy3cA9JxKr9ICupaW7CkhU58PY0pH7qHPhVQIS/jhhQDq5QLCMhvbY4BE1L1jxmEUUuTlyagRXDIiF+D/T49dZrkNwGSYxAv3eMtCwsBilIb4YGB1KnDfNoAyqd+mMTMt4WoDZUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750044302; c=relaxed/simple;
	bh=991ULLpHUbVw9p6UNw/8MBW4ebTq3XFmPrdhOHxLq/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NR1pPFbXSyyhngYeoHCdD27Vl5g1GJXQjGjy5Z/efp7mMJcFNrZJ76CXKMTpz4DD8vU6eMu/aAUvA8FYMDaA0FOzG17I3Yw3+DLAY1jLBAXP5oUBXt3mjrIhcWRz8lSYMF7x380xf4ELUIia9lDvMw6B2zyBb8bpAgHXs10FhCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BY8DR0r9; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BY8DR0r9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750044301; x=1781580301;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=991ULLpHUbVw9p6UNw/8MBW4ebTq3XFmPrdhOHxLq/A=;
  b=BY8DR0r9uqIzU/TgnOk1ZlXDPOZy+arbvpCSXwXJKMraTPE73XDYCgFv
   IRlm/pwE0lxTkFlsM3BX5e+3/bqEYNkksCV9AnWxtF+jZBeuR3uaQygBe
   C3PNZ2dLc3ejeHjkRR0ohBqfs+9dQIRYVF8aEdF0xho4LuKIHGe6xypFc
   NQEF/v2X7w3jTMw2ZmOJxjo61OonKYZx6lhAIpRXbmBRSe3hvowuW86qR
   hjSIKsMR6HRjo33URH+A1S0osMUZhelUtvvAEZdgAvN7i/UYBSYyDxo/i
   vc1XU/8L3/vMPek102mU2tuEX8hP0xk7S3euDflxTL8aCSLDJHvYJ9+31
   w==;
X-CSE-ConnectionGUID: GKTVK7AjRxWIyAoKl9mZlQ==
X-CSE-MsgGUID: i5X7+zXjSvOhP/+GXeNrFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="62449403"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="62449403"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:25:01 -0700
X-CSE-ConnectionGUID: 8eZ9bU/fRcmzJr4K1Owyxw==
X-CSE-MsgGUID: NgfO9NH6SBScxtdx7XBJ9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="148205472"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:24:58 -0700
Message-ID: <8cd5db54-66ba-4611-8b47-448d3c008a14@linux.intel.com>
Date: Mon, 16 Jun 2025 11:23:58 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/14] iommufd: Drop unused ictx in struct
 iommufd_vdevice
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, praan@google.com,
 yi.l.liu@intel.com, peterz@infradead.org, jsnitsel@redhat.com,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <6cbb65e8df433de45b6c3a4bb2c5df09faca8a7c.1749882255.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <6cbb65e8df433de45b6c3a4bb2c5df09faca8a7c.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/25 14:35, Nicolin Chen wrote:
> The core code can always get the ictx pointer via vdev->viommu->ictx, thus
> drop this unused one.
> 
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
