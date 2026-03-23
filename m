Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9104F39151A
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 10:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774263274; cv=none; b=VyR1aHIB0mLqiDyPmPgMXmCCLJdoi9zWZhAHh71/yIppcesedvj75pRL2MNCj7MbpnQuX4NKrgJSwqjOeZWBQMXs4jYU4qOfUSmcs7rBqkSAcjP3ZIXy95ySgesVmI9gSu6glvb5dOvqLeGqLPcYhSU0qWGQW0RMGwPuaFJ2j/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774263274; c=relaxed/simple;
	bh=0T0y9O398fjZ0in1MAxvXmHAPTzbhGfVuGLxYaZrFZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kk/DvnD8fRyXai+nKnLEpH13rqqpqcMXSf0gekDANrfJRTGZHcsOdQDmrqAufqtTwj4EBNO04Een9oFoqSHsUbhQ3TgWEowiQWDkzNI59Rbb+Qo6a7ahMqhfJxulriYYZFdtS9cWwh0L1Vp3fSsx0ovK20zBLPLQH7qR8IinkPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 197211516;
	Mon, 23 Mar 2026 03:54:26 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B1E53F73B;
	Mon, 23 Mar 2026 03:54:29 -0700 (PDT)
Message-ID: <3627e420-a44f-471b-8b57-84d910131a29@arm.com>
Date: Mon, 23 Mar 2026 10:54:28 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v2 07/14] fs/resctrl: Use accurate type for
 rdt_resource::rid
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1774043709.git.reinette.chatre@intel.com>
 <1ae8867b43acb509f6359139297ee3a340bd0441.1774043709.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <1ae8867b43acb509f6359139297ee3a340bd0441.1774043709.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 3/20/26 22:03, Reinette Chatre wrote:
> Every resctrl resource has a unique ID described by enum resctrl_res_level.
> enum resctrl_res_level is used in all resource ID initializations and all
> resource ID comparisons. All functions consuming the resource ID expects an
> enum resctrl_res_level. Of the four structures that contain a resource ID
> (struct mon_data, struct mon_evt, struct rdt_domain_hdr, and struct
>  rdt_resource) only struct rdt_resource does not use enum resctrl_res_level.
> 
> Switch the type of rdt_resource::rid to be enum resctrl_res_level to make
> it obvious what values are valid, match the type everywhere this member is
> used, and obtain benefits from tools that can flag any enum misuse.
> 
> Move define of RDT_NUM_RESOURCES outside the enum to enable tools to catch
> when a switch() on the resource ID does not handle all the resources and
> thus help flag which switch statements need an update when a new resource
> is added.

LGTM

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben

