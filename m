Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB95220F2A;
	Fri, 31 Jul 2026 06:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785480903; cv=none; b=scVhCaaQ6NXSjcuji0sI7vtD5KG0q2/dLLaY7A1jnfb2SvdxHd/ZSwufK7f7FyWYeiXR8sgf2mDknA7BqjK7PoOAWfark4GarJ9qpQYZ9dFpnRzTyQCZHiSw5Gsz/y8X27/W/b+IO3lt8UstY67YbGD+B5KHHLkdhqPvEAbdppM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785480903; c=relaxed/simple;
	bh=HqssH1Tcs1LuZbSVtcUmgrGeeGMP0A7fk2t5iPpl4Cc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TXSEAzprQgRBjwmGYBcGzp6ze49ou12jezweYxLFcOQ1vNWH3fcfO/Qun6BkV53uHtfFlj81KYb1Vr3KOvQHgkm0kAcAWY2WmOnC2LULGIs9su+S2j6e9yS7H+8PZOMUH3LVPrWF+t5qsa5nXeBQ80AU4rEaqRUBL6JattOk4qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZOawajB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZOawajB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D087C1F00A3A;
	Fri, 31 Jul 2026 06:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785480902;
	bh=KL6yKPHq3Xr9JeIxHstvHVCaLbddMNy6wZsKhQrZ0SI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HZOawajBpJ1zi4FsQdS3DibVOJLNHSvmxKek1UkvZbNGk8LSFEgmfZ4N2s5hFoJ2V
	 NbaDz9afOsF8Skm8X2ZUWze/bF6EMKNHBrJ+d8zjFCUSo7YEIKYMLsVzNpel71aLq5
	 XrdwbDGv9hFcaBQJxlZAjCo6trkEca0fAFbACp4tjJE96bVs0tXHXZAT3KrAGtbMZG
	 XrZk8CYyBZxogEqMObT0mxvAG73GWztKE+LTFHaKpIvtA27BP9G6odinjSvQsbvTaB
	 N3OqDcudjSFo+yhtueYmeWtwr7m5IHB+azAGF+rye8BM75msnuSWGWxZ06S5BHSNAd
	 lHcVFlEKUjyrQ==
Message-ID: <15b0eb0b-cd9e-45a8-96f1-460f744b5e4a@kernel.org>
Date: Fri, 31 Jul 2026 08:54:59 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 667/744] ptp: ptp_s390: Add missing facility check
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Sven Schnelle <svens@linux.ibm.com>, stable@kernel.org,
 Heiko Carstens <hca@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>
References: <20260730141444.267951807@linuxfoundation.org>
 <20260730141458.442328931@linuxfoundation.org>
 <669b8e16-19a6-49bf-a1ef-a7bce5075a9a@kernel.org>
 <2026073120-elm-purging-e006@gregkh>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <2026073120-elm-purging-e006@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31. 07. 26, 8:46, Greg Kroah-Hartman wrote:
> On Fri, Jul 31, 2026 at 08:21:26AM +0200, Jiri Slaby wrote:
>> On 30. 07. 26, 16:15, Greg Kroah-Hartman wrote:
>>> 7.1-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Sven Schnelle <svens@linux.ibm.com>
>>>
>>> commit e78f1ac37afcb16cb6fef8a2c92591eab6558956 upstream.
>>>
>>> Only register the physical clock when facility 28 is installed
>>> and PTFF QAF returns that PTFF QPT is available.
>>>
>>> Fixes: 2d7de7a3010d ("s390/time: Add PtP driver")
>>> Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
>>> Cc: stable@kernel.org
>>> Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
>>> Link: https://patch.msgid.link/20260714130342.1971700-3-svens@linux.ibm.com
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>    drivers/ptp/ptp_s390.c |    6 +++++-
>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> --- a/drivers/ptp/ptp_s390.c
>>> +++ b/drivers/ptp/ptp_s390.c
>>> @@ -107,6 +107,9 @@ static __init int ptp_s390_init(void)
>>>    	if (IS_ERR(ptp_stcke_clock))
>>>    		return PTR_ERR(ptp_stcke_clock);
>>> +	if (!test_facility(28) || !ptff_query(PTFF_QPT))
>>
>> ptff_query() here needs:
>> 9de445d8296a ("s390/ptff: Export ptff_function_mask[]")
> 
> Ah, good catch, now queued up.  How did you find that thing?

It broke openSUSE kernel build. We have:
config/s390x/default:CONFIG_PTP_S390=m

thanks,
-- 
js
suse labs
