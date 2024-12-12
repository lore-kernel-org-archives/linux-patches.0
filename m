Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C75223C4D;
	Thu, 12 Dec 2024 17:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025512; cv=none; b=FIJchMH3XNoK8oyjmEYJ4t8NGfoRqsXkegxCIjWspZgwO/kwru3gAgLDfsRu9NKU5Hblbz1eZP7RTK3yrTIP/DmJPLAG6TFJOsGCWb2t+Agl7uXd26ej86WuvU6WJRFiiiXpus4XGB32MvmGnVLyo8eHNcsQZ2RuV/Hi/BSknPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025512; c=relaxed/simple;
	bh=G9pqNAm06VhyitB828FaFQYuXy0X39oL6aFOgQDwNmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G7bVkshX4kgXQ6/EKztZF4je+7NRvm72ShFWkJlM+6UDGLoO3bwFz+qL/ygpo1YuhsnLiZwsuHSEsMIlvl4aivc5Z3pzmAkOPmdS+teVLJ0y4BDOQ5eh92Vsa1Bb+jey/BmLnNNKlXDu2rCqM8pIiJUl7tUNlA8BSK3fNvPND/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0//HoLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0//HoLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00325C4CED0;
	Thu, 12 Dec 2024 17:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734025511;
	bh=G9pqNAm06VhyitB828FaFQYuXy0X39oL6aFOgQDwNmA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V0//HoLDYpZlYWyw2ulh6BAW89NuHt1ptqkHEHAU89JKeYPXnm5StM5Cz5STsWMvC
	 w/6TVoZzWB7EOckJutYNU0dmxv4NxBoktCcxnXkYTfiOv3jf/LmBOpOnI/ql0NKfU7
	 5XMXhiWGG+OiE5E0HfYwQOtJImTlnxbdN2i0OI36RGm9g/xEyv8CNMXpG0E1kS7ubj
	 MaGGM+eXrbH/RdWeV/Z3kZCGynz0Ly1Mc7w09LHgLLFzlgpcPqVdMDf2muPbmEuGZM
	 vlWmsrVNSenfiO3Vhfhwt6cyd+cUfe+reDrODf6Bx/B4LwmrI+0ywnyFOH3MGct3O0
	 866AzbftwhVCQ==
Message-ID: <6e25f099-1ba2-4bef-9477-888288270f5d@kernel.org>
Date: Thu, 12 Dec 2024 18:45:07 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 437/466] drm/amd/display: Update Interface to Check
 UCLK DPM
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Aric Cyr <aric.cyr@amd.com>,
 Austin Zheng <Austin.Zheng@amd.com>,
 Aurabindo Pillai <aurabindo.pillai@amd.com>,
 Daniel Wheeler <daniel.wheeler@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>, Sasha Levin <sashal@kernel.org>
References: <20241212144306.641051666@linuxfoundation.org>
 <20241212144324.128679509@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20241212144324.128679509@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12. 12. 24, 16:00, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Austin Zheng <Austin.Zheng@amd.com>
> 
> [ Upstream commit b8d046985c2dc41a0e264a391da4606099f8d44f ]
> 
> [Why]
> Videos using YUV420 format may result in high power being used.
> Disabling MPO may result in lower power usage.
> Update interface that can be used to check power profile of a dc_state.
> 
> [How]
> Allow pstate switching in VBlank as last entry in strategy candidates.
> Add helper functions that can be used to determine power level:
> -get power profile after a dc_state has undergone full validation

FWIW this was reverted in the Linus' tree:

commit 0e93b76cf92f229409e8da85c2a143868835fec3
Author: Austin Zheng <Austin.Zheng@amd.com>
Date:   Mon Sep 23 10:07:32 2024 -0400

     drm/amd/display: Revert commit Update Interface to Check UCLK DPM

     This reverts commit b8d046985c2dc41a0e264a391da4606099f8d44f.

     Reverting as regression discovered on certain systems and golden values
     need to updated.



Possibly, there are other fixes queued for 6.12, so the revert is not 
needed anymore?

> Reviewed-by: Aric Cyr <aric.cyr@amd.com>
> Signed-off-by: Austin Zheng <Austin.Zheng@amd.com>
> Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
> Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Stable-dep-of: 6a7fd76b949e ("drm/amd/display: Add option to retrieve detile buffer size")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

thanks,
-- 
js
suse labs

