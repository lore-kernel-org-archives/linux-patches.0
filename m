Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3BB600D
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 20:09:00 +0000 (UTC)
Received: from [192.168.88.254] (unknown [180.242.97.168])
	by gnuweeb.org (Postfix) with ESMTPSA id 79F0A7E328;
	Thu, 14 Jul 2022 20:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1657828988;
	bh=l0oUrsIvH8CyDkVx3+kP+TKzoxpht82/VqhKuQHQZ7Q=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To:From;
	b=KSWHECaWEatGMMf8g2XjKBZ2sVP6wZe7qwxdoyoKmWbx9dDVfAW+qBhtfu/RNFa0a
	 Oqa1fyHlWPvW25WICi+UvA9TJQnR3/Ba666IWVcDeE52px/e5INtvI4Gz6tM93pCVy
	 gTfpdyKfLXM55mt+2zL8yddLLif43q+siWnu2G4fXMDKqGr33vizwzreHY+rFqgNmZ
	 PxneLsDfWj2dZvFezgVRpfQWqo1VXiPPMKQbL51cEJkrQs1M3KK2/wT3+OqxAeQxTT
	 JiemWltGSqjpw+yXzaS+3a0H/N7tD4m4eQQG+n38ClboCRgpYcnqyCuFMAzwHmBoEO
	 80KB1d1hMwNkw==
Message-ID: <b49b97df-8051-ea88-dfa7-5c64f611a10f@gnuweeb.org>
Date: Fri, 15 Jul 2022 03:02:54 +0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH WIP v1 3/3] Add myself as ultimate maintainer
Content-Language: en-US
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
References: <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>
 <20220707-my-new-branch-v1-3-8d355bae1bb5@linuxfoundation.org>
Cc: patches@lists.linux.dev
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220707-my-new-branch-v1-3-8d355bae1bb5@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/22 2:52 AM, Konstantin Ryabitsev wrote:
> This is not a real commit. I am using it as testing grounds for
> b4-submit. Do not read anything into this. :)
> 
> Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

Shouldn't we have a "---" here?

Just testing

Tested-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 66bffb24a348..2d662349ee5b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22183,9 +22183,9 @@ S:	Maintained
>   F:	mm/zswap.c
>   
>   THE REST
> -M:	Linus Torvalds <torvalds@linux-foundation.org>
> +M:	Konstantin Ryabitsev <konstantin.ryabitsev@linuxfoundation.org>
>   L:	linux-kernel@vger.kernel.org
> -S:	Buried alive in reporters
> +S:	I claim Linux in the name of the Klingon Empire
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>   F:	*
>   F:	*/
> 

-- 
Ammar Faizi
