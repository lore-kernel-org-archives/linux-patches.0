Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17CB7C
	for <patches@lists.linux.dev>; Mon, 29 May 2023 09:49:17 +0000 (UTC)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 1DA0082721;
	Mon, 29 May 2023 11:49:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685353755;
	bh=E9MHSmzyT+qE+Rje3tdUt/F6QNvfv3JPDPfvuH2uOQE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nQUeP88UQWEb1ttbB9GrED6Pp/x9yerwdRduHZpZukWUTNGiT4tRufYE+XbV8q37C
	 es2uAA7835fitQqco8MAsHNZmv2wmPZTXCh6pmOlLBI2k5xaxKaALB+j2YeuUmgT0/
	 iB2Cev0ni8B7Y/2Bnsy1rpebUnbRssdp0XQtcRSLm8M89EsKfbIlYL9c8sPSdXRten
	 BP6RFL0MOxUw5Ck7LPr6qHETsGpEhR/kx/s76xsLnizaNF/MJlNqYXHl2q4h+cJQgE
	 wz1XlTqyq7KzfvBn7H66Pqa6C6QjFaylftTfX86PUrsw+updKghNlwNUzYk+NZq3yw
	 nd5Kd5debQwKQ==
Message-ID: <f43fd3c0-53a7-9579-bbfa-8d6ea373cc6f@denx.de>
Date: Mon, 29 May 2023 11:49:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.3 127/127] Revert "arm64: dts: imx8mp: Drop simple-bus
 from fsl,imx8mp-media-blk-ctrl"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Marc Kleine-Budde <mkl@pengutronix.de>,
 Alexander Stein <alexander.stein@ew.tq-group.com>,
 Liu Ying <victor.liu@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20230528190836.161231414@linuxfoundation.org>
 <20230528190840.351644456@linuxfoundation.org>
 <511be6c7-7e58-02a9-46fa-e9a134eac8af@denx.de>
 <2023052956-aroma-attach-88d3@gregkh>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <2023052956-aroma-attach-88d3@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 5/29/23 10:38, Greg Kroah-Hartman wrote:
> On Mon, May 29, 2023 at 01:48:05AM +0200, Marek Vasut wrote:
>> On 5/28/23 21:11, Greg Kroah-Hartman wrote:
>>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> This reverts commit bd2573ee0f91c0e6d2bee8599110453e2909060e which is
>>> commit 5a51e1f2b083423f75145c512ee284862ab33854 upstream.
>>>
>>> Marc writes:
>>> 	can you please revert this patch, without the corresponding driver patch
>>> 	[1] it breaks probing of the device, as no one populates the sub-nodes.
>>>
>>> 	[1] 9cb6d1b39a8f ("soc: imx: imx8m-blk-ctrl: Scan subnodes and bind
>>> 	drivers to them")
>>
>> Would it make more sense to pick the missing blk-ctrl patch instead ?
> 
> If you want that to happen, sure, but it seems like a new feature to me,
> right?

 From my point of view, it is neither a feature nor a fix, although it 
is banking toward the 'fix' side.

The imx8mp.dtsi 'simple-bus', 'syscon' triggers scanning of DT subnodes, 
so that drivers can be bound to them, but it was deemed as not the right 
approach by DT maintainers and moving that scan trigger into the block 
controller driver was considered better. That block controller patch 
adds that scan trigger.

So, I would argue that in order to make the kernel compatible with DTs 
old and new, the block controller patch should be picked. Whether we 
want to keep the DT patch that is being reverted here or not, I would 
say either way is fine, as with the block controller patch in place, it 
is just a clean up.
