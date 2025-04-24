Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919942701C3
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 07:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745478167; cv=none; b=iGlTQNQhNfggHO9wUFD0goLtskz0/0br1Fe0C+CtOyV3ki+hRTKLy9vRGF2BiIuq7QqZYAeYZvkdoUNP+PFEqqtPEWHgjFswzo65/5wCzm5ohhmQKljJN9pScsIUm64WQLRQVXCXmlBekdDcNuZaiBT8La0ecc7ayc8yeu9p0tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745478167; c=relaxed/simple;
	bh=CsVdIY8q46bTxLPbuwJ8cUP2eUiwXdsgC6RMjJcwonY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9NbXVpuYrpqLhhrMCXE0A4QT6V3UWf7ojFf8KcVKwKVHnk64VL7x9Tyn6ISvolmB7wwlKe0N/93xU9T7HuoMaglJnimBi3fV/CAtayLXu/Su4OXofavr+JV/Qqzh3rrZVVXpVKTIIl2CVfrN844VsyKaAfdlL99wyyGnpZQl2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KzftGckE; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KzftGckE"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ace3b03c043so104903366b.2
        for <patches@lists.linux.dev>; Thu, 24 Apr 2025 00:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745478164; x=1746082964; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=atZ0zH+QTHFPwFIGyoJZTZ335IopbqtcRNNIDzNruC4=;
        b=KzftGckEDL5YYcmOq7sZuOH5jNZVEPiL89lCgTpG6BjfwReHUxtopc+Fk/Gx856uep
         fDF0GPo+fLwYbf47lH8JbsJ5/J0V+MULi9FGgJcGFmC+bTgZJtdln4JU5X6H8G3dNmwB
         DiSt0z59zDPsy5gRAnQxM1NcnIoKfVP0uLDLfQVhnk24KzzwADfhBhVUCQtiEQ1XeuGE
         WIOdS+gP6mD3QhcA0q2RyL4/BorBVoPfzIfRxc+TdH1HZjwZ7VvuHfTRCMbC/ygxg3Dr
         goJg0MdyRBw0Lm7IOmKo5sjchM1c6zVDaBPGSbz/c5DWzBO6JXe0eczsWI0HA63ODN7S
         HoAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745478164; x=1746082964;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=atZ0zH+QTHFPwFIGyoJZTZ335IopbqtcRNNIDzNruC4=;
        b=T/N9V3EMd0kJy8pOlKrMF6ANpYJqbSmOK7vs6FaMDvk9pFSsTfmUVPD+j/WxcQOzEc
         BQqgyuj1uxWTwFP7coaaXebPC/mOYRABiHTqCGbF+1hipZTFn0h3RbL4wJ/Aqkbijj8/
         YXVCTgXVfE3MPcZ6h9NXBvevjBbpOEIW7bBBdKlk/D5uXT8x7NWQZ6bnP/u6NBu9agXa
         +zqWdX2Dp7Qh/at6hbTJSgaBF82wfWm/5/Az825Tfd9a3bHCMTjXawiCn0Zf6LVLk2yH
         7brBQt6BywvCfBbbc1wsMSaneODflNaefMyYet7ksL9zLyrOINoMkx/G8DGqv26Ou94w
         eLAg==
X-Forwarded-Encrypted: i=1; AJvYcCWR6MAHzgRR7NuvJctr9HSV4K6BHQEILV2pw23x2UwbVRPlHX1TJ5u3bR9I58KcqHs70AfMAJKj@lists.linux.dev
X-Gm-Message-State: AOJu0YzuH/wT59nhti25y7pUtLSGfKHDdgM/ngKkEdHo0grSCEYgUVC8
	WeuTm6Bi+usNGMl+ADeCPYk1ZHRZ1HwIJgcFzHPs49Y5P7uorZZUydCcpGddMXE=
X-Gm-Gg: ASbGnctkR8nvqY3gjQJRCMCjy3YvgY8Tg/6hpEh09RHimqNxdBz5Gaquja+b/ddeTz0
	hSgK7cUnokDpbwFIc6qhGhUe5HuGug8vRTA5AGMh0sazOukNQFpt/2WfXy3QWge+pShoEJVsLDc
	RTJJuEagN2vBgD6tsBVheeQj9MrYj4fqAPg50HVnU4d+m57EazfXcFnp9osZAJ89e3nPUXFiQxB
	yMMKvMyMZVnS9NBbFDOo9uN9Sylev0HfcaCFKA1Bj4SfHWtumxreyKB4LY0OY4CXnJjAnFrVv/4
	9Mw2hX5ES3+YMu5/BXlTeXds874tMLWtkUt+eg==
X-Google-Smtp-Source: AGHT+IHRRXGrXUDu3+rG3nESpdOVayw7JgdtjaocMACREgykhsz0BZozqMiy2x1NiHc65DNK79egqw==
X-Received: by 2002:a17:907:97c1:b0:ac7:95b5:f5d1 with SMTP id a640c23a62f3a-ace57494ecemr146858866b.42.1745478163982;
        Thu, 24 Apr 2025 00:02:43 -0700 (PDT)
Received: from linaro.org ([62.231.96.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace598f6b97sm57765866b.75.2025.04.24.00.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 00:02:43 -0700 (PDT)
Date: Thu, 24 Apr 2025 10:02:40 +0300
From: Abel Vesa <abel.vesa@linaro.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>, Liam Girdwood <lgirdwood@gmail.com>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Marek Vasut <marex@denx.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH] rpmsg: qcom_smd: Fix uninitialized return variable in
 __qcom_smd_send()
Message-ID: <aAniEGwKKRUieo5G@linaro.org>
References: <CA+G9fYs+z4-aCriaGHnrU=5A14cQskg=TMxzQ5MKxvjq_zCX6g@mail.gmail.com>
 <aAkhvV0nSbrsef1P@stanley.mountain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAkhvV0nSbrsef1P@stanley.mountain>

On 25-04-23 20:22:05, Dan Carpenter wrote:
> The "ret" variable isn't initialized if we don't enter the loop.  For
> example,  if "channel->state" is not SMD_CHANNEL_OPENED.
> 
> Fixes: 33e3820dda88 ("rpmsg: smd: Use spinlock in tx path")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
