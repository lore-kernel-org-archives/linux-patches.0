Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6462713D504
	for <patches@lists.linux.dev>; Tue, 17 Dec 2024 02:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734403543; cv=none; b=JD7t3dyv9+6C0tTb9ZfmylLt/NvPi7daBHAvOaIJbEvpwhidiUpz0+4LwFWMCVLhfyK2KYLTotbsTW5knSdZjEm5LrLC7uQ+CfwAUCd5nPaK/eH78GqaAi4X9HXZoMdAJmbpoxQgkvq9K0CXhsDAPjx1lMfrgVBCS2U4PIvhT7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734403543; c=relaxed/simple;
	bh=+b2VZ7ITDnw5UBM7GqgaT6MwN8JvbH+qwhlurt7RSDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TBNC4jYdyM3z5hO6p0070O8nAO/I0/XTGx9lukfxuah/uFiuWGyZX2swTLQk6QRqP0cMpVt8gIR30p8/M60WLViBrJFkWusEqfc3Q+LYsOxM4Yn2MHmqBGKo4dcMxbZhB5gBD0fRS1uTomcWlvQk+XWfki0FdbCoSOJxYOnY7Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=h1hB7HE7; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="h1hB7HE7"
Received: from [192.168.33.173] (unknown [220.197.230.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id D13C93F78E;
	Tue, 17 Dec 2024 02:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1734403532;
	bh=YeJBZ1TSOGlJXk0s8uXWBM59ZJnITryLYIalFVFCJLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=h1hB7HE7ru5ORbF7nXWIrbSHoeO868Tqd0iZ0C364oWr28oRm3aPPsu6589HjfHGk
	 2wI3dNQW6fRhn/Erul3Zju+YaN/B4ft6HQre/sfM5a3YS8hDFS1GFYbtK/iXomSD53
	 oOd26w3Voz7+FyMb5OOYthOh/BZlkgL2dI539frVjv+6TSVFa+yHyimTvL4JrF8/ja
	 +RL8K8aBfS5HhukA+W7UinAWE18ivkPfZjZz3grOGpfyTZmfGR8R5jYLlnj0qJE6Dd
	 xjH/x1wZPsX8uKSa+h49DXnije8LoPcqXdycEBz20TYtxb+6rHBbGxUgA9UxDOD/eR
	 mR/534awvMOVg==
Message-ID: <0716be8a-8d7c-46d3-8b06-8dbd632e763a@canonical.com>
Date: Tue, 17 Dec 2024 10:45:10 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [stable-kernel][5.15.y][PATCH 0/5] Fix a regression on sc16is7xx
To: Hugo Villeneuve <hugo@hugovil.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, sashal@kernel.org, hvilleneuve@dimonoff.com
References: <20241211042545.202482-1-hui.wang@canonical.com>
 <2024121241-civil-diligence-dc09@gregkh>
 <900e507b-b3ec-4d2f-b210-8c06b2b64c26@canonical.com>
 <20241216133655.52691af8651bb8b25567327f@hugovil.com>
Content-Language: en-US
From: Hui Wang <hui.wang@canonical.com>
In-Reply-To: <20241216133655.52691af8651bb8b25567327f@hugovil.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/17/24 02:36, Hugo Villeneuve wrote:
> On Thu, 12 Dec 2024 22:00:00 +0800
> Hui Wang <hui.wang@canonical.com> wrote:
>
>> On 12/12/24 21:44, Greg KH wrote:
>>> On Wed, Dec 11, 2024 at 12:25:39PM +0800, Hui Wang wrote:
>>>> Recently we found the fifo_read() and fifo_write() are broken in our
>>>> 5.15 kernel after rebase to the latest 5.15.y, the 5.15.y integrated
>>>> the commit e635f652696e ("serial: sc16is7xx: convert from _raw_ to
>>>> _noinc_ regmap functions for FIFO"), but it forgot to integrate a
>>>> prerequisite commit 3837a0379533 ("serial: sc16is7xx: improve regmap
>>>> debugfs by using one regmap per port").
>>>>
>>>> And about the prerequisite commit, there are also 4 commits to fix it,
>>>> So in total, I backported 5 patches to 5.15.y to fix this regression.
>>>>
>>>> 0002-xxx and 0004-xxx could be cleanly applied to 5.15.y, the remaining
>>>> 3 patches need to resolve some conflict.
>>>>
>>>> Hugo Villeneuve (5):
>>>>     serial: sc16is7xx: improve regmap debugfs by using one regmap per port
>>>>     serial: sc16is7xx: remove wasteful static buffer in
>>>>       sc16is7xx_regmap_name()
>>>>     serial: sc16is7xx: remove global regmap from struct sc16is7xx_port
>>>>     serial: sc16is7xx: remove unused line structure member
>>>>     serial: sc16is7xx: change EFR lock to operate on each channels
>>>>
>>>>    drivers/tty/serial/sc16is7xx.c | 185 +++++++++++++++++++--------------
>>>>    1 file changed, 107 insertions(+), 78 deletions(-)
>>> How well did you test this series?  It seems you forgot about commit
>>> 133f4c00b8b2 ("serial: sc16is7xx: fix TX fifo corruption"), right?
>>>
>>> Please do better testing and resend a working set of patches.
>> Okay, got it.
> Hi Hui / Greg,
> I am testing these changes on my RS-485 board, and I
> found out that this patch is required:
>
> commit b4a778303ea0 ("serial: sc16is7xx: add missing support for rs485
> devicetree properties")
>
> With it, it now works (basic loopback test) on 5.15 branch and with my
> hardware.
>
> As per Greg's suggestion, I have also tested (and reworked) commit
> 133f4c00b8b2 ("serial: sc16is7xx: fix TX fifo corruption"), with a
> prerequisite patch for it to apply more easily: 53a8c50802745 ("serial:
> sc16is7xx: refactor FIFO access functions to increase commonality").
>
> And finally I have added commit c41698d1a04cb ("serial: sc16is7xx: fix
> invalid FIFO access with special register set").
>
> I will submit these 4 patches to stable soon.

Hi Hugo,

Thanks for your help. I planned to do it, but It is blocked by 
backporting the commit 133f4c00b8b2 ("serial: sc16is7xx: fix TX fifo 
corruption"), it requires kfifo_out_linear_ptr() but this function is 
not in 5.15.y. It is great you could help.

Thanks,

Hui.

>
