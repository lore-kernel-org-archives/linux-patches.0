Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D804439015
	for <patches@lists.linux.dev>; Mon,  7 Sep 2026 09:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772561; cv=none; b=pwcLECwdUIEO5Y3gJN67VyNgdXJfRiSds+pdcfAp0l36JEfD+6AiuqE5wEoC1UCrb1lUuiefnwnSvbR7RjPrQzK4Yek9Asbxl59NxX98tviqGuwROazVqqSIF22WzoLrSOQR7tj1NvzEKtpW1QyUJVd+a0hUNFmBvC1kWHGIF3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772561; c=relaxed/simple;
	bh=GsiXWnND7HBieMr05yVMUYGcPBTgjXKy5fgF0k5M6ms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qPH7U+gtUPiZwkk0p7Egi0LUXeiHwlZ/RIw6UOLPRABIU0GLrpOq2tcUiG8F/jMflGxA/GnoaZ2qM9YxCi8PB+5IY4Hzelxgnc4qO99mDGt5/vHIwTpGRyc7Qz5/8hq0dLGQgtkz/OPmMeJEqr0vcqy+xD8RyRFYFSSGMGZVC8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H621qOuQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H621qOuQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3450D1477;
	Mon,  7 Sep 2026 02:15:56 -0700 (PDT)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F13553F7B4;
	Mon,  7 Sep 2026 02:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788772559; bh=GsiXWnND7HBieMr05yVMUYGcPBTgjXKy5fgF0k5M6ms=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H621qOuQYQ7mk6c/VbuVw0I0s58WzsECzJ2cOb4NA6WZkypxphNnZh8AsqWhNJHPX
	 3e0RoWZUPfEPUhdurGQDxKhML2tZNucl0WI3p1vqghJUOs4v+77O566O+0VvN3wjZC
	 9APkAvuSEBcGFN2wBNmFGA8+y8hJS1CTqT9K7Duk=
Message-ID: <9e24bfdb-20cd-44ea-8617-9b56f147d5d1@arm.com>
Date: Mon, 7 Sep 2026 10:15:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] fs/resctrl: Drop unnecessary is_mba_linear() helper
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1788452481.git.reinette.chatre@intel.com>
 <b615f948cab09677813ae54e316e10ca96acccf3.1788452481.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <b615f948cab09677813ae54e316e10ca96acccf3.1788452481.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 03/09/2026 17:57, Reinette Chatre wrote:
> is_mba_linear() assumes it operates on the MBA resource and returns whether
> the resource is linear. There is only one caller that separately makes the
> same assumption.
> 
> Avoid duplicating the resource assumptions and let the only caller access
> the needed property directly.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben
