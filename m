Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199700;
	b=0844J/e4v6KEjQ5DxhPc+JO7HkjLcLID6Ru9a3NbWD2DUX7iBl2r3f8cejAD6G2Tc6pw
	 oGoH7tVFJljkAi2ZkAYDo8SEZIRMjGvKgRa2NerQ4ThiddPnsvw0MbYie/jNWbjneZ4N/
	 Vet739g+qRF1tHL9DhE4sJuo8Kg966vzBIZJqMN7Zz3HMeIfVTJzB5zTJ9Ww/rG1me27q
	 KQDxPE6krJmuydZYxMXqM21JWZYkrynaHYZFHCA5ya4E8YlYkFs0o22RL/fsu0x423fjr
	 9exD0ifIXCbgsmLXbcZsH1qwMPNBctHegwkXf6eep5mtVKpI0PENeETtoaKPnM5EqRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199700;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=jPtMMj+TNQI4z5t6onBp93FYMjBvk5RvCFaoZZ65vCY=;
	b=Dqe79AyJ36x0eDaoL3U231epRuPz0A7/sq+mojpTRvG0MhZotTi9njCj2ZrgkWhv2uy7
	 Mk1xon/NNzTHhMeV5ANvqH28UFD5qNiCMP6+mOxSeOIx3UU9Y9FGVX0V6r5tL8aupOb1A
	 BvGH+vCZQXu+q4DTcgGnc62Y+3Dm1UyM2FUWP5mN1EcJ7SqmkrXtfDllKvb3XmQnugva3
	 irUDI9U8uBCbDv3Q83pywj4tRLN4wotVch4u80iue2HMU2Bm5MMGOSCmpSHlq0cOpAk4b
	 ZgDKTlLH9AJqRmyA5XijvbvPhPspNkdaQLVsvdvLJmpjC/yx2G1GroJwjOD1bpBhMPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=LpK6y4kK;
	arc=none smtp.remote-ip=209.85.219.41
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FC760A2619
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 18:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33FC760A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=LpK6y4kK
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-9210f2622ccso14952386d6.3
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 10:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795199699; x=1795804499; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jPtMMj+TNQI4z5t6onBp93FYMjBvk5RvCFaoZZ65vCY=;
        b=LpK6y4kKQHtJpPg0vaBR8RoIMnkx2pmladg9Hr8I37G41AdTqnPgVsD49m73sPiHPk
         aZCFfYDZbG+pH8TmftABJLFSg9ce4yjRTvW0AQV84OR0+C6RLA+RsI4B2KP3D1fdS+1Y
         7wNH7/8MeLvgrmykkS8d8CSZfHXTBLqQxa4HSzExgZkBYyOgBXwCjwcYO43xt0mCvXyw
         3lW+AQVV29S90RV3ipkcHbJqKoZrqdx+/N7q/qmZd6o9Ck1P7bO4XVLkWKsZOyVTMPk2
         NfdRoNFJ/DxdxsL2bsP9373F4GdWUH/8H+yUfP1Byl12uP5Q/JHQTLO5BoNFMf4czXpk
         eHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795199699; x=1795804499;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jPtMMj+TNQI4z5t6onBp93FYMjBvk5RvCFaoZZ65vCY=;
        b=j24PdTqkQ2Xu+wjzOHzDj8hM8RDZzxF8aIHkfZ3RL4COMcgq5Uoz7XWlPdPYgIrFoU
         XhntWFB+eOSyVU+Lxjq9MMwOM0fd9XbjB6dg2N6QLoQZGSle6dP5U4qPb8P59/z9Ip94
         8tCd3qYRcWFlKjQhJOeF6YyDABqRZjnG/tvImBqhf95c3TaJOOSKyjvYzwFFv20qtTNi
         ZH330QXZSrCrBrh3DrgQOLN6gt3y+rKe03I+EYaXvPQvAHTT3s5TvAXPH2uBAZKaHAye
         Xuv0a24mJrhLzi0E5sYbYJBDdaAZv6zU8UtSgliPxodp5eczBmyNNTmebk5r5gnp08on
         2hZA==
X-Forwarded-Encrypted: i=1; AL+hErF4NcSm6jrXXTaH+isDNVnpS3RysvtAMQklWD8vu1On5jdHtgYF/TQFYM/5VVqtB6UTne+AtcIQ@lists.linux.dev
X-Gm-Message-State: APuU4Z97O/++tLnqtedEB9n/mu9/3f1HDlY0T+tVRMYLPnZ4wAhz0Cfr
	97W8uu9FZ9ub7fPbz8wkNtEcsWg/gDcMlbHtlR8Qk2c8etDpqvp87+FqBFgoyV39Ro4=
X-Gm-Gg: AZFdTZedcLOV1TdOZnRVD1ZBrmiiKq3LwMA5YqnxSZ0NyMCR14h6ZoAsnlw1fpCs+AY
	4al/ZPuX8Z6sgUrgYIIhWPZthc873M3bDXIbhvw8cIQ22IyrcJ6a9zJ0lEEZmy536PMvLOsBnTO
	sz/osNhZv+hESiYPIbYyI6dh6fBRl6UxInU6zYgHRY7Z7aXXayPtTcX9cVA75v6zjhPodUUJbXq
	AIw0aUYHIs1S5dwKTGhKIXbTdNMfvXQlq298lMCY0EVMM6Idf1VUMc/yYhFlDcG8moTC7CFZ9sW
	M1fCYqXjF0FCvgR6yuS9V6w/qv1cSDup4Ki15Kr0rOrWcj5YBt7lQ0itchcKlckfpGbc/wMxUPC
	UDGbxVjPyyBU5fivM2QnfCVXczpZK7J4SB4CT4KYvmHsvibZ0jo6ZaXa6MF3B00Say6rZBI7MlV
	bC4SMgdOuVRiyatZiXwc9B5hbgxuSlxurzcx6ciK1dyV9fowL2qwBnZGxJ1tX2a6L0K2Mzen02K
	8/QL5Sh0Iakv34539Qo1T5TBOj7FF+uyGQs+Hp6Is2utF3jwDU4aMfb9rIG5yXeJRnaZ06XBLjB
	As9Fkg==
X-Received: by 2002:a05:6214:4881:b0:921:152a:4e48 with SMTP id 6a1803df08f44-92134b1abb5mr65747176d6.32.1795199698766;
        Fri, 20 Nov 2026 10:34:58 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a16754sm32821016d6.39.2026.11.20.10.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 10:34:58 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xUTRp-00000004jZ9-0OT6;
	Fri, 20 Nov 2026 14:34:57 -0400
Date: Fri, 20 Nov 2026 14:34:57 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, Alex Williamson <alex@shazbot.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Steven Price <steven.price@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Vasant Hegde <vasant.hegde@amd.com>, Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, iommu@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v9 09/13] iommufd/viommu: Select vIOMMU operations before
 allocation
Message-ID: <20261120183457.GQ3115493@ziepe.ca>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <20261116081935.85372-10-aneesh.kumar@kernel.org>
 <20261120094207.00002e89@linux.microsoft.com>
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
In-Reply-To: <20261120094207.00002e89@linux.microsoft.com>

On Fri, Nov 20, 2026 at 09:42:07AM -0800, Jacob Pan wrote:
> > Temporarily disable AMD vIOMMU allocation by returning NULL from
> > amd_iommufd_get_viommu_ops() while the vIOMMU interfaces are being
> > updated.
> > 
> why? if this merged, it would break AMD driver vIOMMU functionality.
> And not temporary as I didn't see enabling in this set.

It is broken already, it is missing some series to finish it. It was a
mistake to leave it on like this.

Jason
