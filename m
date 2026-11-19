Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072765;
	b=WgCuuimTYTRWmI9dQVOP+wBCdURUYk3qoJSWVfgd1eV2ZX+B3GA7e7sYjNRbQWya1Yf+
	 /Ykl3S00CzD1flZPKjRb7/uKVixxYr41HmuwWC/eLjQyniBqSzEPpkSZbuYuYXVzZuO8p
	 VXBYDCc1wxpG3SK3I+5SFrjt3oC8haYbx3vpcWr4DqKxxaJ1INQDCycMGIPEXaNO/hJwU
	 IUVSiI+0BiW8Tf7ugMrNQPldfoQ6/JuwHiogJRBpblgzjHq9N9yHAhtP03NKPa0MPrr+m
	 P9R/oMCYLxWFx/6sY9lg2xp+w/4OI+XNaiAJUV3G9hdMi1SevhyjBq2dpz8E5EQcRmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072765;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=JGH8dnM2BI/s1mgvWClCH3pkAXo73qLg8wYZfIZ/+pY=;
	b=Zwp8WBZhfsPR+GME/HpR5/8RXlkpuT5KLEkpXv/vsKQFL/DOAg4fwHrrO2tL21FgaD8N
	 kjzMXfOBRe1PBwBoFg0Us6P9c5PVi/gIvts/4Moam87ybZimpvXXgWag/Dcmi7Sj+KSpN
	 iyrC8+QbWCzDcjfXa2iQzpR7RTG1c52pPRO/n7CrDWeAruRKBcgYbw+BAKKhxD7RCw6vY
	 /vNuhNh0MkuJ6UqDMz352p7UQQrkdtxJgBMCzdAXnkE/EmY3ywTPvtkUcYiIyawmFr4Cl
	 Y0HJHd+XY1tUrwE5bcWK4Z/tZ1xqOkpTteid0tFZNLsCMg7mwbqLktwK41SRJdnOesg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WpBxmTiF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2658C606A320;
	Thu, 19 Nov 2026 07:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WpBxmTiF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455331F000C4;
	Thu, 19 Nov 2026 07:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795072764;
	bh=JGH8dnM2BI/s1mgvWClCH3pkAXo73qLg8wYZfIZ/+pY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WpBxmTiFmfO9H8G8rrmi/1vhx6Ib3uEYuBCFCdMFuJZrvwxrAcN1KOMs8AmEN7tCW
	 E5TybYuqwW47jSgFpV8el/zNMe4+7kDLpLqlIcNZBtyDa5QuDfNnl3vlXbl0VHlwkW
	 TRmvwzcFvsCOUegHTM+pKTmhnGQ0N8wq13lfBjwRN1QOIQuTOHNh0VsmBp2sILUSuA
	 0JdFMwRpVhRJC8YqwRQpw2NHOA0GD2/xP2B4s0ytHw0C+rGkJg6udvoNgKGs2P/77Z
	 a8NojRMli/+TOODLE3iaBM1QoxIho7Mp/C/mnXqggzD7bcZN/kcsosyPIn6j6/HLQQ
	 vQZiXJrGGsvIg==
Message-ID: <fd52d21a-34c3-4686-a9d1-099933e7cae2@kernel.org>
Date: Thu, 19 Nov 2026 08:19:21 +0100
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
Subject: Re: [PATCH 7.3 1913/2651] PCI: iproc: Use the EROM outbound window on
 BCMA
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Semih Baskan <strst.gs@gmail.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
 Bjorn Helgaas <bhelgaas@google.com>, Sasha Levin <sashal@kernel.org>
References: <20261118150247.972732815@linuxfoundation.org>
 <20261118150355.645960710@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20261118150355.645960710@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18. 11. 26, 15:52, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Semih Baskan <strst.gs@gmail.com>
> 
> [ Upstream commit 9850907ee1dd4376c09c4129e0adbe3b39d191b7 ]
...
> ---
>   drivers/pci/controller/pcie-iproc-bcma.c | 40 ++++++++++++++++++++++--
>   1 file changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/controller/pcie-iproc-bcma.c b/drivers/pci/controller/pcie-iproc-bcma.c
> index 593418c2bc3aa..1e258cd8fed4f 100644
> --- a/drivers/pci/controller/pcie-iproc-bcma.c
> +++ b/drivers/pci/controller/pcie-iproc-bcma.c
...
> @@ -38,10 +63,20 @@ static int iproc_bcma_pcie_probe(struct bcma_device *bdev)
>   	struct pci_host_bridge *bridge;
>   	int ret;
>   
> -	bridge = devm_pci_alloc_host_bridge(dev, sizeof(*pcie));
> +	bridge = pci_alloc_host_bridge(sizeof(*pcie));
>   	if (!bridge)
>   		return -ENOMEM;
>   
> +	bridge->dev.parent = dev;
> +
> +	ret = devm_add_action_or_reset(dev, devm_pci_alloc_host_bridge_release,
> +				       bridge);

This does not build on armv7hl:
drivers/pci/controller/pcie-iproc-bcma.c:72:45: error: 
'devm_pci_alloc_host_bridge_release' undeclared (first use in this 
function); did you mean 'devm_pci_alloc_host_bridge'?

-- 
js
suse labs

