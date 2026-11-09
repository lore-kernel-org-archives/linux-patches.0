Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217230;
	b=1h5xtwiG5a05nCqeZ+qkdxynMhG2HOqo9HGOeph2pDEen4ZqU1feEK8K1kFBt8JpbNJm
	 UZ0uHNBwgzqIX7tBrZXhe63Faz4I43kYSFWBItLXuo5/ENMNSX/QK/yjHbdeEY7GqKJfh
	 zkknE5DEb2JSgMZK8VgIh+i27v0AOxTEEy/9TxWcfz3HFLr8W65RxyA6StSnvcEuCMn/e
	 5osn7VEOCy6ZUD8MOjjUAyrdAI7T9BzVvDu1SYRl9uFzC+KtZGET5YP9MObAgvBv9mlWa
	 yEl9sg8QOdbKdsfp3dBN8s5ZYOMLsrNmsMRajnP5v990VBZCMlmCOUaH6C/2/G7DpEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217230;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=PB66Y9MaZYNl68MYlsrU5pArSwHdL9SHQj8fzOt+DQ4=;
	b=rVCbD442S7iXhBUEaQ0x4WJUETA647oQvMthdlvcrVRKPW4/jAPl0wUjYRAZqdwplrBF
	 0ZgGNZZnIMBULuNQSX77hxacqyuDwoAQPuaQD+ba3iG67R3zSBjH39UANNJZZWjZRvhdG
	 mXxXRgWEwgaEykPejz3oRBiHwz/W5bVqpH4a0+rS3HpWh1mBcpb+c7GBby7AmLrxB1z+8
	 9/+yjnf1VHhN56ZXU7RvMDhY/Jh7sqOanRLbxqNHN9TP67mEI0hmcsXm3rYOHeHBbdLcY
	 az8+9NzhWfsPxWG/mAfhszMbNQmoMKrqnw8mUVR8v8o2itJ3tAzvbhmpq7SgGK5mfzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=LxC+7+eq;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=z54cX5AR;
	arc=none smtp.remote-ip=103.168.172.158
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C690E606A322
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 09:40:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C690E606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=LxC+7+eq;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=z54cX5AR
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id F0EF91400159
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 04:40:28 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-11.internal (MEProxy); Mon, 09 Nov 2026 04:40:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794217228;
	 x=1794303628; bh=PB66Y9MaZYNl68MYlsrU5pArSwHdL9SHQj8fzOt+DQ4=; b=
	LxC+7+eq/K3BnvjrHL0M0QDWyjDG5QzvPt6sMwr4Ku2mh+iZD2FVNTPaNPWSRrlk
	7suAbLuuHqzTjdVe+s+PeqzPECZNbFjLrLHIG02ply/OrqMzSmHgv1wuXOuzJgvH
	oCV8fuixD99ud87jtqQ2uW9ZPHtuiCzUTArR/xZBg1gahqzJDnJ6ezYn3Y2OLnHJ
	2QmqR5bSoYUFUGsNtcGAw0ZacPz2FFWW3aWngJwk2ifDq8s70UYfzUUt3zOTtxdh
	3oaTz7GIaV1iK24Lrlm/HPumTianaI1IHt/cGz1yBXCVGqZdOfSgO4HhbTHGDZr1
	6zK5EUQjz0Ljgfcwdk17eg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794217228; x=
	1794303628; bh=PB66Y9MaZYNl68MYlsrU5pArSwHdL9SHQj8fzOt+DQ4=; b=z
	54cX5ARP98a1bT8b1LqoccvD3VjjdcJRY6sXTaz4aWbn+MrtHZGT1/NNwJlPmh7U
	OVAQ3IjLvVS+tPDRXGA0jHFxrf6MnwWsk7G5mzRso6lv5ujqZHDiSiUQeBHCw1R0
	G/Y2cvwHOw4u+IWJTXNYR+Z2jyShXVAeD89CmqPNlUDI31lYZpfuHYcNAnzrsZuY
	kmVRjKeIvMQv62h3n2TnhDEH3OBvzqKzYIrQN+rCGThJusfHK5r5khVMdEm9Zm9b
	VwShcGIQPCtbCSGP50bdkF3pTpmYHEqzCnUg2itpFkasJKLa/CtkNJTHpOgDZAZN
	tw+CjBRw8LhxIuXlmbAyA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794217228; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:JH8XVzQqWOQgspjK7EdoNcVX+KzWBP39gFr2/OyMJzbHUh5
	Ajk4E9DMRcODhJw9yAFuwIVmpOsGj6hoKQledxkUo8xYB5jAg8fWpQ9Vl61HdaDz
	IPOh/mb6aLbHqMQ+yeESzfs6mph0umLHxPyVHwrq6gkmcp+pAmcmY8VdxaTxwJFI
	fdJ8IQ4V3o9cAmwUelPICvxY8epJURDkqStSm+csc1z5yPgo0z1KPMTTFB6bm4/y
	VObNOOXsi31GIDiukBflHsdgIxEEGP0cgO/CEL3mihhr0akzEtYIbA8LJOVE/GnT
	3D0rn31DCyWv9mELlYTMMlY6HQ44/sOaP/SB9oQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:OkVipFi8E5Ktm3ZpzNFnloonNXGKEh6OFTuzi/kZ0Kg=:wE6zOE7uqD6R1gTlzonajC+ElazdVPqc2XU5HRSr1yU=;
