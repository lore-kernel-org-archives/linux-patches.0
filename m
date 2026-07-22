Received: from smtp-42a9.mail.infomaniak.ch (smtp-42a9.mail.infomaniak.ch [84.16.66.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF8A298CA5
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 08:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708188; cv=none; b=imycGjN5lYuPVn13CV9ieRIMme1DZdKCdIWpQmiR7nTX5sSLpQMoc5t3pWfTh2QKdKTfnU+akHI4MPLMBIdgg2ZSBeAjTRXOa/n3Q+rW18rfJ1KGIcx0Cn2oz2CAAcDj2REBZKzQMzSbtBY+Cwt3sj6PvRnkzyGR8Vp4HNokKN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708188; c=relaxed/simple;
	bh=hE0zDnQ+UqJJ4BLvzjnb6H+I4z2TAHTg1lvPy/LzS1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CxdYKQxdHPt4PaxaYtX00kcnsFU8LFHYhZXWzV6FE/oA3sn5T+K/HqzMnjbIVuy4UqU/1yZnAbX1TgWLeYl5+jRchjPLqARYh6GH/11meTUN3MD1StcY2/H09pe6qcz7aRy14OhrQX6vFBgqThNjmLbpaqMdUvEU28rtZZOkcuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gibson.sh; spf=pass smtp.mailfrom=gibson.sh; dkim=pass (2048-bit key) header.d=gibson.sh header.i=@gibson.sh header.b=T1i/zQXh; arc=none smtp.client-ip=84.16.66.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gibson.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gibson.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gibson.sh header.i=@gibson.sh header.b="T1i/zQXh"
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4h4nC45PGkzMFh;
	Wed, 22 Jul 2026 10:16:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gibson.sh;
	s=20260228; t=1784708176;
	bh=Lsbf5HqpXLXokRBbXcIGB2u5wKP2su+pKWLVZgHuvNA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T1i/zQXhM3H8U3TNDF2oTwZ+URRnEdKny3kbNiq9y5iWSH+7uwdR3zv9i3QhGfkpf
	 vbGBzQC18UFWeRprGMIf+Jw3bk+UT+PJPPhqM/3/lKhnYteJMxcQrD6ljd+zZVZ8ML
	 4UTGA1n6C9vb0l7S0vyOxRzY4+bP40x2xPDAGz3wLzNDp2Sjjx6OXyKhGY5r4z3xok
	 bz4d8HtPYEd0dDS64llSd43bDpfwTPhmW/Otuhv0eWdsIAsU5yqcCR4iTW0UvXek9O
	 JvTJfrcbctYvo5r9B3vAsQTS7wZMwPa0jnHOMA1e5TwwQlOxaqqTt+sxPI6dJUQzFQ
	 fvuOE66HiS+kA==
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4h4nC400fJzHmC;
	Wed, 22 Jul 2026 10:16:15 +0200 (CEST)
Message-ID: <dc1702d3-ed9e-418c-a4c4-35575b55670a@gibson.sh>
Date: Wed, 22 Jul 2026 10:16:15 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 1020/1266] platform/x86/amd/pmc: Add delay_suspend
 module parameter
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Hans de Goede <johannes.goede@oss.qualcomm.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
References: <20260721152441.786066624@linuxfoundation.org>
 <20260721152504.653512550@linuxfoundation.org>
 <980c483b-d3ed-41be-94e0-9b28fc42b482@gibson.sh>
 <2026072230-volatile-citric-73fa@gregkh>
Content-Language: de-DE, en-GB
From: Daniel Gibson <daniel@gibson.sh>
In-Reply-To: <2026072230-volatile-citric-73fa@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Infomaniak-Routing: alpha

On 22.07.26 07:28, Greg Kroah-Hartman wrote:
> On Tue, Jul 21, 2026 at 11:07:35PM +0200, Daniel Gibson wrote:
>> Hi,
>>
>> On 21.07.26 17:24, Greg Kroah-Hartman wrote:
>>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>>
>>
>> No objections, I just wonder why the commits
>> 037f0b03c663a2 "platform/x86/amd/pmc: Dont log during intermediate wakeups"
>> and
>> a0738abd042f74 "platform/x86/amd/pmc: Avoid logging "(null)" for DMI values"
>>
>> are not added for 6.6 as well (they're added for 6.12, 6.18 and 7.1).
> 
> Because they do not apply to that tree, and there was no explicit
> "Fixes:" tag on the commit so we just backported them as far as they
> easily went.
> 
> If you want these patches in a stable 6.6.y release, please provide
> working backports.
> 
> thanks,

Thanks for the reply!
I'll backport the commits.
Where should I send the backported patches?

Cheers,
Daniel

> 
> greg k-h

