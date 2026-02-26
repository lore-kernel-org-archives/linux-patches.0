Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D2438F92B;
	Thu, 26 Feb 2026 08:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772092801; cv=none; b=JzbUd0waLhNQV7jKhzp2cYEDD1NJDGiWhATZsZMave2URfEvq0xD6Vqx/EWqSLFaZWp+0voPB3UhRyE+tvHKnV5pkDLAtYEKZflLCjKmIIIJ/YkCRf+Me1TJGUW6aG5XRjvnTF/E+kckgnmG8kmhlME8DePnkgC6i0NijA3qpjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772092801; c=relaxed/simple;
	bh=OxUA/HKHa6M8YsD678+VwxX0wvygG/XYGujEnxOR5kI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=egA/C5f3vAcYAPb00/zxeDpAS7Dy83EF5UvY01MLUvyNsUqkbTH0OEePPEP4vgTnKYI17wQnuGbR7AV1U00zWvaojhXILofUhe9nzb32vV8RSf5BhKOfOXQF8hJSpTWAzD8RPut5FX7S+Nw1EXIN+Iwb1yO0u4ja6lc1vUsXWF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TY55YMad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TY55YMad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6E7C19422;
	Thu, 26 Feb 2026 07:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772092800;
	bh=OxUA/HKHa6M8YsD678+VwxX0wvygG/XYGujEnxOR5kI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TY55YMaddycepVTow/cdH3CDljHX6p0U9otFd+fUlysIMTqhz+hWFZ3SC+W/HBiN1
	 9Dted4TS+xLrl528CtqvOekC2gLmbLkjB5dpAlvxABYunQXKG3vH2lniAmQ7IGq+We
	 a1YoPI+JGpJv4XEwmiCzSia3wlsPTuFtG93/dlXOoHe2QTUszTfYuVpNjK7na27D1M
	 JZ4VhfyhnPaZpfuMB1ykowx5EnC4dUJ/6nVqn4KErAJEo0rKGp8aWVrA/JOYKORnil
	 HUf1SjPWy0BlSWW9FihA2VmcYqjH316TUzKFwKcckO9Q3bqqatH3twVFtlHiJ6PgOm
	 IOxdLwCDk6GjQ==
Message-ID: <2925f3d4-ee22-4dea-958b-fbcab94f76a9@kernel.org>
Date: Thu, 26 Feb 2026 16:59:57 +0900
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 767/781] ata: libata-scsi: avoid Non-NCQ command
 starvation
To: Jiri Slaby <jirislaby@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Xingui Yang <yangxingui@huawei.com>,
 Igor Pylypiv <ipylypiv@google.com>, Niklas Cassel <cassel@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 John Garry <john.g.garry@oracle.com>
References: <20260225012359.695468795@linuxfoundation.org>
 <20260225012418.528826275@linuxfoundation.org>
 <4bbeb69d-698f-4fe7-86d0-67c6f7e2ebdf@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <4bbeb69d-698f-4fe7-86d0-67c6f7e2ebdf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/26 16:45, Jiri Slaby wrote:
> On 25. 02. 26, 2:24, Greg Kroah-Hartman wrote:
>> 6.19-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Damien Le Moal <dlemoal@kernel.org>
>>
>> commit 0ea84089dbf62a92dc7889c79e6b18fc89260808 upstream.
> 
> Hi, this one is broken and needs (very fresh) fixes according to our 
> tooling:

This is not exactly clear to me what you are saying here. What is broken ? What
is your tooling saying ? Are the original patches broken ? Or are the backports
broken ?

Be a little more descriptive please.

> 
> eddb98ad9364 ata: libata-eh: correctly handle deferred qc timeouts
> 55db00992663 ata: libata-core: fix cancellation of a port deferred qc work
> 
> thanks,


-- 
Damien Le Moal
Western Digital Research
