Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C8C33CEAA
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 08:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765960097; cv=none; b=Woselg/VghK747lWHI1Xmyr9ZHdheT5QIdxIE2TGbUwV+ct/rlzRtuJf9ZpSA8T1EJe2xthNxDIHZVOoYTiaxj6LLtQwVqI/PxB7Q9K1SBvnyDIWZaM92xPC9yuox4WMKVqneMt7G9dkseqfmoLmHk28axYC71T31x/X7JIesNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765960097; c=relaxed/simple;
	bh=51+W4VLxgsGLOJJ6gjbxsSFBigsutjzPnXbLcilUWgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JWIw5P/IV0kXcb6VJcOUZioYcE0rBZeynUmEcAGtpVo9W5olEtyyF8HMfOCfiOK0tiOIjL/101dTaCIZqo9A9vB+7eLpD/hYSsE6a+IbxERl9PoisC8q2jy53KMwM4FjmvLWpGwzvMBvtx3bXgjRpY53qsUYOpHMy36fAH2/YT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=BFD43ixV; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="BFD43ixV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1765960071; x=1766564871; i=rwarsow@gmx.de;
	bh=vMeI6jGcam/K/QFdChggliL6yESzOIEWuYF5/U5iEFU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=BFD43ixVBeyJEC9jIhxI/HM0JlFH3ZzaeLC21qMOIlT62dmgutrg4y1Kqowoncy5
	 0csfl4LAwpY2gaFTfKXrhpgTFGyvB+tx021T1hAAT/FShlL9/HxKv9hjrywRt9lUV
	 zwng6RuvbBq9T7KG7OAZPDaqtBjyzd9HX3twsm4TLhQ6D6zrkIxVBO6BuAqsAhsMk
	 vmTFu25+6Dl2uqZjckeRjwDo0KpvJsHs8RZXziCvGpTV3PNV2yR114e6LmRAl+Ib2
	 2KZUHiggKyJlo/QpMxWXCwdujR92dd2iB0151bIynmnrC9yOSIxKc0SMcVBU7g1qP
	 juBp62UcshAZg75D5Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.243]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MFbVu-1vliXJ1A0U-006ucq; Wed, 17
 Dec 2025 09:27:51 +0100
Message-ID: <b72d4821-d3e6-4b29-96c8-6acb1fc916a8@gmx.de>
Date: Wed, 17 Dec 2025 09:27:49 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251216111401.280873349@linuxfoundation.org>
 <1056aea9-1977-440e-9ad3-8a0b8b746288@gmx.de>
 <2025121714-gory-cornhusk-eb87@gregkh>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <2025121714-gory-cornhusk-eb87@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Lnro63ojjW5JfPCzopeBemHTdgSdKuxVQu4VVvgdha8LGzjazUo
 uyFj9CmB8fKwGL9BXtzMzzrCO58N+DZlbcwXT68Ba+GxApLJLaQxE1Ukr6XgoBhVUdwbJDX
 hz3bdGdY++hNfZsJRNVf0RvvCaVcX0SQOAZdplwUgARFewqX9kLnkARvUcE3qHgmCTJZ9Fr
 41ZKp6MwdfaKZrR2Y9+rA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dViFdeJgfYU=;eOJp9tcY5Gp6nE+yeeuDn8PgpIc
 qDiJY3cXAYx3gPJnZ81CqpbdCIPS1d/anFrWwW6qLs4vOFTNQYWfT/QLMY8c7SLf+cME0hiwd
 oP036o+/15NwqPJ2RUDfNQSFgpgZvRfOaIckdpyKt9bJnByZQbAoxV7BAeQsOUabT2z8YOlUF
 D84BxXn8dKQK2PJGBwtqipN2ZzK5T84JlHHCEteBqyLhTp0igu+OkvBRCepkZWuk8T51FhIGZ
 xAQq+SFTLL1L3XynI0zebcIhuK8m/FdIrYXHejPAjBSDeosi744icCg03jMIISkYxAtKxK90X
 UX8ltrkitcBnTY1iOKuJ0hHFYuyTFYDTidyF9x5Svq/IUjn42YLC5kgcKX6IVaiO57ky5CM5n
 iRsK92P6tkcPyisy+9nKEj5/xPzD75tSsLRqx28qeDwT/TVJL6dtjXy6DCNt1kf2fe3TFP66P
 tlUFv5Js3hUFSdJ8l9kyOvNXiSgN71b1WNRg2BzFLoiqx7Mq+r6NgAvLb0XGoEsCNTlMrgOIJ
 pvSeV1DU/qmmSesAJuWuDRRXx5IwGemmUeVaaEBPX9fejpBzUzzJv3NJzUhgnFbdOefrSR3Ut
 IrHUYaarCGl/Xwyi06KHhdBXHJv22Sx8Y94z6TWIxkov8AtCkFk73I3TXw1VN/8LdhcySJXgL
 W3ezh3LuuOtM9aFBdpLoZxXXncFwoae9YmO/4W9xWtLXBEPkA9tJe1kcHoyysy09N5XyPOwSe
 8yH2D6Us8XCq2T6RH6/C45c0/mf0cYkCr7C0o5xl31hCEXKQ8oCvXWzjwDrKxTs8cRs4DUwhx
 Oe/Xi6Gy6hlo/CDHeQk2Pm/c9Od6DeE9Sfestx0bWnansYScVjgPK/GHxvF56hKuFuBshkxL8
 ACsVCBq2EhzziUBfMM+9lenSYx7bx4udiRJzw6m7RKR2f0JZFM26qsaMM3Nr8TlrjsDJgthEW
 +37ieeAJMQklnXnEwbINNHBYepCrgbiTk54crr1gdejE+gDktI/Z5FYeQe62NpEegOHNU097d
 qeVODdk7pakPBD8w0w17EXsrK6pykVy7cKiq/+gT1SKT+f6lwvfZy90UV2mDRVhgu0kL5l79l
 rtQPOV6eNBqPCqNbZ+gjpiiWo1CqbnxNl+enCZ73hf7nl5/yVfmHq1g8pGpjILy7Kp/ogYcL9
 sLHDWJ9Y98aJtrtPgM4B9Jj1SZKo/LKjY4IHkxL7X8jQPeUKBGseY313Ngzyxp6hsq5eFA+sQ
 Wee/jFZKuDPZoT3YoN5g7ofq88YEqIOH5AWVL4q8SD4yS6QL0xZlkEqv4QC8p91FkVvrmu4KZ
 FGWpiuyuNPVLW4FG/DPU6gwa4rpY3sgsdDToWEhvw0WLVWICZw86VlJ6JTxCTACCFA/CTmbhX
 4lUk2YmlcSguPDJIHf5W5GbKbW+9/ZIdAb8gTPo1fql4rROS3Gq7OosM44YtxAL3xuu7kCrLU
 NixWbCYhNks8PPI5Hr8CYXNoLijM79f5eJGAYlr5cyVRedDfJfaibNtyCKqKf4Ea4PaUAbfKL
 8HDFjl108pnS719rHsXFL+ldawnL6iSBV0e6PTwFUOyM/Ya/lprZ5HOzOo6LvDhbYL1PXz091
 mtSxUnrzAQKUSMNxvSyDTjtT/z1L+bFouX86iG4y2qysZAZ5V9K9PFf54HwU9nBr8d1HudY2i
 bYqgOwtqOxPmQTP4a/Q4msAorO+hA/3Y9uSHnWVsifPo1dZ8z6KhC+t4pATXrUQe3PZp9W9/U
 22Xg4I8kYmCuFwLN2VjQUcWirqOCeHa6O0AroM6pYj14CwhO0qUlia/oiUnXODiT8IC4c0LJs
 MhIj9NRavjT1oDHO8xk5/0aVOD24+AI2Cgk2k8LcD+H44tsV7Plc8w0qSY8Nfv6OojovdFE7+
 1cJeg0Q994T7re3tmJ6FNRD6FcToRVRhn2VqkGtNCu9YL+HRewn1fWI9tTDP8yB6Q+4K/dHAd
 ggjKZkyRm7P3sj7nWW1dy83539bmTgr0VTbZ9biG2ZWQtTWIQ9YhAYyzh5OAYCFn1f4yVtKui
 Nj1Mfs5VLX88rLEoi75VvhTnnGPt+CVkFQBIiXkbqZqMzMouLSWcfwSGLNdvdY6XEoW/v3Sdo
 JF5Ye7FE+YgAbEralLTSUG6PdW59QmCqadHdrgCMZVeptjEJ29BETEPfnc6DKt/1JfmmYNqrI
 Hm0hdo5DEb40POGvq7+stq7XMJrTsRbewFNZ8IhGRvz3UvD2GvsCeasdDb6nMsFJgv2H8ubtR
 2aRly+1O6sKF+IFA2C+7lBrt83T2e92dMM13LkV40x2I8gXwG79fgk5DBVMNF6GOsVCojd4Dk
 G2BQTthQL0MpBSczAm4U9xN1tjo3s8931G8iiqDiBTnlapzm6ozLlQbOx09k/Bj1QEFM7WOpK
 3QOvJ3kTYY0JxdPZMmQnShVhKJ4uD9V8knCakGzk2mVexlRjXCMrY1qUD8b0/rN8b2imAIQ47
 i2WlzPknXgDubMS/RN1aUM5KAgf8Ebg825bZeBaQjDEcV5NjftWgxAfVa0RI2q1psDXOImuP+
 FZhBiTkM924z0X1wy1Isz5E89otSmcGzyALC8A523n4aZ4Q1sUVmqrR2azRHVSA9ZL3wl9/Td
 2RYgmNIk2PN3EIVlN/liOSYbvhcgOaNjHCmH97Qj+ypHhD1D2JGaL/I8EVErsU/bUF1qSKGI6
 FIJpneSG2/NXqaWImt6VznZ6v81QdNtAqKrizAeW5Z9JfESYmBnXPD4BbLl+0yGJVN6ky9vW4
 J0Duo0nYk4SSTA5zs8zuFrIRtnlKXyKrqxKALoZBDXKQpREUNiwPNGP+MwbNy7WBOeIR0dp4p
 IY1T3Ws34L4n6l1Z3q0vj++qf+jGiPOeokH+Ztxvkn1vubLRY2lJfg/GViXn5RsPK3zJ24pu/
 eEz7v7IkdvfoHJPyJD5bIJ3g+PZhJVyKUKxjBR1T6BC8Z+RDxgzDEy2BmA3zRTgRPkmQM18tw
 JOwB7jvAdu4Ca32gCf/BwO/eogVTV7ECe4qyeM0vkHFPMXgVNGZr7PJzDUpIMBezsZ/qfT1dQ
 r+xAoYCvBVFlC5gmMRTm5kUYld5HD6FHt0DfKaFsFh2AzaJ9M7ARz+X8PzWgi219y586KOnxe
 M7AwK2cO/WxZsJ2D58sE9EBWuQ12fj4Iq5zOHGQRlmsqDRO/QJ+4MnZ69VzIi1MU+L0eW4siI
 l+gS2nFLwERaWczEkK/1jTGWnNgUUUCoV6MnTd1WwG3PBVXgOzXu/lEXd/r1cg8JYrhRb5f2h
 LKV+DmAh4oSqDlt8nKCG5mr2UUVlXhH9CAuWM8jJ9TKlAIS7JafegiUL0YfY5CRLf06AcjlsO
 2rHiLCjVd8DU+EdTkLX0wkqGjmUDZMDVbPccimbvizEGvbrYJhWaKr8yQHbjzVRBxCG6bdnCy
 YpXEpGF7SfoD6gU7WCHIL0FGj70Ul/YAKCQMESJ3Zk0CFVyH5cqwnmfPzDA5gV+bFqSktSF3p
 nnsA8mKpPlvuwPR3eiFnfvse8/qpTLfVnoBMK3PaMVKaQ2mMOy9f2OIXJXdt57O5ZhC5NXb+7
 TNS/deLhyuWcN4DfG2gFJ5CB8pGf4epfKwoaV7RdJu5RXRlBF5Kz0qzy7S53nppvkDdqWfI+d
 hBFM0ROZ+MxVO2f5vzMAlbiKRRSWfbXs+aEkRvTQnRn04brQnE9OEVFCsOpMABDsn2SyltNBH
 A/yaGQiTh/2WAFiZdS9tZVstkLpeRK2GhhqV+qSQgXHnsdFwcnPSKodA8gXkRFhAcMR3NH7+L
 sR7p4iAJxVCO6/x5y3nF9Gs4lOwjE0ACt/MM/KHMK95yPe5CCNGopd0t0VrdVRiak95D2UNMB
 ZhUglpS9+IkvrwBCPsf/YS1UsZZifQqunMVOAFnuoSDAOZXntbz/ov07b9pSLokg7/XLaGiyK
 6+e15QWHR5kgd/vRNTgWga+a7mnqolIKH/aM+EAsq7eaxcFSrY1JaGZdoGbW2uERDiLatEksE
 DJaKLFBgvZ5uzN3KUTmaNC+P56e/gqFLTBwSMbrrSB548aOHKKq9pfwUc1RsaophBuUnGO/Xy
 8CHJjBj8cgzZVPZdrI2SdXXT+KzN21OlDRtwMDSYFtDBErXB/sI4jpedq8YpWHmXYuid3ETU3
 EBsMbGb5J9BkOCgjUrd+fCmD1y7IqndyQuXPqYqlXfr6DcoY0fs5kcCOt+nJQ9YNa3NkPfHol
 5LB9wjM62ih6gvAxV+eOb+lBPulP/unzs7Vg142m5NGHnb+fRj3rXauLdoVjCxAFMXG3GHtnM
 LoCXV6L4YJta/EPtQpm76W1LkP7CDv9Ux+Ulj3P9qgwt7lLU2iJw42OMQ8jUJg6qRM4oLxynh
 c5hWRZ1vSwiCjXbLZVp479wENF5TF2PqpzD6QeQ1NitpPsGaCsYcYXJJEJ8ite9xNJtrxAMT6
 qcDM0L0Z+qXxdcP0GNIaVkqweVSZ+NSr8AJ1PCVygs3tyOqT8zeE+NxyCJM5GpQBHieoDDOrF
 vrFnHt6W9A5dlkUYIfj0nrU3Qoh8ZGWb9X74LThd70Meu4hp778eRb3EFAryfJd0JGG1OYHXY
 +SjN3LoRdm+u5J5XW7BEURtys6Ziq73GgZf3vj5EjF67/6juYgKhQRPrwbY3L/NMZ3NPyV8Ac
 QNy+omZTC2d2cyYP3NnQ2/wrGQ7j9xwCEkUiJMhewAdY6hkLZe9LzhM0nJXYGcOXf8l7JhhO2
 XIPYO1O+nMmQ83E7npcuxQIrgiQyO0x1FIzkbErmrRjHgYqFYxrDR+XzWo5ECG5Dsd8WsJm0I
 JHcFYWJGH+iAILGAL3yhmFwjZi//yqAiBZ4guCyh87NSmgSJ6EfeyZhH3rZU3u9OlyvZ1FU7Q
 7fJe/jbNOIWzxhplUYVXFIWf5ZwqGk5JS/XkMMuAHUmOrNv7doZFoGUHB/mfYjLU6qyYXEOv3
 hL9blp+32IJ+Fb3F94Vj5BK91U3fA84JEUinVnZLbwdwda/Kx35UbR14r3NXg/Bc4uFkm9c6U
 JwBiUZfcc67v9Eth6JRM0o6N1AzvlxjAevsXMY2CfibU0kvQv7Q22Hdlzp1k9nLR14C++mbLU
 f81HWpSEz6OSuru1puEXalwCXciezsBWYsQbUHVoxL3BxoNb7kQmaiminptiYJ9uh6jKUsVSK
 Tm41RiXQ77Szhl+cW5f4XNCbNEsnJyhsFIAPT8

On 17.12.25 06:47, Greg Kroah-Hartman wrote:
> On Tue, Dec 16, 2025 at 05:06:56PM +0100, Ronald Warsow wrote:
>> Hi
>>
>> no regressions here on x86_64 (RKL, Intel 11th Gen. CPU), but *only* wh=
en
>> running GPU driver i915.
>>
>> with GPU driver xe I get here:
>>
>> [   14.391631] rfkill: input handler disabled
>> [   14.787149] ------------[ cut here ]------------
>> [   14.787153] refcount_t: underflow; use-after-free.
>> [   14.787167] WARNING: CPU: 10 PID: 2463 at lib/refcount.c:28

....

>> =3D=3D=3D=3D
>>
>> If I did the bisect correct, bisect-log:
>>
>> # status: waiting for both good and bad commits
>> # good: [25442251cbda7590d87d8203a8dc1ddf2c93de61] Linux 6.18.1
>> git bisect good 25442251cbda7590d87d8203a8dc1ddf2c93de61
>> # status: waiting for bad commit, 1 good commit known
>> # bad: [103c79e44ce7c81882928abab98b96517a8bce88] Linux 6.18.2-rc1
>> git bisect bad 103c79e44ce7c81882928abab98b96517a8bce88
>> # bad: [d32e7ccac8c6afc6a3a46fa4e7cdf0568ee919bd] drm/msm: Fix NULL poi=
nter
>> dereference in crashstate_get_vm_logs()
>> git bisect bad d32e7ccac8c6afc6a3a46fa4e7cdf0568ee919bd
>=20
> Is this also an issue with 6.19-rc1?  Are we missing something here?
>=20
6.19-rc1 is okay here

> thanks,
>=20
> greg k-h
>=20

