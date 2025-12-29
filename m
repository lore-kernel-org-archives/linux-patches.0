Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F22C17A2FB
	for <patches@lists.linux.dev>; Mon, 29 Dec 2025 21:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767042199; cv=none; b=VQDTa/xbWqlfCu6JUG+fHxZJQkW+nH4ef3WlD8oG2sqy3szkT9+PvTz+f001aKt7KrtJztSuu96ZPYu8L9dDrQoIUaa0HJormoTka8LNxyd+lMJjlxLwauLqFOG8s4N0KdXaMT/zE4yjbmKdJNnxaGXsDcUnYwfaqyh9RY09B/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767042199; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AzjOz0TM7Z4mvN70ejY0vrl2GiCKbPmS4+P73W7rv4rRwHzsa045w2o8OkaXvbNRz6I4+WMD5GyWhcTBCPlqHy1J12gK3Nle6mHadY8Nuj8OV88K6KMznQ8rxHUpjq/LiG3smW2IQzC6teb1rkg3km9TbOAZT3bykjUSLkelxeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=f7pzBDyE; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="f7pzBDyE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1767042168; x=1767646968; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=f7pzBDyE/FG8j6DwzBiJl+bYk241eZaEBfjubm7j/aW5Ozkx96GnVZ/btak4b7Rk
	 ZuLwFWKraxXUr3gIvAuDxFhWcJcrTig2dNC2gjMoENEmHmf6LnvekkhYb2WcMKUnd
	 gflz1gLReiVIhTJ3nKtAYt7jPvhw3Q3FEC4NFwcz3BRVawnlLJJBj5OqWxjPnNF0i
	 2X2K/1R5+QON8Yjg5YpO7q/9YsLGe/VXKLP+/tS66BNcp4rOu37+PCDNzVq6XUVNT
	 aOw7QIGEU6z2f5LIIceGeiYQY6x2jy8XWTm1bUTyMlEzIPPYn/w+mvrY5CitJ6JBo
	 Q/Z0dAEHftuJzYDknQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.35.4]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MmDEm-1wI9aC03Iu-00m6Om; Mon, 29
 Dec 2025 22:02:48 +0100
