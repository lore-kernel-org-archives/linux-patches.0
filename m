Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9D12857FA
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 13:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767964679; cv=none; b=FlzrRdS7iGiixklTfuXku3j5Q0mnYLggzFajhPsh52NzAJdIaJfCgWD51qvELKJ1jrUXteCDSSa9q9Rl/iKWM6uw4FRx4mbrDEdmT94FF4UxcrgwFD5nJ/UZki4sJUJFxy8qB/leA8IMdQvXBcCDDDyzMvNR5+UULlRyDPAvmcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767964679; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eOgSPRjgoGcwSwHMRdAbRFSGXOYblq2rCC+2yzwTUXV0TppvbC2EqAmpOYcdFZDiMPqg2/oron5XIzw5vEW/lPK7QCfEQ54GqeYY5InKOzRGoW/ub/1jlD5h9Xo8eXLEbrTw3WqTFd0ySQ+E2QYguf4ON6g6Rkik0uFM7ywVb3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=BfhCXra8; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="BfhCXra8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1767964666; x=1768569466; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=BfhCXra8es73FJJ2hfFLvB0E2dOVXqJR9WfMFhjrPXRTKAT3HPt589Qtm+FCOHNL
	 OX124xyECHuM4wt1NbZ+ZqL0iTBJtgf32LKeYxo2T+9a7oj2++qwx/h+DPEVNtf5B
	 VXYbxXoWYCBQdNHhhnAHnEXfsQnLyWj3tFZMpyW/KmCprYNW2eSdEsFPVHBJIsw8e
	 Aq1ZkMBrmv7hbSVRaeX8ZGAQoLTYF1RThKAvQuFY+efJNtEvWunu7+wren/5mgxiz
	 hUGt99d6svU4Wd4YTeb2YVeVvu/7t9RUBZo1kjQsFx3/zJZxz6UZ5CO9o0JlQvyLw
	 FAXLup0Oz6BfLu1FMQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.225]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MybKf-1w3X9D0xvZ-00wBG3; Fri, 09
 Jan 2026 14:17:46 +0100
