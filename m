Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872529;
	b=zwrhpOqPTYNZYSmfwJ44biKvfmwNSNCWTW6dgqCRtY6ajgVIAXR887vykqMVCIusDCdl
	 re9FB0l/foTkMDnjjKqv4Uwnzvg7x42z6OZn3trbyQ5hMxGJBl8AXRbhT+P4dZtnDv+g5
	 SgooIEio/5mS5fwcQbRdRw0kbRuygIipUzTriMD82mQd59+lcXJfB0qUkZ+/c63mq60Lt
	 09jSdUuXVCDR0siZfThgQCfO5F5hw2pLTp1rT1tEYG/wK8yEZVcXyKSAeYApZ/gB/Rh/C
	 Pyx7q9NPK6JNzS/mdh0VmTTa23+vpia7R1RJGt+QaRml4bGiNQRjcrUodGfmt1u10nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872529;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=qCAlryKPiznzzC2bOV10w77gBQgnhQiwsYcCE2uHqbk=;
	b=rZcfNC4/a3y+klGvm0gBfduyZHX8V+vSuOfmQrv4QE92DCsquY4afyyW4zw/Yu4h5zbc
	 3m5/dhQjN11k3CwF3vEfHpU8RI0bn+1G4quDzobR3+1jeiWUzf37pK9GGKj4iLVHRelhu
	 3dRjdK+3CjPBLvTXw/gkk3EGc6wMrJjGMX8U5AlHMT0Tz0TG+3nN+PVttahyQHy8ViRHT
	 Wbcn/DsUOYMiD5N/UQjHbSoTqD0YPTaexfa5nZgRD0cEXonIqRnSJCprhJ+CtQQr6tceL
	 GUiQDAbwDkTeuKkmYP0UxZp5vQn0oLORn7C00rO+BYSzW+2bMr0NtKdVnnVa1OVmcqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="U8f+kw/m";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25CF8606A329
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 09:55:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25CF8606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=U8f+kw/m
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45813152B;
	Thu,  5 Nov 2026 01:55:24 -0800 (PST)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 283183F628;
	Thu,  5 Nov 2026 01:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793872527; bh=WrQxKHQ/kZJM4MHyEbrJUsdTlIaJZDfgjkNuyt20UIg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U8f+kw/mbaMZU38BUKHT17/25RhQBok5piWEI8zzQc23DKGkUO3zKd/x7MkyTXPd2
	 lVRtS1XWbrtqABoFEB862iRAtqeBSIaaYYBEH9mugx9WgX4w236RyD+Xq0+EH12oN2
	 8X9fmk/JTqBZQSNk+2f7tWduYC6YLGu2zrZSLy0M=
Message-ID: <93382997-2cdb-4433-8130-d03fe49fb0d9@arm.com>
Date: Thu, 5 Nov 2026 09:55:23 +0000
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Add Ben Horgan as fs/resctrl reviewer
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <c68cbba4455d3f5e65c38b76b3daadc04217abca.1793838993.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <c68cbba4455d3f5e65c38b76b3daadc04217abca.1793838993.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 05/11/2026 00:37, Reinette Chatre wrote:
> The resctrl filesystem provides the user interface to the resource control
> features of multiple architectures, among them Arm's MPAM. Ben Horgan,
> MPAM maintainer, has consistently helped keep MPAM's requirements in view,
> both in discussions about new resctrl features and in review of resctrl
> changes.
> 
> Add Ben Horgan as a reviewer so that he is copied on resctrl submissions.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you for the kind words and adding me as a reviewer.

Acked-by: Ben Horgan <ben.horgan@arm.com>

> ---
> Position entry to avoid conflict with RISC-V change in same area:
> https://lore.kernel.org/lkml/20261104-dfustini-atl-sc-cbqri-dt-v10-6-1636a003a3c0@kernel.org/
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 93abbb315065..04bdbba16138 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23460,6 +23460,7 @@ RDT - RESOURCE ALLOCATION
>  M:	Tony Luck <tony.luck@intel.com>
>  M:	Reinette Chatre <reinette.chatre@intel.com>
>  M:	x86@kernel.org
> +R:	Ben Horgan <ben.horgan@arm.com>
>  R:	Dave Martin <Dave.Martin@arm.com>
>  R:	James Morse <james.morse@arm.com>
>  R:	Babu Moger <babu.moger@amd.com>

