Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADDD3815D5
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 14:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773844286; cv=none; b=aiHfkBd/TTe6AwJlUWJOSl7MbGUe84a/q2KsoBdr9Ip3lIIrgTfoSbyRR1AvVablUrPDhE9tjfD2P08afGUXUG3a8nzKMXcv2N0LI1SD0Qk7qfSJXca30YPM8ZDNA147J1X244wRVJRVca6kKGdD3DH74b2e33j4A3gnntWOI88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773844286; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QXDcdz4X0uxfm7NrykQbnsuTIMVckLFYz0V8C4tbsi+gkQkk+QnFfFXpZLV40CiVBdUJ28zmmBDk/Xdm1nmS7Cmdyw6tB+4qHZTfMBDS8Iz5ktaoMr4kspoBRE0bCps0X9rqyKbXEVHjS+0PORP/7Y1eAZ4gv9mbFUSMAtFbA3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=kCHPGqhd; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="kCHPGqhd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1773844249; x=1774449049; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=kCHPGqhd4FSIP3WIL85FEptLz6osZ5hzDWVPQj1C9r3Cn4hnzBt8F5rl2/VCleRL
	 NT8sJIOsJJZ/4EP1GTa6WUeIieSkkiv4cWBUF7zGxZeofDkJCJpBtbdvln3tithL4
	 PV9qxXSvl8cOVkdX2BXMp6PE2r0251oetuiJWaUp9tV1P3jqMEQoUpjOyM24aKtfd
	 +Hd7ekCF3uKE8QAE3SSgc6MtKs8UTK5WGp/B1qEofMsUx6iaPzkpji69SfEHD2Vcr
	 F30DeNtCMAYRtZwaup3wCN7yRdZvTUyJnjKQFcf7khjeybOonO+pQm8BcEKhIRtcB
	 NKvH11IddRL+mmGLjQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mof57-1vEMka0RDd-00blV2; Wed, 18
 Mar 2026 15:30:49 +0100
Message-ID: <e3e255d1-f2b1-4cef-a7c1-a1831740ba47@gmx.de>
Date: Wed, 18 Mar 2026 15:30:47 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/379] 6.19.9-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260318122547.233850204@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260318122547.233850204@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:zNsbj9ZPFtjBw7yeosfYJH6NB/IrxiFjRtAYnVW74CU+Aab8kTL
 4dgZ3aeWkGJzDuOQdzTxgsaE1w3rQZpS+2l0E98QDio3sVRJflz7qJJKONqc4hwNkAYw9zp
 /k/w7iI9CiVrfDdVhuvMbRmuaGmhdkDYG4+C5nntAYMjRFyR3o/CvRhotxYzMSwpuUGKK1F
 vYyt1MgiyEw7I+K8Of7DA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:wmQ3C6X69eE=;61/01cdY3ARsZVFmmmv8b1taL+P
 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

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
