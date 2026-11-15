Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794708170;
	b=1t2OEb6znEWrwP0L7gQJOKYTGI+Rgh6sDiZvjluj2d0Qd5sD8TUOpxl5UtPuBoiuzLzF
	 nvTkSZ5XfqjK37ZA9u+hi3osUv6hn82NaoQYX/yYsriAniHuXdUQ9Ifskbd9dhj3kA+uJ
	 1fN2dWypH5eXzVfDKc0WbHC/RT6q1moFetrS6sy4lhTmrO1sSY2Wevhk7ec8l0xRNIwKo
	 7MQbetxT0kNDGWMxkgjzsgmZO3XJACRhg7uHqcpBPMzabevH8W/Icylw3LpfFyKT0A1fS
	 PYD1if8DCiTY7ZTmiMyfVhCjyTAeWNU2Lxi3DtARVct6sPz+1Wj2b4h3esfQGdbPzNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794708170;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=xgSiOUry8/4GQSmtt4XirsMA0TN+qnFqTSFR2WzxbOg=;
	b=0WNsxBJ8mfb5+B7WN43Ft9zGSvAbWoX2V5U1Y99XgGLYWbX8HT+cYkCrtTHIG5VhuHCv
	 WUqyQiNzhluj8fNFtEhkwlkVcdU3HgvBgVMwg3RS5YUE+JQyLtQiUO/dB+lJHJerJ1h+Z
	 kd81DmyltiJiZ8ZZMHL67nHPtfguXE1tQt2z1soO8IWcu/oCGmaIyUUk8OexhUlVnqpqY
	 l3YJI1yecbduePDoQc8Wq0De1wTx0jytSOt90IL37he+gPzXJ4w1PEspvcanmQw1x62ts
	 AF+OqO+ufnktCr/jUC8ILpmKvkbeDU2GiMgw8TtUEwQ36UxMFgf+CzXAvTv57LDewTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=jpltLqPc;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=4haMV33o;
	arc=none smtp.remote-ip=103.168.172.155
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387F9606A327
	for <patches@lists.linux.dev>; Sun, 15 Nov 2026 02:02:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 387F9606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=jpltLqPc;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=4haMV33o
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 59A6C1400035
	for <patches@lists.linux.dev>; Sat, 14 Nov 2026 21:02:48 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-09.internal (MEProxy); Sat, 14 Nov 2026 21:02:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794708168;
	 x=1794794568; bh=xgSiOUry8/4GQSmtt4XirsMA0TN+qnFqTSFR2WzxbOg=; b=
	jpltLqPc+1cMXe8U/4NNjhTBF07N1HJLp5JaxV4gXQzRZlv5sIGERY9JKds5Z9yg
	Nzdj38K1xBxpbWkwksuFK8KcawJQlmhNS+ATLBTxA48j++/Sk4gFO6lNyX+g3J7T
	ejVxjv4QrYjpuPKwlPWKXJ8oiiKPcSu/36V2ynaqITfJlbcSpW1wo7YsjyQvzuV2
	pXWt7HDtSdo59RBgtPtVIRnpyoOdyUG7uQmqP1ev7Dn/cCYL+BHg1WH3EBmwP4il
	wYSj2vktsd6pmlz2VYwAkrsACUysRUgmeLUU10AhRgrsjbjuZAfLKoF8+LV/IKtl
	OTH+h/WjRBXZ2nxltvgBnQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794708168; x=
	1794794568; bh=xgSiOUry8/4GQSmtt4XirsMA0TN+qnFqTSFR2WzxbOg=; b=4
	haMV33o8rJYNBBtMSnF5ghWdDrsxgk8USzpPZBdpgN9cVMu10LFy1Ycqwx9PBmvy
	4L5ooYYTLRZYUdwkWdGJJWzulrt1cnKTmYMW3wb6eYAPz3jaYkyOoO/71TLdJE3V
	HeSBxANeu2etF6Hvoz7m5JTXUFOjusTuP+ivB2yVawfqmhI7sUHxE5V/6YqVOZua
	5TgvHFOzRouLwJRAW4PAwd/+PsfV7WkIETOUYQI/V07mI/+yFF5YQNRQAKWfJyuF
	tsp4j/UzyfUBXlTry0R0x4MkX8TMSFmEYDwk020PuKTeOSrdSkwcoGE/bfmTu7wN
	qava5rk2qrlZXNDGQw8pA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794708168; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:DzzQVcZyiktHkT8GEqbESw1816NLeUQ0CxudPLbZYXcuCKx
	nFrCN/hE4MW3bX5jFmr+0KKzxIkCAw1jy35nkELRbZ4Bm8j9sqaaya9u1c7V3K+R
	8FwdDXe5DTfwxnc2TBRkOBThnAqeTPunmGf8qaH1elLh+HAUaORFHSVjFDpjjoc9
	GESlGTZvCQ0eE+DGZpkkP8XQw514skaIDQsTno1Q9FAd+yOHRNjCEwYU7ePqEsX5
	/ul5grSXY8q0XXQZYMQGTiCER4Y17ImbVhHKn69yOYMcnUfkEsa7iA8T/9FCh0VA
	mbO+lEtqjkYd/Vdxg9zQ5kUuIa+D8hCXA6qRBmA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:FFMOKhGJ9p5eEH2DWlocJU0y0igLo2sjuCpJrZ4TlrE=:Tpw3Non5gE6pOfwR95MYUuG0UIe4k4tfuqOTIQe75TI=;
