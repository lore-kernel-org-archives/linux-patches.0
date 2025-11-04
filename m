Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970B42ECEA3;
	Tue,  4 Nov 2025 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762265598; cv=none; b=QMsIXt7J5q+X0Z4AU8ptTEGhVn9ZapPihyn/rJSXgoIcWIw2Vp198dab9vfwNcnXzYH1tGwg9yK0QOd7ZdwSoARsBxsoiT571rkjEZzug0hI2jYTPVoLx5nDqN0Gzuwej4QYsJbrctiuoi7qNuGt+Dp7ZM01jdJ4NPejhzv2P/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762265598; c=relaxed/simple;
	bh=NzB5eDDk92AtjiCiTD1GrcBWlbNtGgxHHeoWvnyYlD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pEvIEDhM85HS41ROUhUVaEVLAitSdvY7UCzAax2lqIGyzjZtHxm5G+cqr7R4K/g93YHb49erdmrLGYes+CV4P0c8xsuLwSDfiTp4yKeGfgyF/ghCQimWgGeL4gNaCZCFyAzZQ7DEsraACdzaJNtQFRYyKjPi1piMrAg4T3vdhXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YKI/XikR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YKI/XikR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AC1C4CEF7;
	Tue,  4 Nov 2025 14:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762265597;
	bh=NzB5eDDk92AtjiCiTD1GrcBWlbNtGgxHHeoWvnyYlD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YKI/XikRPYw9nsmm2awIMLjjWfJa6xOnrS5Yp49H17U4P3iF/A+n0mXu4xW9BC19g
	 /YTwnKvC46IyzsyH7ENbvCpTy8+vGCtgetzHQN6YMX2rwCGdsW5ynYFmewm++kUL8K
	 c+TiYr5SEAqQBmU0IM12dOid6YwqBDG/tcKBuM7qEM563P9egBRyxGGIKIF4Q+5Itv
	 ww0mt9O366kvPzN/0TfL2tovB0BWm2cnXpGSAS6l3fYvm/SnVqDiWSQVTgKwHjQfqM
	 Xa7wOCFScmFf6ELtezyx9svzaI/2NLHOVhPuAe1JGrcbLHwpvWulu+5bEPpcBEbYem
	 oxOgPSTGx70QA==
Date: Tue, 4 Nov 2025 09:13:15 -0500
From: Sasha Levin <sashal@kernel.org>
To: Mario Limonciello <superm1@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Mario Limonciello <Mario.Limonciello@amd.com>,
	Mauri Carvalho <mcarvalho3@lenovo.com>,
	Wayne Lin <wayne.lin@amd.com>, Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>, alex.hung@amd.com,
	aurabindo.pillai@amd.com, chiahsuan.chung@amd.com,
	alexandre.f.demers@gmail.com
Subject: Re: [PATCH AUTOSEL 6.17-6.1] drm/amd/display: Set up pixel encoding
 for YCBCR422
Message-ID: <aQoJ-w6keVUWz7BD@laps>
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-163-sashal@kernel.org>
 <a1426a8b-85fb-4428-8d6b-540d3e0b1e33@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a1426a8b-85fb-4428-8d6b-540d3e0b1e33@kernel.org>

On Sat, Oct 25, 2025 at 01:24:48PM -0500, Mario Limonciello wrote:
>
>
>On 10/25/25 10:56 AM, Sasha Levin wrote:
>>From: Mario Limonciello <Mario.Limonciello@amd.com>
>>
>>[ Upstream commit 5e76bc677cb7c92b37d8bc66bb67a18922895be2 ]
>>
>>[Why]
>>fill_stream_properties_from_drm_display_mode() will not configure pixel
>>encoding to YCBCR422 when the DRM color format supports YCBCR422 but not
>>YCBCR420 or YCBCR4444.  Instead it will fallback to RGB.
>>
>>[How]
>>Add support for YCBCR422 in pixel encoding mapping.
>>
>>Suggested-by: Mauri Carvalho <mcarvalho3@lenovo.com>
>>Reviewed-by: Wayne Lin <wayne.lin@amd.com>
>>Signed-off-by: Mario Limonciello <Mario.Limonciello@amd.com>
>>Signed-off-by: Ray Wu <ray.wu@amd.com>
>>Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
>>Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>
>Hi,
>
>I don't have a problem with this commit being backported, but if 
>you're going to backport it please also backport the other one that 
>came with it: db291ed1732e02e79dca431838713bbf602bda1c

Sure, I'll take it too.

-- 
Thanks,
Sasha
