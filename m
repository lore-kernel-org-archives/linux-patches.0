Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F7B1C1ADB
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 09:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750842540; cv=none; b=ZDqV/cU9qy3jzfoB3/9alZ0Ikse00A6aLfiJIdh92FkeolkY0fDqUHaQTAZrNq0zi/N3HjBK+rVpJE7O9PN/YiGOsHeZM+0w6fRiIFHYHaoJwqhqq1DEF028+Gzky7srSp3Bdo/UNl8DcOWgyFGmLWUE21meI9zeTauJI+YY+Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750842540; c=relaxed/simple;
	bh=iPSIlxbA6AL4kk1jewqtNJ7P22fvFyX5+2oLAJK7b8g=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=S2Y9p1OzUOoSTZMeOXyEzUBBDYwA8M7ShUOpJpAgqtR4VlKsPUNLxOsHO+SjnaoLabOcIsp+/ZpmlQ1hrrVWebPWw165DuNP+XfcDlWjqT52e/TfDsXBBDIk2RmnVwA8ibXPV87tJZf+kS+iZuZQVTJz5ThyGBPAHlOkK4DQbKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5b347a18.dip0.t-ipconnect.de [91.52.122.24])
	by mail.itouring.de (Postfix) with ESMTPSA id A2796103762;
	Wed, 25 Jun 2025 11:08:55 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id 584E06018BEA5;
	Wed, 25 Jun 2025 11:08:55 +0200 (CEST)
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org,
 Christian Brauner <brauner@kernel.org>
References: <20250624121449.136416081@linuxfoundation.org>
 <e9249afe-f039-4180-d50d-b199c26dea26@applied-asynchrony.com>
 <2025062511-tutor-judiciary-e3f9@gregkh>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <b875b110-277d-f427-412c-b2cb6512fccc@applied-asynchrony.com>
Date: Wed, 25 Jun 2025 11:08:55 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2025062511-tutor-judiciary-e3f9@gregkh>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 2025-06-25 10:25, Greg Kroah-Hartman wrote:
> On Wed, Jun 25, 2025 at 10:00:56AM +0200, Holger Hoffstätte wrote:
>> (cc: Christian Brauner>
>>
>> Since 6.15.4-rc1 I noticed that some KDE apps (kded6, kate (the text editor))
>> started going into a tailspin with 100% per-process CPU.
>>
>> The symptom is 100% reproducible: open a new file with kate, save empty file,
>> make changes, save, watch CPU go 100%. perf top shows copy_to_user running wild.
>>
>> First I tried to reproduce on 6.15.3 - no problem, everything works fine.
>>
>> After checking the list of patches for 6.15.4 I reverted the anon_inode series
>> (all 3 for the first attempt) and the problem is gone.
>>
>> Will try to reduce further & can gladly try additional fixes, but for now
>> I'd say these patches are not yet suitable for stable.
> 
> Does this same issue also happen for you on 6.16-rc3?

Curiously it does *not* happen on 6.16-rc3, so that's good.
I edited/saved several files and everything works as it should.

In 6.15.4-rc the problem occurs (as suspected) with:
anon_inode-use-a-proper-mode-internally.patch aka cfd86ef7e8e7 upstream.

thanks
Holger
