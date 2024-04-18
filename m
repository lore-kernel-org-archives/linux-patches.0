Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF3338DDB
	for <patches@lists.linux.dev>; Thu, 18 Apr 2024 05:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713419869; cv=none; b=AsUPY9ZJJ6I2bZzsXUET+Ox54OVOneOlXGnG+w2iLVC7xRkYQivvzH9bcKP+30e+cCJztoklP9DD6ppFdLPQSYFujcMxsMdGfZ4HBXQmDayXHyHum3czyUhMfskvGsMQ12BEAmbiU9a45jgcj2si33AzqwlRO0e/MuW9HpPXx+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713419869; c=relaxed/simple;
	bh=FSWfeJRVhpivjhcZOKtr/RECIGZFZ6Lvd8suprQ2zlc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mpn40EQUr9GUSQ54BWW9kQPV2Zy1B2AZuS7j3yBDuNt5nCQuycm3TAbxR1H6iJuzDCakBufnqGjxDEtlP5HT52gHUdxSRFnOi3QD+WV3vSgewQGJ+1dcGAF7z/VEvicz1SWj1TlfGplvS0mVZfjY9P+Plp9n7u0CkXMtXz7R1NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PIb/x+yi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PIb/x+yi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713419866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WnN76fVoeHJRKOHHPsuZPbIKbYuzDGfrYAq34ct/Ccs=;
	b=PIb/x+yisoY2Up2KefHLTe8qQtOw0rshL65+xSCD4lrgWwD9qAg36FazNx6sSwmjKppYVe
	mtvImtOMmIWma7S4e7lwLB8Mzg0xs19HEJaQ2QaeQk7NxotxP3WwULMxnhjiRdyIvGe0m4
	gas8tibb3L7I5ZnbEkHmSNEATvaVTKo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-DTcWEj5HPW23xpk2_2ejAA-1; Thu, 18 Apr 2024 01:57:45 -0400
X-MC-Unique: DTcWEj5HPW23xpk2_2ejAA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4189d4aee2cso2940825e9.0
        for <patches@lists.linux.dev>; Wed, 17 Apr 2024 22:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713419864; x=1714024664;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WnN76fVoeHJRKOHHPsuZPbIKbYuzDGfrYAq34ct/Ccs=;
        b=ROGxw5/c+3rxgude3OJ5yiRfmUNpNxgdUpfP9TVjvqvbOckByfVUJH6p4u1me/NbB+
         wJQFnBYw8sznyrHOQQjbSWDpHRBps16IiFrLJJgFSjShNDBab5rVaAnyHiqk6ZJzDnkS
         eiUhYwFkxWvvOuOT9QUYXJDF8o+JtVgcBiFDx7H1uupepUjCyIxeBkG7qTcYg5TqOCpa
         2K/50raErA6gj0e44VHfG/K5YTy90ZaoY0ln01qQkF0Y9zbe4JAl/RglUB8105bYT8ox
         KhsK61VY/8t3R7UfQAYk94F27L99/+pBzGGfJOoxDzVOjGrYs44WHcC128ROJnhhajw6
         YoJQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/uJzC5euyC4FEqAb41yeJBHJgot6P8AEU93TkKE3GWng8ELTckBfdvLRXbb0jhPM22SV1GCW0KZkTpPAIkUziwmvDfVRndw==
X-Gm-Message-State: AOJu0Yw018LG5neVkldjLDaQyLv/GqD3xsJKMpZv9Ih/PebOsfCu858C
	C/n/YNOjhoyOlfk++0xahhIOBhsnrTdEeMvHfbKhr63DEpTCiyCbDqOhLQTM7Z1fUm+tY5Mpdyi
	xRpHsThksw1ZexzFh4irhEf1r6mTf/aV+vwfKOoj9UqrgWd8vuJ+UwcA=
X-Received: by 2002:a05:600c:198f:b0:416:3f85:d49 with SMTP id t15-20020a05600c198f00b004163f850d49mr1207760wmq.18.1713419864128;
        Wed, 17 Apr 2024 22:57:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEivO//bEq/fkCuEybbkIrJpkIdU2CyNNJe3O+FwYgdnqOOzAsnV3tmnt1D2t9sOwRhRe4I5g==
