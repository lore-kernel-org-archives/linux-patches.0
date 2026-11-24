Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540076;
	b=hXXKof2iqD2ZsHxvtRJ5LBx9l3gByTq1iyZDnaf/WpQEqnjYKp49FVp5lFGwrhL330xF
	 KsLTH0bZ7bFds8i7cpu2S+Ciu4zL4TWsaARW6mz/xGw9/PTEnbWpMYX3BhELgfyxUL1vE
	 wyxWcmpBKpvaJXcCnQ85ZzPr8wKUBcBulrYxWfIr6PDSBxUj7tU0kUO1jxAcSEUfCCsGT
	 8Ymu72LO12pJGUg3t+tmS/AE17Z1QkOp39ZbmyebFta/EXT5/DPgJF3cXMzE8l75fxgM4
	 +b38qwEPSOMoRE3LdtSPq0wIfZnwZE6YeuQEk8lRj8uMzhg2M9xv/xQSuUVScCnrqHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540076;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=u9RNgucBnI08qUwk1iWfTQpaGbeV2FiwOEeQoPQxy0A=;
	b=ZgcxX1MgQqOddspvUaF26ZZsT6BLIXs/lZvHg7iBKEcs4ZfqdBa6IG8Q2d2ZkktJD+y+
	 27DJdPDam/6jYwS9zDQbX5OVPtIXmTxh0RcAA1HBGWGSaryOLuCg41KY4wWPJMyX5A/hO
	 u8nvSFZGn/RrdVOat9Km2BdnaSS/Bdqm4SI5IyDH6nZg0a39be97FMcZRD9obzupjZYwK
	 TdxpMZbOkTqru1KRh9HAe/Ls+9U8EewA7z33pXhqjA+RHQ7ZGh4xETGN7oDjlclUiVKk3
	 FqA7oBVY0pxkxLCfn5MDZXQvIwUzirJLvwYjxGqSQ4DkyohS3G8n7dOrZJgCKAICBZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=a7uxdXId;
	arc=none smtp.remote-ip=209.85.217.53
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A1F606A31E
	for <patches@lists.linux.dev>; Tue, 24 Nov 2026 17:07:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50A1F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=a7uxdXId
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-7cc81984fceso1877977137.0
        for <patches@lists.linux.dev>; Tue, 24 Nov 2026 09:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795540075; x=1796144875; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u9RNgucBnI08qUwk1iWfTQpaGbeV2FiwOEeQoPQxy0A=;
        b=a7uxdXIdscfFP6MO7kegi9TO0eRGMDCqklhQrwLvdboZ5LuIN8fiGRsiJYuaJC2zEM
         flASYZ1eyha8gk14nzPwKSJYQwyyP0WJ7BY3JrzJ60taGXCf5oD7blz1DWhT9ywSbXM+
         FUDM9E5OC906ySVup+NEHB92Hr+giMTpoDcD9L3FGQGrLHlPU4iXnuxdASeVbWpQDWJj
         rVD1639CuvBybqSHg9MgO8/LlbbsLVqVuAhmWHMGiwaFHM+GGaYcycI2dB1xNJoOqu4w
         D94hPVb/rnL3vTdBG2LGKCisIkUkz6TfWkCL0trNWiqGgUplmNviSCBN/TpXJSw/WFGP
         UxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795540075; x=1796144875;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u9RNgucBnI08qUwk1iWfTQpaGbeV2FiwOEeQoPQxy0A=;
        b=UUGUeDQHbmQty1OFK6KZcK5m3IsX/w+l3JmapKxuTG27WSS45CiS1HtKp3GdqSlK6J
         nDeuoMBaEmmSn6io6Jg1m6J27hMDBxicaW1Vme8DVTdUyvuIXgy7n5mb3t1gSzFV9dxp
         o7hI9ywjmtYnaZW7mTNV5pcUdBpgRc47NBE5G3GYmxdueWGy8PbFUCxqmFG7EWx62WsC
         n6mZJTchk6W+0L9CCXrbEuzicKkQPf+/zw3Cz5W6tlNPGinv4iRipUAz/Zb0/iQ2N/FG
         G8FxZrqcu7cuah1sTUy/GeCmxhm7GoBGDHAcIXS7m7HqJwnABBFAPMewXvgrSlnskSWI
         AG3g==
