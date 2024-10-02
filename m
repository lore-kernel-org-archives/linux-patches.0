Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7271CFEA3
	for <patches@lists.linux.dev>; Wed,  2 Oct 2024 15:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727881275; cv=none; b=IPCW3/zbErq6G0dLQQIAFBr+Vi/WHxqelAaegPL5a9kbbnAgEKE5DJ4nR0iXNv59GCpr4kBpyvC9n5HNTv14qlDOvBRPDWYV3N9FfCc/WsWpYLONn0XHGIhH8E66awz/TfUi59+yFhICy3R4XkHbsNi0bP9d8i7fzK1kQQ78jh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727881275; c=relaxed/simple;
	bh=+9FhUT/HesuTcX0o9ubFVPBRifzvCK4Uultpo0OLeEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cAG3NwY1WE5bcLOsvbIiY2NKo37bD94Qej5HzmP1sQWxxaFaXXe6ohSnD29yx3vWSMDf0VnwpNgOIrea7KwrIG5josBLLy71nkm9xd0qXlREfkHonF2saMKyFSwKkbalikdX88JzOAMI7acMI3bRZI9+K7uRUAG5+YJhjteG8bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=cmucU3kJ; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="cmucU3kJ"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 4F83C89308;
	Wed,  2 Oct 2024 17:01:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1727881272;
	bh=705M+O8eoZeecbU6OkZV2lEo34Z7b8fUSTokq7+OAtY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cmucU3kJUGQT7O32MIT58cTlxFGRkZZV4pQcprgPlkO8dBJFLhXe3dlA4Qc3Syy6M
	 /hFH5SPTAUmpDQI95V7m34iR8gwOY12DYd1yRquara8UE+bPO9BaIPr5aVyzDJfhXL
	 gHsa/C1rV22xi0YlJjGkv6OTb9bqej+QGdVDSk6fQSefYuH15A6q4A8R7CSJlm4/uj
	 aO8HPuVVarhh9NrPNFkVQmkfP5XzaEibnginuA23B4jp/ep7kkkq3ERjYGYG9OhA/8
	 2nCsPv2xM1azBV1JL0WB3sPpWkynCMPje03AjDBmeZL+20KRROOEO4dzf6nPxkActz
	 sFxZgpQO1ZyEA==
Message-ID: <e999b9d5-0283-4d86-a0dd-e4d9c29c91eb@denx.de>
Date: Wed, 2 Oct 2024 17:00:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 288/538] leds: leds-pca995x: Add support for NXP
 PCA9956B
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Pieterjan Camerlynck <pieterjanca@gmail.com>,
 Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20241002125751.964700919@linuxfoundation.org>
 <20241002125803.624242401@linuxfoundation.org>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <20241002125803.624242401@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/2/24 2:58 PM, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Pieterjan Camerlynck <pieterjanca@gmail.com>
> 
> [ Upstream commit 68d6520d2e76998cdea58f6dd8782de5ab5b28af ]
> 
> Add support for PCA9956B chip, which belongs to the same family.
> 
> This chip features 24 instead of 16 outputs, so add a chipdef struct to
> deal with the different register layouts.
Seems like a feature patch, not stable material ?
