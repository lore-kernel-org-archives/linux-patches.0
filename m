Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FBE37CD5F
	for <patches@lists.linux.dev>; Tue, 17 Mar 2026 17:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773769683; cv=none; b=LTtip+Nq0By+IkYTAnINgjTQs0PFH5PE/8k8QKubbwsgH7FcVf6krWZGSgWqrQRT3UmEyKsmAPgrbV9NgO54GitGTHXaCfmmK0UjX/lajnsrM28d7lY8fOUtdc8fB4VGQKX9nMGQ0njn7NzCrp3xs2/pgXtTzSIj6Vk/XsM0O2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773769683; c=relaxed/simple;
	bh=ARTqOmYk66Vk2vqC3ltbLa6RvWqpE7HnxXkZGVlfraQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JQn5al8IWuZepXDSgnJxQMvyUxmFHBmPolRDuPMncI3ky21MwfmbXYorZvLCrroXlQqcHBhNEPvhB0iWKCrQ0YfYeOlgsCuji00yX6ir/6ywsahqxcd0GmkzptKvf+Tr4bPC36uGWQnZ1s7XNBErpKbCa4FYfoHgvmbZndgzt9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=QqXKX3lZ; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="QqXKX3lZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1773769652; x=1774374452; i=rwarsow@gmx.de;
	bh=o/ZmeXS2W3fbty4AWZGlOZm+IWjieGFac51nYgHaiWQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=QqXKX3lZGd/MuPf32UAeIQFXOcf+cUDjWYacXuZESq5f6+Z5yMgpg/DhTc6DkOHC
	 t1Rf93V+8OluABS/NEbHg8En7qXF3c38HHR417/r7wi1Tu5OTMjaiRRgQzMXbEapx
	 bIAK6S/GB12OXvbI5mkdIBKnYUHCbBe0dJzt8Qk3ooHd2wfgq6g3hkPn/QwOWs/NI
	 +tz/cocC9SylztDPktrDwMEnn8LCrAj9YCpJFk0vnB0p44EOoWJdHb25kOykn5Ub1
	 TX+0wcKpQVZOh4+dpZt5tSlKpGN5EDRIHx0CFkicQRvYDJyFeA9GuP4S5RHm2Ne+8
	 VqC1l5TDz1mw6ZdZrQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MPGW7-1wERYn025V-00Y0MD; Tue, 17
 Mar 2026 18:47:32 +0100
Message-ID: <10df8843-67e6-4830-955c-befc783f25df@gmx.de>
Date: Tue, 17 Mar 2026 18:47:30 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/378] 6.19.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260317163006.959177102@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:N3pSBfrEhZyw2FHpqup8xJxe8rUoa6fkVuaOTv3vgaaiODp9w2O
 AhTgBwfa1O9fGomAKv46L8SGLBj6ctZSP9gUmONnqLloqo/D2h9ZJyzTzc+IaUlF4KpYqB1
 oYji/Y0feXbEtc8xOcHoERH/Dgr48QPY19jwmYWHWXJGLe14Vvl0LJblwAaQMA7mxzGXXkZ
 jR687kln1qXgvaKKZcH6g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:1p4wHw6FyLQ=;IgIM/pVy4f9KImDP6FxdBKsFhmD
 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

Hi

compile runs in an error:

   LD      vmlinux.unstripped
   BTFIDS  vmlinux.unstripped
WARN: resolve_btfids: unresolved symbol kthread_exit
make[2]: *** [scripts/Makefile.vmlinux:72: vmlinux.unstripped] Error 255
make[2]: *** Deleting file 'vmlinux.unstripped'
make[1]: *** [/home/DATA/DEVEL/linux/Makefile:1277: vmlinux] Error 2
make: *** [Makefile:248: __sub-make] Error 2


if I do:

git revert f5ee297b23d843d4ae690595aa29e8f5baeaecf9 --no-edit

see:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-6.19.y&id=f5ee297b23d843d4ae690595aa29e8f5baeaecf9



all is fine here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
