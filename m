Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793618908;
	b=4rSn+aXY3nwH0aXFV9MhFv7nIw/F3dcdNhoNwJWj4DN3O27UAeIMAHcvkl/bHv/36CCJ
	 YbC7yJKAFuQmPr9tLfGVOBz1Jn+9qTaqQqC2o4Xu+/7wg77KWhvTXVXv2RyXdkpWrgcgP
	 KHwuNaauJBY0x7EUsSxpTqxz7fDfRtKwgDGxY8gUVqCK3TJsjviqrpnqRfx07djzU36Am
	 IsKUCsn+jRhhPTuPIwSz/F2nMP0ypBp91WRheogfRrgwJpdhzMD3WoH5posSgsgn5NCqH
	 f6nJnRhChrY8sl6WhKKIqaGMcJHZGpY3StRZ02c8LWKSyXKugKzghoRYQM+EaQbwHZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793618908;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=MLwaQ6Jl6/f4tSN2XtwUoJlbirpWyViWzdWq1gz8VdM=;
	b=qPpXfw+4zGPyp6H8ZBwyarVFoNsiNg4XlU7D3/CnmVnMtA8XYBUD+P4jPf8YaFBK9Sdv
	 rclnuYelfwbYaA7LgBUMP7y7i+L2PwNmlCreEhA1mzlhEnRRcj7d6P5Fbx2ODi7BRA//C
	 VLsXQheu4kT7LPhMk8gNd0jcCdkyLIZoxn8G0K5js/p19seIGetUzCKL8obnSBBW4LAEE
	 xEbOol4MKsRAkcv8M2wtFOT25X4QifuDvKd4ndLTEiLu7NIhs+l8XrLTvN9t0vRt2pblu
	 3btGOdkdNb02rELJj0DqHTsbG73g6CbJIO+4/VZv0lYKBcBfInLBmWSF7yAYsL/niJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.208.175
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3F0606A337
	for <patches@lists.linux.dev>; Mon,  2 Nov 2026 11:28:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B3F0606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3ac97e45a79so27345571fa.3
        for <patches@lists.linux.dev>; Mon, 02 Nov 2026 03:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793618900; x=1794223700; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MLwaQ6Jl6/f4tSN2XtwUoJlbirpWyViWzdWq1gz8VdM=;
        b=qIQ2ejEtRr21NrEuCV4pMJgM3PhQjmZwVsbgTI2E9SHZL6HIiFEd99mQhCZZja39Sa
         4Wne3paKRI0HxAMDQV/v0Dc9UsDQWQUV7nElwR/y9SCoINc51kThlHd82ET1FINYt/xr
         aw0ypjseHVo0p9mDLVQf9CmR9U9jRIJ93ABktK234qZrDvAxx2IGQqo5I3wuAZPRtCeC
         LJYioPVr4IlDvhha/y8o83w+CME7I+bMg4gk/UZafn1Ompx5EfGTseTRGKly0oNflu83
         NZseOVRdcgOEt3X6OhTJG+805I+whhPzuBFTv7nrITucJt+mNtejFe6ReeIEffmpcmY8
         +S7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793618900; x=1794223700;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MLwaQ6Jl6/f4tSN2XtwUoJlbirpWyViWzdWq1gz8VdM=;
        b=03UYDMsLNGyJxJthUEmaq8a/eH5EC5SI1vBqBSmXGHOnhLzAGP6fmY5EFg6LXmf0Lu
         f98v3uWwreOhsF+1CazI907S1vX++4zPTCr70bfeKns/2KuO1hvdg6w54UznoBPqsw2p
         3fJCAj32dLni60dWB/jMBI0a8CgkUYyTs7y0CUyfxoObKypfAbrnkPn57GqBBUW972vP
         V/uvnddnPtyCwN1VHHH/7w34fssjuQTipgVQ5Ii2owAFJJaheJgd1lFcdWLFNWfogocA
         iz/ja39P5iEN+K08Uqtp3uo/qB7wZvRXYN6i0ORSfb8/ChAE0QCrS6u09SzQnQ1tD79f
         ANKA==
