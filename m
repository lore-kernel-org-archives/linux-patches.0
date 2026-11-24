Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795526276;
	b=jVlvvjc4iFOK43dcVS0NMqnhoSoE6lFUOIXf7mIBdsmokeK1Mwvok/VCuWlwerNdD+n0
	 5ge5zZmDJBIhTTthe7imFsyypNSr8eLZvrU4ygi/BcCZQsA7WhK2Av0OD9BxzProCWlDy
	 8ikbO17c1pXyLXhtzFLUnqVBbI9rMAZYGI4pyJJyQxpYbQLyjbBkUo4U8C3I8HOgBlHY4
	 NlqsQgn2xOCis8Bq3d68Z0gElu2eMeCNw3LHDZD/n/QwEIhN/AKho8Ohh3XUCvTDoP/jX
	 UhgfJvkS735ubuT5Ux6i/u6inloDWMaEsEHnClgZiQAGuPZqp3mg2rAHdsrx4wV/NlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795526276;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=JQr5O3TAm0LrUQZ23OaV0ywjiZMgF6OfZ39GqtSUwII=;
	b=C/vUWOk85XVYQ3mdH3vkJXlmKe8i44X888P+xZizsKrjg3Sud31nLw1F2taO9AzqFUFg
	 /OvZAFPP6wu/yHKWxJCmudmq8O5n4BmDDMXFT6WXn3cTAC4mPkF0TPGsCi28LIOYmy5wc
	 oM80Xs9VzGuwGQRbJ+AxEdlidgz0lG25ojbjvXjYv/FIPqX8aQDPYoflKe3Izujg+VaiQ
	 K0qr704jgO4Pfjt5aGxsDPy35vVInTjLsM3agDqnU0k+MHpz3ENO1E62gy9A8aUr0E75n
	 ofs8NV9KMml5z9QjFcb5k07QoQwpQEfG0o/AdgZy1h/r9NqTEStw+WYnxcvBODKbqhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=TpvdSgOk;
	arc=none smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E8F606A327
	for <patches@lists.linux.dev>; Tue, 24 Nov 2026 13:17:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56E8F606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=TpvdSgOk
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-55d03bfd477so52325341cf.1
        for <patches@lists.linux.dev>; Tue, 24 Nov 2026 05:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795526275; x=1796131075; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JQr5O3TAm0LrUQZ23OaV0ywjiZMgF6OfZ39GqtSUwII=;
        b=TpvdSgOk6WWTGFrKx+ao/aLASu3ndPzaaz5li6JnfDuEhWglOpNDI5WFworLuX0nTe
         qpBnYjSpJNdhCbC2gmEIpIsdBPbT2Zmgqg7/k2rNUzvQY+ejQ5cJO12J+e52++rmzesM
         5umcH2u+3NOE/kslAqvgxLmN2+4sWO3hTbDBO2/8vEG3A5T6Pl2NQRjHgrGyDp9hJUh7
         nZDDXLHaRmYb0bYKcaqg5eFd7TZ2okx4ZRhDzBcyHLfzM8dXDjuW/GzZj+SYhSw8YSiU
         j3AW7MdeUNEnbYls2zPXGVFNVytP9l4PvBRamUJ11wmoireW/QepFFY3RQUgQ1YbZ5uN
         8KPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795526275; x=1796131075;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JQr5O3TAm0LrUQZ23OaV0ywjiZMgF6OfZ39GqtSUwII=;
        b=LzGsPll1AANqU+bEECcT2nYj8oudfjUlYWOllunYhkreFPhZNFc3N/0/Vh+andTR11
         feJZiWkH2GXoFs6Esx7OvIVuABHkvmQsXxl9PW8lXwaoGyELR7JbCGZ7Y13ex1nfkOP2
         100B4u5sDGzjQN5oHAEp0ysT5fH1Co5NzAl7lreEoSph0rkNE9mb7xfhEkMqjhUNiu5v
         wCGTJ4CYSTDDsKT3m45FNbA30lcwjqpoA3NGxPN4g8WQjGTiW8ZA4advKOm8tb7tGU7H
         taUb1YXAldLyGOEdBMU8oibC81s4Z5ixn2lzemsuAC+typXqmHMG46J+4g7wN03TnQAO
         5QBw==