X-ME-Sender: <xms:C5XxalG7F-rjqszrMUWX5X-yrrdjHARMi6WZv2-2kWOkBs3SW_bjbQ>
    <xme:C5XxamPWFMfjEw6KNaejHhRudQhgk2xs_pp7_oPUTk_gbwMrKzDB3q8wdGzPz28Ae
    dy08nkRQtYUEcB0g3sWEFuN5itcNggE1HOdJJp3ktJEMoW4JDGL3bPO>
X-ME-Received: <xmr:C5Xxaioh1AJYyIvPDkkrnrqsyT0X5Jc4HFR4wTzJlSJYXACRe_eFC1qplz0OTcU-C2PPl2rib8JPSCdBiYv_OhF5WK0zWOCR>
X-ME-Proxy-Cause: dmFkZTGnZe2GvT2gfoWgG13EbEStaj7gxjVBeZBtfrNL6VkTuhZRkS+iuGyiDI62SMPXNp
    PAJZG3ILMH8OgGo8/Dx2YdZpuDquzAXeJmI3UUdX+Hy4WfoNJn22rfiYUVz82IfAm5eJY9
    mnMQ0Khip1Utgst2oUCdm6QUYrziKT+2+50jE2VVh+Xh9ZmDNp/nMNiLtWuCsNCH4k4RNH
    BALW6y+HVaUBKSn/EUc++uFeYRDN5JttqYXiYzXUFa7JD32poKR9SjbtGDx68Ru/96SewQ
    wKSEE2OqRViMrl6yPdMBzBLMPGLERTvvD8xm2I+V6zWejyQZIB7B4M1vQLv+4X+WQ7TRgA
    mJfIgHuY7C8Uxqmtl0di+DDsfNt4Ducbxtfiq153F9kQH4V00Trq6cvVb7JViiJ1wpqK2s
    r1zqfx/DiKLfqvVbC3QskYOiBOzGveQU/SIAb9UiX5JjVRkf8Hi7Y+1ptSlJsBX2UY7gQS
    j9RALDxmKEFwmG9H79TNW5TY4MZ23cmOHzDxLVB5Iwdlq8lTLCCE9gob+UzvwVp75mAcSy
    f/TowSZymCTJjzL1oW/pHn4gjrNXIcGDRARNPlgEjif8ez6RgDCNeyho4CSlo/S4OUGiqh
    M56+tztioXA9I7rKs4Z2mgdWzb5d0bMpsdXWhuR62JEkc3HveOS+yCIiqcXg
X-ME-Proxy: <xmx:C5XxavDESBzMKjbqEswYQv9XqgH6wCJxClmGq9HZG4sxTVUBgexXFQ>
    <xmx:C5XxajMzl5TmuVHuJ66Px4mRYSj5_Yvyc5E8nTB6DmxV2gMPxXBYqQ>
    <xmx:C5XxalA1wEnFEhMdErtkiRMrEcQMrbzC--yZIK_ru26r6ejpoaM3bw>
    <xmx:C5Xxap-0Rqbqqx6Po4i-iHBZ8gmaNW0RrSzNJIey2lLL2Zc0esEl5w>
    <xmx:DJXxalbrcx4H1yud408iSG1gxqkgxH9wRqQtIS0hqW7bBEaTc6cTBgmh>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Nov 2026 04:40:25 -0500 (EST)
Message-ID: <d4dd6e3d-2f99-4912-be9d-aaf8a80e68ae@pobox.com>
Date: Mon, 9 Nov 2026 01:40:24 -0800
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
Subject: Re: [PATCH 6.18 000/869] 6.18.63-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261107134852.069646174@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/26 5:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.63 release.
> There are 869 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.63-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I took 6.18.62 and applied the stable-queue as of commit
85f15de479e79a3a7515d926437bde0a0f16306a ("Fixes for all trees").
This drops the build-breaking XFS patch and is the current
stable-queue as of this writing.

Tested on my Lenovo ThinkPad T14 Gen 1 and an arm64 virtual machine.
Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