X-Forwarded-Encrypted: i=1; AKwUvBwA6lUAy729C4Fl4unBHNCBJB3lZBwuNbbe1G/cWEC1Q6uY/p7fymDnUDOk2car+eDYPZcWONut@lists.linux.dev
X-Gm-Message-State: APuU4Z+i3oT5ts854X5YAIOCPuyOtPQSutOyIXlUSAW1IhnEhK3/NcuC
	qI+yy3DjE+zv4QO+Kqnto3jhCE1mQ+GI7sQo2jp5FgCzexF2UoNMFmVBovmTzbk4jAQ=
X-Gm-Gg: AYBFou07lq3FIqTG1BB1yjYnfdMvzf88EJUTlpUEp5uKshTdhhcmOIG0lsv8BUqtok9
	X1sj49d3GEMBfbuZiFPBirex10T6GuVDA6MpHjgiC6h6NKo9TaXRpTyc8VdYTktTDMXXevnGNCA
	rVS3K9w/kO1BTGgBmbetoDIZO0dLDAsa6rIvmjGt281syJT0npyic3oBWBqjomDlpWRN5HEURuv
	FHW8hD7Q8ffAaQYlK34yRE0WNuSzDSy69PYDSTbf/lklmSYmPmq1eVaozFa6joGBEiprvcMZyC7
	xRunnTQNrsfUMB2B63v3ciQ+I3b8NmldUBmi89AUQkHj0SWuSOeGvpHyPPZ9sgurr1N3TslqHje
	XsLvPniy5lI5/dhcvsGBf/RIVffpB7DAGbFax3yUV6XbcJk9jDksmCrwjfFfrHrKcTOF5K5BtC6
	AqISpLKRYMgWH6YTCBJtYvaUY+6z9UAL4AjQqMjNdpGEXItAb8Lr88ilfIo6w65NKYuTTqzeFAA
	Dj4x91F8fT3MKHUuBUxsvzhWtunWXFX9sh7tiEs/5ChjKGK//A8D8MjTfsSjlDmBjMKgkS9BX39
	CL465dogb576SrVf+Gd3fSPByJbKaqQukrz8awtL7uBeyGi1Z+Q+TW3Aq6rT
X-Received: by 2002:a05:651c:3137:b0:3ab:4eb4:5f19 with SMTP id 38308e7fff4ca-3acb7b5ac93mr23955881fa.27.1793618900071;
        Mon, 02 Nov 2026 03:28:20 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3acbbefd30asm23263631fa.23.2026.11.02.03.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 03:28:19 -0800 (PST)
Date: Mon, 2 Nov 2026 12:28:16 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Jonathan Cameron <jic23@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 03/11] attestation: Enter secure operation when
 evidence is accepted
Message-ID: <auhzxNDC7JZylDOt@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-4-aneesh.kumar@kernel.org>
 <auSfroz-gNb62nMG@FV6GYCPJ69>
 <yq5ajymya4ud.fsf@kernel.org>
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
In-Reply-To: <yq5ajymya4ud.fsf@kernel.org>

Sat, Oct 31, 2026 at 05:09:30AM +0100, aneesh.kumar@kernel.org wrote:
>Jiri Pirko <jiri@resnulli.us> writes:
>
>> Wed, Oct 28, 2026 at 04:26:10PM +0100, aneesh.kumar@kernel.org wrote:
>>>Use EVIDENCE_ACCEPT to enter secure operation after userspace has
>>>checked the evidence. Check the referenced device and evidence
>>>generations before calling the driver, and record acceptance on success.
>>>
>>>Remove the separate DEVSEC_RUN command and callback.
>>>
>>>Keep DEVSEC_STATE_GET so userspace can read both evidence acceptance and
>>>device state. Clearing acceptance does not undo the device state change.
>>>For example, with the following PCI/TSM patches:
>>
>> Note that the published wip_attestation_all_1 baseline still
>> has DEVSEC_RUN. I am planning this merge into EVIDENCE_ACCEPT for
>> my next revision, which is not pushed yet.
>>
>
>I agree with your comments here and in the other emails regarding
>attestation. I will wait for the next revision of your attestation
>series. If you can accommodate these changes there, I can rework my
>patches accordingly.
>
>Could you also add the ctlv-attestation-spdm family so that I can base
>the PCI/TSM changes on top of it?

Yep.
