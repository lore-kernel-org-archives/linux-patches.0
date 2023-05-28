Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB7E23B8
	for <patches@lists.linux.dev>; Sun, 28 May 2023 23:57:41 +0000 (UTC)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 202808215F;
	Mon, 29 May 2023 01:48:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685317686;
	bh=w81jPivu3y5bF3adPCm1pXsnjb8Fhcj5vQLQBslFxvw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LjhltQg0mTBWu3GshJUZ3R2Ll0kWG2w6Yi7EgW+/DzEzHLOVvwzgbs4Hv06lJsMcZ
	 US4NynN2L+jXt9vb7wX+iHEb+FMtr5EqsVonrMQs+jdz3pZKrbyAxv+zTjdYzNr/Vy
	 Oa2j/YUSHT8GZv3EuLQpfmxrnEg2MGJBc0Jx4SFeAGRMp/ts7KCRCKoqmxnEiSqyqD
	 IWtIQBlsnJz12TCpd+Rw0bkX4BbhkNy+iASlRAD6p6iDiaSivLdmuUssPwIVRyv55h
	 KVGrP/CTuzlrryckoGT/oCvZP8mMuhyzhZGtTvUE8Xo1SkjwBLl8lJkX/P2vqXtNKS
	 xRhgDHb5bqlkA==
Message-ID: <511be6c7-7e58-02a9-46fa-e9a134eac8af@denx.de>
Date: Mon, 29 May 2023 01:48:05 +0200
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
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Marc Kleine-Budde <mkl@pengutronix.de>,
 Alexander Stein <alexander.stein@ew.tq-group.com>,
 Liu Ying <victor.liu@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20230528190836.161231414@linuxfoundation.org>
 <20230528190840.351644456@linuxfoundation.org>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <20230528190840.351644456@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 5/28/23 21:11, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This reverts commit bd2573ee0f91c0e6d2bee8599110453e2909060e which is
> commit 5a51e1f2b083423f75145c512ee284862ab33854 upstream.
> 
> Marc writes:
> 	can you please revert this patch, without the corresponding driver patch
> 	[1] it breaks probing of the device, as no one populates the sub-nodes.
> 
> 	[1] 9cb6d1b39a8f ("soc: imx: imx8m-blk-ctrl: Scan subnodes and bind
> 	drivers to them")

Would it make more sense to pick the missing blk-ctrl patch instead ?
