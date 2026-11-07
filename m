Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060190;
	b=XmtGGxjfe9l2GW+QpusFu5Gokast72MiIUQs+m5TMJuCep3ywVycSOjeBlDthmixL0f/
	 o6TxrBJhg0uHOeyDzVI4NkhO2oFsX53MQN6o1JnDZUUPGMT+tgAxUrphqaks/+TDsMjLT
	 6OPytDfZ8pYnhWQvKKZCebkreb2sjRqRRi4H7MBhi5iHoCg2UjsGUt2i29AQBRBFkSIB0
	 CT9vlrt/7AQvLpC8G8Kp5WyW+xEKgDWKzeMgCdJDUf0C5uEcRMSHBpLjnXIKRVal+9BUk
	 KIUndP5PM9iH5xfHI9LFtQjAP3pavtWVlbkMw20b+apS5yLMtQ+m0/B6MZ019dKhjsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060190;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=JFro53a6teejAo9k1Voj4vJ8gyDDsnoZgiMyyWElCAA=;
	b=h7u1ajcvozpNGBW+SX4X7IM3gX947zmGcXaZQm/M91RydT7OQZR9P+4GUsIpIz0xJuNB
	 3B38t9cDRnM9SScneg/qdm3/XvnrNmTm/X2/llP93b3P+Hde5S/Lx2gavZXsuYAH6/zjM
	 4y5lzRkRIqPbW4Vaq/F7RbZYM5U3XNir9hxtTLg2NQKj5EwBZ4uhiZNBr3vzWjwZs+FkO
	 suveDnz3vYEIRwLgwH7n10MxQk5PILfzSAoi9Ebpc3B8EiymFKMG5qgxpyeOVOMNt5SUU
	 SYMGRy88nVseZg4Ns7RSPRjUl/gTWuucfSp0CRU+hi4td1ptjvW6ElHb/uxnzMzeQ9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.de;
	spf=pass smtp.mailfrom=gmx.de;
	dkim=pass header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=jyqY3L8z;
	arc=none smtp.remote-ip=212.227.15.18
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A8A606A333
	for <patches@lists.linux.dev>; Sat,  7 Nov 2026 14:03:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98A8A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=jyqY3L8z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1794060146; x=1794664946; i=rwarsow@gmx.de;
	bh=JFro53a6teejAo9k1Voj4vJ8gyDDsnoZgiMyyWElCAA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=jyqY3L8zT0SCrrgWJ4J8CFX71cmRrQbaa5O9lwPAD/c8Km9ApMlj+9j1RogSt8br
	 Nv04sQ/0AFfEcrxpn/U7dyi8wCxUBDpTQWpI0Y7k+O41KzRKl3XRipiZjonLfKaYz
	 dIvmAEkVMOixFrboVeeDRMBfzAECRl1D/SUssH82enWZ/ov9s44VFcNHHCipCxVRK
	 yjYH6L4s/gEhy1bZ6QvlmzViQM/1gl6b/6zV1xViGG2KE+mqrLVsX6kUjs8G/RGQ+
	 dau0kFuGcFJkSxMDDtc3Oq09iRrtgEUnPirnx6MQLWhS/bs9lOXHrFgiDf8AzRmQY
	 48mHItY9bbdrki6Siw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MxDkw-1wbJKj1lk0-011JDK; Sat, 07
 Nov 2026 15:02:25 +0100
