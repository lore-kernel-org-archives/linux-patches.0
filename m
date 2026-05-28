Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E639338B14D
	for <patches@lists.linux.dev>; Thu, 28 May 2026 10:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779962794; cv=none; b=r22YxYMUC5f6PIFoclsiB+9iAJhYGvHjbgLnrAyKzLkYh1Lo1TZ6H9h1G44ELEVl2RcFxJenyXCDVGhgmKXCQa18VCgiqHr2Dydxv5xgunm+gVUC7O51KMrRRfxFq60NoefI6dlU43GIbrMbQfYL7Hxb8oN5J60yo1SpgO4Z420=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779962794; c=relaxed/simple;
	bh=xftLrBUvvCJVX6E/W9YWdV08iAMIX6wKufd8P3TGrDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tM0XkpFRI/brwNDGdXnZrwl6nAimP3Xn8MOKOu6vgq/O0sQpPIcqC/EnhLK+dfSAA987RcSQkncgSNnrQ812f+VISpMw8K5mrpVTl79wB0YEPHZdbFapBSt/OXAl5+/L75cKmItl1hclU32QgP/lguR6EJ30RLVfNDKkqReNVrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qLBPI1il; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qLBPI1il"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B8DB43F7;
	Thu, 28 May 2026 03:06:27 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 23C7E3F905;
	Thu, 28 May 2026 03:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779962792; bh=xftLrBUvvCJVX6E/W9YWdV08iAMIX6wKufd8P3TGrDQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qLBPI1ilxvAUD4xkp2+LEXCAAPl8VqoicyBkSLCD/0SuoXt2sPacI/xyb2sIaNngz
	 SSGbMeaJ0i2lZjUsTSWyWcIdu6oUDZiQ86oFYRp0tX9cliKkOvXhQhCkAfSPSmUEeK
	 9AwvKFkfV6+yXuixg7vslWSfqWzMjSXeVgmjZXuc=
Message-ID: <c9695e1a-7147-4a3f-b11a-350ef02b10ff@arm.com>
Date: Thu, 28 May 2026 11:06:28 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v3 1/9] fs/resctrl: Move functions to avoid forward
 references in subsequent fixes
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <872066b8b05a0dc1cbc81d57ec7154f9566de755.1779476724.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <872066b8b05a0dc1cbc81d57ec7154f9566de755.1779476724.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 5/22/26 20:15, Reinette Chatre wrote:
> From: Tony Luck <tony.luck@intel.com>
> 
> rdt_get_tree() manages resctrl fs mount and rdt_kill_sb() manages resctrl
> fs unmount.
> 
> There is significant overlap between error cleanup during resctrl mount
> failure and cleanup on resctrl unmount yet the cleanup is not done
> consistently in these two flows.
> 
> Pull some cleanup functions before rdt_get_tree() in preparation for
> a new helper that can be shared between mount and unmount.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben


