Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDB1282F30
	for <patches@lists.linux.dev>; Sat, 18 Apr 2026 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776531071; cv=none; b=RoT4psl0lQ4c2nq3lqH0G0tY3Yvvatx8iKQe2MXE5qUy12zBANC+YifwVDXEyTrUi/1hswoc9rrQl9JiG8zOqOBbEK6bJ7JKgwH3nxa1gn1Z6s/3OZ2loUvOOaWbnoP5b8M5aad6dryMjqPlHOIJoeoLZLMb/SAXqSzybqw9tyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776531071; c=relaxed/simple;
	bh=Ht/D7E3a40rysU0EGbxhXZptGJc/YvINGjzqbgLU6ho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWtnlYlmwKFV00qK/lvnHyPPF6eM+n8Qq84JXXK+CEDGJIdC7DySY0GJXxh7xbegD/5ki0Q8UtaCF9cAPVjV6wLhAe5zvoZPDENybOzNs0/uoVwuWCjDdMNZNvnLToxqIQOhaS6JjChgaAZTpDhZE3SXZA51qoC04f/EMHNUzpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=QLfcj8Pn; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="QLfcj8Pn"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8344A1143B6;
	Sat, 18 Apr 2026 18:51:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1776531067;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=TYiYkD9LzUceCOAC/ZE7LE8Rqv3G9vhEboKcik9QaKE=;
	b=QLfcj8PnITmsT2yPdx6rCPCsvHbK75/InNRyLdZBszYCZSedLgbv/0C16V3AtHVpZZPMGW
	Yoci1r5+2OSBl/TVrlDRO+Yz8eRfNzrplGzOjonBburB1yi5UswEX3BOzSLttZwn379zeZ
	nT862dOrVn75JMkW+MJSN2iP0vJTvv5PE5HB095PrNJm/72ZpHTDkx5wGm/mOCxh7DqlSk
	h0KUWNgU2tt0n6hrmoLFOHyCFYp6DYXDM6dXVLDPDJw3E3dQVQgiLz0U2M3hLEe5a/05IL
	uN6dgG8fM+8qN6uyexSL9PL6WeVXTSAwD+plwYDM3fQVNqXLbsybrR9rQt71Uw==
Message-ID: <ba47c207-bbdb-43c7-bcae-a09bddf0806d@nabladev.com>
Date: Sat, 18 Apr 2026 18:51:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 311/491] dmaengine: xilinx: xilinx_dma: Fix unmasked
 residue subtraction
To: Ben Hutchings <ben@decadent.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Vinod Koul <vkoul@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20260413155819.042779211@linuxfoundation.org>
 <20260413155830.683657586@linuxfoundation.org>
 <e4bf9ba9ceba4f2e23483b4aa0ebcff8251c0b73.camel@decadent.org.uk>
 <8c909ddd-c8ff-43a1-987f-1a348917d75a@nabladev.com>
 <6def01a404f3b10ac374c011000637c86598453b.camel@decadent.org.uk>
Content-Language: en-US
From: Marek Vasut <marex@nabladev.com>
In-Reply-To: <6def01a404f3b10ac374c011000637c86598453b.camel@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

On 4/16/26 8:43 PM, Ben Hutchings wrote:
> On Thu, 2026-04-16 at 20:20 +0200, Marek Vasut wrote:
>> On 4/16/26 7:58 PM, Ben Hutchings wrote:
>>> On Mon, 2026-04-13 at 17:59 +0200, Greg Kroah-Hartman wrote:
>>>> 5.10-stable review patch.  If anyone has any objections, please let me know.
>>>>
>>>> ------------------
>>>>
>>>> From: Marek Vasut <marex@nabladev.com>
>>>>
>>>> [ Upstream commit c7d812e33f3e8ca0fa9eeabf71d1c7bc3acedc09 ]
>>>>
>>>> The segment .control and .status fields both contain top bits which are
>>>> not part of the buffer size, the buffer size is located only in the bottom
>>>> max_buffer_len bits. To avoid interference from those top bits, mask out
>>>> the size using max_buffer_len first, and only then subtract the values.
>>>
>>> This change is harmless, but the problem it claims to fix does not
>>> exist.
>>
>> The current code subtracts two independently read values which both
>> contain status/control MSbits and the actual value LSbits. Depending on
>> the MSbits being identical in both separately read values is unsafe, so
>> the change in this patch masks out the MSbits first and then does the
>> subtraction on the actual value LSbits only, which is safe.
>>
>> Why do you think the original unsafe behavior can not trigger a failure?
> 
> The old code masked out the MSbits after subtraction.  So, there was no
> dependency on their being equal before substraction.  Since borrows
> propagate to the left, not the right, the MSbits could not "interfere"
> with the LSbits.
> 
> If you still aren't convinced, please try to find some example values
> for which the result would actually change.
Ah sigh, you're right. I will add this into the list of lessons learnt 
the hard way. Thank you for the clarification.