Message-ID: <d0c94be2-ff24-456b-acb5-86666ba68fb1@gmx.de>
Date: Sat, 7 Nov 2026 15:02:23 +0100
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
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
To: Jiri Slaby <jirislaby@kernel.org>, Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261104211038.406938024@linuxfoundation.org>
 <3dfb9b8d-3bf7-4fa2-89ec-6561c1b7b70e@gmx.de>
 <2026-11-05-1-daily-reply-0007-7.3.2-rc1-wx@kernel.org>
 <3d2ae531-b076-4dd2-8afe-2f30c7c1d928@gmx.de>
 <fb15f855-e306-4b08-87df-f31a6bbb2a51@kernel.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <fb15f855-e306-4b08-87df-f31a6bbb2a51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EHEgM82q2JEFfzduivW4ZOGP+ZvHx0kdXmJd3c7zTFULVPsDTXT
 hN32Jo7fl3FrCheCziS87H4S7HZmjB+KWnqMzNB4dW362YK6nA4aUm0xDSE8Yu7pVhGRhAO
 tRN3GNt3EtYRlhqHPxoOqy96jAiIaEqvnl1XFpmb1VohpgNFDLJgz+rVkgHBZB4NgkjPKky
 Pt9XYNIdSG1hCDH1vLPOQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:nedyd+/HFEY=;83Jy0lz37tebJq5DVY4xqOCGVlK
 JXtTEzxSl8x4f4s22kMF3E/cot0Nd9NGVpGzm+vp6oUbx9j8b1eCN/3/xt/I5owSlJPJE+hOg
 wlpAsJJw4Tu6pkdVWwREudh+dC0MPvyIxIo40VsfvPzCzvXcN29VlOjLWM3LomKrqjrnkoL+8
 NSG55M/GPWc6vn74tAZwOuXH5iO6CgOfbSznsuuaJlZYwDhAJ+SqOdZ0BV+9TMKDA/gjFfNMi
 hCW1uf9ff3btKYnL3L3CSUGqyQ8tKsjktM323aXyHJupVzgrUJJBTzQpBey5CMUttJNAH9RkE
 CdNs8QQ0J1E6GV0fzD9+rhVIIgKNpBF36+VopQf5Plz1SD8Q9vXED4O9ssWq/6wCYwXxHdDuP
 +ppcujkSaSkYkHDL7dIwcYl23rfbAjg1kPw0Yyiz7DW4LPbrbO6tzSfucmpi4wcoD/Edcvh9b
 leGPl8LncOJrrH6F4bfyU2hVuZWWWCmFL5Mx7fkDvTJ5BvQqb9IXEywW9XLOROrEDE5YjjcmF
 Vu+tSGM/EKe9igmR3Go6wefa9rnXgix0PLMz+4SKntBNkE3nOuDcbyTYwLz0yEWkEqXUpHh6P
 JRjkEVxo+kwYHJgqgPF9r7uzA7BmBDAdDxuPvbMEVZm0Uqgqf+NX+YyXMLhDqYs3zZBGyAJdt
 dL2jsxyfztcFyah3Rp/klTZVvUbhIz5QgUOx7k8cc3Fcjs/U9k+8ru28TolLpFbPya2XEqxMe
 VZpBXewHjfxTmyWHuZTEXXSqSyFFbRwuMZzYaAoBXBOrYsDTwl+qW8NNN+wW3m3Ob2GPLXy2y
 RrPFjGtCng0oUcUvq5j5v0lBhbg2tirLG2vKZSPfOa+pGGwSxQcxanHVqvwZGn7ZSEMHezE/N
 /hss/+VzxFQOs5m7znHI6Dvq7BGB/JbB/fsm07mJnwj5UMXa8wtX0CiULlVbH2DuSo3RTpGLA
 voIUa7ozEeaKBprYBCkvC+OzcBm7v2gmPg+rWeTgCriFmm/p/dcN38oLOOKsu8g1v297kTPmh
 ooPTjwMSlgCl5Ugkl7JtMENCfmFLe9jTbjCVgCuNRAPsytNBhEbzP5qLU5gyzuBvTk8DbPGjc
 clW2fo9K6iMeb0YbW50LbwgDI2PpeWlT41PBVrggExl3VaUJhUzYT6nKZapX58fCemdMZhHO5
 /QUyhhPbk7IQXcYUsfylIzzKabPGyM8ydNuhD3nmtXjP7zWVbXHqto56mGat8C4+hzxwehYoh
 meeoldRv7doiXmyFE/YH03Xy4Xa7ymQLjNeo5sBX0L7bsF45nA78vRStXCBfMvES5N3RYaulA
 4ytbyP5WWjNX8kMJzlqbf4kt4/hOPXyNFpqR3vzsR4tYg+Rn5ONzULZPdJmxbM4xwb6N1aL1O
 YpLM9fdqXgIf2gWuTbWxIbm7TofDjQISd3RDMDOoz3EB1Zk7+IIJHP1o3KlZ51ewyvDdpxoQ2
 MXbFlIMgNlptRREHyJL3uAIlRH1D9n0Hwl6anweA7DKmLCX7vfcNRZWCpE8yk6CYFiOkoy4Vl
 sj5mvzJEhqnLH+CpPly9vIvRw5oAREsB4+FuTXqORYspgIJDmS00QwBACiAA/fpwbah1/KAQ7
 3953Ac6sGTObtsDk2UJmWC2mptNMza9lQpFi3YD1iD+CWileWeia474ZY0yQekyj7Z2szM3XH
 OAahsup6DyKssVx5nfbAAAq1c2S0uP8YKFCNqpy/AOxKV9KxVyAFnhgaOSPLuO5Xlel9260VF
 9XG3dGndfi6rHdnvNjfPOz0EpfnZKvyFBKF+M9M+qmxVOreTzLt3XC4CwrfbxGTLfz7r8X47R
 O42r0C47y3HMX8774g7Q9Jy/EHMjoQKSyhiEOVLwEmRuZxTok6yqcTNOW5+8v36BXIXI9kqSl
 u3c0RL9l/dmF86TJDAsk3Vg/JZIPUtkeARCiblk7p6bBLObxGN/6iXJtXuax4upOerUl5mvzH
 SMwn0YAjWqu0/UvNhs/qAxeqcWK0/tr1f58szfdq+agSZozmxfyk+ZFZit6aSoIfq9yk3y85B
 HgFflyQJ5Wfw76eWSJ2puhfPbCKPewhIMlg5pYXT9ZgdklBqMZTCg6Pb99Jw786B2SAy9e2UM
 /DrgwSoRXJL/CC9d4BXWafJtV2N9uSv4IMljIwbVCXBG4J+IGIHJJuTECUisU8ML7gmm1zXlc
 1ARrSbtiFGyO6n9dfqBnBcIiWmfHmgL04eY4nfqkfsCwbVcefVFl1kHUQgLEfl4tjP16kcM7H
 TrGdyKsBZ90HqATItRSftdd3FwTpggSi2bjJXplhLSkl7kuQyil7NfnzqK77pTGEIo3esNifZ
 aybaUv50QjnTT6SwqZ2Bf/KBjPjzZ3LRVlhZUOsnfyjJWQvt6fyprhSYz1D5HYrtH/w7l9C3G
 XrHJNeKv13PMee5n+nbT5tslMzL4yxO6481Ee+IpRQcP9Az+1KQvYL4CjmxFrDuV+AsddeakG
 QsWuRA92n/Z4uVd1Q1MCS0c75cKxRrXHMXGCmOGsZq1ecHmZ8mltrzP8CFRVcXEXlguG6nhqH
 8Of7igtuSglgD17dNpF7CEvksc7lQGWDLNV4yvkmG88ctB7hEQHI4F97aus24bq2QZCI0Cst+
 Vawlq8c1tYBAK71gzKd+f2iRPwcNgBYZAj4tasvKd7GOZhBSFX6dxn/JmOxTkJYUOemi0e6A+
 ShAZCq6tRvsz6ERReeJEnBI6qQTUuZvMFB1vwj6wcABATU8U7yn/PPcyyWgrhIif66s6gXUJs
 t7OcqVzv3rcEmFLMM/+2c0ck8Ko0G3tceSdgOv21RZ1jQt6ZbFj8gKkQcIwOkh3IVy5uSU0b3
 XOGStmi5UgT87Y8LBDJ0icNfeBMGwazqHrAUqswOyje3aQH8ZdL0LsTV47n+6gH4mbXk+TLlg
 New+QA+qUghQAflukypg/MDjUgdLe2I3FK9lnTBIhuK12d7z1sN7ZZ0oMdWEyc6egRkaOmT6q
 Rr1qpV/ounZv7kY8qVUvVxB3GgdpAGn7NOOVdSYK6diMsHqGLwcgl0FV6R6U9N6NFCJNDzrSN
 f94NsNICrJ5DXymNjlMBvi0cFtxQKeNOLH1tttuyJufwJocK3iV21B9OfCM/7IfHWUekBTgPU
 b+qYpjL+Bqh5/5u1Ww4LUn55QzTdJEFs6C+PlCF3vT5lsVuhr5sDs0R4qpJcicvPsfpTSdYZq
 uRLoZylVQAo9KbRGEMADeSL8WDZJJXenqrFgQwRPQRGLD2NV8WQoMpmm23zUIhISzU5XK9dM8
 Usns8ss3fAIrfXQqUQE8q9ZLnl3E7Pfld/PeMa1b6epOXS28G0DliPyYwhFYcXP4odVKruFSH
 M3W4SLxdZ3vARjgwjMuWbb9g21pP1kX67bZml++q3CXWFkbI9DHs3/HEkdsOvsL73NNQk+001
 I8H+EzKHG69qWlDINStmcwgUqoyLv+SayXxkZyDgb5ooOtQjSxjruO/AiR4pvbiexoEg1yFc3
 4xSfhSCGDHkPef4Fz1+ob8hJsNQXNXeTMU9oOeMaWLBFvu6SXdjGDgV6H4e1Q0/QpMUlCVxE2
 hNcDPm4o9NPn2086xdX1dGY9Ie3hmnHPQRRAl704a+sPzXWgdof0CrhbUc4ybUWho0NHLfv2r
 CIlIQwwQtYIrD4kqBZyjfZ8mQ4FJISAz92M/GTiUot+W03mZrZygo5v90/l8nP0hcH4AXNynU
 vgJu6VZXdhiEXWUnXRQ/b3hDmgX+IMIXRCCD+q/hWB3WBnvOqrBRztz1IEGWJkIn09N9bJnc8
 woxzfbhvn2nRtKGNLqm7NQDxSV5P+w6rlD44JWkggthv1RipC6N45hSMBEdNQZx8oJVg2kvHt
 ShmU3WsMATJ3/+7z+wG9Am8dUuf90f0t4kMsxnoOfigqvOP81tUMoW0nq26yl+wx+KBbXGoZd
 EvGMCjDmtdJomTRalw++XRL4ANm7LBPHDoaPqVpUgnDgCi7IBiVPZiSzWO7iI35FB5zSzTGoi
 Qe87+btdPEGSu5jS58LoejmFlnwqddHo7zhdYBNHsMtLhRzBGX0XIO+GT6vWCsp1GewvVXmH6
 uWZvuPzuFDeXdSI5HGqqE8WVn1QFOcNc/Sz84ALKJi4Shrld5wDdq2aeS9C+pDsf8Jbrkf9o3
 3i8P48op+E+mibROlos/mcJmK8lmISF9O1Y17dcnRBT0m8jOe9t59ppNw8eP1PyjLhftqSZBr
 zp99VtjDaYMh16f5yBUldX/u71tA5bG1CHPZXRw7ytLjxO3lqn7wR2c9wsWS2RJAhunNEgvqE
 Hmf0X2gJEHdFB7RazfqId20kSPpEkomO/Zjx1mFWspFoju+Ll4AI4woWjR2c/I07m52StFebX
 o4lYeJ2qFNcJB8eZhQawAvwivLEMgHb6QSPhle0tKG+Ap09lcKAo4Va0C6/7He8KVJS43aS2D
 DMHO8636dY1vYCV4u3eVC1w9RUnVjfoKh2WOZ85Uc9vzn6tPEJfGdLBDRGVb/GxcNYl3vx7G6
 uhh1eEk0ROWuTtHH4cgu2PZR8E2fPV1Bs1FUpkPO3LcYpQ5g1k7e8d4zVQKoB+jFk1u/pN0L/
 H9DUh3KxN6537FuklnYXkiDXgI/sMlW8GbvHv7gp4B4m4UHi5Ajh9IxTvTq8zvXiZIMY4KQyu
 bpok59Lg09ow0LlqdNo0xQTrQNfNYW8WQXJTPDGh9p3J7C8KLEHhgP60c/NDwaY4PwHGvEkh+
 pVUzw/S8ZDKLp+HAhuphZGj4YEbs7c/J+M4HOGGgGqiqiM2v/E8Jtwhe0pqSf92ABEP+mIedZ
 FSfbQ/2rg0Sb132OhBCn/kAVZnvEfC5v45xX2RFBjwPMeTxzzMKuNLxgkmq9ho0vhuq8PblAp
 pxB2e2XNurTIDc20uM+TH25TRXxSBOvzka/6xO6Gwk9KRxdBz5/4jolx/BDDmfrVuJIFFORHW
 vFdpFZbHbyJsvhQLxCiu9hRiY/pSCVjzwZN8yG1ywRCNmZV64AXBr/W7HvEs8YAo6/mjRWO2g
 xGJS16flvE3Xi8Fa4XCLeDW/4d5fsqpzt1kw/Fl6S2Je8yW6mBqn00fyiOd69jxFRpIYwR3hh
 uEeJsOL/nQJmUCTuhMiG9qwShAtWpyzJe5eIbVZ5SnFlWfuhgNV7zYfIm6BMR7Svz8/YYx2my
 DC9FMelHELxREGD0IAmwSSrDsZCcO3Ks+SBV97G8wwd8U+fIfrQWMslCqAHstw/S810/tk8pw
 e87TEsBXen50DFAqoKoXvxBd3O6TbhIV8d2Z3AgSxyIj0njul7V+m9U0KRjU0paps8L9dUjy3
 dKiz07PDZtRiSCv4tuedkUFuEcx2+sBGnbp/VZsQP96D661WUWzyL/NP69CnGm/+x0iVkrMlN
 c32vAlcyCL04dtsHWhnZshGPCDNAnaLPlllNBs2cgD8cSAqJpPLiJx7nKeGqqmgM6cReGIgEB
 0oAAi+hlHQSrucFozk/dmM9ZP9mlOQek/1saJFR6tyAP9X73Iug7RjC2xL3MAtKagbMXbRWOt
 T8gMj8O3nDpSdPgkorETrM6+Vqe1hIvB8wQvkf6ZiDTE4+XzIsSksY2aQJ98NOAWY/1sbFZlQ
 khpxkeVzcf+20wF+WQrR79QLhiNRKI6BggyaJn0v5uAUQK2KVeJZEnNcvCPdgoRsEd8JDbgcM
 yQoOdFQgQNtBo9/HrqsUlCPsAO1boHSgO+vA5scFpzLLTuAm0ELJStt5dHJULmW5p09N79NnH
 nNikXeYyBbUHP+ckkuwG7zL2+ONmwnhXsPDq7AzqUkI+c1iZoIOtKkM/fZFs5EiNG2P3/WVtB
 /SkUdsa+uim2p1M5EpDc8UPnw1pfRtw87qSBnr4DTietcOJYQAvOy9Nb4+WqC4vmk7ykYYyXV
 KU5ht3vnTd9HbciZzIda9OlRK2dgIjLSFnF9+OthDuGHdbJ9oX1AiJgjzosyaZgOxnlN2Ps39
 njJvyoAEVlTdvJWgzPbcE4c7N05e+0Cgg2ihCOPKLIyTn0kgNEVHbrGmpzK3CjgvZuYCu5n+g
 6PmlODolE3XNOxQ3YxHlJ2QxaQQnAw0C+uUHW8DgLvbFMYVXULy7bLPpV8IssbcoRq92aXLDD
 AC05uAeTWOlxSp14cbda+a8ndawQEs0dW0o26klNpOUq7QTPQn4FAFkHPn/N2zGj5gt3gBLJS
 IjnCi/S/Pe+u7nSi3hztydklm+0zlUFvMS56YmRfY9pZYThI3B74adFUo7Mc04b199z5jekq3
 lXde5XdgATvxQ332hUKmKntP6P2eJ4l4zJCx/nzjEalHZODs0wEBPXpgQYNi4MArQMDq6A0IW
 GVYbtS1N5YXomDAIXXpL98eNfXfBMPjL9Q+bOFkJhTjQPTHOP+0r/MjaAt+zKHA+zf9qFoMpN
 iMqnGw0kAspU9KUTUk+TtriDusVlkbFYI7Lj4/ArP6juMdYjThTXf4a3rC39ggKSvGyZXv1L/
 zQagRHgzhiFcFoyMnScn/4FKGfPD4cGimlzGHnQqgGQ7aeKHpFjLcDLWdYhyOpad1uIdTiIDK
 bXPuzVJbVtvjssrdQQ2m74XpRn+EcXqhX/bsWjdsVqz5ZVcSBjtxQlv4KlA+cjrNdzeZsB5KL
 01VZapjGM6U1lcQZz2muCk9RUjWBHDPQVrZHQEeSHL5Elvl+vhor9fINC5irx6fj8s/jlhgU4
 be8mRYMOA99CALlXwjz+9yIq+47cplzEPE5pe9fAlVO89C+MTS+EpTk0VnbMJXAAyw7xLHNZW
 EOs/i79oXi4=

On 06.11.26 07:26, Jiri Slaby wrote:
> On 05. 11. 26, 20:58, Ronald Warsow wrote:
>> On 05.11.26 19:39, Sasha Levin wrote:
>>>> I need to revert:
>>>>
>>>> "x86/mm/pat: Fix effective RW computation in=20
>>>> lookup_address_in_pgd_attr()"
>>>>
>>>> otherwise I get:
>>>>
>>>> [=C2=A0=C2=A0=C2=A0 0.108037] ------------[ cut here ]------------
>>>> [=C2=A0=C2=A0=C2=A0 0.108037] CPA detected W^X
>>>
>=20
> There is ea6fd393cb9e6811a748c7551de0dd3090f9dcde to avoid this false=20
> pos. Care to try that?
>=20
After figuring "How to do this" and esp. after the help from Peter=20
Schneider, I can confirm the above patch applied on v7.3.3 fixes my Bug.


Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

