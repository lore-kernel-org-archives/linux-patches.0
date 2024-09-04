Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F5A1D460E;
	Wed,  4 Sep 2024 15:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725463818; cv=none; b=UYQpM7wRCCmTJw8ES95wRRBgmizlfIZARNrQotNwO3f+dHyF67WoxN6IorGcxrINxe84JZOrhebLcVrV4d58k6zeckM4Xz/3ZRi44XJVethZNfhEqhlj+b+6PSR7PvK8wy9FDv2gfWWOAwNUyA9cZtHZdLqQ8+vrbkdWuunWsvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725463818; c=relaxed/simple;
	bh=1O5SEfamUJYUWyxcb8o5tSAdda7kUacl8b4DoatmHxI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eo7peazeH1V3bDwIam/MSr/J1Pt2K1EH1Nts3fzxuph+4d+3heY486kDX5zyWiiOz0Her/RP6jH0Ko1HHehas3IwfeHgjr9JQNId5HcC/P/czCdthN/IVjY7IkRjix4z8ms5YvxLEK9q5MHZyviHhckTlAaaLMayUmgdA6LFK+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLiUD02U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLiUD02U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B543AC4CEC2;
	Wed,  4 Sep 2024 15:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725463818;
	bh=1O5SEfamUJYUWyxcb8o5tSAdda7kUacl8b4DoatmHxI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kLiUD02U37stJT/vw9brM50+TMElu+QIrhJastpkOa+gqBjj6UV2tOjwYPTKx0y3z
	 4yssb6m60m9irx1nRGPldDNTf4YC27P0IwwaMUYroR0U5EDvOCu1+rBwJRaGhQisRH
	 eqChTrDqLLccp12WNfMXVq26a7N9dqw8QGgkDGWcHRidmB/733hTrofSZqQs5qX9i0
	 EkYlUXOblaHeR/fq9dY1Ft0+KWNZ0yxYhF7k1mqVTFWvRthQVmJy6t6YamCqFqkDUk
	 ioC/LsS6e0fJxSXwAnnBVFMhwkmvd6/KLnNAjmmlszjwXgFpTcNty08MMD7ehvUp3r
	 tKaJ2P/fk+gTg==
Message-ID: <28103118-911e-4b1a-9c76-2bd4ec7c830f@kernel.org>
Date: Thu, 5 Sep 2024 00:30:13 +0900
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/3] extcon: axp288: Switch to new Intel CPU model
 defines
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240903173443.7962-1-tony.luck@intel.com>
 <20240903173443.7962-2-tony.luck@intel.com>
 <d114d151-950b-49a7-8be5-19c1b8b15d7c@kernel.org>
 <20240904152420.GEZth7pPI4NKghUxUS@fat_crate.local>
From: Chanwoo Choi <chanwoo@kernel.org>
Content-Language: en-US
In-Reply-To: <20240904152420.GEZth7pPI4NKghUxUS@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

24. 9. 5. 00:24에 Borislav Petkov 이(가) 쓴 글:
> On Thu, Sep 05, 2024 at 12:19:17AM +0900, Chanwoo Choi wrote:
>> Applied it.
>> https://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-next&id=089a6e37c5394bc22d34c0c22b14a31b897b5831
> 
> Now, can you remove it pls?
> 
> It will be way easier if I queue it along with the other two...
> 
> Thx.
> 

OK. I'll remove it from extcon.git. 

-- 
Best Regards,
Samsung Electronics
Chanwoo Choi