X-Forwarded-Encrypted: i=1; AL+hErGGjuPI3tzo297wSaZx7sAiPp1LZUxbkieUgLj9r2fibavA/SL6mU8LxsJ/J0e+kYXtJspe3RUW@lists.linux.dev
X-Gm-Message-State: APuU4Z/yduV1IZ65VHRjZJM1oCboDMRU3G/aCOoFde2WovPUSEUeQZpq
	l6v0I713uOfiaFEmz4jVNaAzhECxOkExTG0Ibvear5TQccso0pQSMNHMdakLoAuuNRw=
X-Gm-Gg: AZFdTZc5Oyb81jqPuv5b6P3nKZAqJ0kRKGhhp34sY/7pPVc0b6cqx7rUhepeHfulOE8
	Li75ZvDltfnEA8k4aQJU6SyRSJnj4jZSpyCJ0GCkZRLgeJ+BZkindV9xVGTZ4Ul04mlKOsrBVhu
	j4RpCYs/ejQyDfbaSypyALkXT6gAysmNN50o+JgMeQ9cm7GD0IVXnJdaboGanJ8iEVwodXf9PGF
	Xr31fQMoJQ9wc0a+quJI7Dia+QHjdEvutx0BLUPxidvTJ80+NX9267sK0CKDGGItyLbRDmIkuEr
	ZKGoewhENlt72Gcn7emOaDWanR/H3ux0RYvMWY6o5g7iQ14h6hPi+CsXeXYYVl66RPinTGHnDHy
	wYvt1KVDEbC0bXJ+P/GCma+tEabhsbPUCwxLzGdsolZiRH/MLHogdVejZGSPI4aG8O3RAlQMYD8
	eMkNa1oQdmbkWB5duJaBqjuHZ+OVGj7c3sUWDn8RC8AOn9zki/pAA6S74Zc9SLGSsArQAlUkRUC
	E3rYYZ0AaeqPxtXLZ9T9agNf/LNCBxCqCsMPCAY1+oKA3xfGbSm/p+EUSkPi92PDamm/xXVXkDv
	zZfyAw==
X-Received: by 2002:a05:6102:688c:b0:7ce:a69d:b020 with SMTP id ada2fe7eead31-7d72b36164amr6731183137.5.1795540075186;
        Tue, 24 Nov 2026 09:07:55 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921366d853esm132634586d6.27.2026.11.24.09.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 09:07:54 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVtzm-00000000uyF-0Lng;
	Tue, 24 Nov 2026 13:07:54 -0400
Date: Tue, 24 Nov 2026 13:07:54 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 02/10] coco: tsm: Register the TSM class before device
 drivers
Message-ID: <20261124170754.GB114530@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-3-aneesh.kumar@kernel.org>
 <20261123152903.GG179082@ziepe.ca>
 <9f92f7ed-5198-45aa-9cef-515ccbf98398@amd.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f92f7ed-5198-45aa-9cef-515ccbf98398@amd.com>

On Tue, Nov 24, 2026 at 11:40:16AM +1100, Alexey Kardashevskiy wrote:
> On 24/11/26 02:29, Jason Gunthorpe wrote:
> > On Mon, Nov 23, 2026 at 02:03:29PM +0530, Aneesh Kumar K.V (Arm) wrote:
> > > Register the built-in TSM class with subsys_initcall() so it exists
> > > before a platform TSM driver probes, independently of object link order.
> > > CONFIG_TSM is boolean; remove the unused module exit path.
> > 
> > Why isn't it modular? This is going to force alot of stuff to be
> > non-modular.
> 
> The TSM core registers a class. The platform TSM drivers register
> TSM devices of that class. If a platform module loads before the TSM
> code - the class is not registered yet so it fails. We could either
> teach modprobe or have dependencies in the module or do this:

I understand that and Aneesh's patch is fine to solve that problem.

I'm asking why it isn't modular. They don't conflict, using
subsys_initcall works just fine as a module.

Jason
