Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482E52E36E7;
	Tue,  5 Aug 2025 03:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754365418; cv=none; b=qvWjnSdr86YcBSmbb/4y8SqeRAspXmpHVIJit/I3+OysysH+Xl457xKxQNfiKgLAqwhZVwYAMwL++dnHQg6jQr7BJ+/FjtavzXEHxxxuaX3cv3IhXS1woAWmljFkEbX4H8juTh46IUsryi2q6XJJH0O4mxrExt4HFMwDNnarlYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754365418; c=relaxed/simple;
	bh=ZniYHKY8QuSd7kXt4f9NMukHnaBfrOkk5MNpA7EfaWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kSCmo8qd5G9VKfHgr+bwHTR9Ayvha7g+SkjZzqhEkO5otn/64WSXVvBVkpCYSRP751JdqqseE8weTL6YRAGh+3u3q+tN8aMEszaav4TQQHrj2851aNACkdOuuwEElPko1as6uaq2FrgzfaDIURmOnXNKAbe2jyvKbrWuvi7x/Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=chLuxORT; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="chLuxORT"
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-af91a6b7a06so900846666b.2;
        Mon, 04 Aug 2025 20:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754365416; x=1754970216; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8WbAm5nExTQIfe1sqlUAgj5NdK4GQb4TTe8phjhgS70=;
        b=chLuxORTaltKP+PS1DOjUrnv579w3M7jxQvmDORR5GObqBzLi7nv769GLpu7D20p9Y
         Pyw4C/mjctmoo3P+vT1APXGrqfomDHMqqAPr95E9iZOGwEXSz9EXKHk6aajPo4zU8isv
         5e6gq8f1oDR7C1IaBW5sHfITNu0NQccj5JyEaQ0/QXhuBMlB7ZW/FI4fT79BsDGsxeXY
         yfJr7rfWOAN3+Bgri+C8R82SU052OwtQvh9XgFf1ZTNPwjIQ7Xr2/m4ThscdST4gpYM7
         7UUpRH4PYRCFZQ1Pss/GzVJzKJJLbxCZe4MsTkVlnt4ktQEYygAPr3rveuKUAN1gi+Xs
         SR5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754365416; x=1754970216;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8WbAm5nExTQIfe1sqlUAgj5NdK4GQb4TTe8phjhgS70=;
        b=xBRRvZmUTCQndWkb8mHUT3G0ZcnmmsHfMsxNY+OnaFO0xb+7pABEF74CpU1tqTTP++
         blK2kdLlVztwxRbSiHi1UkBouYbZd3Sm+phPnXNzGt+3pi0aFRZbjUCShcV2HC9/ZON7
         wA5gDPgGXTCz+Gams8BMU4kzi8OPLtOdm0HeUpBM5fi89hOersyOlHtddbSV+ZIIgCi1
         7b4pyMg6e1pH/iRIbFkoRLCoIIXclr0tmPd2umD5ge3JTt9WKKa3o0RpD/hg7SOi+yS1
         eSaZhgV29UemWPgcdW+mfQ9zskc/+SHayzKxWPcM36/nNvcypa4N5eHpiJK9aW31fzRi
         iOGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWGmJAMa54qNtJtW3T1u8fHeNi6YfwK9SmG8VgvMpg1uwm5eXRjp0l6TJcZV2H0iD+Qrz0TKaGAA==@lists.linux.dev, AJvYcCVvE/E3K/98UNPSG0yfLvU6SiTYuQwvIXu5lNDjdZxp6xUMMlbo+cFy3JIM0yAXAGbXG8Rw6A==@lists.linux.dev
X-Gm-Message-State: AOJu0YzHPV/9URInPhkUKAaR890U8IxnQhILQ8uJewznYKG/15wzLWSB
	vkkPiDfKvXKEwD5I1L0URNQqE4F73yrT//G5cNiL6D8I4rOClks+4Bun
X-Gm-Gg: ASbGncuUt6JGZhsDZemnAOvpGB7UbnMttI5xiDoGaciHqG53vOpt7Sa+KVfWy740lhv
	RU1caa1LRunaHvcV9ZnQ8WKwFcHP/Zrqcw70wmKCgEOApXS35RHPFLdXENq8N0gcwNub+xq6TN/
	7iNGoUchTJ19TXgnjM279O4TN+VTZsS2oWUABclrhc9S0l18Ow5Lp6OnkQewT5eofv1IIyb5i5k
	L015HPFCgSJ8vCJ2+JQCWe4aSV8pQOjx2/JJYuH7J19HnuTPVKgfg0zspGZp3owmv3+5jOzHCr5
	85id6XkEkYQK5BO4jgEr1vZgK/1Q0Is4xcN6QEJ7I4v5a3PDphzyw9t2hjXWyobULEHEPKXuJgV
	NDQf0mip75fyWPyng0A/ZJBSZGUK28NqjKK/qPjOTXH7pSJYdfjMdxYD8h+0srMiyUCjzo3c5CU
	4sGyZO9M+1n8eovQkLFije4Sr8VDf5zo+7NFo=
X-Google-Smtp-Source: AGHT+IEjmKLsdjb2ZjdT33M1Kp092lXe481aQZe89Govc26G8aNvSHe8HQJ6UUJmTxXI+6BFVbhvGw==
X-Received: by 2002:a17:907:6d04:b0:ae0:d804:236a with SMTP id a640c23a62f3a-af93ffcaddemr1330563966b.3.1754365415456;
        Mon, 04 Aug 2025 20:43:35 -0700 (PDT)
Received: from [26.26.26.1] (ec2-3-126-215-244.eu-central-1.compute.amazonaws.com. [3.126.215.244])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91ee3c1f7sm772698966b.68.2025.08.04.20.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 20:43:34 -0700 (PDT)
Message-ID: <1684792a-97d6-4383-a0d2-f342e69c91ff@gmail.com>
Date: Tue, 5 Aug 2025 11:43:29 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <a692448d-48b8-4af3-bf88-2cc913a145ca@gmail.com>
 <20250802151816.GC184255@nvidia.com>
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <20250802151816.GC184255@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/2/2025 11:18 PM, Jason Gunthorpe wrote:
> On Sat, Aug 02, 2025 at 09:45:08AM +0800, Ethan Zhao wrote:
>>
>>
>> On 7/9/2025 10:52 PM, Jason Gunthorpe wrote:
>>> The series patches have extensive descriptions as to the problem and
>>> solution, but in short the ACS flags are not analyzed according to the
>>> spec to form the iommu_groups that VFIO is expecting for security.
>>>
>>> ACS is an egress control only. For a path the ACS flags on each hop only
>>> effect what other devices the TLP is allowed to reach. It does not prevent
>>> other devices from reaching into this path.
> 
>> Perhaps I was a little confused here, the egress control vector on the
> 
> Linux does not support egress control vector. Enabling that is a
> different project and we would indeed need to introduce different
> logic.
My understanding, iommu has no logic yet to handle the egress control
vector configuration case, the static groups were created according to
FW DRDB tables, also not the case handled by notifiers for Hot-plug
events (BUS_NOTIFY_ADD_DEVICE etc). iommu groups need some kind of {
add, remove etc } per egress control vector configuration operation.

Thanks,
Ethan>
> Jason

