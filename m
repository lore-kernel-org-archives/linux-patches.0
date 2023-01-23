Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DC17C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 11:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35656C433D2;
	Mon, 23 Jan 2023 11:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674474364;
	bh=zEg8X0VHfQqYvwVDau1Shrz6CwI/I0yBIiV+dvFeFYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aD27Z0fJAsAKFYaqhwqKgUlIi1xST5vKkpDVe6VFUZDwJTR6HrGDqCF2LRCKyMG4r
	 lKUbFTMOCX3B1zmzVnj8Am7T+fdi1VwQBZ3rUOupxoCL3dplA01lSTZdL1HHDiSkUv
	 FcgP37Cf5IiUsonXBZGeF2clb2ZN86GawF9F/ns4=
Date: Mon, 23 Jan 2023 12:46:02 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc1 review
Message-ID: <Y85zeq74fg7OtLyf@kroah.com>
References: <20230122150229.351631432@linuxfoundation.org>
 <Y85wE2OBrVvwUlLp@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y85wE2OBrVvwUlLp@duo.ucw.cz>

On Mon, Jan 23, 2023 at 12:31:31PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.165 release.
> > There are 98 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Hmm. Interesting.
> 
> We tested
> 
> commit 9096aabfe9e099a5af5d13bb0fb36e98bb623398
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Mon Jan 23 10:49:12 2023 +0100
> 
>     Linux 5.10.165-rc2
> 
> and found no problems there, but that is -rc2 and you announced -rc1.

https://lore.kernel.org/r/20230123094914.748265495@linuxfoundation.org

