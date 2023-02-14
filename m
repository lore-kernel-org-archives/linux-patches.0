Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11644C5E7
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 19:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3086C433D2;
	Tue, 14 Feb 2023 19:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676402360;
	bh=y721sh2e1eN5erI585gjsMJYeGmu4kCuris4aCBoJNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VbH3HSD/nIe2s+SqV92n4743bZXVb6cbUwGAnHgj6ejcZDvo8LIjTRhvtCj0OzTb1
	 FQFO79vTgd+10ljeWiIS37IYPdLhBoLtKNPGdcZSXnaxv6wQOxXZsqtxsNpCkKd+Yc
	 3QQtd9+AMoaUfU6/AgbW+RnSL3TVHARNQhuRCKb/nkx0dCVaf/2q3izlEqcvJFxULC
	 71zDqYvVi37X81sZ6FLfZr5rtaw3KJxRVkZ5zndcAd6K3lKx/VM910GaK4hnmGBKrm
	 Tka4lWAXJeGHs165Ll+/WDtveCA8tEt3uqCgj/UV0yre6QsoEa3u8Ds0B3TXtiO0tH
	 2C/RnprOC/9bg==
Date: Tue, 14 Feb 2023 14:19:20 -0500
From: Sasha Levin <sashal@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/134] 5.10.168-rc2 review
Message-ID: <Y+veuKPmuGpXjnDS@sashalap>
References: <20230214172549.450713187@linuxfoundation.org>
 <8c06157f-a482-a7f7-8218-863db3dfe268@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8c06157f-a482-a7f7-8218-863db3dfe268@roeck-us.net>

On Tue, Feb 14, 2023 at 10:07:45AM -0800, Guenter Roeck wrote:
>On 2/14/23 09:41, Greg Kroah-Hartman wrote:
>>This is the start of the stable review cycle for the 5.10.168 release.
>>There are 134 patches in this series, all will be posted as a response
>>to this one.  If anyone has any issues with these being applied, please
>>let me know.
>>
>>Responses should be made by Thu, 16 Feb 2023 17:25:19 +0000.
>>Anything received after that time might be too late.
>>
>
>Still observed for ppc:ppc32_allmodconfig:
>
>In file included from arch/powerpc/net/bpf_jit_comp.c:16:
>arch/powerpc/net/bpf_jit32.h:131:8: error: redefinition of 'struct codegen_context'
>  131 | struct codegen_context {
>      |        ^~~~~~~~~~~~~~~
>In file included from arch/powerpc/net/bpf_jit32.h:13,
>                 from arch/powerpc/net/bpf_jit_comp.c:16:
>arch/powerpc/net/bpf_jit.h:124:8: note: originally defined here
>  124 | struct codegen_context {
>      |        ^~~~~~~~~~~~~~~
>arch/powerpc/net/bpf_jit_comp.c:18:20: error: redefinition of 'bpf_flush_icache'
>   18 | static inline void bpf_flush_icache(void *start, void *end)
>      |                    ^~~~~~~~~~~~~~~~
>In file included from arch/powerpc/net/bpf_jit32.h:13,
>                 from arch/powerpc/net/bpf_jit_comp.c:16:
>arch/powerpc/net/bpf_jit.h:139:20: note: previous definition of 'bpf_flush_icache' with type 'void(void *, void *)'
>  139 | static inline void bpf_flush_icache(void *start, void *end)
>      |                    ^~~~~~~~~~~~~~~~

Yes, sorry, I've dropped two broken patches.

-- 
Thanks,
Sasha
