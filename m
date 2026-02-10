Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14622DF151
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 07:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770709607; cv=none; b=ZbS4l4DRmedJnCJhtJDKnnDg3n/92B39jbVJ1vOPXjVhN3e2PO3fd/OE4p/NQLSln2YgSv9kMpfg2mENi5Q3tPbxCW/7HBasKFNeO/wIpIkdeF1ue/noMir9UfxGzJ1zA0oDsI7jYBlQjp8hmbfazAS0FDMNRJSEPISt+/NGxNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770709607; c=relaxed/simple;
	bh=m1HdOO0QfCe3+/BLkjO688TG25ggRTAyye/fATeEpqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AW9cWZDCbZ2y89s5cc6gXqsJg4OMoj1p2uqfLVopE1wbMupeBVZseFj0eO7Xx6Gi4q4kb4YJKWeflZ2e1m/fVkTD9vew/h9dP1asLj6/OMo3FVt3OXtwsPKW67Ivim6xrA/2BjuFPZRC8STDXxc+1tB2mWQT2qiOnatZOckbwfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=rsDOegt6; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="rsDOegt6"
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id paEdvC1biaPqLpiSKvgnz2; Tue, 10 Feb 2026 07:46:44 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id piSJvuduMjAxupiSKvCXYo; Tue, 10 Feb 2026 07:46:44 +0000
X-Authority-Analysis: v=2.4 cv=EoDSrTcA c=1 sm=1 tr=0 ts=698ae264
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=REf7ZeV+LC9D/4Gz7JrHr/0umPnMj0848AOEJ7ZBuCw=; b=rsDOegt68soUlkmmNjr8F+sDGK
	5YRLicnb+5J4Myxn6Tu9nx/+M/G22zzuh5W4Wpktofh9hY9L0x7gq8AGkDv1/Avlnta5KSNVNLSA5
	in9ANW74bh8OVWH9a1zIQk6fLk23/2UMF/IiKZTfmf1n6bpUZiLlTxv9eVAb0+I9YuH3Gw3jyyCBX
	VupWEYMn3i9A5bIyg8hdEFyUQ3Fvj3YEdJ7w7GPom/flriRV+dkSQyXsv2UC/B1j2dNprr547wO2F
	ZJmRqzX57W54ay8G0zYylSg34TgdWCJeVCKWXqIBSGbInskpFS4ZSTjINsmCbj2Y66A3Y543FeTMA
	PPRv0YiA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:54944 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vpiSJ-00000004EZ4-0sHH;
	Tue, 10 Feb 2026 00:46:43 -0700
Message-ID: <0c7c44a4-ee3f-442d-aa15-b05d2563286a@w6rz.net>
Date: Mon, 9 Feb 2026 23:46:41 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260209142320.474120190@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1vpiSJ-00000004EZ4-0sHH
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:54944
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNEyVox99b7wMeFJG6pt0yXTE6vXcoa0hMNfn1CSx3z8SjtdHiBQUUODAobP51JZ/nDtSAgpt+XAn9FdnVOrEwen6aEiXT51LlMd1sumQ93wy2Mo2cGT
 5FBoh7KoN6WtHLqWK4VQHcAnp9xz/am/SU0pQVlOCxlZv7W7fPofnvsoQOfZmJ21qQ02jCTZorxdpQ==

On 2/9/26 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