Message-ID: <6034dadf-0d56-4b8c-96a5-a05d5bc78524@gmx.de>
Date: Mon, 29 Dec 2025 22:02:46 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/430] 6.18.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251229160724.139406961@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:aCI++RS/AvCsKh7yUH8WOvwIHGTeHyPc4aG/4OB2lFW+X9MBhsq
 V7dajMFRwcpdr3X6TYGCX+rwp+1UJMe8RYGTkUCbf3lkCRkmhTfKW8m1U0Qph4hPhBzkLdO
 Ftahrp66a469BwUe0Xr+uQi6XsUKIEdrpTLFI6Zw7UF4OcVZNBb588JPGJPpzHfNa9YQHsa
 NjPz074c8g34tCioKi4Eg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:gcK07DkRI7w=;y7j6pxiHkLqHdQPGQj+nxwzq6AK
 cIvXcmzA6sHyamCN5XPTDSPUlz4ffo0L3a21MryajpzErZTreovZwkLggBSM2LXT1IbqDn7+T
 bcABy+DKBtTGOJdGdFyIF74gnxMiP1dQBbrTvby0WlLQZFZH8u/hyqnh+m39ZaV/PtZpQgPdQ
 aAlqe7KeDE3EunfTRapGfERA7K3Kf9jGNTKCImWiQaQPt33uYoSqCQ+jVM5sJtlm3x8fdCvN6
 qWCUvTZw25hajURKZeP3ovtk5IvfjrYMJtIsjPKGWSwXEFf1G/DZQAfbBAPLvEofcwfTpiMZC
 oUkFF3P0X5rOoTaJeNC/ieU89sJ0msAopHPy0if+fT6FYW3gsA9cQGcRiKepjp5d9NuU/vJl8
 WptzlgN+hpBlR1luByTi7gp9RAn2H8APOGn/Jm2VaPn2K9gd2paxAB+m4+xcz+X4Mrt0yjXb4
 NdPR0O07BNlSpGx8bnKE3rVjs5CoRzoI6f2Vyjg/0pERwle5zsheTg2dgS0tL0qZl5C3JDW1j
 LSeo+WRghqCUiObnGHnfSJ3cIAMQlKsyZJOnzhWiw/KZV61mwvhALMs8ngPbC0oOtz1nXB8Kg
 M5MXUpUv7dQfcii9cdUOSl4ltSYpeUrWFN2/PqBByjGdXSQkSGvmY8HYyYdNu2QjwsCtavUw2
 QC/MC4JpgyCihIiG8HqmS0eEa162ZlID5pGoEcMKU+8sx+DkjP+QQdlyVOqRxL6jCFNmjv8uz
 NS+o4GlsgSarAj+NLtg1+hd8MVa1WS9nkpP+2Pl7F8CbXjlDShogJDTSEeFppVNjDItzHR11t
 IOjRcBLVuFZuTj5pfUk9QUxUX3x/8thUCvaAlUpzTg05mjNLLZWiFD6Sw7rLmlQwnaF0k9RiK
 2tqh6gGJX0IPgNekbx2PALyy3NoJFAkKXGR2CqSSTPnl0LvPWJP/4vyDcn6SfdP74VP+YYzWL
 kKblIk1V96Cuf45S69frUb8EzYQvRNMd3rdNpHBdEH9ksDgBwKqsaWCvvHKjxuKJAeUUE+vyk
 hRpV6McUT3e45ksPuVbFjmf+l+qi+Clz+Z8RFaGDIx6U/lzQG9HPFfsvN8U9IjIKE0e3UNF8v
 oo0FSwJkHykTsSUAXIVgZAAryBubzdUwDpTdoOO+2X9rIQAyolzPb+Ylo1AxdC2zYlPzCL/mk
 2YxbzJvG7ZY6GzU+9TUqc2rdFOIOvBOW81sdux9d3ZJZdPPYHjYPjPxymHkEFdveyWHAY230z
 gPErkT4UPPkFxvE0km6Z/sCwxSQegbxQTxntmfHtXXh6vgi8cE+cEJvok+GcifMvho5Fk6qUw
 +GJ2q/3NAvt5VnKOYQxLJFG2M5JZK2CFaV3CoZlmu6KS3+EuJcRqeHaCNNNqSQb/Fk2r8O0Of
 2KtGlMlZ7F5wKFC84uqfTIPMVVWLZ8P1FFBYWmuCf7w4UpsMuiRTEtEuWuKCOUGwBE21NaEiF
 H/Q3+OqPlTc/qxe/tCq55pVvz1AyaAdaw08YuK+h6Ol3h+c2oE+6ou8cgbykESI2VBOx79kLf
 m2pA9k30JePtnQ57Xnaa49Oeq4CQC05kVupPZiSMuoBT85sxy5fvpI36j2rPi1htOaN2d7kUR
 9ykZ2pLcoTUoXkATDMeM2JHRjwuE8PQM2TngkkoxorGGrkbdqPTGoTctMu46mkyYdAWk8FDBC
 RnhpAZOgiYTK/jl03DhRmb8gVkBu/s9o0lncEQ78nSmDGwhnQtXIEi7KxTtqwfHq58oFCdnod
 gW+7z9KNYNHoQxalXTkeLlIH01jCRqcpDpPWGjDVH1YAkZ02rtJCO04bY1Ye9MhlZLoq6ulWW
 c3Kd7rS1lo4r37Te5pEM6P7w8BG1fjpJDhjthNiKja0RJ5XsAXwCNLavtJXnUZFLZiC3X5bBE
 AAxZqn3XYAgWMeVBH/HaJgnprY2wzZCURRiS7DgGjpzFGmx0HhwF0kC7ERNE/RO2YYK5a4Bnr
 J4njWp5NvU/WtYs+sZaD6dvj+Xx6FC7Z+qG8afmCHOEDxre/RJfc0q71Vgq7qBEi3d+gViMCT
 h/Hl7VQxK5Sf5jRpm1/EuRBFA9n7EMu3h9Hdx8Fe8sSRjCXPdmTadL5xLI/+VTKWZaAVWufs4
 +N9HzNi6O6j/1XRg/8TyYYZm8aGokw0SnLZWGy+UJCliX90t8ZBEit91a6C2JeDiN98sieZ5T
 FB4Vk8kLARjsHHtlJIWMDndNwJezKrM1IF/m6vvxP77VCJ10fHdTdI9juGkqMD75dWSw4opKY
 JqWONl3SL8IRmDKrBr75hSOhI7mhuOYxkCNPCkdRPsaZlRUDb2sutRJ3C880mLkDKSAarIVBp
 wfvx1dK9d1RHAg7sB3uwju+Mcl7ihdPKPR95B8MKtLKDAzfEWl13dBaKBq4KYACbK0N4BLL3t
 TYtSITBYl8Mxzly/YqjE3Zu8IgayTLiiPxUYx5043JYxmgypOB2GZQ9ytphNyo3MMUWKCuXRk
 iB/jbdZnjQj6F90OcqDiAUZi8AwxGdEa9DPMyaLfPqDXAj0Nf+WCG8O3W1CvxXg7JEcaLNxBN
 +Hf0P2vu8bH/WipPFdKFry4pJRJUHeSMm45XMS2qQUKbFHbIA+wEY5vXrTo41tH8iOaTFTP6V
 Dr/bWR9KMryNSgyzDlu9GlcYk2nrwd5sB/W8cov3ojYL4djpHrPBoUxb9yWRx+5Q43pg8s/iC
 6L+Kw55GWNqgNQ/p424nScSZOGW2H9YE2q3o+j7pGdQ1+rKjhHeq1QczB3leZnN+N70YZ+uQ6
 m8F0JYblCtQzlXLOURLuG0BdBn4/kj1jVAi9D9ms0NiPUbYYKQgoRTlo48IN01ut1gbyHTkdb
 SyrySjmw0ceIJcHcIvr5ZTE3ksfX6tXIlwhYkhmpk7ekGYG7IqLOJ+CxiZnmIM+JPUMkwsCMP
 /bNdczGnjQgD6KazWA9aqSIJYEKh/fBaViNdUWmjn0rKg8T0kHIJm4K6jr+0wTTJoeq2+GLyy
 j3yJhbTcvlzwW3HUQ9pEiMnHrtaMq8R+4eCBVa+WYq8AvWb85RPKZBYY9TFTcKrhKFmL6sHLw
 +p88Odp329F+7lsqS8nkcmwjEOTJinn1NGtmVDgbbVWgWXlTktxqo/Phy7eVWkhQZFmnO5KXT
 /50p4FKepBEKN/AcvRH8fAgjwPdJGJVX0EgeXECEM/nItnY/CCfUdJMfQdM6YO5eCzTE3s1Y/
 Tn8EIJkHCCB/g+EfkbS074Wkeuj+eHRTH74bb+r58Y8xi22CiLlDH+qC8KWpm4iT5pseZwu/l
 J5uP7y1mPTJDd1eq1mKYzFYqSZsbdsI2FA+jRcTyXjg32lHD+TrpC2ASVJP2lkX/MfDVz4l73
 Jimo+eTdX4hrb6imilJgs+C7y+zOsOcYPWFjVlPnurcuA1PSQsZn4Z98VvJTv/JLsNLXOFR53
 bRRO0sRjuBJld4WV8W3l+Q9vH7pXNEU7uUm8fGJi0MsU48I2uHKkC3uwrgF5g3yNVt0x3/ycE
 suGN/x3/WCUW33it3OnYBQLrm7gzPB1i7aExLzes1XIWPzjZo/U+GNx/KYWFwePzlzuHlkw1e
 jdFZub2VZD6rTgAsTT90K0wxG8a1Jt22dz2EN/PWWI0Q3UWasSJD11VNbjRZ6C4T6kQJJOcjU
 chq5/6F1e6e5kkKotF6BkWWYLNfkgIJm0ULmhaaFHiWm/UdbTOxVr9+u71s9/S649QhpL00qs
 owSbUa5oDn3Yz7xcv2Q8a+IuN34Jc6fgPiEVNQQgVr2Vw+5V33/q7XhxCglkH2gwOCCJux/by
 vxqGYPoexnSFTxkHV5QNJ89uzr7Kl3i5yoMtaVQDWKgqpH/J5+ikyYrBIeF/9O3pM2oz5ik2U
 v/1a+ozBv1vYC0A1QbM9hjXGRq1/GiF0NUHLo1HhoXnhdX62EZghemvDHexJLEWjUAxe4E4Wq
 yCFkGazrNrrMduynsgqdFOrQNUlvEFdpKTxA30LXxJtz8Ta1ruD8LMco0kMDQwF7Y5mgDF5OD
 k5y95JOoFG+9GXyj+15Yx9N+5GCNYl+5WU55ILh4iWfIQRmzAQxrJ0O7vGxjgtxgRrO2uoEI0
 6qYp2oZnZCtlMvDxjXwLc0Cs5zvxKYOd8LhD08l8J75VUxj155JE+a3JQ+GVYp2Zuvabj7G+6
 uosCTvLoGIKqlzRix2AKErOkWPBVLT3+2Y6E5/Ygzb/hsczoR739LcxfTrWHUXLOkmBsL+PpZ
 +3GNOocbvY0sEZLy4S6VOlDV0uWwKvaPpMMEYd796PEM9fDY/WIGMk8eFTmPgp3yXnGFWcBA+
 k3j3bybjGzNzzvsPO4WmZcVb9VUiaK8qj/LVo7bkITjl0kl6qyJ1i4gjdtiAF9pWOiv2VI9c+
 XiHcaCWpz9hW7swuReMLqbvV0NGtB1+4N6/NVFCF0ainA4fIvnTZprkNYBKwigMOCsA6xn4SH
 HMFv8gkaM37ec6kpPI7NSlS24JCR9WgpObET2neYbWN7vJLmh5665U6XOJB/FO10y0QKo6K7M
 SJT7IVsU5cscFNUmgK+j9wQOnpXfmOrS1MVhJozEKRid7/uTRcfsMEOwdFemCzD3L06m39T8n
 sxJxKiQJao+e2mmBp7U5OuHjzvbdYy9krZnUOxgAr9U1vX8D79GTmQcWoYuTpZCAQu5L5NrIh
 tn46cCFH4qEhxpQQF7LaVn2ESYvx/LzvcfY1UYuesJHDSUAj97tDWaWxCKh1afPg3ZVwoirBO
 kOXZx4oG8W6CDXXCLXm+48Kbh1P5+Sc0KPosxClCDDiImF3RJsAJvV0LiSDwU4J/prBoUPku5
 sGXagetEOTHTp4Z9+Bxd8fVZ3boICmhOBh+R0BcWiQevV7R2SepPcyT39jUjZxcYGtUyANY0T
 cK6I6fFE9BwWeMuuRXNlLGoHAZQC+mtW6884364BdmT+T7p0sUCIlOEx5cWgSdAJcm7FRK1zs
 0L4E+FUWvrl7QpFIoGC/fSyK16QwEwV4FYUz6GQQxgG+JB4Jb2uDzqsuwzqeeGehBQCK610BU
 fAtzi3End0+/Ec8pOrDweBr7v627rxXoxpfIb73ECeUw2SSvTME9VrMYWpqouOsgpBALCKhlp
 6U/uIurUtT0ZBA6ZOs3lsxK+XbsDNwpnjNInHEGFcfYsNnQxYq1s1B8OCssctM8qM5ElA==

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
