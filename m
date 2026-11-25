Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795616245;
	b=dz98cUgmjJ17HQSaqOsccaad2s4UMXssdIPpKXVkMqHHIznMGzHUY2yiuJa/W0c8T/Iu
	 HiO1ZO7+ShHKKIfhzKm9ZDJQuK1sPj9vOIDqVGQ0+opSxBG30AxxLHqbdsC+ZaFxMTjyb
	 7P4uUadOwIrJyv59jFWsDkfgwx4kGQr3c1jZ7qZWPwYWvHFN/i52cmjT2KDfkUn3sminU
	 9DYqsQFBq6ZAbVSroAnc0Rv9SVTce8tg2HFCSoyAhuSm0zLUzHV54ThpM1EhtmPWVweB9
	 ejU4rtz3pvCCJk42Ek2l4UpanV+8j0oRJhXxgTF9Rmt7adkgZrzzgjeTku6XuCCu9+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795616245;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=82OlthbTcf764s1+nsFlIqp1XEt+X8IqMsOwsuhDROg=;
	b=m1VhD9SQJ/KiNvsYPfRx09nSF+FVeoniVfVu+RZVq2yWTrJ7ytXYXvef6YDs4Gk2PFxN
	 F7CeDfOg6st2b4JhlzK6/zdyYEkXuwtsfZTUL/XfMNtEOc8klE/1i1eXVyjjL0F6h2YNH
	 Sn3mmbwRzvepr1AATLyXQ5QpMzR43MCqWP/iRyB0QMjqxfdOTto718c5f6WNYwwSqdNUd
	 oX10CTHp8i7HxT33/Jc3ikyQ6JP7yYKAs8Zn3b+7e79odBpIKDPfI7X+38ncC3DtcaJ1h
	 sJJnoW2b5w/jj9qNuvQfsZGvA+ydEsdFS+ojZwdIjL+DmxdkGIu9dad3DxaHqEK4/dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=aWoAz+MR;
	arc=none smtp.remote-ip=209.85.217.41
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1FF606A333
	for <patches@lists.linux.dev>; Wed, 25 Nov 2026 14:17:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B1FF606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=aWoAz+MR
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-7d2dc1ac787so1867856137.2
        for <patches@lists.linux.dev>; Wed, 25 Nov 2026 06:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795616243; x=1796221043; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=82OlthbTcf764s1+nsFlIqp1XEt+X8IqMsOwsuhDROg=;
        b=aWoAz+MRKJ7ZzjVoomqnIi8F7xtWVif6B6xrm3ZiQN3LCsHrIzjNoksJDeqVFfgfZ0
         6ScroIcQtVKUDNtBAPGV3gBj1UTZMu23rMtu12tc/NKzM+VSVgiTAJHQz/giCI3WIIPW
         D3V5eEeiuCWiaqpKsWTt6RB7RwSlyGVaGakyOvMA5iAKnNz3viOiWz9xJ2v134dF/Dcw
         2ZGCZ8UJR/qejGtBWQuimnD+roaYurUturyOREBMHnebxmuHrypMEyhHLVlTe2fICpGc
         vbkIPICxUyAtihDBln18T9TX69g6GVFbyxkgqC+M9b26nATNNGftaQdMySjfeaQApBTR
         0rJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795616243; x=1796221043;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=82OlthbTcf764s1+nsFlIqp1XEt+X8IqMsOwsuhDROg=;
        b=zLwDDWnrlfycDKkscsG7oUEjqvlZmb+E8a9HCsl3KxhpHbF1S5uWLAdCuO3Y3LHjy7
         /HauSKtQfQEwqLd9imyGf3Kmr7gVmqiFclckFBOZQCZDd8kc9UB9AcV/jqURZrHtj9ME
         KN7STKqN0sHfAPgJ8cpr3dsiTMFqZCIpatLB00PHfOz1KY79Lxi1YsuxNiA4jM1E6/yZ
         V01PqvM21u7m70NqXfg0kUTfOpEIcBPWFtc9HBVfD1lEzD3+Ra+RdrI9OSOzolPUpVWQ
         7NbzpJAchNWMl8We+TwBV56Y0oxEGehaFecNb83wKwKyrsxdQamrpAXeRuGt3LbwFBbz
         IR7Q==
X-Forwarded-Encrypted: i=1; AL+hErG7Aq7HwsTyZRZ6SNX8PDfCKD7nR0BPeSm6oeJvLG77udR8fTnJzctvAmNo4c/cWb9VNIgSGKdx@lists.linux.dev
X-Gm-Message-State: APuU4Z+/Py286scEd+8Df0sy2yuXGIiWECIsJNL8TWOJi1LCFw1upwDh
	e4PMTPM3i+IT6Z+WUTE+YLC96/I53jXJz8DDKK52fGHOXmPeI7qTQbFbyuvpbGlZ/do=
X-Gm-Gg: AZFdTZdnpA0H//WMAGx7knXOqRmnO8h66L3Xj4lGSalhsUXgL9E7sKu/yQTObNzu93M
	vdgEnJQFEqPYL+61PDv9xm4/1QulRJML4ClW3wETcUguraAUG916r4zXR/x4yV4q+P+pw5RIXa+
	9485L1vqxcuLK39UZ2p3HqeqFZwshtcxNs3KEi/09maUT76kJ2h5fiy0iD9cqXESDOq6BhvpMo3
	U61EC5yS1BF38K4VpZh/cOjpIltuaP0eTFu/iH31K/d5q88bBrT8yCAVTeNjehz/YtjSMHVPUx6
	MXW1HL+BEBmedozMHBcqbjWdk9S1ey4DAledNSthXjCOJd/ZqsF/4DCksJjP5hTMeYK3qXa8MdU
	4GopOOVh8PIBIr1D4BMDHL4XgqVPwjEy0MoAUVR6GpkLBgXK1O8i7fWNDuxD1SBOI8rzilwZDED
	qYFmYTFqmxUXYr/osR3VIaT5n2pn7/LC3fP84YUx9tLdODOOgTgxJ/SUHOn+jW6qkPo78XM3yfI
	vYzaFDK3gS44l+AVBIUtAenOcUONBjtQyeEGtGJ+/0R9emn/YKZ5Z+vr572ZKj/M4wP4iVBKQOa
	eCHFdg==
X-Received: by 2002:a05:6102:374c:b0:7c1:75c5:c4c with SMTP id ada2fe7eead31-7d739570939mr8150077137.25.1795616243315;
        Wed, 25 Nov 2026 06:17:23 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921645f50f3sm60805116d6.24.2026.11.25.06.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:17:22 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWDoI-00000001jMI-14hV;
	Wed, 25 Nov 2026 10:17:22 -0400
Date: Wed, 25 Nov 2026 10:17:22 -0400
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
Message-ID: <20261125141722.GB246011@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-3-aneesh.kumar@kernel.org>
 <20261123152903.GG179082@ziepe.ca>
 <9f92f7ed-5198-45aa-9cef-515ccbf98398@amd.com>
 <20261124170754.GB114530@ziepe.ca>
 <17ee3598-9cc3-45d8-b068-31fafa06268a@amd.com>
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
In-Reply-To: <17ee3598-9cc3-45d8-b068-31fafa06268a@amd.com>

On Wed, Nov 25, 2026 at 02:34:38PM +1100, Alexey Kardashevskiy wrote:
> On 25/11/26 04:07, Jason Gunthorpe wrote:
> > On Tue, Nov 24, 2026 at 11:40:16AM +1100, Alexey Kardashevskiy wrote:
> > > On 24/11/26 02:29, Jason Gunthorpe wrote:
> > > > On Mon, Nov 23, 2026 at 02:03:29PM +0530, Aneesh Kumar K.V (Arm) wrote:
> > > > > Register the built-in TSM class with subsys_initcall() so it exists
> > > > > before a platform TSM driver probes, independently of object link order.
> > > > > CONFIG_TSM is boolean; remove the unused module exit path.
> > > > 
> > > > Why isn't it modular? This is going to force alot of stuff to be
> > > > non-modular.
> > > 
> > > The TSM core registers a class. The platform TSM drivers register
> > > TSM devices of that class. If a platform module loads before the TSM
> > > code - the class is not registered yet so it fails. We could either
> > > teach modprobe or have dependencies in the module or do this:
> > 
> > I understand that and Aneesh's patch is fine to solve that problem.
> > 
> > I'm asking why it isn't modular. They don't conflict, using
> > subsys_initcall works just fine as a module.
> 
> it "works" because it is module_init() in include/linux/module.h:
> 
> #ifndef MODULE
> #else /* MODULE */
> [...]
> #define subsys_initcall(fn)             module_init(fn)
> 
> and then the dependency problem again. Do I miss something?

What have you done to make that a "dependency problem"

The module loader chases the symbol graph and orders the module_init
calls based on a depth first ordering of the graph.

How do you get things out of order in that world?

Jason
