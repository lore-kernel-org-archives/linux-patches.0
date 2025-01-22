Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B199321171A
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 11:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737544310; cv=none; b=bOIBX7looR4dttPZI51XE5sEzMp8JNW/dPuf8C5O89k1jE0TavXx/IhhpzM3ifBKm9TPGJqaP1ohOSOimShaL7I+Nxt+hmNsvfaPQt2sabiXPZm3QtfSr5A19ZbA2lVy2YSf1OtH1/JaDwa+jiIWMM8nPzSSWM6PhlX8Dm4JE9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737544310; c=relaxed/simple;
	bh=OOoMM6ogp3WvYHbeHr0N0ppNAmLwrloVGDbXHFJyWsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HeiuB3VgD9DPs6NorM9NSrUEouROJgL7YziGzpK2Ubr68DelVidZSALHZTrLW9WYtbAuipWBGCeVTiesvDSgrCC89t28IEkoMArLoN6xFoOOVTLHmDkeCiN8h7sVMtNCTtegTpUkgd5y8vHIxI1TYenPWP1eIroEw8IDahPsSY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Ox3xBahS; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Ox3xBahS"
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
	by cmsmtp with ESMTPS
	id aIlltmJYpzZPaaYeAt6UZO; Wed, 22 Jan 2025 11:11:46 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id aYe9tFK8KjBGzaYeAtln4k; Wed, 22 Jan 2025 11:11:46 +0000
X-Authority-Analysis: v=2.4 cv=HJvFFJtv c=1 sm=1 tr=0 ts=6790d272
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdSt8ZQiCzkA:10 a=7vwVE5O1G3EA:10 a=ag1SF4gXAAAA:8
 a=5w5GKDrklCRB6mbyaZYA:9 a=QEXdDO2ut3YA:10 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Mwdjw+pPnWKxKBlaA04VTYFOaMsNHgNXqAmkF4+QZrk=; b=Ox3xBahSwjIpeAUckOv8TeN5BN
	9U/Aksn35MJDDBXEqOK7OAzjbF2hGV3vY7wVCwZiq6/QhyTG542uecdzegbLexRMfq4LkUx122jLv
	oPwRhVsC+lIObHeEDCqxiRsOhE1SxZsDSbP3F18GriuM9utwmbfvyiunWPQTAzLpKwXnKpWSqXeY0
	OIcfq/RpQ40bK5yNk7rXRI9ou7miPNmKTFJmkxSrkO+YywUtXzNwEGj296B938eNe6lVETyEhpVe5
	zMhvq3mFiS3NeWBzCTVroxolWvGk/c4rj93dW86Tbwc5tfgH/aajH88liomvzzGGjI/qp/u7zuigc
	wOD3XlWQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:56226 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1taYe8-000VLw-1S;
	Wed, 22 Jan 2025 04:11:44 -0700
Message-ID: <faa9e4ef-05f5-4db1-8c36-e901e156caea@w6rz.net>
Date: Wed, 22 Jan 2025 03:11:40 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
To: Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Guenter Roeck
 <linux@roeck-us.net>, shuah <shuah@kernel.org>, patches@kernelci.org,
 lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
 Jon Hunter <jonathanh@nvidia.com>, Florian Fainelli <f.fainelli@gmail.com>,
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net,
 rwarsow@gmx.de, Conor Dooley <conor@kernel.org>, hargar@microsoft.com,
 Mark Brown <broonie@kernel.org>, Anders Roxell <anders.roxell@linaro.org>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dan Carpenter <dan.carpenter@linaro.org>
References: <20250121174532.991109301@linuxfoundation.org>
 <CA+G9fYtv3NNpxuipt8Dxa_=0DhieWWc07kDgCDBM+o0gKRi4Dw@mail.gmail.com>
 <cc947edf-bece-498c-bcb0-5bc403141257@app.fastmail.com>
 <20250122105949.GK7145@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250122105949.GK7145@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1taYe8-000VLw-1S
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:56226
X-Source-Auth: re@w6rz.net
X-Email-Count: 20
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfOnpptZ9NrP2UgHrsDvqSBoWDkNE9TBBW7yl7WaizyXwF5u8AN9NyQNUUNgZ/gUriGfC+AiA+4KEz0mavCLH8+p6HtpQc0+sJ8G3GDRefTaS6bgUZEqr
 NfOAyGxxRWcz9F+6FcVsmlwty7szgj4SC8ypcUuq+//FzqcnOPC9zYvzI0hqwArR+FiBIZdIIUvrzw==

On 1/22/25 02:59, Peter Zijlstra wrote:
> On Wed, Jan 22, 2025 at 11:56:13AM +0100, Arnd Bergmann wrote:
>> On Wed, Jan 22, 2025, at 11:04, Naresh Kamboju wrote:
>>> On Tue, 21 Jan 2025 at 23:28, Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>> 0000000000000000
>>> <4>[  160.712071] Call trace:
>>> <4>[ 160.712597] place_entity (kernel/sched/fair.c:5250 (discriminator 1))
>>> <4>[ 160.713221] reweight_entity (kernel/sched/fair.c:3813)
>>> <4>[ 160.713802] update_cfs_group (kernel/sched/fair.c:3975 (discriminator 1))
>>> <4>[ 160.714277] dequeue_entities (kernel/sched/fair.c:7091)
>>> <4>[ 160.714903] dequeue_task_fair (kernel/sched/fair.c:7144 (discriminator 1))
>>> <4>[ 160.716502] move_queued_task.isra.0 (kernel/sched/core.c:2437
>>> (discriminator 1))
>> I don't see anything that immediately sticks out as causing this,
>> but I do see five scheduler patches backported in stable-rc
>> on top of v6.12.8, these are the original commits:
>>
>> 66951e4860d3 ("sched/fair: Fix update_cfs_group() vs DELAY_DEQUEUE")
> This one reworks reweight_entity(), but I've been running with that on
> top of 13-rc6 for a week or so and not seen this.

The offending commit is 6d71a9c6160479899ee744d2c6d6602a191deb1f 
"sched/fair: Fix EEVDF entity placement bug causing scheduling lag"

It works fine on 6.13, at least on RISC-V (which is the only arch I test).

It's already been reverted and 6.12.11-rc2 has been pushed out.

