Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [194.59.206.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439783AFAE4;
	Fri, 24 Jul 2026 07:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.59.206.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784878775; cv=none; b=dDmE2W8C3Hspxd/lNlf5uR8u01PEyux3QxuJjH93X/P9X/HO9I4FBvP8K/HWW2SxZclE0O13jLgetVp/KGDeb3nzv5VbeKnKSAcqK6W+yDqq39NxjxiZE66CwtUA0MObhY0k24h7PV2/gL288UMjNNPl5+64ACcjjBg6fNy/8LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784878775; c=relaxed/simple;
	bh=AuTLKQZDF53bKT7svIbTzPrwxpFu2eFJIzYJEFGNPR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vAoDvcxuUQKTtThwtBFWU0v8Osd7pYjIznNCJnjSQl8gw10r59EfLqhoucJCcbLyTYXu85VfiULXotjk9Iy/CLOEte0s/U8Y3/vC8wzZ2otA6+69NI9GvK+gdnhtkuEkGrw7YW+6YifuOU5itm9y26u4D7mYCa4SgcdRkpuumnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=V8F+4dl6; arc=none smtp.client-ip=194.59.206.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="V8F+4dl6"
Received: from relay02-mors.netcup.net (localhost [127.0.0.1])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4h60H51BDBz4D3Z;
	Fri, 24 Jul 2026 09:38:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1784878737;
	bh=AuTLKQZDF53bKT7svIbTzPrwxpFu2eFJIzYJEFGNPR4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V8F+4dl6wiCVWwmOVnw+2CVDsoNYXzL1u0LInUvOm9nBnnlyBI1lV2u/4j0vY/tcY
	 J/fvKDlhpX/NyapqgYbK/v/tweIOugAllmtwFFd6c9G0gMchBihMlcxc/bM6cuV0Bc
	 7Om+x55BOvaPbfd7DyxR1faPG4UgYU8l7hSnLZynCEG/8rIEtVBX/oy7Nw+601xNGV
	 ilICJFUHmbZhPof1ivl6hE/P2BYwZPsBII2zXkqjj2VG/MrkoUfUn2LPTfRIhO4PHE
	 h5/wwT+6f/FKLdHQ+2gzLTIYCycFNq6rRTF21SnC12hSndVcoYtGy1E8QAB2anjDic
	 AeCFU7d9VAr/A==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4h60H50Qxwz7xQ9;
	Fri, 24 Jul 2026 09:38:57 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4h60H36vDzz8tH7;
	Fri, 24 Jul 2026 09:38:55 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id DD24D5F9DB;
	Fri, 24 Jul 2026 09:38:54 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <42ca3723-9222-4e67-a1ca-6eb8883bc596@leemhuis.info>
Date: Fri, 24 Jul 2026 09:38:54 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1202] 6.12.97-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, achill@achill.org,
 sr@sladewatkins.com,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <20260722142834.868902312@linuxfoundation.org>
 <16237d02-bc2c-4401-a1e5-1d81961a65c9@sirena.org.uk>
 <2026072454-vividly-suitor-3eb5@gregkh>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <2026072454-vividly-suitor-3eb5@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <178487873560.2746002.9665850735566545600@mxe9fb.netcup.net>
X-NC-CID: G8Tby6SRnrWHwKxfF9+78E8zsecPV9+0yj4vPGg7PHCI4MRsq6Q=

On 7/24/26 08:19, Greg Kroah-Hartman wrote:
> On Thu, Jul 23, 2026 at 04:17:55PM +0100, Mark Brown wrote:
>> On Wed, Jul 22, 2026 at 04:31:38PM +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.12.97 release.
>>> There are 1202 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>
>> I'm seeing a regression in the proc read kselftest which bisects to
>> "proc: protect ptrace_may_access() with exec_update_lock (part 1)":
> # selftests: proc: read
> [  167.845745] ICMPv6: process `read' is using deprecated sysctl (syscall) net.ipv6.neigh.default.base_reachable_time - use net.ipv6.neigh.default.base_reachable_time_ms instead
> [...]>> Full log:
>>
>>    https://lava.sirena.org.uk/scheduler/job/3014030#L10663
> 
> Odd, and this is not regressing in Linus's tree as well?  Did we miss
> something that is needed here that mainline has?
Mark, is this maybe the same as:
https://lore.kernel.org/all/20260706170735.2941493-1-linmag7@gmail.com/

A fix for it is here:
https://lore.kernel.org/all/20260706-procfs-ns-eacces-fix-v1-1-a69ab14c02e6@google.com/

It looks like it fell through the cracks for 2 weeks, but I prodded
there two days ago and Christian since then picked the fix up (and I
guess will send it to Linus soon).

Ciao, Thorsten
