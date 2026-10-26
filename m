Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793033997;
	b=wIBwAGmMgTMC0ic+tpAuBShaoZC056c1E/ivxOXuvebJil9CgrIPZptmCOdWqVvL2ank
	 G0PPgpDAxtjrX/yYF4FvtNF+yXAgD43qjBpLZKAsJUD3+gGmqudXZq7j5B7iGF6R8xMjK
	 pJpeZ5LE9ip59OiqeK01eicW5kXD1FUFgMTsYM5jNWYymcZaRMIohlkI4mQ1NYMKBOGVC
	 E6O9RCzthEpfk4OqAAwUcWmTzwquR0FOSce6rce9GTJ0Sl6xsRLmFzH9OgZh6A1MLM2JY
	 qWFI6ZUgWJUtgU8MrfrviCfmZdWF2Z+kARl8jzfTqav9oD1zhcNOQNWWLfyfAOxaJzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793033997;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=tz9jpCHJuuihYoFsJHjUWPfDZzHDI+xFwdCkQ387VRI=;
	b=ND+AbMW793LvJfF8DI0QT1LQiKy3h03UJ3Qw5G++atzvT/n+3Z4NliBb5yAKq1NklfRc
	 H8dcjJroCzSOImwBjhW/CiO7cQEDUTp2EEpC5TtazhCARJMuRF4IQiy0Ovw3QadpB2eP3
	 C10v7U0gJPea6Qmd6E5YtnX1uRTaSUKNG8DB9w6ccIAxG3a5A3SQs/xJugHdZWEC6Gpyp
	 ct3M+MPEM41T/88CCYFLoyv1czNq75NuXTzSgENwhoHzmgQxshr2cc/bp4uFqEKzUcKFW
	 fnPv/sx5LTQfAviZqySt6xp9BOPfELIJFl3uWJ5Psof+NV55bkuthAC4Vvk1lhFjs7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pQqfdgqQ;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87458606A31D
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 16:59:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87458606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pQqfdgqQ
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ac451e128cso2361376a91.1
        for <patches@lists.linux.dev>; Mon, 26 Oct 2026 09:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793033997; x=1793638797; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tz9jpCHJuuihYoFsJHjUWPfDZzHDI+xFwdCkQ387VRI=;
        b=pQqfdgqQPr6sm90VjRtsNJCelBr8KhkndevrXuHjrB8yHY20IMAjtqhnDrDr65b+UQ
         hz9/RIB/FuGi5W9Y65iMzQUZ+qSs5aUYIEHQ1fKDmc8jDSkb7MYxg38gbN/BmAc0Um3f
         1ostHCIRsaaCF5RZKS11TmgiqB0eoGsdnGbWeYwGuSZlcicxXJKeA38wJhol6/tYmF9y
         zOLCj14Xp5Ew82SQJsJbEZHwLxUluG+JKF2OBLxWaThebvqPRruA8FK43hY4dw6ubKCO
         mvnnboqb4Tz3Ieib4nSYqn7UvyHrPnq+C3qH/QWRauW/ZpxZdrOaFK7u8IfzeoURlFXX
         xyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793033997; x=1793638797;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tz9jpCHJuuihYoFsJHjUWPfDZzHDI+xFwdCkQ387VRI=;
        b=EliTrsdc+75zi+EOktZBkQzRs6CFqsfTgcqSX1vFAAa8WLHE8C+XWUOIt4LCD1Rzcd
         ipHUiCNigs4jQOBHz2P2Rf2ElmlWikb3d8SKQC7PpS3Md0w+EpMCtJ3DFftg9GypyYO/
         406dsMaVOeAQz3kAg7NTK0nRGRtWScAKnyPV4OTzDtt9IKVB6sbWX/qJZynHn7U6ONd1
         RVJMV7KzKd2aRrcOKCaBdzsx1x57NtkfRDgRZYKYEg33NjrYDhEiwjE++fVlf6e14sky
         HkFlj31GLskl9EalR1LwAi7wTkakK+s5H6042pLT38qv3zGTVtjgP2kTevfiobJ5CnsF
         wnVQ==
X-Gm-Message-State: AFq9FYKvKhhOP+DiMFjSHQpjbMDVLcyThs79B+Zw/svQjp6/DFQMVtJQ
	T37zbDwuXBBTHFcb9hx4hcAfNX6POyV6f+K9git46L06el6ItFhnX4a9
X-Gm-Gg: AYBFou1ROh9W4wN5l2Mh6///DDqsI4Lk0yYg+c9/FyMGayBzkX4xkIpg//KXBucKHDo
	Ox5N46CqJVHS8tqthi1JxceTpF55T/CEKH0jtp6EzlsE6PvNuRk01tvXMLcvHFv/xuQXqqEPPsZ
	VQbwEEC1WrsSC3U3FXcB2qdSIUjQLg/+7hd7WAK3cA1KpFoVkhfUc5XXXhyF3S0uwlFSGlEuGLs
	fjgt0Hc4lalkAWcGHa0jDczvMDCuNg2d4PiWFlU52I/jN6VfwjR9G3c7Cp78vVWm7RJ3tsiAmKM
	i7G0KYY0tgH/9O/fN0m0RhylP8FEfuGWWxHkeP5EmOjYDKUtZwa+CwhNb/9gtGPVDfLf7AmkgKF
	HH4hd7IZlhShR+fSQ2mPIi1Lbr5pz0UrJ1cm0Spz24zi2e5npqVwPZns9HhQmAeq7cos8hn1+5B
	mw2v8iACLtHYEbODEMyyafhlQ4THNRw75fYZVjxfy9DrRtIuN3nr20zl/FQRQ5BCRVGlx0k2p8q
	oDyzymkBnm4DMDVNj67YjGhsPx1cLNCMzSdBxw1OnJv6xeslceootBTPyP6QkBTxAZiEnZ8nh5B
	Jy6NFDI=
X-Received: by 2002:a17:90b:3ec2:b0:3a8:1a1a:7895 with SMTP id 98e67ed59e1d1-3adeae6d30bmr5210154a91.18.1793033996922;
        Mon, 26 Oct 2026 09:59:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae4066aec8sm173335a91.15.2026.10.26.09.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 09:59:56 -0700 (PDT)
Message-ID: <17e72e8e-42ba-4d81-9249-e02ecb1ef695@gmail.com>
Date: Mon, 26 Oct 2026 09:59:54 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/231] 7.2.13-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261025125805.309934791@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261025125805.309934791@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/25/26 05:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 27 Oct 2026 12:57:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.13-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
