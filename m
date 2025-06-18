Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7D92EE981;
	Wed, 18 Jun 2025 15:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750259571; cv=none; b=aO/1UU5Y9enzqJ9L3pCcHN0MsHOGPc0N2LxruF2rZd72PneYfyHwp+6PLOHJ6yNkNfZECwBR7/AOV9RUirzGb4yW7bivHXtM01RvyhZd5DP7Y2WEKNc0YgkaR7h61iKVntFuYdslCIBHBfkVFST1KPYWsLhMkFsd6tX9CyoQ/aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750259571; c=relaxed/simple;
	bh=ZwBQMyQEJS/RXHKpxFJsZskhbkcyOpp55zZF15F1NGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxTDoV8x9PmbvvUfBnxPmexcBB8xdgdtI+H7215uYtvKr9hy2YNkMgIjXYz7BmFIxbhKM/+B7XeAXYzmFjyvCJaIqgcFrHtbof9RM2ton3MmBPAugYmdjHZvBk4dyucdCyuj80jrbxUDb3UXMzlRK6KRRe7ra7mJ2vYNeadGR6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IVowrAVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IVowrAVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEB8C4CEE7;
	Wed, 18 Jun 2025 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750259570;
	bh=ZwBQMyQEJS/RXHKpxFJsZskhbkcyOpp55zZF15F1NGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IVowrAVHzk2g4J4LtkAn2aPxALuxfaKumyjdR3NhjEob/iI21g3LhnFszAr7i12DM
	 MdSrIguJLpUkfUxbvcQaKFsUHuDWJk6B36iPvi8cgq85bVADl5AGX0hOvDLV9lnJAy
	 xAi4CXM0QkL87Kmo5qjsDS+vUssy27RU39Ivsh7G8Z++YDpNmYjMCndMos8M8NKvxZ
	 3/cK9XheizwZwu10ZbWeH+4Daj4/vQDC1/+1NlvLhi11UqyItI2AyhsZeZTpC4i22Q
	 GtnZpGYwE0v7Hy5sFETYHOBehWrcNfIl7QfpWN2znWBDckCNr3JhOPbezRYNHn2SCf
	 JvgArh0dLWiCg==
Date: Wed, 18 Jun 2025 11:12:49 -0400
From: Sasha Levin <sashal@kernel.org>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>, perex@perex.cz, tiwai@suse.com,
	yuehaibing@huawei.com, linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.15 101/110] ALSA: seq: Remove unused
 snd_seq_queue_client_leave_cells
Message-ID: <aFLXcQc6Wg41gPSJ@lappy>
References: <20250601232435.3507697-1-sashal@kernel.org>
 <20250601232435.3507697-101-sashal@kernel.org>
 <aDznZgej_QbaalP0@gallifrey>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aDznZgej_QbaalP0@gallifrey>

On Sun, Jun 01, 2025 at 11:51:02PM +0000, Dr. David Alan Gilbert wrote:
>* Sasha Levin (sashal@kernel.org) wrote:
>
>Hi Sasha,
>
>> From: "Dr. David Alan Gilbert" <linux@treblig.org>
>>
>> [ Upstream commit 81ea9e92941091bb3178d49e63b13bf4df2ee46b ]
>>
>> The last use of snd_seq_queue_client_leave_cells() was removed in 2018
>> by
>> commit 85d59b57be59 ("ALSA: seq: Remove superfluous
>> snd_seq_queue_client_leave_cells() call")
>>
>> Remove it.
>>
>> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> Link: https://patch.msgid.link/20250502235219.1000429-4-linux@treblig.org
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>
>> NO This commit should not be backported to stable kernel trees for
>> several reasons:
>
>I'd agree with that big fat NO - unless it makes your life easier backporting
>a big pile of other stuff.
>I'm a bit curious about:
>  a) How it got picked up by autosel - I'm quite careful not to include
>     'fixes' tags to avoid them getting picked up.

autosel does it's analysis based on LLMs rather than just commit tags.

>  b) Given it's got a big fat no, why is it posted here?

I was trying to be too smart :)

My scripts got confused by the "YES" later on in the explanation.

Now dropped!

-- 
Thanks,
Sasha
