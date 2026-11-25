Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795616300;
	b=nFB+6+HdRA8gYyZZSFVBaq0SsrxKBEdT+v9M8Dv/hnpyY25ukVLnYOcQMz+tj2Z9iE1c
	 2NFXZ7MQo8O3RGeyX6slnk8Llael9YPHuKubLZTDFrIZ/SeBaagKBIBPjRQHVoNaYEgIJ
	 3rUVXLUcQlmggtGukRK80h9yBm/saotYCUOsN2QN7VKIrxITyUBhK9RsFeKf6ySZYnHF8
	 rtLO2GGEOGSTkv1elu4JnBm3rX5xWcdtjFKZqgN6V8W8iBiP+XQoMfBHvFylYcX0pQtjQ
	 veFAXS5uBnZYjXIUjyeH6w0HIgTVEYuhUKy+L7Xnl+wMaOa150NxMMyzxFmKZLStZCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795616300;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=5bQ37Dr+87om1NS6c4tle8Uvo6AzgbEUJjiMwoZ0S2Y=;
	b=SIvDCclNdgM7q6hHXVxEkBOpExon1vmytxZSykEtJxwjLKBXjQt8JrTx/KNmpZ+h0JF1
	 xR8yYzF60t1oNdh94+sKf80Qd7hjXAH/2Znc1rhHLGJMfaizsDsGWf7EvJjLLplGKlav7
	 BsHiHuLi1BS8xNZBODwVCVENh4LFd9qPO3JdRXbfzqoXGmfFYgtTlhQeHY2jD5tM9mdLL
	 lybiS6Bz0QB9+UXznviUhZG7RaAFzTGAvjOhK05kZrCF+O4KzQ/xzNWjJ+VmkLkeJaS0B
	 5jR0aYgZrE+w+8cRkxmahNGbsfSK2gDxq3NjWDabNnlqjWSoo6ddRvxoXvDr7n8ndpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=nSGECwOx;
	arc=none smtp.remote-ip=209.85.160.174
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA24606A323
	for <patches@lists.linux.dev>; Wed, 25 Nov 2026 14:18:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AA24606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=nSGECwOx
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-55c48582654so65463431cf.0
        for <patches@lists.linux.dev>; Wed, 25 Nov 2026 06:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795616299; x=1796221099; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5bQ37Dr+87om1NS6c4tle8Uvo6AzgbEUJjiMwoZ0S2Y=;
        b=nSGECwOx/IH9Ow0CjCOosSbhj0hMs+uxX4hcfJg8vCaphCA0cBH1Iwc+gx9xV82SgM
         PDdW/1xbsl/Au8nWOUUJ4LePWf1qxDv8g4jAD9GRJsG8fqzDtkXkwrA5edDEGIsGW9yR
         GoeQ2ox2dr8RNU0UPrm1VuJ5om5GqY5+EB+ZQPMzSQ/wLF7f5f2mCLCrJmM7XnELJyP8
         fB8IcE8uWGpAaxNiZOC1z2VS2b/VnNTX0g3P/zi4sRI61ffKHGeQToVdU8gSVmfrTD3y
         6llm3A+xKM+O6T7LJ/tH0uqAWv6gFykFjaQx/GG6FAYr+g2uxO8GZjnjw65w9gUA7rvd
         c+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795616299; x=1796221099;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5bQ37Dr+87om1NS6c4tle8Uvo6AzgbEUJjiMwoZ0S2Y=;
        b=EmpIFdGzEanbbD1O0zN0m4gvbmzp2FEG2apl3Ip8atKsdAmlz3pnvQxqZZFCRL5Lnq
         HuxxElCtAu8BHsRtgFYj3Qa8GOk7U+aUyjf5ANx/yQS10hJZxQCHRJxBJfzBlmgHev9i
         f+DTZM0kuiXbVbTEnC4MoQC+wThHb7VrNQ7dXC9DfPImSa3rJm+rqOzvxPhm2d+E3g3e
         ChGGzMddumeHRmklaRew14zp8W166nfkZGYQC3bnp0+GBTR+4c+27i2r0SHh/9zr/Ib+
         UrRBdvvrpDQNFlFufvRsqbnXaaRgtGK3iweUyJ8RCBcFNM7C08KNK1ENjgdwH4pkSv1t
         0avw==
