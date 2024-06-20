Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35F81B4C57;
	Thu, 20 Jun 2024 17:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718904759; cv=none; b=uqXAt2N28lyUOboZlMBxWsR2JTNnNKUw+YtnXCPJNApQ+x2kdYuV2+1mIuC7wU1eTer4H8xBm19K9APS1jLfm1zCuySVcS9V20qAKqHN3NY/Jgw9FsbVEOJZoH2tAIXd73Rbwpx5IE6sHP9SyZNY7qpuR11BrpQRJMZQeP3nHAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718904759; c=relaxed/simple;
	bh=Ts+o4DLTXehjZyeHtMv6S5vqB21Rs0oTAypOtLp54rU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Khe3cXGUdErFiM1S0TTgwy1KfJwd6A7IXdjTPye55SbE+ZjTzNZfX+THhjLy7LD8tDXt0vI1K+JEgTVaKLB7TO8BtKxvLbSLNzb8bF0QK/zWnE17mkh1TSS1CG1X1lunT6SS73z3zQ1uUyfs+jvwxEuF1xlI089lthwAatXy8lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=svenjoac@gmx.de header.b=gbnJn78c; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=svenjoac@gmx.de header.b="gbnJn78c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1718904729; x=1719509529; i=svenjoac@gmx.de;
	bh=+a/gBdVUBp3b37TjJVSy0kNY3Cl6AVJmqidg8Y53dB4=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:In-Reply-To:References:Date:
	 Message-ID:MIME-Version:Content-Type:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=gbnJn78cSkCXp8vtbWZG0QE9i6MlkuVPiA8GOL57+0+jTP83+E7JIFdLmWnSvatF
	 QXavR+X9K25IDZDjosJgPGvw3und67imfCb0jTe6n/FeJaKlHnbxfvhM1vmNGr1Vr
	 G4GObPQqo6iJa0+IQotGctofZYcFBqMfIe3Zy/eSq4Yx0Yi7e26iQdME8/nA6hFmg
	 7M+YkKlsuj/POrCka5SrdJk+8esLkC8MoIQV4bt1OPmoA4OVKww1yjOItsQcc1wcR
	 AlgILYeUrjAsuKOfCNLJHshjSbsjK2VoTnsPfjTkfL5IEty2bX4jhcRVai3JDMC1z
	 rsz80sZQJ1ND4WpPXQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost.localdomain ([79.203.67.129]) by mail.gmx.net
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MXXyP-1rrOGU1fOJ-00XS1t; Thu, 20 Jun 2024 19:32:09 +0200
Received: by localhost.localdomain (Postfix, from userid 1000)
	id 758908009A; Thu, 20 Jun 2024 19:32:07 +0200 (CEST)
From: Sven Joachim <svenjoac@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,  patches@lists.linux.dev,
  linux-kernel@vger.kernel.org,  torvalds@linux-foundation.org,
  akpm@linux-foundation.org,  linux@roeck-us.net,  shuah@kernel.org,
  patches@kernelci.org,  lkft-triage@lists.linaro.org,  pavel@denx.de,
  jonathanh@nvidia.com,  f.fainelli@gmail.com,  sudipm.mukherjee@gmail.com,
  srw@sladewatkins.net,  rwarsow@gmx.de,  conor@kernel.org,
  allen.lkml@gmail.com,  broonie@kernel.org
Subject: Re: [PATCH 6.1 000/217] 6.1.95-rc1 review
In-Reply-To: <20240619125556.491243678@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Wed, 19 Jun 2024 14:54:03 +0200")
References: <20240619125556.491243678@linuxfoundation.org>
Date: Thu, 20 Jun 2024 19:32:07 +0200
Message-ID: <874j9n1pwo.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:i+b2EJiqseAXzgK5UePzEeGyPoIp8OIxqKVASacOhRqeE11/NGA
 Rk3U0jvuSR76ewmbxJHQYFzZc43fu12JhT4p+iVjRGxWzLdHKSWqeEHZzYnzXdLAnJUVAqR
 j0B9RCrpk0OEMfG4/O7NkhR11jryrasI0g9/jqRSz4mOIizZsm5KpceIsz7XRiCLDlkcu2X
 K18RAs4T6DL6LhEwf91GA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:sDEeG2sWfDg=;lfcIxVmUkhuGU7E1+qtpD+qzUL/
 M9R0KldLs1E4SsFWExATp33gQq03wnUH0HTiDjIPGfSUxDEtOfR3bPMRvKVtAjPmsxVrlq+P8
 td/WUn/g7tJ1UfiGgLOrq3lJdfXfncR+SfKTI79BwL/uMEr8AOCjyWFmcWxVoVQ/bKbdVFlfe
 mbUiUyDZ5KpuBVTvz9izK7W9sMl52biFlLdq+IOo9k4vwIaDpn4fSGqgdTxMlPrCR0Afdfs/o
 mlVx1hMwRp/Hhrk1hLa9wJbA1EsbYozd4Ds4o+ahon3ZLOIGk4A4hDYzLBNJ2xiB265X0aUqK
 miN7ONY/dNjIf3xe4YzLDwiTKVgkwrQyg0Ejc3BVqJWEkfQU+KCW7d+WGmowKAHdY/sx6fsj9
 /Iu+5092mxASIfumMd0fjUnKdYwfyTTLT79K1zyxaTxWvu1p23OEw9+zmyFM2qaug33Ul2Xa3
 e4yeJ76TcF7+nR1uVnbrn317i7xOGLmBgyv1/QKGDNFlitiQ+TYZj704EHmo7J98+4i06Xsvc
 N5YCR7yQeTFrDn+YAM4Ek0rroK99Wgy+vtEjy95iVLvlNWZS1lihQeRxnILfZnygV70hVZ7ms
 Ed5LsdKcdO5vdsQ9tZXZIQH6vs9cZM+3qwiIIFYLx63PjNRatIxpvfjYfppzhDsKSJyS/Av1G
 942MQPfnT01NKwj+jRJeqgOcmVbLTtsyju271OJGHJuy5McANlucACLtcxusgeY/CeYqZS1NE
 Bae15jcJyA9CxKtgn12mzagJaKDS8POvNbKV66WLYquUYWbfzwWkEkztL5e1v0L3A94vbnSbY
 PiFSE4ly2JnTcqCZuqunlmhOAYnN8pmT14UZdhIqC9zNc=

On 2024-06-19 14:54 +0200, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 6.1.95 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.

Works fine for me on x86_64.

Tested-by: Sven Joachim <svenjoac@gmx.de>

Cheers,
       Sven
