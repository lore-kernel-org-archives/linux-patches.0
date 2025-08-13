Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171222ECE9B
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 11:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755085223; cv=none; b=Tzy9GMCKT9c9hDo4fjKOTdQ+9m0jiwkFUhNR/oSlbE2ezAWtL9IT+O1CvXJCODj57psqhVSqtpp+ZvrbHL2Xn087R12KnjxCMCNGoBT4P7bw+m2XPdowzlDP2MoHdArdVKtAlC1KYZHSZF3hSRguCio7p46toQHRmSBerSx4Uk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755085223; c=relaxed/simple;
	bh=xpRGxjI3aaWc8kYxd/WTYp4luIz0rhE5gTeURdJgB08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+RK1tNbOJzNYNB5DxMABX5arXRisLveRQIoX0p/4CbNQrKKfU7TO8E59wGs/Xk+948q6aomhq2buPDOIOm/or7ObJD+ifMWFD2zAynUkUct7F6O6b/ZhJzJ7wrVpf+GCB0WXdRhjSppmYMJE4utDFAk/jUa93MYZtYFS0lh5U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=rDXjGoKU; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="rDXjGoKU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1755085176; x=1755689976; i=frank.scheiner@web.de;
	bh=I1KPvMUpy6ujWmI8xRsu0ydgC0ZZ35aU6/IEdY4nsg0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rDXjGoKU203bviU9gRAq5Bc9djAedbu1z1HjZMK7Xc92J6Gtv/BTU6PRJvWgCh75
	 9mSu5T9U5hqXTHMJleArT05MTunQY8W8LgIgn71Uksm0FUXA1QudzMdK3XwS8ofwB
	 N7fIgtvY6VIM7YODoi5RRJlEp8+cYcvnicSZHEuXk3+2byArlGvxbr9llo20Vy+At
	 7LrI55eFafInALkG3jh/tr/gXfMQasJONRo8xN8EPQwIXVajLWbPx41d0WbVE2/X7
	 ZImx/3tlFAbRY+7XrGULSmkwOouXo9HHGxCWX51xzejnGOmtkG5JQvs0i3Fjcx3lj
	 ESSr4MTGpHYQAGdNNw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.30] ([84.152.242.163]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MDdy7-1uueXX0EGF-00B6gA; Wed, 13
 Aug 2025 13:39:36 +0200
Message-ID: <88337bf0-0a47-457d-8e0e-ed707fd6a5c3@web.de>
Date: Wed, 13 Aug 2025 13:39:34 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250812173419.303046420@linuxfoundation.org>
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7MQPbvS3JVtR1aBZicdAKdd3wrGuTHoBhfPEBB0A8GX6js6Icel
 AcA9U4rmFXOVCB0DusuuKRhcO/xVKuFCNdDcBGdtDlhaifPqh4WvJrtfZbQcX8PiefQ5CSE
 wbO0zZ1z5BDtRuN39zLxmyd1EkundV5e1xGVvm/I27QrY3IzZNS+yYPhw/xgt1XrvKcaKLk
 JpbhgEq1bwxQGEyg+E6fg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:RC8h9Xhkbaw=;Cb/VfD12lsvAFC+PLVzdgQz6Mq4
 KpXCyjFtBFFtJB2mHHeH9UU/TaxNjaqH1nIdYc9UH92RTHgPQAx2wzyxwLShLEd7vgdq25NyI
 WSmi+mBv2vfxNQ98FvNpawCMqQJZbUZqOrZBOB+3btVF9+9euUJdlGCAS0t23sesUF4SJ2JmU
 0L5pGP3qBNLcE5F+xcHI8RASWix6WK1FKNz8jLgcpurniNwa842TzSVQMrOQTsiXuUwsPx8/m
 wDBiYRGTYIDlwtBTLEgxXnxiuR7DyduBE//fAxfAYTAiAS8Ti2a37Qy/Qvi91/hOzhdflvsE6
 8GPfTcweufkq0lZT/1IVM7h8ARgsytA8EzJ67wEBmXbAxqW6Zpi2io0T1vaZfI9v5EWo9tN3O
 BR9+Ki7ip1vQUY8fOqwQHQGAOwZv2ZFtJZSdKTaS0303HcPuyL7JXrpdfYdx4sW3KP2tfV4lB
 BRnYe2wvz/tlGo0jdv69+yOOlBCvobHFFZLvNqL7n9baciSAm3vvIwjX7MqVoxuq1a2JvelTq
 fe3FT5DHYm+xDwIq12t1qVCuHYWSKdyzZCPCvnKBf60MGwG36piwosAwNQLnJTjFCe68Yxesp
 5LknQ7qe+w+XP6RVTDY+S5fIY2d/Ld82BqgwG7YG3rW2PMi47QpEWGC9140SbAT7818Vwbyu0
 Av0U5dFNLCSdOyFggQs/5Plpe5JLcp0E+xHfMf487V/ZE1wg3IkmyGPbLrMHgsEyMeDUzmRQA
 S0Sq0opSBJCirvCqNBtlpqKs24NUr5QkYxjcWCPtCgZvPnBfL4njRroAw1NidYeCP0RPe4MJP
 /ZLhvf0mlggKe7+zs7Zyn9vzON/s/lhYo6uDy1hmIJClVIV1iGOFGqkdgCug6vnapkIchth0j
 8WsY72rl+wIyxg/9739CzlkVpta2Dfp5WaSoByZHO+IDMNHj50xi9lrsnpLcEGh1SYeM9lnyT
 7bhwfuZrXtEGjHR0Ns2ufxKnMhw2z+l+HJGTXOHJVebrAGPTl/ol1RO8UTzn6CN8ZxHJ9ujUt
 CwnU6HZjm36LbV9ZsQ2LxK6JySJZaHhLo872SYMbwq2V9YMzRi1KfJCSg6+ZC5/lz+7NSF8Kd
 AthgSVC3671oixIcb+khOiiyZ2Uf9j/j4g2/rD8/2VQiFz+SU/mF+oNNaor32Rj2w+4FDVSTx
 ShCB06cOucZ7MZ969N4lzU+6Z9p7+7KxM1nIw6mmSskFOzsBSNXiFpDWx6lSmtscjCX2qb7Ig
 nQqSbBzB7/oxncMmfbTo15SlZkcPjlxtIt5/BX6Iz8EHg1dw9enFpVWm9STNQgRCThHBEYmvg
 x3yXqLC9lT22g9SKTbVtmBOLSQnw1hqBoeA/fFVu1JsQycrE/TRLlDa0IHovygIECZDPPksNF
 NafzXMLMmluvrsT9H2qSTUXqtn2SPLhMiOGPP8qMs+P5/4S8QAcrieWn+l06N9qMKcxqnW/XO
 Q3eGtBku1+F6lnH+E97RCQRM/Vod6N34Ja66SwdQgNZfqEgl9F1U+ZEuMD51Yt5h70SWOvhGV
 4c7xYLCZNl0WkT4pvoVORGaB/YmU8ylty6TNa+2+EuqIOiWAZUXJHDKLtlqG/ssXYsghfV+49
 BD4/LU1lXi2bEgODFj9eZEHzEBaPOOXL7jUfByNRIktzf1L/ZuRx2Afw+OHiT8m2uq/pRQZrf
 vYT6Ii/a+5X3XrEZ6Np1xvTrKfkcvYe+j4PBpNtsmxEK9BZGkqkRC2ldEJIOB+elvnzexJNz6
 0ZRW/UkfinTGrqOe/jPqQwh07POe+l7V/o17uu2OtnkcLRvs0kYOV4Kfk7+LWE/8MzmZW7XlS
 H77D7WlAuJoxlxLgn4moAGnXpuM/CeNye7TesDiY2ad88xA3ixqoTybga0n15GBObvth71fIb
 blnvJ79GBuc8K5MTYr2zFirwfUj4IY4FwUpsPgv1DNTsmcYfOXTzkR2hAYNwNORSrQSn+f1zn
 i0Dgn7OSN9MwSAFFdVmJhzzWIRiUw/4B4BUAAEN6UmOOeifzTHz8p9t0lVx8a0VGz8XFAPUsf
 Uncp78Xt4NE3ZXrzVl3AEPiydqZp5IxT6IcPEdfJrGebovS+3x5699p4unjsvqp/ib0cCjhmh
 iFZzOesCxLU+tfKwWw9nrFsvfHnWRNT6NYEj8jeJnYXT4jTOz+c0i/kqf+W97/RWk/M+buZPd
 /CAuHkJ8pxrPupvgTVFvOzOtF3G8GnPeYH0gbQ08A1Vo7sdiq+NgdO3Q4XDtb76i8fPdzpl3g
 R90bmp1L4ubNYyf0qIAAWNRSXfKu24I5N4VfmhgjRoEwkl8+rISYEChPNG9XToCAwQfhYGq0d
 eIrGvQcxgxgvqVA1CzyVGA+8amU7KQTZ2SyBtWZLBMz88/Ex0+pLizy5HE2lfW7s6tP1ep7fz
 qUonVyIz16lhVKEJVFd7XAJ5iWwYDZ/Ge9Gj+mKBoxr1b1N+OPF2FUewpZeXjsDN02kHjUGkb
 JQ0oRB0Chh+aE23o/6bRsUrftSeLWMv8Bkjl5QJzf7ci6dl8wRd2yhEvbIhCe3NyUOSchTCJ2
 Lj/kvD6r222atbH66Kk+mzikffkt/0xELhHukGq7uRAZPH5XLIQGk9Wuk5n3mg2GAOJQeFZ2Q
 3uURDrpikFcWUkgGq1cvtJ+xfTL6+HILtgdMB/ysyTJPBaDU9/VRae2wdzk9C3UjF7rcFYMQz
 ZnshEpB0v3VbG+dwdBj/lgRpwxrGcYv/EXqfSIdsi2+NC3UyatNOp4M1x9CcND2aXm2y3jh8H
 s3iq0sA1YDYFT4G8ViB9xO8/HQb3Vy//OO4xzePmZ9Luks1YkgDiMF00AwnqPbdljWSqSKlEC
 1kMCTNHw/e0E75TbEi7lgsIgkFfXAhNgFog5sBwRlvlWSQSHAMbtiQPRZNCPCjCMSmchCv0EU
 cbWD+eav+47PdQZpUv3DXC3pJfdYKyCWdCvIBCpdA5qa1xWHHAeEkbJaiI7MXGPMFhHRStnmB
 Cd1KTFEMNeBhwtRR542XZw6zKHyo6GGRah7WR6Bhqp/DqDlWahXYYjpkY18zGTL5l+0XFsZon
 P+Y40H0810GZRtG1OwcuXNgKuJcMPIc1AH7o0M55qn8R6Ihf28NRY56Cksh/+RrprNV9kfQZt
 GTc2IDHzqBhO/mbbZpnhNXJhtva8xudEoBm+kQy7ONbfYwzrl0qH2HDZLudIoxxblr/Z2swKs
 eS1l/MqXoEyyu4HFOXCDX+rPmHpgmWDyssahFRuV2sD5W/QiuFLfBISZDX1ZcTdgC/EDLY0L9
 CNBvs2jAfE3r2785Ue8ikG6ScW0borbU0gJtzzUy26q1LcwvcwK4Z+fPeh7k8Zgdi7cvIsUIV
 FixJF6WrOwhlIWXuB/AJBazdk048k5uSwYKY8ej456fVVLYGnWZDl1wBP9Fw/zl46crDrTieM
 mqPA/4WJ4cwiUHFAk3FA==

On 12.08.25 19:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.1 release.
> There are 627 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 14 Aug 2025 17:32:40 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.1=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.gi=
t linux-6.16.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

Cross-builds for ia64/hp-sim and runs fine in Ski ([1]).

[1]: https://github.com/linux-ia64/linux-stable-rc/actions/runs/1693371933=
0#summary-47986210868

Tested-by: Frank Scheiner <frank.scheiner@web.de>

Cheers,
Frank