X-Forwarded-Encrypted: i=1; AL+hErHmzNhbzQl9kJW1ilX5fM9vM/QE7f0PyjryMqZita5Ty72OaeWnDlCn0rLlS84atTdTp/Y5WU4K@lists.linux.dev
X-Gm-Message-State: APuU4Z/rwF014l0jHWkljDpHyGXDYKcYZXQ/UFcotrq4yWiSTLvsN9ll
	azWwGk+aau7W3ut9tdyNxhv+UPfmmwGkolXckQzMLd0/G2e0DxkGiqzjE4v8HVjfIwc=
X-Gm-Gg: AZFdTZeNyvFYCbaOWVzTsTmxMHKXl4mJY6Oe1/j84HiV4sDdS0dCzFPofDTaSb1hCIi
	86pb7judERlcpWDhFGRitdK8DopdNdjsqeI3ZsER79h37PaLHvoMODKcI6vmFipJt1LMgrdWkpX
	7BFdyQSI2kjEK5jemPzWceCsdwWHTRqWOVr6BeK2PTuYnlCKzF28pOBUYfVDLl+f1pyiy876foC
	huLQdsTHJWwDkVvGSN//2Ad8UUnoy3v8DIPDqRn7hpNO/WUvh4AH8FMdDdVtJne2cz48V9IX9ZP
	LgXvkOvC+TC/HtgZ8vDbkpgUOOauqM/odwnSKmV0Oh8MmmS5HVNtYHhBMUTfMgxXsI1yTghyf+2
	H5CUu4S5ey7UUtcYje3Mft+3/CJ5syAYsVI3YTf/wAqOLBjimt6cHRVrz9cwbPiG2ARpC2F7SZ8
	QT7I2n6qEji877yyoibXEEm4yIupGLskMFAr/YOJeRXg5ccx7XHnFlbKR2hbwAR5Sedtpjq5teU
	5GePu6xnen+6NRUpV3ijO8uOPezObsPKx+PJExs8Mmd7gydHqBiFbGic7OTo9DPKuBSpA/svUwf
	nwslT/8=
X-Received: by 2002:a05:620a:3722:b0:949:472f:226e with SMTP id af79cd13be357-949bab15455mr2786066785a.71.1795526275080;
        Tue, 24 Nov 2026 05:17:55 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349cdfbasm134605646d6.17.2026.11.24.05.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:17:54 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVqPC-00000000P5z-0Ouc;
	Tue, 24 Nov 2026 09:17:54 -0400
Date: Tue, 24 Nov 2026 09:17:54 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Nicolin Chen <nicolinc@nvidia.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 00/10] PCI/TSM: Support guest TSM drivers
Message-ID: <20261124131754.GF9566@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <2026112325-emit-squeezing-5d96@gregkh>
 <20261123090623.GK14811@unreal>
 <yq5a7bi3riha.fsf@kernel.org>
 <20261123115803.GN14811@unreal>
 <yq5awlq3pto0.fsf@kernel.org>
 <20261123135638.GO14811@unreal>
 <20261123152533.GE179082@ziepe.ca>
 <20261123185826.GP14811@unreal>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261123185826.GP14811@unreal>

On Mon, Nov 23, 2026 at 08:58:26PM +0200, Leon Romanovsky wrote:
> On Mon, Nov 23, 2026 at 11:25:33AM -0400, Jason Gunthorpe wrote:
> > On Mon, Nov 23, 2026 at 03:56:38PM +0200, Leon Romanovsky wrote:
> > > > >> >> But it should not, as you are making driver core changes that will
> > > > >> >> mirror the same thing that that patchset is attempting to do.  Please
> > > > >> >> work together on this.
> > > > >> >
> > > > >> > +10000000,
> > > > >> >
> > > > >> > Greg,
> > > > >> >
> > > > >> > This series came as a surprise to me given the fact that device trust
> > > > >> > series is exactly for that - allow confidential computing.
> > 
> > Device trust's primary role in enabling confidential computing is to
> > give space for the userspace to do all the TSM and attestation stuff
> > to get the device into T=1 private DMA mode.
> 
> <...>
> 
> > Getting the device into T=1 should influence how the userspace decides
> > to set the trust level, but it doesn't interact inside the kernel.
> 
> The point is that I’m describing the reverse relationship: the trust
> level should determine how the device is configured, not the other
> way around, as you suggest.

They are unrelated. Neither influences the other. The user gets to
make orthogonal choices if they want T=1 DMA and if they want
adverserial. All combinations are useful and valid.

Jason
