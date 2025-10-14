Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CE130CD9E
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 13:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760450398; cv=none; b=JsFekHRhbondMGn6JKSmHMkOrxG/mZkawtGsqQexPycizmwXNuAT9wpKsDSheNbqNzLA4KVfQ/iFkx9BPhzDpfDQrm0foqkdECdJKCNRl8IKB+FZVgfnHVhXgG5nNduroP5/VGWCy95Fpab7BxJzCSD/kvEMZ+T/EEWu0gurIb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760450398; c=relaxed/simple;
	bh=XqYhWcXRRW0UNGCW/ZMfInGwJuhMAQ6n/LIE759FKq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EiDEq7bHhAgVHsBx8lu2A3Gz6E3hk0U15Sbd9nGEpKJVK8jKXpn4JSbzfZbL/bDaDUaCqS/JBxl9R/wmWMDfWlFzEwzB3Jj3nH+aRMghkv6QYfy70660QSyuy1tyvyPybTHtt+sURSdyXf8cDYsAgtBpzSBZ4PCnC30nrxVbX80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=uQr9jUW2; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="uQr9jUW2"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id 8eAGvuxAsv7248fZDvJ756; Tue, 14 Oct 2025 13:59:55 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 8fZCvwSCCBc9y8fZCvFrSC; Tue, 14 Oct 2025 13:59:55 +0000
X-Authority-Analysis: v=2.4 cv=ZcMdNtVA c=1 sm=1 tr=0 ts=68ee575b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=zQCNmZIh7_oNgwDxKbcA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=v07wzL3TXtGZaExHEmWCCWHx1M46lpQfmqmvV9srVYE=; b=uQr9jUW2J2+sl7Ylaf9V1+EJdl
	sj1UMif8i+GkVA6XMk3XjbxQwAA/wj8TR6deKul3v1ldvMzivH9AbBae6yE/jSwZK0gKCFkFJyG2r
	ddEbZdNAiOBjd0Zm28bSyOP+fpWeWoxUim7abKJH82kCYlV21+KPEkDMdg3gejQR7L4oPI13WYDaj
	wr5QRboc9GbS/2na0l2qnL4ZvRMoFEXsjtSypl5/6YtQvhk+K4aRnknRmeLlzmeMoqpv6bXCe/F9X
	6zrYY3urN/hGJ5rH7wxznBCOlX8PjXG6Dy1zHMer/1xdwplU/eABt5a1QIq0uCAFfLYOroPST78iY
	Gk5pjdeQ==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:43702 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1v8fZC-00000001lbq-0kth;
	Tue, 14 Oct 2025 07:59:53 -0600
Message-ID: <048b0b99-a0ea-4295-a1c0-821b6a353cfa@w6rz.net>
Date: Tue, 14 Oct 2025 06:59:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/196] 6.6.112-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251013144315.184275491@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1v8fZC-00000001lbq-0kth
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:43702
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJbppht0qSobeg97+CmOj/jZu8QrM2oNVbz8zaMriOMUD2H7WQRjbfR7FsjfQl/wD9l77LLh0xGABesi5Ly6FIIgBbNK0HBV1mZB5XiH0N+vXulcz6Fm
 qxOYx4RToSAgE69DG2q7V02zjXc+C4FB1jviSl3zjJv6mWaZJeIU5A8YM6kAiCmVjA0ymaEIi4h4nA==

On 10/13/25 07:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.112 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.112-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

