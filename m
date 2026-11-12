Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794464607;
	b=xqkyujhWFfD8b6Xib1Lv/aNNxspUnNPK7kEjU6XYDyw4FLiDcUqX7IXpHZzHy41IMV1H
	 dszIOie4Tj9B4OIwz3RtG4mDemAjEARPiwbQoiUZEU8umaQnJcSqKn7h4vQaDxva0CO0U
	 48g9NX/Vx9ZBXoTghpiunAzCcSp7EIEei8s5naqMcmcP4e/9fHnyhx/8bkZeeUFF9aH5s
	 rQIBrOVyUHFEgW6R9F0Q60nJ1nGNEm+SvSgqkDS7/js3wCtpsrQOQNWf5IJYMMXlu2UEA
	 cnsJ8UOX9mC8xIk8rntiOJ3k7gY/oFTnIexZzbVWtykaJH/Owmdqw0/HgiDUPdps8/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794464607;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=zy6ApZ2Ry+9EbeLcbhxt8WUVLUvktSFzo5TP+sTiL/c=;
	b=Veuv7sE/L7bDQjBCThAiCRgDvN4OdoAWaRGf2zauoDINmxSn0OzwIkkmlW6LydDhJbfU
	 Fdt9qTxOj+AForVavpzMh6n8kAV97Ot/YG8elV6z1ZCqDPHJwWFjJtoO6hhK45+rN7pKa
	 kC+Hu0CDNdmQhZsa68Pei0f06jf4JReOiLMlAlLH6g5+B9PKF+AeljJGNw2xXNTar3XTf
	 akufhOKitSbKx2DU9rhc6Syc00MHf8z0PSk79gT1J9MoK5SvfGxOiHGu0N+CDd16u126t
	 hG+0qeVPqQlcFn1fmyYsnFQnUJwMPfVQ5bE6DW+Nrh/T7dbHa2qTb+nQW5kjyI4jqyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DByTpNmf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D94606A324;
	Thu, 12 Nov 2026 06:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DByTpNmf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBC81F00A05;
	Thu, 12 Nov 2026 06:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794464606;
	bh=zy6ApZ2Ry+9EbeLcbhxt8WUVLUvktSFzo5TP+sTiL/c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=DByTpNmfDkp6/n90NFByvY85ftMmLKlur/NmMWsfCg+mySMO/K9cxak/dnJOxsn/c
	 TonOICF4JhN7w28EMhvwu9j0kq2tkL7zRHcaTzhb6N3V6r07hNGGFuM798OByJgUME
	 p7a4oGX3sSo5fYhMF/ELZEqnqwimStkqhX1MZSO4lLKUISJQIoUhsi0b3u99a60Zsr
	 FucdlRul/X46FajwrQV4DD3ub/mkU697yUOISDQ/KtUco8heuW1JPUysHCRlFQkfNd
	 f5zfAZ44pwnX2/oiEwjGGlKC3e8Y7kMVgYpXpSq+VdgH/lx/vxrZkuDGaNlVUXHEW4
	 0KyM9n+FMZSSw==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>, linux-coco@lists.linux.dev
Cc: Jiri Pirko <jiri@resnulli.us>, Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 09/11] crypto/ccp: Defer SEV-TIO link setup until
 evidence acceptance
In-Reply-To: <066c612a-057d-4f32-93eb-a9bf7d2ff372@amd.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-10-aneesh.kumar@kernel.org>
 <e8785bcb-45ed-492f-af66-deadfba6ac25@amd.com>
 <yq5ao6c2p0ek.fsf@kernel.org>
 <066c612a-057d-4f32-93eb-a9bf7d2ff372@amd.com>
Date: Thu, 12 Nov 2026 11:53:17 +0530
Message-ID: <yq5a8q2yr2ju.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Alexey Kardashevskiy <aik@amd.com> writes:

> On 7/11/26 00:14, Aneesh Kumar K.V wrote:
>> Alexey Kardashevskiy <aik@amd.com> writes:
>> 
>>> On 29/10/26 02:26, Aneesh Kumar K.V (Arm) wrote:
>>>> AMD SEV-TIO currently establishes its SPDM session and enables IDE during
>>>> connect, before userspace can retrieve or accept the device identity.
>>>> Move AMD link setup behind its evidence_accept callback.
>> 
>>   [ ... 49 lines skipped ... ]
>> 
>>>>    	dev_data->req.sla = 0;
>>>>    	dev_data->resp.sla = 0;
>>>>    	dev_data->scratch.sla = 0;
>>>>    	dev_data->respbuf = NULL;
>>>>    	dev_data->reqbuf = NULL;
>>>> -	sla_free(dev_data->output, tio_status->spdm_out_size_max, true);
>>>> +	sla_free(dev_data->output, dev_data->output_len, true);
>>>> +	dev_data->output = SLA_NULL;
>>>
>>> This is a bugfix (thanks for pointing!) and does not belong here. Want to repost, or I can (and should, really)?
>
> still ^^^
>

It would be good if you could post these changes, as I don't have the facilities
to test these SEV-related changes.

-aneesh

