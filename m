Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83965485CD1
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 13:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787318661; cv=none; b=LTvjOeRsTeuP9Fg7r8fJgSf58eaUwDyUtCF7+mFI7CHj4a4OU/Bb7R2YUxC89DHJ6tzVCOGUsYoWOfB8MWfQE1JViYWZs6T/CCId7HwAlLrYYkEMCUF390FohNo8tDyUdlsqMQmsJDZp461L8XqtWZrjP+YBCpIMp0r2mfvWkpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787318661; c=relaxed/simple;
	bh=0KeAh2yZQ4/JEBjlAjH72kjPeo27SYU2lWuAvxRubTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FKGBHtchqcclUfIspHtTkU/mXtA5H7oaMAni/x4/tgiIQ/cuhn3NzjPOfEjyh7IZ6H93jS0Mn4SPr/DX2p0sqFxrzQ3m42yl8LmzbEL485Ce9yagEY1OTDY69SdFV/2ED3cGAlpKIb+fm5gdREXuaJbSSjRdPunEmwkT2EDzd6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=mZQVCZY4; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OArAfgxF; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="mZQVCZY4";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OArAfgxF"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 269F07A009B;
	Fri, 21 Aug 2026 09:24:13 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-05.internal (MEProxy); Fri, 21 Aug 2026 09:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787318653;
	 x=1787405053; bh=3OcZOneH84uMUHuqcJlM3UioXw3CQO4uTwxF3T77Seo=; b=
	mZQVCZY4qviuTBoOdYtXqQzF5wUEkiD7WhlA5QzFAGW4I7AUb2p3frJXqKiMtRef
	GrtlNvtpyw0UXB4gWQ+xGqA0R9knWU0X0jMGQ74qmjbJ/hQt8vVmFSXHl7YMlrW0
	McJGJJY6FhlFj7D7YYt6/n/g3BnFbrE7B5wuk7OfNotXCYyxz/YtSKkuFnTQW919
	NywzHXoNcC6hcek9W4xgjBqGv1brlWy2yEg6iivhi6qMsQW9Slygm6I0quYBBYid
	sv7Cx2IC2UJ+xDKEPRFgKxSktpw5dEPghOUWpv2qlMMob88oYevZrHcGLhCjYTI7
	1FEtHMeGbbtxWTA+ncrEbg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787318653; x=
	1787405053; bh=3OcZOneH84uMUHuqcJlM3UioXw3CQO4uTwxF3T77Seo=; b=O
	ArAfgxF4JWESUNhDM0wbyyknxvJtVZRpwg2GC2wAH4Qe6vhF6L2t9oMetFTyYLFr
	tLUguikGSgaHo9e2e0TockB9hWLM7G4/hd+bZ5pNavpFosFEntd5P2ClkXjM9E7B
	JmbtVNrZKYQO6OAGew5e3p3pXwYuYc35j1k0yCjnCm6qgmafJ+XxeKytlu5ZgUfg
	5Wd4Slm5H9PpN9sQiSYvg6ZLs/oZ8ZRbBEZu58yrccHLUB9I+PHloOtHfac5Z+ig
	/KeF3WypcJTQ1eilAvZV0b8CsTpuDFNU7xgZ9wEcT2W60R4wb3QcFGDULeWRArY1
	4d+YorkaH562XynDRpxmQ==
X-ME-Sender: <xms:fFGIar9E2V8y1rGj6wCEQtEo3XYlHS3orw02_Ebk2QuDiGILhJQ_KQ>
    <xme:fFGIajkuXeHGacvM3LyZIZ8lul07kWToD1hgS7rJmhCXK9qx-xiIXI1pc8sxr-n9V
    eddX8HUWxGpAMUVvBkUbdYSd1kCAD_GiI5pv4FVkqAMinSoHUw5qs0>
X-ME-Received: <xmr:fFGIakjL078fQZ6FnGLa9Ko4XelZE5j-v1KJsfbhc3UmVEFYk538wBRv2v1pNwL15aS13AjLTw_oJeven_fMw7vWeC9kEJl6>
X-ME-Proxy-Cause: dmFkZTE0dgeGrkFtExipsGvFxrlukiTCyhW8juZDcRxWB7HruDPtRi+cEjF5fpNXhqEfLy
    1POzEkpwnLbp2TKo2DROkP5fzezrNae41A/uihjcK/n8j+KCxZlX+3k1wH15SdzbimQ+4L
    jaGMKRb2qVAePcD0awLL7x+O3ARamG9258V09IO2PD/zG2wusSk9WuSJlf1w0Ld7J13hul
    JPVapoSS2jyiH2/pHqXTGTw5oXEQGL+uM2omTLHNgWOVLp5sgIk033NiDmxAgajhKmmvuv
    iVKNGD5OxJDn+8ebSZYsbmnBBmANQb3SRFbrkS0qVAn8JmWAJ4yqXp7xhCLeTfP1xRYlcb
    OF/frTo7oZ7KV9RZCKNGV8m9h/axT4kN0ixIJ4wFxHgqE49ou4YTaftOnG8o6QkGqgWhv+
    GnG1OBp53KXOfny9RO4TFE782IFlz63iCDD8Qv+tkxqrC7FFil1RnMbiOBkgRSuoxg/Yu0
    48sr1HXsabkVRHicDSyRe09NBjAQmjF4UbWphb6BCfcjgQ/6ee4oxA2qbhfEysUgF4P6B4
    wdUo6HQKmaIrw21QYmAj6oEmxHu18w2JLGefoPzReWjbjlMobPMkxDoNg/WFWPMghi7/ti
    jWWGMtZ5L6koFAm9TtL5bmWfVLJVasj+uhlQXVoKF71M2b2+Ta7QwpSEIR3A
X-ME-Proxy: <xmx:fFGIarYnox8eW1OyYEdLrag-zyeUo6rd3DByIopOsreDWXl9tEWBtw>
    <xmx:fFGIaoElWfmXe2hS-e8_C_jC6h-LPOsbI6nTTPSZwtanVe84rSj1hA>
    <xmx:fFGIaoZ07nPSuwIbgBMqk-uiLaUdYu6PVTuoYuFyGHk6C8SQetg3zw>
    <xmx:fFGIap0iikKgzOtK1s14KQXaTd2py_gxGymOyoBXfn_EMa7or8tUEQ>
    <xmx:fVGIajxbcTDRremBExfynunYN0E9uDB1SxPujFgS_Hy8Kc85IUA4HJNK>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Aug 2026 09:24:10 -0400 (EDT)
Message-ID: <00aa6275-65cc-45b1-98cb-ed2fa84c8603@pobox.com>
Date: Fri, 21 Aug 2026 06:24:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.153-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145211.194104353@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 7:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.153 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.153-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