X-Forwarded-Encrypted: i=1; AL+hErG6RzU06R++PWlp/OIaLVBmtnRQ3q8aWBTwpqJGGKjcBhv8TXrj0S/1tJF8bQRUjyZvUkNX3xR+@lists.linux.dev
X-Gm-Message-State: APuU4Z8WbKZ312yKdZT9ilpkX3KF/gW//zOg5tfI72YHYK7wwyllw51I
	+G5np3O4dckU9EdQ+LPpeI2Tq/nzEq5nozFQ/Q2BNhjOckylsW0P7QplD81UXip5kqs=
X-Gm-Gg: AZFdTZe0MITwK4gQyL291Q+A6QVat0NCALGYI2xnGAfmWBy8msyAnSSWqQFgxMB9XKu
	4BYSIU4zdne+3Tk/C6nCkMGyj8OFkMJe8HwmPecuMcO11TKZ84uawi2sZN+8ku4/OK/Wj+2TKqg
	Y6O/6U6gD0wCUJNB+i4aqp+ipbMpavgIzf9Cyd5VhZfDg50rdiFOahZZETGHWGIqTL6i7Gwlgbg
	8Xu0bmKk4tZIh9qeyaMUlePhHLERuvBeJNrkn28ifZhPyDpzug9YUa9MWlkB7OF4xKl4PVg7fch
	pGBvkxQuDoeHAgKSesAMr84OtBWisIjR8FsfI7R1DZ8Z9Ft0TjLGCRBsuWywDavvTCM6dSSC0yA
	mUjBCCP+FvW1ZHVpj4VZNeJU7j/LtwrWIJBrLgZcHCWPRSzHB8SVxOaUvd3YNI8BBSDgj0N2Ybc
	2Gqf6Sz4vMGIWsWq5b8t5BxfkSXxGMpdlnm3fd/j/8Ta/Sw85iOHCnoly5P+Eco6QXSlEfsRKQT
	HWiJVbNpL+l291gDhgCoY3MjuFfgld8uragyDpiffl/9nomSaO+J+XC45ajZIU6oHh92qaHAVFE
	d+QpZw==
X-Received: by 2002:a05:622a:1aaa:b0:55d:3721:872e with SMTP id d75a77b69052e-55d76b34525mr321765931cf.69.1795616299369;
        Wed, 25 Nov 2026 06:18:19 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55db5bc2f31sm27755541cf.20.2026.11.25.06.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:18:18 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWDpB-00000001jOX-3H6e;
	Wed, 25 Nov 2026 10:18:17 -0400
Date: Wed, 25 Nov 2026 10:18:17 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
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
Message-ID: <20261125141817.GC246011@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-3-aneesh.kumar@kernel.org>
 <20261123152903.GG179082@ziepe.ca>
 <yq5awlq19v10.fsf@kernel.org>
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
In-Reply-To: <yq5awlq19v10.fsf@kernel.org>

On Wed, Nov 25, 2026 at 01:56:19PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
> > On Mon, Nov 23, 2026 at 02:03:29PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> Register the built-in TSM class with subsys_initcall() so it exists
> >> before a platform TSM driver probes, independently of object link order.
> >> CONFIG_TSM is boolean; remove the unused module exit path.
> >
> > Why isn't it modular? This is going to force alot of stuff to be
> > non-modular.
> 
> tsm-core.c contains only a small number of helpers. Most of the tsm
> implementation is in pci/tsm.c, and even that codebase is not large.
> 
> This differs from the architecture-specific backends, such as
> arm-cca-host and arm-cca-guest, which can be built as modules.

So, why isn't it modular anyhow? It doesn't matter that it is small,
the expecation is most systems wont need this stuff so we should have
a clear reason why it isn't modular.

Jason
