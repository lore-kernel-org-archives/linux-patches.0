Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBBC2BE642;
	Wed, 25 Feb 2026 06:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772001995; cv=none; b=t75d6QcKM+eGGP5PG5uJ6c7c2MY8cRJ7MPzSzIZxFgfrxBhNbToxwpJJHJcQ8NG9s3ievPkzUuPbwYqJrguU/OFSnChuGZ6dfTAwknOR1ku/ceiqvlMj7qnhDwAtjQ/67B4QqrHc8h1GMi45EzTvdIP3j/1KGfiZNnZdZPmFETY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772001995; c=relaxed/simple;
	bh=BeJA7G0siXCB3Ao0rY8v9Oc6tjvzqZacEfVv9U5JCDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gf2nW4RLSawpL/9zK9fspWTcNusrGr2LZ6SQyV2ZsI2foizfkEY04i8r6mUBnMTzypAbp4aZnw7ouwo5M/C3DoALM/5W4CZeJc3Y2yGgUzo1HnFgbcUed8yHc87rf4/k9bxjG1g9+LhXrVR58Q+ednpinofbE1pSXXxZSnooYv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7gXHvXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7gXHvXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C271C116D0;
	Wed, 25 Feb 2026 06:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772001994;
	bh=BeJA7G0siXCB3Ao0rY8v9Oc6tjvzqZacEfVv9U5JCDo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H7gXHvXnzmnMWM7+iAxoPIOXocftNXhJZ+n+zqM7uf0gTE99Vx+PinVHq95ZRlL5U
	 E5EzA5zli6/ghg/UlNV/yi2DiBxx5V0pnjaIG30gYsE3vz8dYo1ACt9CxZc1+1vn0N
	 31anOLFCi5nJ4OyE6rriK5Aua3DoIV/k0SzDYfX8sLINZXIVuVByLHxKXdBG1h34B5
	 vYNZKnJIWG0v7SLpsyPmwkWL0CAWUWf9o0S5UtK5BhNbeckNJWSKKKMmSjXu2Jbuxu
	 r7tkWXd5hqeAXitVw404foXgvL24Q/TmdqpfKO4euM3k+HfW1S9yCJeY2wXobDj9rG
	 eVTOLvN+T1nLg==
Message-ID: <96928eb5-bfa8-482b-9555-3662e25803cf@kernel.org>
Date: Wed, 25 Feb 2026 07:46:31 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 202/781] drm/amdgpu: dont attach the tlb fence for SI
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, =?UTF-8?Q?Timur_Krist=C3=B3f?=
 <timur.kristof@gmail.com>, Alex Deucher <alexander.deucher@amd.com>,
 Sasha Levin <sashal@kernel.org>
References: <20260225012359.695468795@linuxfoundation.org>
 <20260225012404.620340700@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20260225012404.620340700@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25. 02. 26, 2:15, Greg Kroah-Hartman wrote:
> 6.19-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Alex Deucher <alexander.deucher@amd.com>
> 
> [ Upstream commit 820b3d376e8a102c6aeab737ec6edebbbb710e04 ]

Bah :/.

It was applied in 6.19 as:
commit eb296c09805ee37dd4ea520a7fb3ec157c31090f
Author: Alex Deucher <alexander.deucher@amd.com>
Date:   Tue Dec 2 14:24:03 2025 -0500

     drm/amdgpu: don't attach the tlb fence for SI
...
     (cherry picked from commit 820b3d376e8a102c6aeab737ec6edebbbb710e04)




and reverted by:
commit 808c2052f046d730a588f7b92b04a12f64970853
Author: Prike Liang <Prike.Liang@amd.com>
Date:   Fri Jan 9 16:15:11 2026 +0800

     Revert "drm/amdgpu: don't attach the tlb fence for SI"
...
     (cherry picked from commit 9163fe4d790fb4e16d6b0e23f55b43cddd3d4a65)

still in 6.19 (the cherry picks suggest fixes takes to some 6.19-fixes 
tree).




Then merged to 7.0 as:
commit 820b3d376e8a102c6aeab737ec6edebbbb710e04
Author: Alex Deucher <alexander.deucher@amd.com>
Date:   Tue Dec 2 14:24:03 2025 -0500

     drm/amdgpu: don't attach the tlb fence for SI



and reverted by:
commit 9163fe4d790fb4e16d6b0e23f55b43cddd3d4a65
Author: Prike Liang <Prike.Liang@amd.com>
Date:   Fri Jan 9 16:15:11 2026 +0800

     Revert "drm/amdgpu: don't attach the tlb fence for SI"

It should be dropped or the latter revert added too.

> SI hardware doesn't support pasids, user mode queues, or
> KIQ/MES so there is no need for this.  Doing so results in
> a segfault as these callbacks are non-existent for SI.
> 
> Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4744
> Fixes: f3854e04b708 ("drm/amdgpu: attach tlb fence to the PTs update")
> Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> index a67285118c37b..c362d4dfb5bbb 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> @@ -1069,7 +1069,9 @@ amdgpu_vm_tlb_flush(struct amdgpu_vm_update_params *params,
>   	}
>   
>   	/* Prepare a TLB flush fence to be attached to PTs */
> -	if (!params->unlocked) {
> +	if (!params->unlocked &&
> +	    /* SI doesn't support pasid or KIQ/MES */
> +	    params->adev->family > AMDGPU_FAMILY_SI) {
>   		amdgpu_vm_tlb_fence_create(params->adev, vm, fence);
>   
>   		/* Makes sure no PD/PT is freed before the flush */

-- 
js
suse labs