X-ME-Sender: <xms:xxL5aq1nOGhKMVoze3UkOdBNoD2EMM_t8CGYGS-hySl20DKiv8FEVA>
    <xme:xxL5ao_hqIIuhdC8obRYOMqsZxyOXvwAZvFYjmXiRq3t_Cgq3kH7TY5HWnnb6wWAc
    pQ_lBdgRiuXAqJOB9WrUgvoEQZNCW_4H7GLUmSRJkrRU6ofbSy9E6E>
X-ME-Received: <xmr:xxL5auZqdlfqnyRwfOHAKdmJObz2InV71Aa9dE3azzW4fr6aNCNurzR-lwswTFVOrNslPb--TTerz5ywjrHfF0fWBby-h989>
X-ME-Proxy-Cause: dmFkZTEBnDdc4pznVckitJbI95Pg4sruqJ/c4GzT1RFlylgcChDtglOD1navQFQG9T4WdT
    LXPCzMsSu7+oOpY/tjKnfqRsuvXzo79H7cOA+v8kIeagruBSfkGe1+uq5oeBHFGJxFr+36
    AL1dyct1h4wr3rBmLn9Mb4ldooOvCJeU/TUZucAGYD3qu7WQf20bmLL323jDt17o5E5bJd
    APKGrDsMvQH8nXrriEODv1pzjIWhRVRoWXpqc25IvCd8u8I1ys+BU52SWIU1KX0u7NkRcN
    f8RnJ7Er57suWh3UQVFeSXdvs5JOoNqt9S4CjwofcljgVELRsd3VxZ+7ZrtCw/esE8y3b7
    /dBG2vrnnO8SKWNmcG3dsndWf1biHJlej4f1ljsec9wVKAjrb18RMjAeRD/aCOyrHW99mS
    4pqtfeJI13SWVbp5YsBkIOU4sSMXmsaQ6+3BoEeICygVGxS6PKpRE+WGCOAVrLLRekQB6w
    bNEwAO7Q2Vm2URk9D9lKEXS8/m4ue1ZonxwuXy9SIfJA2GyuAQ/qR+EibuGeYL7xKQYKn8
    /68V8pfketRlDNN1dqxK6g0tQDk1a9VgKMR1jEAhZ+caP/o0JQfG3Zoxauh0eWxxhpIgAf
    xfbPJJQHuln0cm5vVodt+hvcDl3V1Gbu+LMxwnbVatrU6X8R06xC5DoMLqPg
X-ME-Proxy: <xmx:xxL5avwR8fRZofkKhc99HzlOq0JBscni2uz8TmbXvJMNUgbhlO1G-Q>
    <xmx:xxL5ak_JiHhyG6a4W6jMxbHylA_JRapgiQs_nroXTeNngL3MfeFB6A>
    <xmx:xxL5ajxHSg7--_Eot-wiG4yOrh7X_x5udtjzNeiHP6V3DSy9taSfMg>
    <xmx:xxL5ahteuo7yxBCJEaPn2OVoilGuzOCBCqcWERFosfuSNtuwqiQf7Q>
    <xmx:yBL5anIzwXDe2ioczJ87icRmiKppHm2Y2h8Is0__2b-fCef22e2ytdAH>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 14 Nov 2026 21:02:44 -0500 (EST)
Message-ID: <e750f93e-1378-412c-b213-4d0e1408c067@pobox.com>
Date: Sat, 14 Nov 2026 18:02:43 -0800
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
Subject: Re: [PATCH 6.18 000/686] 6.18.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261113153820.902362109@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 7:42 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.64 release.
> There are 686 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on my Lenovo ThinkPad T14 Gen 1 and an arm64 virtual machine.
Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
