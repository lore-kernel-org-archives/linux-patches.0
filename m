Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020914;
	b=SwdVgXymKToBmkgnGC9CP0ocBsrc3JurS/6F+pntNyFDCRruT7uXllETlvZfVhkmcvQh
	 WrCpUnvmNKczDuz1JcVEVaPAPOmm5d8s8rGNN9q7TduIbo04TUSPim2OdOgkMiyzhl+6v
	 t0vcn4PQmp3TWU7X24DZ2j+3ZzRE8mbI+WaKX9Xxe4DULSCrVXSbJmh0YEOxXcUcQJkA7
	 8RBHWxzkElrdQIl9jUPVCgQriASQkICl9jshM28iAvKcFm6XdvczB/ON25PWBSEiGyIx9
	 zuD/MzNnIp/R1Jkk3PfTX8E7vbDtlQWZF1WUv0BCtkZl/U/zDFmGnnitUobVgKNP86A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020914;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZLM3s8d8UDzrM9sfjMtb4usIGUWvbcJkqCBFK/uTBxo=;
	b=QsApUsJWXzDO/m+ikjPdNisNkDxvnH7+mmIeK0I3yoJb55VwnbNYuxukGbsLk15IA46Q
	 wF6YkLEqOaBtYD6p49OhQnuhKzYt3S3mjNt3p6ZdO/3dD4dvAn1M/qDPaxgxv4yt4h+Qp
	 TUY1EfJDDz19ymznEP8kMp2ti1rw1sDFeFXeb6FRB3l5UJ5X8FVWPxgl8ceRqOUyHiwAj
	 oNRKOJzNTxyEa0fwHaTOstw0lolunDhoX5lrlBRuL+DtgxlaTscWmKZE1NcB2KSvgo5CX
	 J3npGiLeiQv54DbvBp3rvMc/Vkb34NvDh2iXtqY4tEBqsosaQESnDL1JBaLwbzhkB2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b="Z1Wj3+L/";
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD357606A31C;
	Wed, 18 Nov 2026 16:55:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD357606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=Z1Wj3+L/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZLM3s8d8UDzrM9sfjMtb4usIGUWvbcJkqCBFK/uTBxo=; t=1795020913; x=1795884913; 
	b=Z1Wj3+L/fBH0smUe3N/4DWjZswp6mIRxDNziMdaQwG7Pcn4NLfGPrZ4K3IiNMKLQG6OY6yxnahZ
	IwwSNbVOHfRNRZdaa6cPzcrkjvw+0jsHH9lxyj3PDhGf94oh45wCqO8HeeMJr14A1ZKszGFzubk1V
	vCcfQA+3G0uNIL2AcoGzcIMIUOlyNnly3JMckeFQubb+2KhoLzp1Uo7u+jpFSLSNkZVL/16HAEtxW
	IYTjDPGO45g8CFqmLZFUMuf3p3VQXJ+/miG7ff0zaWEedR1QyYl6iXmPOtuy3XBmcHQBK6Cx32ojN
	dDAODXVUU+shGG2wlnZKBeXUNiCIx0M6DOyQ==;
Date: Wed, 18 Nov 2026 17:46:26 +0100
From: Brett A C Sheffield <bacs@librecast.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 0000/2857] 6.1.193-rc1 review
Message-ID: <av3WYtoFXmHPM8uk@karahi.librecast.net>
References: <20261118150201.293410965@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>

On 2026-11-18 15:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.193 release.
> There are 2857 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.193-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

Same build failure on amd64 as reported for 5.{10,15}.y

-- 
Brett Sheffield (he/him)
