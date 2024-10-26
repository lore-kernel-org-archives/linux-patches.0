Received: from out203-205-221-149.mail.qq.com (out203-205-221-149.mail.qq.com [203.205.221.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716CA217F2E
	for <patches@lists.linux.dev>; Sat, 26 Oct 2024 06:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729925021; cv=none; b=aN8FkQaVQDvaKy910eVKZbFWp+Msq9nuiJjyjFWJ6iak2Zajek5Mvedm2WH4hh+GJFC7ddFDUynR8uyaYJcrdhjhbDIMQjAFY8tH/SUa4xVsaiq0xRQMrWkB5DKHMzjvF1tO4y5rkf6dCyv7oUFezyIGR5bTJBJRVX+NNIExjLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729925021; c=relaxed/simple;
	bh=8RhuHhyKDCejXCMwjThdGwtybfa3udHgVYXF2blieRQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=ILaTOris5DFJL+ohZEsBj2cw5u2UqnjWr+28PA6ib1/MJ0V+UpGpTexR13yporLCFy0I6zuVOD4qiF2tXHjfgvuWrvjXb5/UxSdp0f61tFgdOneBNUv35bABemQ/vgC4hSkF2WkqtXhnPfHU23gmBhY6K+DvOIZbtmYtuiqNCEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=WTiMmzZk; arc=none smtp.client-ip=203.205.221.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="WTiMmzZk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1729925011; bh=jZJrnJWAOw+7HE7pv1yAKc+czPaHXuZkpN+pJfn8Uws=;
	h=Date:To:Cc:References:Subject:From:In-Reply-To;
	b=WTiMmzZkV16VS8Qlhk5nwM2vIM9QpkwyDCEPtD6n5QnBUDt+ABZaisry/u6/pPPxQ
	 8hKbW2t0rVHgmLEI/ziTe+WiadtN1W4X7dIwoTLrC2W3XzLzv7ZwL1X7V0wlF98f0h
	 Ivyp2tFsCO6h6I/IlahUfxl9YgF1LYNkT1HQtxMM=
Received: from [192.168.1.189] ([122.230.45.198])
	by newxmesmtplogicsvrszb21-0.qq.com (NewEsmtp) with SMTP
	id 95BA0271; Sat, 26 Oct 2024 14:37:27 +0800
X-QQ-mid: xmsmtpt1729924647t3ojemr4z
Message-ID: <tencent_0EB8B858C220FC37F7CFA4019C9D112F3009@qq.com>
X-QQ-XMAILINFO: Ny9b0zP53WzJVjefAOwZdM53epvMrDmdDN7fH3HO4w8U30+hJM3UTPtS0OCVKC
	 aWFWjwgbkIjKFm+plsI/WMNYSUTL44lw5K/p0y5cMmcadwX2MqTbCjKoO5r1Uzajyh1duIlxrMgi
	 RnVHEqeam6oxUpmYaodQEDpQxfyc7EJIz5k5m0muMAvGd0EoFmiGy/4JegVsDVgXX3P46HSiUrKB
	 8sXzhBa623MeKRKbX+vr3sQ31l1Lnic3+Dt/AIR/DiXxNQrax4Hz0Re4hr5+xmNrd1h1hOtpXjVZ
	 fJQMsP/7XiK4sAAQVpRn2tODKtwsB0cOHfPHewz1dFf9U38ylqNubgMbe8dDjl9DbBktRmRT/Ffg
	 OEm1TUThQLidEK1VlmeCD97r4lZnnffo+5UkFYqmz9IODdEgGmf4wsRlL43t+eQQoQ69XNQdYo0F
	 RTKsJAFH3vx/OKZ6cOIRnfa97MJvMOp6qYn/btGORHB7c8pkbIs3OyQosHXZpETrH6gdr9k9ZlVn
	 ijy+jA396FcLLSefmzuMH/OMWAQj8XISRMcwKfmcwCQmfuYyQMqu4AcNdZBTWhLlQGRDj6ApmSEH
	 VTF3J1OZmx4xLSHqOUg1LPjLjgesZHT6btA87n8I+bnqRE/EwA17jgiTfB3TtZPuhnMPbDt6aNWW
	 0UIEcLXmywQwwlqK1iH7Q4HlnEqDtYXL2KOpn9qYkKDHwdeGhoOL0ffRZ2JfxqBOoAI9wlgF6+CI
	 IB/iqWkH+Du/vEn4Z5fp1mEHfG97RUg0hyQS9zpYpIk22ZDonwj8RbLPbLZiSdoEDbs8Z5TWIK6F
	 unBu+GnJs6kyrjWpXINTecZctXSEpTxzj1iCXikh46/o+XCcJhpum/svs6UQzfHieSVM4HNewssz
	 sBcPfA2INlvPukFLdBcSMMiGm6KFuzs2UBj7fixaezIZbV/2iMkW9NqVNWdClK2SXTwXZyx9bvvX
	 pvZ98bgnwuCVXgzU2Fb+S7ev6eGnw+pCm8LVKYk9/dvq0k5QPuOnye/nSdqCRv
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
X-OQ-MSGID: <3aca3d1b-a678-460d-be25-19cc545c5416@qq.com>
Date: Sat, 26 Oct 2024 14:37:27 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
References: <2024101835-tiptop-blip-09ed@gregkh>
Subject: Re: [PATCH] MAINTAINERS: Remove some entries due to various
 compliance requirements.
From: SekiBetu <sekibetu@qq.com>
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

It's so sad that the most famous open source community is opening 
Pandora's Box

