Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD227464;
	Tue, 29 Oct 2024 11:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730202058; cv=none; b=HUMoQMh7v9GX50WyqVstqddNpPVveLkFgYwQ4NYGFswK14u5v0xH2pT4P+1wYP5A9oGNlB0dg/InYEfWkFGIwuGSj6Bgwnh+gfGcelp8E1Y4cIug+JT3qcOi+cOmTr80w2eK0C2BciGZFRI6JFGK/4A/W0LoaYWeMsE6P348CXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730202058; c=relaxed/simple;
	bh=381JEAKnbz7sVs3cmaS/BOoExIQYQV7M+X2a2z7oSf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bClMRZCvQJpG1GJCN0k5sIwqIqXFYGo6yFjKm1V27ztJTeo05B3gSVObO3ozwIpPAcx/78LQne6kACrwKWZbFkSghkMZScJhNMv5Jh09mSYb/MKruwCwuOW1ROt5B32KMP+GimHtZ9Swdmo22069RodDaqu8FQj+/yLciKgRUJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ceOJa5Oq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ceOJa5Oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5512C4CEE5;
	Tue, 29 Oct 2024 11:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730202058;
	bh=381JEAKnbz7sVs3cmaS/BOoExIQYQV7M+X2a2z7oSf0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ceOJa5OqAk9v0O7BRbX7XvvM2t7ozx0pxI7UjPZPlw5AtIomgQHTkqj59fODoUurx
	 zzXL+zt1f9R62r5OkLys8jq4cQwTLGA5BdJ4/8snf29Om4ymB4H1OV7rG4g7WX+Pzd
	 9nq9HC2Zx9w/1qy+38UNzjsBuWwnRqh6jgTCqg3lf3YZG5nKOMbu7059QWk0R5SDgS
	 33CCRS3owTTU/vl6At+LM5VZrtZusiIqHA7LjbUdqJ03BM0Zxc0RsUzQfHaIq4/UZ6
	 Lptbf/jeMVMkgQQck+HPJYWAumpVKMme2DjPHqAUs3TJTOOKmYE5XTzw8DBgrcvpUI
	 5Swl0tmXRXimA==
Message-ID: <ba1da208-22d8-4145-826f-9cfdc5c18eee@kernel.org>
Date: Tue, 29 Oct 2024 12:40:54 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 068/137] tty/serial: Make
 ->dcd_change()+uart_handle_dcd_change() status bool active
To: Sasha Levin <sashal@kernel.org>, Jiri Slaby <jirislaby@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Rodolfo Giometti <giometti@enneenne.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
References: <20241028062258.708872330@linuxfoundation.org>
 <20241028062300.638911047@linuxfoundation.org>
 <b80395aa-5e1a-4f9c-b801-34d0e1f96977@kernel.org> <ZyDGgPiAJBVWNJ18@sashalap>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <ZyDGgPiAJBVWNJ18@sashalap>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29. 10. 24, 12:26, Sasha Levin wrote:
> On Tue, Oct 29, 2024 at 06:59:55AM +0100, Jiri Slaby wrote:
>> On 28. 10. 24, 7:25, Greg Kroah-Hartman wrote:
>>> 6.1-stable review patch.  If anyone has any objections, please let me 
>>> know.
>>>
>>> ------------------
>>>
>>> From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>>>
>>> [ Upstream commit 0388a152fc5544be82e736343496f99c4eef8d62 ]
>>>
>>> Convert status parameter for ->dcd_change() and
>>> uart_handle_dcd_change() to bool which matches to how the parameter is
>>> used.
>>>
>>> Rename status to active to better describe what the parameter means.
>>>
>>> Acked-by: Rodolfo Giometti <giometti@enneenne.com>
>>> Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
>>> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>>> Link: https://lore.kernel.org/r/20230117090358.4796-9- 
>>> ilpo.jarvinen@linux.intel.com
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Stable-dep-of: 40d7903386df ("serial: imx: Update mctrl old_status on 
>>> RTSD interrupt")
>>
>> As I wrote earlier, why is this Stable-dep-of that one?
> 
> Here's the dependency chain:
> 
> 40d7903386df ("serial: imx: Update mctrl old_status on RTSD interrupt")
> 968d64578ec9 ("serial: Make uart_handle_cts_change() status param bool 
> active")
> 0388a152fc55 ("tty/serial: Make ->dcd_change()+uart_handle_dcd_change() 
> status bool active")
> 
> If you go to 6.1.y, and try to apply them in that order you'll see that
> it applies cleanly. If you try to apply just the last one you'll hit a
> conflict.

Oh, well, so instead of taking two irrelevant and potentially dangerous 
patches (0388a152fc55 + 968d64578ec9), this simple context fix should 
have been in place:
-       uart_handle_cts_change(&sport->port, !!usr1);
+       uart_handle_cts_change(&sport->port, usr1);

Right?

thanks,
-- 
js
suse labs

