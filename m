Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0621A18CC1E;
	Wed,  9 Oct 2024 22:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728511401; cv=none; b=sPJwT+/gPK+sQT2/ofo+KFRbh2mqBZroJI6RhCfdMDlxLjFxHVn5zC57fYf7B29gJQjNxtSXhfo4XOo6H4efZqmiXXtk2iAVMpjuRoN9luoTfKMOcc2Vl5FOVGkAIq3wi5xFvkjD1uE+TUfbMMKOwKZKz2wTTm8UtUaz2tM7fYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728511401; c=relaxed/simple;
	bh=wHu0vL5OYfmu+L39nIZU7+e1wsKSMJA58f6KwHUZgcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NVdmdWkdUm7he+ykE2K4H4G8XxJG7C9CeAK5lCVZO6kvYJ7MOA27R7pepGsqO+QUlDZLU3H6cN5bz5aJQTzQb0CFlY+FrBIlPhzhXLeOcHEt6AKApolMNyDakPR29kU8SuApjpP77jTELPg10x5SIG2Of6GdSOafak9HWVnsHKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WV6vF9/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WV6vF9/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D998C4CEC3;
	Wed,  9 Oct 2024 22:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728511399;
	bh=wHu0vL5OYfmu+L39nIZU7+e1wsKSMJA58f6KwHUZgcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WV6vF9/2fDQLRiQPFYPkhYe8w4fpee9+NbNJZy0nVD5UsYX/9qnd+VZN5aZqKkPa9
	 fMNDVQcholTOjszBa+mA2ZH84jZ798H9vTL7erJBZm/O+W1DepFkMNBGeLz52Kwnpj
	 fS1Gw3kxcO8cgDd5vwwko4bWQr1sHg3dGR6WvnpCUCqRw8mL5EVRy1LH9vBOnq1Oet
	 mPuSzCByAW6VY9aRwT/feic4jL3wopgxfwXyYXDtoAAGMvEYKk4RFO09ffMIZG6baH
	 veTgjlvlCFKSy5SMiVgCqdrmaDnB1h1MFQWxikEn+cZato8SeAGvDVcQWyTxiCMAS8
	 tz8hPaEzluwmw==
Date: Wed, 9 Oct 2024 18:03:17 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jan Stancek <jstancek@redhat.com>
Cc: Cyril Hrubis <chrubis@suse.cz>,
	Anders Roxell <anders.roxell@linaro.org>, Jan Kara <jack@suse.cz>,
	lkft-triage@lists.linaro.org, allen.lkml@gmail.com,
	stable@vger.kernel.org, shuah@kernel.org, f.fainelli@gmail.com,
	jonathanh@nvidia.com, patches@kernelci.org, linux@roeck-us.net,
	srw@sladewatkins.net, broonie@kernel.org,
	LTP List <ltp@lists.linux.it>,
	Christian Brauner <brauner@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, rwarsow@gmx.de, pavel@denx.de,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, conor@kernel.org,
	patches@lists.linux.dev, akpm@linux-foundation.org,
	torvalds@linux-foundation.org, sudipm.mukherjee@gmail.com
Subject: Re: [LTP] [PATCH 6.10 000/482] 6.10.14-rc1 review
Message-ID: <Zwb9pbX7MnPqGPoM@sashalap>
References: <20241008115648.280954295@linuxfoundation.org>
 <CA+G9fYv=Ld-YCpWaV2X=ErcyfEQC8DA1jy+cOhmviEHGS9mh-w@mail.gmail.com>
 <CADYN=9KBXFJA1oU6KVJU66vcEej5p+6NcVYO0=SUrWW1nqJ8jQ@mail.gmail.com>
 <ZwZuuz2jTW5evZ6v@yuki.lan>
 <CAASaF6wdvXAZyPNn-H4F8qq6MpHmOOm9R+K+ir9T_sOG-nXpoA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAASaF6wdvXAZyPNn-H4F8qq6MpHmOOm9R+K+ir9T_sOG-nXpoA@mail.gmail.com>

On Wed, Oct 09, 2024 at 02:03:31PM +0200, Jan Stancek wrote:
>On Wed, Oct 9, 2024 at 1:56 PM Cyril Hrubis <chrubis@suse.cz> wrote:
>>
>> Hi!
>> Work in progress, see:
>> https://lists.linux.it/pipermail/ltp/2024-October/040433.html
>
>and https://lore.kernel.org/linux-ext4/20241004221556.19222-1-jack@suse.cz/

I'll drop the offending commit, we can grab it along with the fix once
it lands in Linus's tree.

-- 
Thanks,
Sasha
