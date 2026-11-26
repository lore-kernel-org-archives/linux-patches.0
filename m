Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795694602;
	b=jiiBjnzLW1YG7enZFBUYDmdm4lz+dCG+Z+9bhJfxjhyX/0nmTlLyg54lW4IrotDwAFum
	 GUPQ8sQ+BRMVJ8zhhBtnWPqwcbCc4Wdx1fwxblTDL3R7FsAzbdo4u2KxArguyIV0HWXho
	 0e+rWxbWqAZsZ318f3QlVAAWArs8MVx8rVDU5YNiZlyvmgB+hIP9kZirYfwE2rpg2oFxm
	 u/yS8XfXipPEcSAEh5d2TS6KvR9v5bNY/Z61qdtawH8DRmG0MP0ZJb3OIPQCyrvYD3kIU
	 2QJ/xAqif1AIncuRZbX2HxKpyHtbnnqb55RMTFYPPCCuPgQprh1Ek/aZ9xQsquKr9Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795694602;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=1uXlAv81smkuUGJnHF02JcKUsVrSpmh7HDz4gNJ8hNE=;
	b=ASHgaPp597hCmqSegqxTxMgbdXfkjFJMP8v8Sib9H3AnX+MoV+UbQATdXEhPzcG2sEqY
	 uWXPsrZAN4Kfk4sfjqTw0vCz2hv0TrCgec+O7RVMDZ42zuRsDu1D021wdapAm64GCgggM
	 GtaTIvoEhAnQhf9d1hRVSReFurl+vpBLKon7YyOxaaRP6EJLAYrMXm54o1e7hldkqIA4f
	 G3hxsSqzb+fHIn9Sp3Nw9VMvTbkzr/p4/kWdLQs3xuRst9S68edP50uOyTmI3hga//jVJ
	 k4rR3rDZd0RgFT4TCMFJbBzGEjdRCEJuP6lbiEy2L6vuEBLqne0GgHw4lYa4SDwxNsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.de;
	spf=pass smtp.mailfrom=gmx.de;
	dkim=pass header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=MZQg8lnY;
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05300606A321
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 12:03:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05300606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=MZQg8lnY
DKIM2-Signature:  i=1; m=1; t=1795694599;
 mf=PHJ3YXJzb3dAZ214LmRlPg==;
 rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
 d=gmx.de;
 s=s31663417:rsa-sha256:DQISxuMCRKU+bg6pshKmQbULZElS
   5PVNIFnc6tDJvkBmUmruAkH55B/ldhgU8Ooe3i3YuWt/HEmnF45pn7npDgPY/JN28x16SVM2g1h
   9z3PW2bj7MHnfFJWz9s73RLLi+6GhoTgHQNdG5EHQa60RD6QwdXuebOrSgZe88yrDZ6ogMowDtJ
   UyhWCxd2x0P4UqoSdT+zeldQPFxox/5/FyjUndBVMt8UVKggQEm/chmGfz4NO3z9RkePlcG51o3
   5UCxzuQmi/y5HjPxjgtXFOzVqKCd+nTv2vj5fn3X0l8sHpgnstd/M0eJdWNi8AmywXxnhat6uSD
   NUuPGYtZx7sljw==;
Message-Instance:  m=1;
 h=sha256:
   j4FvFeEIt8askXEg0WHkffyCxpfoLsrOMCEpA5jCAv8=:
   1uXlAv81smkuUGJnHF02JcKUsVrSpmh7HDz4gNJ8hNE=,
  sha512:
   RXFwghCRVlcW6JozIKt4EA43EppxxJMAo0iGytWZl/xuRWgU02sbZ1boeFpY/QcwzCP0flMNtASn9r7c6mXlqA==:
   KXmPVppYD/XQ6rXAh5l84SjhG06jRU9t4HkKr0mo9a3NaOKNY6/F3WQv8H+Y9LNNMn+bDYLOVmtfLpu53N/yGA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1795694598; x=1796299398; i=rwarsow@gmx.de;
	bh=1uXlAv81smkuUGJnHF02JcKUsVrSpmh7HDz4gNJ8hNE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=MZQg8lnYoev38AnJjTD6Tc6nqX5VZTSsKvr4N1bq+A+uEL/GPNRq8mHxGj9U3UD8
	 TQRzKlkVJlpyYGIb+mUSgww3HmoHIiCqkFcaiEABTOyK7jAsfTj+WFoXZE3VxPIBS
	 s5egpTJRI++c6U8TQikn+tOUMabm38UQq7kHkbgvhisHytvnqQRrJSiOhyfMHhwAf
	 M6dJ5zVlI5ciTinrwJbKrb1b4KxKux+LaHiOsYnQ9yUtRREaQ2t0SR5WnpyCCCTg8
	 Vvayre5g9hkIo/szp/yLqKiAVp1i1+xVqoUFPoyaWEcnN1e13pCXfJKEGFm+1QoCb
	 OcnNPnh5RmBEStWB5Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MGhyc-1xkHie2ZRi-004wf6; Thu, 26
 Nov 2026 13:03:18 +0100
Message-ID: <683540be-96b0-4263-b1d9-180b25627463@gmx.de>
Date: Thu, 26 Nov 2026 13:03:16 +0100
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
Subject: Re: [PATCH 7.3 0000/1005] 7.3.7-rc1 review
To: Jiri Slaby <jirislaby@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261125143821.729802100@linuxfoundation.org>
 <1ba253a4-fdef-4169-9e9b-cdb6652e47c6@gmx.de>
 <87bca99f-82b5-461d-bd3b-23f217b895d1@kernel.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <87bca99f-82b5-461d-bd3b-23f217b895d1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:f3KGxG2aNoMhC8v3hkv24YRkZkVBN3XPD12WlNj+v7l9YnmCXiv
 9Cm9kXwqUGOtMjsdA4fT0Y5o+/BUcmDMstN9tM7hsRkMpO1qleZSonVwIeLsxflLyB2ermp
 r0ViElhrGsLYPTT8GK+00bHUed2SFxo6kY4+REB3oYkqAPeNALdU3WzXT3lLcK5Rq8dQXAp
 19lb5Hd8Rjj20aQdcbgFA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:j079YgMIkjY=;sjyr6U172R1TcFTdNMZIgmKNSNX
 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

On 26.11.26 07:34, Jiri Slaby wrote:
> On 25. 11. 26, 19:12, Ronald Warsow wrote:
>> Hallo
> Gruss gott,
>=20
>> RC doesn't compile here and currently couldn't figure what's up.
>>
>> Question as an git greenhorn:
>> Is it able to bisect a kernel which initial doesn't compile ?
>=20
> Sure.
>=20
>> if YES: what is the bisect start then ?
>=20
> The previous stable release (v7.3.6 in this case).
>=20
Thanks

Ronald
