Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32EB1E04BD;
	Thu, 20 Mar 2025 11:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742469322; cv=none; b=Lky4pl80O7eerLezNGjJVK62NYnzX4+aJIhpsGr9ediSH7LHRB/2aDDaPPKPoPq40zY710jOSUdu4pNWn0XUvrjPPFc2IPwN9uhzVsJEl2WywVo3AtfWVpIOGfsKZJa1cJAES1Xf59mrZEoax93EnLlq5NhmR1xFwvE2tBipm7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742469322; c=relaxed/simple;
	bh=U8N5O8F0G437aw8fksOZ2OUWPw7wnJX5o9P0lkxWNJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZvRn8VlGUFyFt+gOMbC6jZol9CantUBQ8FoSqdBABca+PTfIZMvPTh0Qt2wyX/BOtf5XZuyFZQZwWQYJTkz8bEdCjXgYhDal7wrWfa0vwLU5gU5R4H2RkY+qG52XeKIWg2HoyjRk60xvJNCyogy5GlU5NtYWGZ0vC2EGgU0XA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XYv+iKId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XYv+iKId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991E8C4CEDD;
	Thu, 20 Mar 2025 11:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742469322;
	bh=U8N5O8F0G437aw8fksOZ2OUWPw7wnJX5o9P0lkxWNJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYv+iKIdDWzLGvF4KMOWnoHq0O3V7LL73CQmbtGGo8M5ZdCMIgvWvNTONOWVYvXf6
	 AV2LU0G7iUJyrVOFsiksiMQsWu4+TCbYcapckOuthsjh8OYznvrL2TteP6F/yzKClh
	 TZXI5Emt55Xr0Zk5Ipw+W1snTbSL0Iju1XBpnusa8dsFxiWt8d0bsrXRvlEM/ggVVZ
	 elXosugQ0raMmI3S7eVvHsNunXE/9Wo3VTzWHNu4gxovFvs2PSl52cMTOITjRitwvQ
	 MJyRlB2yAVRzYJiEo1H/yKUWsrN0VzskEK1onsMyNF6M6GkuE6gMNQ5UPo0FJHuNTN
	 /DXQpYb/PMrag==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc1 review
Date: Thu, 20 Mar 2025 12:15:10 +0100
Message-ID: <20250320111510.223109-1-ojeda@kernel.org>
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 19 Mar 2025 07:29:31 -0700 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.84 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