Message-ID: <7959eb36-a916-4232-af5a-cdeb71fe1106@gmx.de>
Date: Fri, 9 Jan 2026 14:17:43 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260109111950.344681501@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:gGdareBbHE3OG36YmgQt8r5gALyZIrPtwJ702nA/U6RKY5h08Cq
 kxVkhraN5ldiiH8jed737QJ8Ocax77Vq8h/gYmrzu4a+o+sPLBZa5xj9oZPd2ay5n7R3cVd
 DoqEPBElEdpC5QkCioH/V5v/rvwLB6PgLo6b1RYpZ6L76gfCf2kUIcJdQ+PmfgaNflKt9EY
 gRcYj3SUeyWIcKprxsztA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Uib/vOEdVWs=;NjWZ5kiFWbSYIoZZTfbCfo2nB79
 +Mh5FmrWeqpR59/IAalUtWdCrIGjCfGSTafepgTEe0S8rlTRfF6ES2Ex0NjQbrJHcXYbeyu8r
 2Ep3zJEvGNSuhvWkZ3NutoIOmA1zbyk5S+FN6uJhTC6aRTlJNfYyqdFj/Z9MkzacP+sSSNt9x
 8G4OyR51Mmxh6dPcuLZZAAUzlXZ4I7hQiemjRIZvOrFTKyiuRXzR/E0tC/D78nwhDAT2T8gBG
 ie0X7MdRx5FmHfmyYqfL7AKeewxIk9o+XCO+Csk2feDAANQ6MtqBZso0E6nmIhAvjiKDUrxKU
 AO7RnOFWzkB5ljqeIBOG/Omk8cwm2eRGu6vBlKMPRw+SkVN+CM2leC+IKGLCOVPInAKhS5x/k
 Fo+rHtTdMbhX6Wp+XvGLefYV7rvXfZgAPxv8IwysR5aNE1Bc6qrm5NIN+IPb6NZsJYVnn7qJi
 4pb5BiK0DRPvplzyKtaWSPw2a1qTkXubZEC8ABxJDxOJOx3vM3b5n311zZOqtdtNoT5jD+AFM
 aKZude+uAhagNu3t3I9gH6jwReWBh9Bev5AJ/8vTJ5VfEk0HswduIST/T/QPwOMMFp7c6m8UB
 M5z8kUN5PWffgxxmT13tBo+1kX1N9C07AQ3ChS/9T9rq0G/UxMrvf+pxEs7NZ3/clEeNgy5qt
 aPUOUT3zSNSX3bmSgiWtBGUFfEs+J8MmhEKRU2i+tf5+45nnDlF6oImTDkWXsxFrwVNFw6m5D
 +eXYzg+BlyC+N7BXNIocmn+rWZCd+GTc1xpVkIoycONx0F3vzcX3J9cQmVfTB5rxabHGggVom
 36Ih5wuNBknFgQAP8HajUgoNChLLYok4yqMjecKzD8YrZnmMltpDH0/aBBoqWdcQ7OiQl6m8x
 M/J7jQhpaui7XFtWI/AyqujTI43zBmomLEaRr3amv+OqiSLY0LprmBIolsEDjgMDB75lrEjBN
 fenIsyjAJyxZYBO7gQ520omFyPuyp9NaWzOpqSi+L6JGHiF+yoBlh8xfP549ouY7ndsBIBwQX
 f7Wvo30yi+bBP/X07QVVTUnwBSJYa5rBGSboGYnFAUBMQC1rJ26PY0nRerJpJ1ZNTzHYFE+Ss
 Xr72z98Bt2O+4nUxPpFz1i2G5hR0DLFbnjMiS9Sx7nthJaSoca1mHWUhfWUr1GfbH3ihGFzWR
 lb7fFcl2qfd/iAk4MOouDzM5GugWT2ZdRb+hviuADtX6Pspy/Df+AyMKRvTsHEsw214hFEL7s
 4XHMOW+eyKC0Lp+1YmJ+7e8XCmOvzUcCGmLR+hBJXRxOWyHNr28Xa/WZeSCMeDkhAcxLAnhZz
 D17wDetn3A7mHV0CQ+DFNgr8Bx40r5E3R6PKFNC7jESizBI6I5kIcuoUaGIhULpzYl+yx4EFL
 ZMs9+1O0XSFlMxsGeFFYA6IiwUVLj/hg2RiO13KGetIPdUyniO8/Rf7IRFlykhjnaAZ7z2opt
 jKlh5oxD1jPg0ADm3W3jUh/9GPYwzJ2eDTUnMcRE/It+OHg8dH/LypSHNzwg9y6LPne/WDAWn
 Oef5Ig79Jxp/XYaN6A/nhVL5NtM312sSaTVa4FOLXoQ9sqdYQ1SyP5o8CwALVU+pPcDTaMMht
 Ty4we9/VSYrGc8Hs3Ih5g793EU9fa9T3/AUTTJ9Sb33/kUI6pTjf8kUaQzfgDLKiYpuTyhjiS
 jtAE1xXoFS1I/uOBd30OZ7D7Pr4FV03VrLeBYgZV3OQyGHKEuIud6azk3vJIQ9YuIYFDqdXDY
 GW/iKI1QDq2XqIAkoKjJE/ej8q7PJrnFQu7NkJUD9GQ3WhAc25NJ0Db7TY17X5V/KTxgfD3XP
 pLSs/MufudGwLVLuuCYLPVH+amWFmZ+nuD49a8e6/XKqToc6HZUqJUV9MQrScCHi1eaGggj7H
 IlIqL24ryOgQrNSm72SKwaGAeUMwCdycsM69Y6ynoUASeNz5AHbBb/kDRwCg9WWO7fFS/VMoD
 +6PEoVMMDiev4rq/R2SjVe13U91K3dWMykA/tus8W/EcfoPMnkdcC35YFNAG5q4cxMjqejDWU
 ypylY0+H2yM2GpuG22D6KNdNz1vfgOjOtODQU0tvBYesbvgdZ0t50ZQEsKzki30q/LejnwudY
 g5ZwdU+BN8VhYczM73Ix+ksHrz4aru0TRdqh0EJVni6JLBEilEtxwhVPxo7LTHsbQfmfsf3gf
 Hxy6AF/elwLjGAjGhu8TsBlxu4NQu5bRPEVKKp+RDmlvhQ46RzUSiuLc1UExmu530/wIJ7PbT
 3eWGPWtsGML2e+iQzgQlQoXvhv1W2Y0SiEJJd5mhNEz1eCyrLeM+NNjbLE5A2+17vookiv4+/
 kjhdnZ293Bf9HJnYQWpjb8CuZgL0pOxRAacb9z/vqFrQ7qWaIm1lipcsF5zmQU8YxIztZ2j2u
 mrs75ktMuAbE4w8ZESiFrHd64ObGOcjZOAfp+91U8OwC8jKBEc90u/AGRktDqo+VJBGad6/tZ
 0vZwuJSN9GYImJgdR5AI2AKbtRH4KQHlubize0m4scAZFw1RnrFwCx2nBh4qp40a7Z8zo4jzR
 ZLxHuBLSBV4fxC8vNl9F3YYnvxGq7XO5qWVZG8bqx2x0PkXWmgHa/go77qYBwcMN/TqG22rjQ
 9hP5D3yIZ6LDEmUXZn7b3SvvUK3vkTSNlV1C6mG7tMmcjUiLH+gfu45wOCv/XMTby1emN1kVx
 QExX6caqdtOxwOs68uLrymQYMncmAkzEOyuLWuG0KdpvPj9pyYI+zeRaz0RTatkb7UuQ/NIAP
 McO5txBBQ/YvG4Et7hYs2bKJSR6ZK7lK9r5VyV7f3JruYpBR2/0QQzLNmHAsi5Uv66OpZ02Qy
 3bpHeqyQn006Nbjfr+FPIxXJUVsuWzMCAzhm1EIoHb61qc6g1Ma16tbHzJhv0tMKuk8Yo78qj
 c6bauVvr46Wb6sE4TAB7whJjWjH7AejSZiQWKpTZ39JzWRhK0yCLywKb6qGM0cpujUYoWoaXa
 FCcTaDEeY3XEYCE8Nv8unkqmsHN5RRlAjdgdYAGo5BDYxHGb/0cqd2RErPaHxh2ymsrJcJNsi
 Ekd4x6NepnkriTrKxhSSN3WByYDBAgQj81UKhqH8H6WYSYUAKPSEqs8CpG6EMrX4+bGon0vJp
 a55HfSIbyd94MYmTt0tpSp3bAmitpkR8yA1QswWaMLY5I4YT5WH7iciU6cj2tPT7GVc5Cw4at
 6DUh1xigV8VYeJWt6zipDZBnKAXHyfHuk0ewgvmmNT+FMJ8W1sns76YYAE5i5K4JqW4H/esdj
 7SysmqyiQFT0+qF/hghEXUOXjlrD0M5z2n2jmWhm/8Vp45wJQyYblHIPgNJK217axbbhViHMF
 vmhs52SZYn09Aj6sZx4LM87RTCA5C5FmacddHWCDwivUKlC6y7L8PBxt4XkxLBCwUKgLn0L6B
 DPmRLI+cqO6KbZUiYS+qCz5sWmw76WO/8GeyOhTksaki8kUaAm1WOagfqoVMF7qCmBHhH9vx+
 16bmX6HqSVy334J5y/wJjyN8433qFCnv9NoXSx79sxuHB5p1jZV6ev6qRJfU7/YQh9y8Io8cw
 V5lte4Bx6LQAU2SYtrFyrAE4OjcB/S5CAuFV+gvO+gQWlRY9YjT+n9ae0bq+uDMkItKIypxw1
 p5TTNqZIAl+nAF5kP8p4T0QS/TfDNiVMdQfVB3kSL6/lVgfExNBLwn6jawaKQR7dXrg1GDl5a
 WB4Nn8N2el7TaY/4/vYbVUnN8p0qO0wkyx+ub8bgaao9WiV079ZfIAKC6PJHLSu3k95ojkh1B
 BLgqUkGz7mlKrvB0+IsQ3oq7K0+yzLydj5duykDfoOFv4frspdV/Nk6nU9km2glRPvEj+wWYe
 mft0o9U7o4imFMi3PUNnn+bqjpWcl6AvyC1lwhFlq9TI6IvoR9fCxLx39sqeT24ljnZ2ntZqT
 VQT7TnxRi9j/n+jfWRQDsRVLiOw94WR3FAKymv0upFcsA0bACIuzH6qT4kjMgp3Rj+KWoYgE4
 0YWV9qDmVEzU8jeUEdiyVy3JYW11QwMfTr13xOsrvPfIpRG05yTyf5Qr7wui5f3PAuyuv39mF
 P7BS+bc8ISgi1W4qY+aTxmZVcjj96CP3+cNZeK3ZfvJOUnZv/l0sHpihRJuAHQljGYS1PovaS
 He/wD/9cFfSvTQa9krYP7Id4meuicAVlsx8835oan/zIyWdTQfhE2EDDQb0dQAWXrCmQSBWiV
 nh5gue2lBZDuIhZUhBagWEgFQ9SK15poZW1C7Ecx/5uo19X8wVED+RcwH1y2Ff00IRb9kx/JR
 vnwZ/GKsI+ygDuEiaQhdERB5cjuCfJcTFKynzFgVi5GDb7TmNqP5EuwbxmiDuwt7mM++hXhAT
 x2oqR0y1ugEqHMzS9wr+JJ5KEPdteWpAoB9NfgSTM6GQ9qvJqiJlshdfJuPxESnbyagvuMnph
 J4EDff32iJOL96aQ4mEbBItsLuk/Gzj0T90KQ7MSln/ukeBhByOMxQoGyVeqhnqzIduV6s7BK
 e25E4UWehL/XHVc02vvZGgaoy/8HSEir/ahZGPgE510elIo+gYmOBgl564IaI2qlWJ35amXoN
 V7/njR2TwnTnnSbmUWa5l5zT+L5JBlNzGJxOnIruu2YnAI2ypj/n+Pb5kqHCUr01BhxRSndRt
 b4cc4GsFRlwLfccDhss4xTceqPHQ/DLDL1hXOc43SABcz2ii1DsfEck0kfUDp0qdh4zHBHFuP
 5jfkRQ+OIIeP/nhQGPfx0OU04uQebWGlEpCBjL6NA5DyemNsVTqAuEJoFJW9bEg/1150Gb8c3
 VbiVFkyXOLYeNKhnXKEjNMVY2r7Y2wZUSIJhPumV5zYuFSzpOZH5HLFmpJdcnxbj9q36pF6sf
 AvPTW0QlFCZaPNEAYNj7cF2YEMb7Nz8y40/Zbt1BTel6Lz5si8anRfppzzhqPTz4QToVB8QRY
 +N18lkvO4Bhvu3Cc4qtvv9GnyAEuoxapl9hYrnwLfL81UZaYtfEtX4/5cnMrvIn6KiJSvww4d
 V39fYj4ooGqmYTy6PtlyWe1VU5e3jurSuPSVRKmECuqHYlrEOBIHwD6Hv/1biuEGaXcfr2C66
 z2F/7I2WJ16RzGFEKl7fUg98vk=

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
