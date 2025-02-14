Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1CE2566C9
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 10:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739527930; cv=none; b=iZdXLaqtZ3fDa5u6ax3QR5jdPYZ3NjuFREniJJwpfGuRjqjjoerr+nhrho+TQNxf90YkGeQkX4v/r4p43YCNWisC8gocvtWCEgQtEAPQjoVxVtTyjvy40nPC02DCLln2+i8oguc5uY3QAVVBgIKBX75GIB/XdfC/fmDnePVa4oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739527930; c=relaxed/simple;
	bh=uo1ONZh7PV6yV5ok5Kqc0LS/gvE/SyAXHxFR/1FcGaA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=kuZirhsYJ/dTx9vqFDNmNIcypwGLIBV1x/kCp2fUwpjlseHyvLKb5t9yGP5uE4UurzpvFzUvOyzfJSwfgUOPCW68p9WkUOL22x7J/0FCFAsaquzSMNmBd1DH9JXGlI4xbGOhtHfjK+2nackmcqt4igZ0UCCBX7AGqRhA/WJw/jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5ddd71dc.dip0.t-ipconnect.de [93.221.113.220])
	by mail.itouring.de (Postfix) with ESMTPSA id 7CF7D12566F;
	Fri, 14 Feb 2025 11:12:06 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id 3FB0160189381;
	Fri, 14 Feb 2025 11:12:06 +0100 (CET)
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, Juri Lelli <juri.lelli@redhat.com>
References: <20250213142440.609878115@linuxfoundation.org>
 <e7096ec2-68db-fc3e-9c48-f20d3e80df72@applied-asynchrony.com>
 <2025021459-guise-graph-edb3@gregkh>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <9a44f314-c101-4ed1-98ad-547c84df7cdd@applied-asynchrony.com>
Date: Fri, 14 Feb 2025 11:12:06 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2025021459-guise-graph-edb3@gregkh>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 2025-02-14 09:42, Greg Kroah-Hartman wrote:
> On Fri, Feb 14, 2025 at 09:32:06AM +0100, Holger Hoffstätte wrote:
>> On 2025-02-13 15:22, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.13.3 release.
>>> There are 443 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>
>> Builds & runs fine BUT fails to suspend to RAM 99.99% of the time (basically
>> one success but never again). Display powers down but fans stay on.
>>
>> Tested on multiple systems, all x64. I first suspected amdgpu because why not :)
>> but it also fails on a system without amdgpu, so that's not it.
>>
>> Reverting to 6.13.2 immediately fixes everything.
>>
>> Common symptom on all machines seems to be
>>
>> [  +0.000134] Disabling non-boot CPUs ...
>> [  +0.000072] Error taking CPU15 down: -16
>> [  +0.000002] Non-boot CPUs are not disabled
>>
>> "Error taking down CPUX" is always the highest number of CPU, i.e.
>> 15 on my 16-core Zen2 laptop, 3 on my 4-core Sandybridge etc.
>>
>> I started to revert suspects but no luck so far:
>> - acpi parsing order
>> - amdgpu backlight quirks
>> - timers/hrtimers
>>
>> Suggestions for other suspects are welcome.
> 
> Can you run 'git bisect' to try to find the offending change?

(cc: Juri Lelli)

Whoop! Whoop! The sound of da police!

2ce2a62881abcd379b714bf41aa671ad7657bdd2 is the first bad commit
commit 2ce2a62881abcd379b714bf41aa671ad7657bdd2 (HEAD)
Author: Juri Lelli <juri.lelli@redhat.com>
Date:   Fri Nov 15 11:48:29 2024 +0000

     sched/deadline: Check bandwidth overflow earlier for hotplug
     
     [ Upstream commit 53916d5fd3c0b658de3463439dd2b7ce765072cb ]

With this reverted it reliably suspends again.

cheers
Holger
