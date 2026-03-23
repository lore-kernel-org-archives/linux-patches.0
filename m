Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7201C390CBC
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 10:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774262987; cv=none; b=HG+MoabDZHL1pzdqJ/c2dhUFj2nhG0ffxwSC1SBqdm8PFxjPtoMlN034FyMTuCM0m/f2tn7PhzdK3lNeuY/NI6oTbJWZ/U52q1KLqSLVL/HbncJ9/isu4qxvWD4NyJRCf/VWRw4NmV7iknfb6R2dPWorSv5KfGVYeM2SCUrtuTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774262987; c=relaxed/simple;
	bh=yT+ywJno7F1fu78c3cW7WYuKxiNBGzt364+YjWo6Dc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PtZfy6sjFDv5n4pZMkwM1YGo38/Xl+gWXNex1PeGWSMMl+hO6BKBu33eaHuAnTO/q0v26znldxTFM3jLI53ZPTl7dxc8w+EDEJ4qWEpGkSPu//xUizqLD3AUUbjspuSULMPcOXto7sbEIRrmQRBzAHLL/DsD/7tBQdL2pmCnu90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 013691516;
	Mon, 23 Mar 2026 03:49:40 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0087F3F73B;
	Mon, 23 Mar 2026 03:49:43 -0700 (PDT)
Message-ID: <a1a692bd-3e97-483a-aed0-8005a08534de@arm.com>
Date: Mon, 23 Mar 2026 10:49:42 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v2 14/14] fs/resctrl: Inform user space when status buffer
 overflowed
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1774043709.git.reinette.chatre@intel.com>
 <0a2c56ac55725fe3131e214297649b9416671b9e.1774043709.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <0a2c56ac55725fe3131e214297649b9416671b9e.1774043709.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 3/20/26 22:03, Reinette Chatre wrote:
> resctrl fs commands are becoming more powerful with, for example, a user
> able to use syntax like '*' to make broad configuration changes. Such
> commands that span multiple domains may result in more than one message
> printed to the last_cmd_status buffer with more planned.
> 
> Display "[truncated]" to user space when displaying the last_cmd_status
> buffer to communicate if it overflowed. Upon encountering this user space
> is expected to combine details about the failure found in info/last_cmd_status
> with related resctrl files to learn the accurate system state after the
> command failure.

LGTM:

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben

