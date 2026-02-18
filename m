Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E86733DECD
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 14:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771425903; cv=none; b=Lt443QikamwmwN48oBW/V3x4IyVpGVcqrchAJT37nBSSj7egXSa3cs0XjiaGuo9iA8iHZ/67a5BeLOSq9bifFVUwRuFkUGa76V8dyEviQFw3+pMSQ1p2GCehhpi5Zilhyss9T1D5VAMSYaHyo5c4r79bEap1VSbntSbLGQvhN4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771425903; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FyxAy/pJVNiwD05WrkZs3F7jdgSRc4TXSzv5Oe7ntKQzUUltMc7w02ymf73d07eLY1eilfloX0yLaC/2lpfdQaR7ax418NkL69U6ENhoG4pHRqytA194yaJfn7MBiINuHzx6S0VeHMwxWq7+dPrHgigBEImmiGPtyb1JzqvNyCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=oZdSF7zv; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="oZdSF7zv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1771425863; x=1772030663; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=oZdSF7zvZDvnJF3VoZccfTXkWJT1GjgRK8g7uXeH694DHkvKEDCXmdqFPZ1JYjHM
	 zo/pCf6l9gXDapVPA0Zun6Khf55PKhOaYaoFLBsYxLsCVuZVDneY9vfKZYyLqywF8
	 XY8XBp5SIJGc8niBg4JTlol3mOiWonvrJgJCfBbwl48gebL3ud6arRS2dtGPLFzmZ
	 XnMDhLvev6jdmiqyAzER3Lhjur/ipXAiiblvAPeWOpFbOnfHL+2k6JoxmRZlMt0LR
	 aE0j/orflws8Yw62KjX1F4f9kuHMpRk9lCIkLGY/jBgyZaHuZeCZFSydftSF2fj6i
	 zu2gJVXiarRospRZQQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.35.188]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MulqN-1vbC8T3REB-00rSsa; Wed, 18
 Feb 2026 15:44:22 +0100
Message-ID: <5bac9c6d-56ba-46c6-923d-bf4488749df6@gmx.de>
Date: Wed, 18 Feb 2026 15:44:21 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 00/18] 6.19.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260217200002.683975158@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:oo8IUOAq3/bMfyxi0h66x3Rrr1WHSG818Ryzm7nNw3HZ+rNQc8m
 SCbAf5K9o9JJ2clRGSQMdH0+3JTGhY8ImY5GL9Yi7Qlkf9S4u9Vgswq8kUva996kO90p0D2
 j7qk7w5poNof3vnu0+hm3mPvkoIzHL9CbuFP/3jSibcNEQjEDEhZ+Ypw+xUZ/eVEtEslOk4
 0+uA70NuxEpsbwdBa2rpg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:O2dD1VZ9gVw=;A1bOyPPD+K1gQ7kGJT5h6UN/OMs
 Ea6LnL/NAgqBcsrJ7NoZBjHG98fc6L0LokLIGMnuuvahTCr8zaguD+lZgS1OuqoEhhy4i6t3G
 vR2zFyYTK63MQWOqZUOW4jcwv1mIeQa/pANp4V5YFgl7A4xMqWbgYz6L3pEZOYHKJuwnjvjQB
 zZDn9LvHsVUrBa+lHU/7DKELve1Uldq9BoIU66ivWw/ewrTk23qWKkNUvnklw++ahT0IBL/KV
 POYMoTOU7hvH40De31jDW/bmyMf3TH4d8PdHh8E811bA7QSltobSh38mgyiuCrPes8HtYGVsr
 eP5HfhizqEUsCO1lC7Xa3bG33ySBQo7jaJ3TIfXj+afA0B0/yDQsdt5DhFE0mHHN95LfniDxs
 QOJSEK//UoFI+SHxolu4tOT3FkJWkhJTo2kWseVXtEHqI0FyQeu9rdFSGfswfIQ6p/PSPws34
 WEI+HAwsj7l5HHHqE2X3J9a9DTyUGcuogPhfSAApU+qQ++O3uR+q4X2OAaH4GkvxEGuOEIMlL
 8k+0g/ZRpH/5JdSqLcl2RyKfiiWtMIayAfDdtejecdGaz91IXUmIgPC44HTRZGcoN3mRT1k3s
 BmfwqN+tlvUWYfELgNCofaNeTaq6AAiliFNd4fusa6nghc/DU8pTenBeuebj72xfikUJMjwM/
 jTovRoPktkkfwJ4BO5f/x5f+U/e8y9Aubiy3tFa/F3uH/Q8sm+c+gyL6qmmdWQkk94pFJ7lLz
 Iw0HDSIfKWZfotRTNdQg+RYh+Op8vWqnMi5z4FKyp/usoVJITaMF6x2dXGaQ1iaINop/UIuA/
 CYhiXz9lu/MFgwLxZf6jTreVdHqNZmknpIo22AjF1GrDSoO6xHL/i6eSsFq1LNLNCEcC4VPQU
 qIIJjYRb7t5hvKqlL1zfySrqFMoxZBAcjP5yyrqEgjtBvNJrZmG5G0OV0DI9p1k3Ztiq2muUp
 o6Ij3LBFpRD0q1xqeg/tYPPnUItP/mwKqaMd9rRz51VuJ8ngh2nZgFwxpmYXzMrMP+djXLI0C
 Ru8Ge4opByD+eG/ptNPqnQFsFOPe2Pf3UaTClYHh/8Qck1i9jpM98J8K+hXHjoOBY0Ncm9dJ4
 MYLXq7gIutO9P4y1iz6b3mT1NsnFXTBKtWJbvVwKn4oG3V4OzRH1NFftpav0qufUigRosTs52
 CbxAJYJLtYVB9ildddkSgpBpcTWOLyGxF/W+psjDZpyKTEa6UXknx70bpP2MvmRh9TkYbtsP1
 xGps2LfkZ1ullP0lSKbHzbIGb5fWkXAZqZhgYtnoViQfkQfIK3e2JARc9omWddkN/LrXoQeeb
 FLBgAkrLT+Mq9u6dmVLVShUzcORVswDltriN9qq5BO//48gSwbFRV5j6Jw5IdHW7zFXsWODXZ
 nhzdmAnVzjl2eUDBEnciyWNpJCzIwDEni2QkY/EQ/AXvJC0ghAxtNvGpPbZ69jprrhaSO28iC
 O0xgYFTkH+20fl9fRA5WTmUxX/8EPzy5NySCIJJQ9LRkHtT7ySFolPYNqdHcPpm7ehp0EhWDq
 uQy5pX9uYY370gmOKk/HANKBnPmUPaTtwcbXcEpsJ5OMFXSpDNPnO9rnoaiJ3ke6UtOaeakGr
 JbXugUWOzvPdlN1NKNRZWlU5UtiNriJgNC5T2KaQvhYJqPLJHlgJUArf3i/u7dYg7dnjfFCeD
 1ABZFmFx8s6W2N/yJD4dI8opPKTXDyAHLLS/RBiyYPl1YOCf2aEIUgh+pXO51Ms4aRCvYHg49
 7u5yJXqwqA87GQPBi6ZoA8b+jE5u6GpGh7U8GtrweM+3HWf9xhQAouS5wpLhP5nUnKP9MCSEu
 q0vxwP6vdLsMLRMg3+BRtGqel59h5QnVmzu7o6kaYBsc6/l2G6Ls0xdSD1xsACr66veFZHtTB
 A3my4OgzHrbzX3qdcljsaeUMAwFSpf2OtcgfWiUKywJXykCP0zXxT7DRdab0tdEg6sJEKil7+
 HybSbJdyM1ESPQXXo81okvadiK/PkPD9LpsmwgrvTnNsaTf+zbsEF6xPt7UMINuGjfzWk1opj
 QyjtvO4gKcG/dGeWpE+RfauGqgwEaHQXccITDQmPGFs8CbloAdfXv+IlrW6Aio3jUrFI1jC6w
 toSy3PtIkr0vVdcCoHsGaj7hE+XygVH0W/phl9yCdNqvMftLan3DOWDXMcAPusFill/VBd+Kr
 Gi61uVrl+yzV5pZdiFByMkrFvbczO35FrZIGL+SItrOaXywYK0so8jQQ4AYGTqNs9CtPPsux2
 Impu0Y4dVzgiy+npQnGZsxHpcShSLZ3Rkjwsn0TRmCvWI7rC8yYSBJ6Hyfm89rQsyaiiQqW8D
 z65kZnMyhN3omhEbe6OL/nGKwoKnxwCFNIOcUWrg0K1x58OzJNa4bcx9LIDtdGjXpz+oFRbuB
 la2PvLU/szpeYFlsw4f7hFcZ21VG7r9TZRwi35jhfex2e5YM9BJFyKi5gCh2dqzJpY+jnqdGJ
 rlCiPBMJeODq1sNe2iQt4WZwuX6h63CP12Ci+H6J9th84fsVuBDgAdAJM8yiMJxoMDV47ok6L
 50iB+Wouze6n9sUebHKyWuu1FwsZqjqnpuNYnc5hk5zAb10FGbNkPDavXEBZnHl+gBLq8xJyH
 kFcDmqMe6J7O5JmW5IiEFMKOSkRvCBOWxhq5DgF3Oq6zp0EI5iKi5snWYG0C63sWxXMpqtdKg
 kAnMHWxhPVtqtcifrVENbDo2sh45aIMZq7KTzWV54KJNMAJ5xcdU333hQ8cwF9HtaGaaM/03e
 sAdXEfMEf4dl6SaQ1EQHLP3CGP7ZtTeS52JJbXmElndQk9O9UTrnV93xU9H2xRVb2UpnDtmpy
 gOYMvGpykjSBlblhoqkAep93j8bHDgZxs/TeoiQUuFlu36eY2cGTQz+wgvvv0ngWZcF6u4UVD
 CscMfrgtj7BlE06b9oN6GdDeW7Ptcqy/99sMWrothwFfa3ebDql3IsL44tOASF/vH1W/3U/y2
 RK5B7A1Da+E+kWG222RWA8VrO0YX9wsuQGwC4tMwzDFve4l/GpNROyfK0a/jsdKdbIvcQ+Ii0
 ndErI9/oJtdEWc1OQqZPZOd/uUhysARRAssq3tn/47YCzb9/MrOnTh9woF9vcizotIQl/g340
 hxQ/lS8lrdbDiJXyDFJzKiiUbiAuh1VwMMcAM3uTVBZVAcuXvC9qGKWr3Jw7XkMTBOJ64Oxvd
 D9wV836MDsTXOs1jBwvl/+X+Y2xb9I9M33T/lhn1jfcDfK6DyuDqCEk7HwjKeZqtD0Hisf0S7
 f62KcxuT/nFtv4m5uZ56MLNiIDkC6kqPF9I8eEt1wDTWlpM+r+NCB2U7UMvqpCbm6l9IYHVaH
 6JB26t4OWXVh/tk3Pr8O/HRZCZ22QKItazBZViVXXSOgocg603czpDECYAQrX8hWwhQxMMkxh
 1mqD8DZL+RWvKz6IzCVKPxOlyHFOhN8tLfF4FmMg/3AuQzttymffHCca4k+bFQT3YyqizASMh
 CeBxEXbJoKMzdBayqoLnIcXnB3q9EbJxIHDZIq5ZzqAQsBqSA+wnzVWJsujPTeCnR3V2iZ9IW
 eb6iDBd6oYmnIWTKQkUzXrBq6hgHoFnljGhpezKwq5yEazHBDq+K8Xki/2hBBs1yIXBK0/R1p
 5GJVoSS5jKP8ldgO5dV2vScZL7YBzPLjNvag8Pc/TCPB62E7GtQCCvNWnF1wDjhn9QFCNHefr
 sOeMyfmvXPumwXO6QdvyIzfySSk7Tem/9Pc2papEofnm8PtUTucgFFphYoCzYbucXp10yd4qL
 IbqE/QrqXQ1QiDTLXXEbjqc23Frl2Cu5bt7LBDAG0FgHxRh948win8sQyzM2ll0e8QAyzaNDk
 FgOAVDTau6f5hPCnl94x1ucFd2AkvBTzZ0Ic//ItsGdvyxYMusHjsJlSFezZvTTEOmD4zONFZ
 2SRHPcDfhkq9k5Gyo6hcefP8JPxT/pIsGw+xUHaSD7ZWRmDyGuxoBKFNleNbBQ2SnVQnPzZdB
 q7JvLlKpjWNcvG92WGgZQ0R5bBgE0AMG0kg+zmaee/iISFRJrd7VXx9xQ/L0aqGO4lTblPl9T
 5XHUA+F0UEHKvj8wr33juoeINJJh9CqN4tHcCkRpxHUUJjcKpGRY3295PT22iVIxI3Xj5ciXq
 CNGTqKEDOijWyZVmTs5TygN9+v+OzspJMLeMXXPp9GaN7X3PsOc4wXqOECrvGXjmo15f+AJSh
 OoI8pQIWR/+rGJBwANCR34/fzVgfG6wVV2YQGi1lppmdQzoUHf2PQwcD6CmkPfseqEgkb+NQn
 l0mDftszpqmn5zlaWU8JFkGHXRaQ/rEQL3NMgMh48Dk1/CFppOaZnH20CG3cLNm/jIXRMNe6r
 MkmRIOm0mxHBmBMWxo01UZaGOuKGn52Ay6hNRt6tIxAZHTfu0vCYH/+VAk2IA++iw+kupydR4
 FsGJ7xlig2VmM7FIqti6Sj7KHGsPwtQjbsAXYW5jiMVgJxi8H81nD6rSYujD2pPRKm86ciZAq
 hUwrfS2UpeN5qjOpM17zlUA10AN3HgPkBraUH4icnUwfKp5KnI/nLzkt9GxBXnxeaQb15kWk8
 hjpWd0mnpkirSa2DYojpZRAL3AunJL7N0aCmY2KK4id0D9qN7+IRpkVkGX9SZpECjPHaizI16
 w46hzrRuexkI+vjfj9ktcKPXdPf3EgywOfrBH2zr7YkvfwJQjCP73k6cBu9vl9UqGOmtnkfxN
 KTbhhjPNnxlVkbkhWWgqVLXO2agfO19lYmAqNCPLm0KuxUALsKyvpa5vY3xgFypQ0pMZMAOz0
 PwnEwhM3Fkj8depdoDaVUy46cLYATH0XMGtaN4ZwkvxtEWVg4uJtNh7ucNpbEC+Eo4NZKsS8t
 B4piSMQDdwsVoXpyjQfJwcLZRj7a/+nlofItKQhalwAE9qYa3ri0Re7q2QNdayXeD2F8YZHND
 tuJVhYaaOfFOoe/05zUAF2uST+2nwMSSoLOEDKH3+mJaYFaHcpfWFy1PAmFt0yu2jYgamltuX
 WapodLFd6ofToD3D0OVIe+ArRbQXgVUn0wsVDS7OQa3+gOSlsryC/e46mNiD+/aywHzbPkWDd
 Ucy9YRZu4BpHMV5tAPsJdWT4e/R7o+kBD7U4Z6dIqrux82e

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
