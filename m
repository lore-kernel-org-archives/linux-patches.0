Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA821CC16A;
	Tue, 29 Oct 2024 16:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730219942; cv=none; b=XRYPE3m3zhIzK54o9zZwXVS5q9CD5Q9cwLP7ka79QeQSPRrb/0IdpMueDDMwH5WdqiT0ms04o7YsqvULxak90hHZLG5NrlF6qF90cebWs1OrjJSt6JIxihEKC4GINb3ZLmm3/9O/g7/nYJBlASgCH6Ip3wnuxfwWAkvTJUvBDNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730219942; c=relaxed/simple;
	bh=FgFt+nUEU5jTtnV7+2px6chrOJx6kodCC14Li0aeAnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ofi/WEG1hl9FLNIDjX+Q+djYmIG5ybAJVYh19utCOYbYbHltFwTROCfdm9500McaeXJkEqDCZNkqj5ig0dN88Ylcp95UkQ8ScFvjGVl2jokA8IlzSn7hUfAriEVUZEdyo63akYXk1IOa7jMOyiUxVTcMPdwaCGCJkUsaEYSnlNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p3Y9M/8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p3Y9M/8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D97C4CECD;
	Tue, 29 Oct 2024 16:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730219941;
	bh=FgFt+nUEU5jTtnV7+2px6chrOJx6kodCC14Li0aeAnY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p3Y9M/8lI4PqiizhCf46Mkk7w5tJJBDDoIV+7kAyFipfTcZdcNUBsep2Ex6Y+dU04
	 /RzCN9wo9Vt9o0R+J5ZBw9Im9D1GWop47zFy8f4MXMJxf+aODpnU5UnPlFJnVCB9i5
	 /1olrGUrMllFFCXWssN3XISX2gHzJI/OUlJrBET0ZS6tsbl7PSPu2nhdydq9EZs8vR
	 9f1y3vSP9/5ClNQ7YI2UiduTPXcwOIIENkT9tfr3TxBYi30asMkCKkprgis5ZMZL6e
	 dp39yuIuu8GIFwd1qbntx1UAm7hxJOzS6k5IpVJTnJRaCcwyZROyFuPXO2dVNXuvhK
	 406tHJ5svioRQ==
Date: Tue, 29 Oct 2024 12:38:59 -0400
From: Sasha Levin <sashal@kernel.org>
To: Antony Antony <antony.antony@secunet.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 6.6 133/208] xfrm: Add Direction to the SA in or out
Message-ID: <ZyEPo8A7LREpkkhQ@sashalap>
References: <20241028062306.649733554@linuxfoundation.org>
 <20241028062309.914261564@linuxfoundation.org>
 <Zx9wp6atLMR1UcCL@moon.secunet.de>
 <Zx-Gp8f9jjxmDsIe@sashalap>
 <ZyC2Ow9usJkkpxjU@moon.secunet.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZyC2Ow9usJkkpxjU@moon.secunet.de>

On Tue, Oct 29, 2024 at 11:18:04AM +0100, Antony Antony wrote:
>On Mon, Oct 28, 2024 at 08:42:15 -0400, Sasha Levin wrote:
>> On Mon, Oct 28, 2024 at 12:08:23PM +0100, Antony Antony wrote:
>> > On Mon, Oct 28, 2024 at 07:25:13 +0100, Greg Kroah-Hartman wrote:
>> > > 6.6-stable review patch.  If anyone has any objections, please let me know.
>> >
>> > Hi Greg,
>> >
>> > This patch is a part of a new feature SA direction and it appears the auto
>> > patch selector picked one patch out of patch set?
>> > I think this patch alone should not be applied to older stable kernel.
>>
>> It was picked up as a dependency:
>
>I understand how it got selected, however, please drop
>a4a87fa4e96c ("xfrm: Add Direction to the SA in or out") from backports.
>
>>
>> > > Stable-dep-of: 3f0ab59e6537 ("xfrm: validate new SA's prefixlen using SA family when sel.family is unset")
>
>this is good fix to have in stable kernels
>
>>
>> We can drop it, and the netfilter folks can provide us a backport of the
>> fix above?
>
>It is an ipsec sub system patch.
>Here is a backport. I compile tested it on 6.6. It will also apply to linx-6.1.y
>To apply to older ones kernels, use -3.

I've replaced what we had in the queue with your backport, thanks!

-- 
Thanks,
Sasha