X-Received: by 2002:a05:600c:198f:b0:416:3f85:d49 with SMTP id t15-20020a05600c198f00b004163f850d49mr1207738wmq.18.1713419863732;
        Wed, 17 Apr 2024 22:57:43 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-177-117.web.vodafone.de. [109.43.177.117])
        by smtp.gmail.com with ESMTPSA id g18-20020adfa492000000b0033e9d9f891csm909663wrb.58.2024.04.17.22.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 22:57:43 -0700 (PDT)
Message-ID: <00054ec1-66c2-46e3-917f-cd5a43ffe4cd@redhat.com>
Date: Thu, 18 Apr 2024 07:57:42 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] s390/netiucv: Remove function pointer cast
To: Nathan Chancellor <nathan@kernel.org>, akpm@linux-foundation.org,
 arnd@arndb.de, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, wintera@linux.ibm.com,
 twinkler@linux.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-3-fd048c9903b0@kernel.org>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 xsFNBFH7eUwBEACzyOXKU+5Pcs6wNpKzrlJwzRl3VGZt95VCdb+FgoU9g11m7FWcOafrVRwU
 yYkTm9+7zBUc0sW5AuPGR/dp3pSLX/yFWsA/UB4nJsHqgDvDU7BImSeiTrnpMOTXb7Arw2a2
 4CflIyFqjCpfDM4MuTmzTjXq4Uov1giGE9X6viNo1pxyEpd7PanlKNnf4PqEQp06X4IgUacW
 tSGj6Gcns1bCuHV8OPWLkf4hkRnu8hdL6i60Yxz4E6TqlrpxsfYwLXgEeswPHOA6Mn4Cso9O
 0lewVYfFfsmokfAVMKWzOl1Sr0KGI5T9CpmRfAiSHpthhHWnECcJFwl72NTi6kUcUzG4se81
 O6n9d/kTj7pzTmBdfwuOZ0YUSqcqs0W+l1NcASSYZQaDoD3/SLk+nqVeCBB4OnYOGhgmIHNW
 0CwMRO/GK+20alxzk//V9GmIM2ACElbfF8+Uug3pqiHkVnKqM7W9/S1NH2qmxB6zMiJUHlTH
 gnVeZX0dgH27mzstcF786uPcdEqS0KJuxh2kk5IvUSL3Qn3ZgmgdxBMyCPciD/1cb7/Ahazr
 3ThHQXSHXkH/aDXdfLsKVuwDzHLVSkdSnZdt5HHh75/NFHxwaTlydgfHmFFwodK8y/TjyiGZ
 zg2Kje38xnz8zKn9iesFBCcONXS7txENTzX0z80WKBhK+XSFJwARAQABzR5UaG9tYXMgSHV0
 aCA8dGh1dGhAcmVkaGF0LmNvbT7CwXgEEwECACIFAlVgX6oCGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAAoJEC7Z13T+cC21EbIP/ii9cvT2HHGbFRl8HqGT6+7Wkb+XLMqJBMAIGiQK
 QIP3xk1HPTsLfVG0ao4hy/oYkGNOP8+ubLnZen6Yq3zAFiMhQ44lvgigDYJo3Ve59gfe99KX
 EbtB+X95ODARkq0McR6OAsPNJ7gpEUzfkQUUJTXRDQXfG/FX303Gvk+YU0spm2tsIKPl6AmV
 1CegDljzjycyfJbk418MQmMu2T82kjrkEofUO2a24ed3VGC0/Uz//XCR2ZTo+vBoBUQl41BD
 eFFtoCSrzo3yPFS+w5fkH9NT8ChdpSlbNS32NhYQhJtr9zjWyFRf0Zk+T/1P7ECn6gTEkp5k
 ofFIA4MFBc/fXbaDRtBmPB0N9pqTFApIUI4vuFPPO0JDrII9dLwZ6lO9EKiwuVlvr1wwzsgq
 zJTPBU3qHaUO4d/8G+gD7AL/6T4zi8Jo/GmjBsnYaTzbm94lf0CjXjsOX3seMhaE6WAZOQQG
 tZHAO1kAPWpaxne+wtgMKthyPLNwelLf+xzGvrIKvLX6QuLoWMnWldu22z2ICVnLQChlR9d6
 WW8QFEpo/FK7omuS8KvvopFcOOdlbFMM8Y/8vBgVMSsK6fsYUhruny/PahprPbYGiNIhKqz7
 UvgyZVl4pBFjTaz/SbimTk210vIlkDyy1WuS8Zsn0htv4+jQPgo9rqFE4mipJjy/iboDzsFN
 BFH7eUwBEAC2nzfUeeI8dv0C4qrfCPze6NkryUflEut9WwHhfXCLjtvCjnoGqFelH/PE9NF4
 4VPSCdvD1SSmFVzu6T9qWdcwMSaC+e7G/z0/AhBfqTeosAF5XvKQlAb9ZPkdDr7YN0a1XDfa
 +NgA+JZB4ROyBZFFAwNHT+HCnyzy0v9Sh3BgJJwfpXHH2l3LfncvV8rgFv0bvdr70U+On2XH
 5bApOyW1WpIG5KPJlDdzcQTyptOJ1dnEHfwnABEfzI3dNf63rlxsGouX/NFRRRNqkdClQR3K
 gCwciaXfZ7ir7fF0u1N2UuLsWA8Ei1JrNypk+MRxhbvdQC4tyZCZ8mVDk+QOK6pyK2f4rMf/
 WmqxNTtAVmNuZIwnJdjRMMSs4W4w6N/bRvpqtykSqx7VXcgqtv6eqoDZrNuhGbekQA0sAnCJ
 VPArerAZGArm63o39me/bRUQeQVSxEBmg66yshF9HkcUPGVeC4B0TPwz+HFcVhheo6hoJjLq
 knFOPLRj+0h+ZL+D0GenyqD3CyuyeTT5dGcNU9qT74bdSr20k/CklvI7S9yoQje8BeQAHtdV
 cvO8XCLrpGuw9SgOS7OP5oI26a0548M4KldAY+kqX6XVphEw3/6U1KTf7WxW5zYLTtadjISB
 X9xsRWSU+Yqs3C7oN5TIPSoj9tXMoxZkCIHWvnqGwZ7JhwARAQABwsFfBBgBAgAJBQJR+3lM
 AhsMAAoJEC7Z13T+cC21hPAQAIsBL9MdGpdEpvXs9CYrBkd6tS9mbaSWj6XBDfA1AEdQkBOn
 ZH1Qt7HJesk+qNSnLv6+jP4VwqK5AFMrKJ6IjE7jqgzGxtcZnvSjeDGPF1h2CKZQPpTw890k
 fy18AvgFHkVk2Oylyexw3aOBsXg6ukN44vIFqPoc+YSU0+0QIdYJp/XFsgWxnFIMYwDpxSHS
 5fdDxUjsk3UBHZx+IhFjs2siVZi5wnHIqM7eK9abr2cK2weInTBwXwqVWjsXZ4tq5+jQrwDK
 cvxIcwXdUTLGxc4/Z/VRH1PZSvfQxdxMGmNTGaXVNfdFZjm4fz0mz+OUi6AHC4CZpwnsliGV
 ODqwX8Y1zic9viSTbKS01ZNp175POyWViUk9qisPZB7ypfSIVSEULrL347qY/hm9ahhqmn17
 Ng255syASv3ehvX7iwWDfzXbA0/TVaqwa1YIkec+/8miicV0zMP9siRcYQkyTqSzaTFBBmqD
 oiT+z+/E59qj/EKfyce3sbC9XLjXv3mHMrq1tKX4G7IJGnS989E/fg6crv6NHae9Ckm7+lSs
 IQu4bBP2GxiRQ+NV3iV/KU3ebMRzqIC//DCOxzQNFNJAKldPe/bKZMCxEqtVoRkuJtNdp/5a
 yXFZ6TfE1hGKrDBYAm4vrnZ4CXFSBDllL59cFFOJCkn4Xboj/aVxxJxF30bn
In-Reply-To: <20240417-s390-drivers-fix-cast-function-type-v1-3-fd048c9903b0@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/04/2024 20.24, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR) after enabling
> -Wcast-function-type-strict by default:
> 
>    drivers/s390/net/netiucv.c:1716:18: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
>     1716 |                 dev->release = (void (*)(struct device *))kfree;
>          |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    1 error generated.
> 
> Add a standalone function to fix the warning properly, which addresses
> the root of the warning that these casts are not safe for kCFI. The
> comment is not really relevant after this change, so remove it.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/s390/net/netiucv.c | 14 ++++++--------
>   1 file changed, 6 insertions(+), 8 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


