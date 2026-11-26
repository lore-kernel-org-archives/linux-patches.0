Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.202.169.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795677378;
	b=l4P3qgd0g93jnuzvy/MrwvhT7WaFdXv+ZJ3Db2/ALrqX24b8M/PjeHGDBF94TTVJqURD
	 F4zJky2upWeIEoNABzyo2YN1qQ+wRmRihknXr/Pprg1YXeaANJ4gUc+SaYkhqyW1pA8RU
	 ovcxluxeXUN0d5omYgk+UHlv1UHoObxeihs8z5V6vqhoGBfML/Z8bHz3AFyWsIpISbiib
	 JbZL0sdbLhQVsL9UOolsFN/jGjxho9lC6r4LG2QVJ32DIUmTGypsqw3yC/ECXr4NbRK/9
	 OtrOz93aPG/9HE/BHrozPOm4S4s0uNvV2pXJx5YEbiVTQ4eDSjpLfX/Zc2tJRrL0ZTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795677378;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=3i+ws2zWCjm2HMLKA4ul6PfFA/sYM1N5/ZXggdpt1CA=;
	b=n9Z/09+RMNzfUcltp0W0RfL8yXGyZmrTkYQ9g97tv99OzhaNQhtE0Sq3yH7z3qnzoA9Q
	 WHoQdLyKOjOEQGcNLcNzcSxkAABaCpnk6U2DYQ8AH1DMuzJCHFfB4MEPb3q1YWaY6RNgW
	 V+Q/0J7J7Rr4yolgahB+1VL9xUfoZMwRjgTKKjMgdUPRs4WEr6Mx7mSDPtBH6fD4/YhvL
	 qZ3qVprBjq8SLRn/llrSKlvL/VcfmBG9BY5tEJV3tEPdqwNxBLa9zC4wvtZMor01k5sub
	 R6puiGngfuyYP8HaW+tvytnLT7tsk7Q8Ufp8mHRMZ5GnH4AvraWiM5J45Ey2xf5Indg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=EX1GTFw1;
	arc=none smtp.remote-ip=44.202.169.37
Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331B5606A31E
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 07:16:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 331B5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=EX1GTFw1
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id WJ9yx5x17V16IWTiKxGOUC; Thu, 26 Nov 2026 07:16:16 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id WTiJxbh0vGh2BWTiJxy8OF; Thu, 26 Nov 2026 07:16:15 +0000
X-Authority-Analysis: v=2.4 cv=Aszu3P9P c=1 sm=1 tr=0 ts=6b07dcbf
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=7vwVE5O1G3EA:10 a=pGLkceISAAAA:8
 a=9S_pzrnjRmio3dmI4TwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3i+ws2zWCjm2HMLKA4ul6PfFA/sYM1N5/ZXggdpt1CA=; b=EX1GTFw1hOqQBV7UpRx7LT4wPv
	3pxDlcMUQ/S2DK+1ePUAXlTxWE5CXZJOFQQyOYzoRGqrrYo2XsW3DeNhlmALhhRrsg5Y9aJJL0sye
	phxRfMEgd6m95tw0z0icZXRts0+EPkaZgl/gs2ZjCGiSgXYk82meYaUHzpyxv7jML+QVn/QmxEwcp
	3bGcsuLLywIjr1SoX7A9L/IVjr9ZD3vm1p+bfau/NrTqW1xbO2mCcIqPN0rYe5Z/OR/Qb3KvOyOyw
	9PD/aHsy4x8gjwj7LiSIcnwICalJnxOR2LJRzwJ4GSxUimkV7rovNXSKE2SyR0NR+sYrzu1atIPm9
	kwQtBpAw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:43092 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xWTiJ-00000002EUP-0ZqL;
	Thu, 26 Nov 2026 00:16:15 -0700
Message-ID: <60eaa0ee-adbd-4bdb-bc7f-63f4631e022f@w6rz.net>
Date: Wed, 25 Nov 2026 23:16:13 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0361/1005] sched_ext: Reset task fields on exit of an
 SCX_TASK_READY task
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Rahad Bhuiya <rahadbhuiya2021@gmail.com>, Tejun Heo <tj@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20261125143821.729802100@linuxfoundation.org>
 <20261125143830.189554233@linuxfoundation.org>
 <0782adf7-20af-45a3-a09b-2a34c76afbac@kernel.org>
 <2026112640-recite-tipping-891f@gregkh>
 <dc5dc970-d7d5-46e4-8b2e-327c7e31a90b@kernel.org>
 <2026112625-skittle-retouch-c4bd@gregkh>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <2026112625-skittle-retouch-c4bd@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1xWTiJ-00000002EUP-0ZqL
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:43092
X-Source-Auth: re@w6rz.net
X-Email-Count: 4
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPYic+GQFjHlEuNNgitxQ4MN6olgCL0WXMH6ahZrS4KXMi9Tk/ecxLhPvnqIGwk8L+9itnIHnfO430Jeb2SnaVmeoRPXa830LuZB4cYqwKHdijlCXI/f
 fMOf1S1+U3NQALN13CJXZ2b7roISsexWgsmIbm2jFE05evVsCPLRqSSn3698pGUS+GCnbcKoPOxEgg==

On 11/25/26 23:00, Greg Kroah-Hartman wrote:
> On Thu, Nov 26, 2026 at 07:53:04AM +0100, Jiri Slaby wrote:
>> On 26. 11. 26, 7:36, Greg Kroah-Hartman wrote:
>>> On Thu, Nov 26, 2026 at 07:19:47AM +0100, Jiri Slaby wrote:
>>>> On 25. 11. 26, 15:28, Greg Kroah-Hartman wrote:
>>>>> 7.3-stable review patch.  If anyone has any objections, please let me know.
>>>>>
>>>>> ------------------
>>>>>
>>>>> From: Rahad Bhuiya <rahadbhuiya2021@gmail.com>
>>>>>
>>>>> [ Upstream commit 564405c424f49d70b13debe7fe5b550234ad6b84 ]
>>>> ...
>>>>> --- a/kernel/sched/ext/ext.c
>>>>> +++ b/kernel/sched/ext/ext.c
>>>>> @@ -4198,6 +4198,7 @@ void __scx_disable_and_exit_task(struct scx_sched *sch, struct task_struct *p)
>>>>>     		args.cancelled = true;
>>>>>     		break;
>>>>>     	case SCX_TASK_READY:
>>>>> +		scx_reset_task_fields(task_rq(p), p);
>>>> This fails to build:
>>>> ../kernel/sched/ext/ext.c:4223:17: error: implicit declaration of function
>>>> ‘scx_reset_task_fields’; did you mean ‘scx_set_task_sched’?
>>> Ugh, I wonder why this code never hits my build tests...
>> We seem to have:
>> CONFIG_SCHED_CLASS_EXT=y
>> maybe you don't?
> I don't, and 'make allmodconfig' doesn't select it due to the
> CONFIG_DEBUG_INFO_BTF dependancy which does not get set either for some
> other reason perhaps.  That explains it, and we've tripped over this
> before...
>
> thanks,
>
> greg k-h

CONFIG_DEBUG_INFO_BTF requires that pahole is installed on your system.

