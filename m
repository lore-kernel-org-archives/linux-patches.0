Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EE8359A70
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302394; cv=none; b=pu5KbOXoSkRMaBPFmRnFYjuRm6JQT2oWGYiMyMColptNAaKYrCdZuWdF7ycs2kdN/r8ssN0JLVqs/PIayhiBGX81NNNsNmPUrueiYwnh28RHZQkprpW1oN1OXpLo3HTuBfHRZW1aSod8AY9/G7N9Stv/5fgkx17R3pFam+45MNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302394; c=relaxed/simple;
	bh=3GgB+gs45LBEf3dGewRLcICT7q47jgtonicntnTw8uw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RSMmOsE/Fb3nToaE7JU3MTcxPoLWdUZSbCyXoJekVa70E3KgvIFF2/NOJ2y2Kc9tsiHg+hmFwR0aBwoX03l8nRfy2ThjWshHesleyVAum9ptS0rgOWDSZcHAFl0yXOrivJzgnI/ysGS+T/6yqWaWWIcLQbcpJkDpfyygsWACRmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=O7iDXdO8; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="O7iDXdO8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1772302380; x=1772907180; i=rwarsow@gmx.de;
	bh=UTLeHg7r+2CFWjP6BhDbuinUwW/QDWJLRM7o8udHdxk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=O7iDXdO8cSRhXIpMm4E2GZcIO1O7iOgcqOF69Kr15RbvICf2K0BjyWydmHf/ypce
	 KdvIsyXI8pYoF6l1AOC3NRMkRgnW1vEqO1QuMqgDIxHebnRKWurUq/URPz/CY5u/P
	 1r0eqkhWwqE6QFQ4djSaRMMAZQhQpIGag4ERdSkNmuGpy8YGFpCmBDbEzbmVtt3oW
	 dRUg0IbFc/JpJdPgdbqrgSGM/TJZ2aeGJJQAmRAa11RulxQ67aHWneytiBEmLBi1F
	 jNPIvYTIDI5XhVhdCVaYq6wNQr6FzRyU22C3DQKujuoX9CpVu5bvaIFeIlrjMmQPn
	 Vu8DZlBgCzARQO7M0w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N6KYl-1vcUTN20fR-00wLGZ; Sat, 28
 Feb 2026 19:13:00 +0100
Message-ID: <601576c7-970a-4e9d-af5e-c818740be8e8@gmx.de>
Date: Sat, 28 Feb 2026 19:12:58 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260228173244.1509663-1-sashal@kernel.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260228173244.1509663-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:w+kwudU/jgDKwLTQyxYncJKHRXT9H/jIWc6+Fkx8I1o/kXz/7XN
 yS4T7p3lwFHus0WrnmFBFg46s1ybNdGB9o+UykgRcwFhMAMUlgiwfu1hYywR6qtNGKeuLRP
 IEDTXMZBxtyYL3ccLnPwOgagR5sOXDhkYMSMfutRFjINNKpsIEy0Xb26EJXOL6VeYAu8qnx
 QzsHRsfZXQSVuSYkMQC/w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:KyzC7M9Waf8=;cmKLYmjF9kfFB+BdVyuxJTT97oW
 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
 f41GE80qRH6P5Ea1iS/iB1q4qU=

On 28.02.26 18:18, Sasha Levin wrote:
>=20
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 844 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Mon Mar  2 05:32:25 PM UTC 2026.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git/patch/?id=3Dlinux-6.19.y&id2=3Dv6.19.5
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-6.19.y
> and the diffstat can be found below.
>=20

It would be nice to have a download link to an patch-*.gz what Greg=20
usually provides.

ron
