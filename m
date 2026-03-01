Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953E02F4A18
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 04:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772339180; cv=none; b=m4ZGpHLjzJbkNKwPFu3ZFwi3aM6Z39w5iYxKmSZS+rq3WQebk7viCXBTEad7815GhVKEV88DOYhKT1BWNTIZsQV/SvssKA0OV+lmTJpSd8kd623MhFrEXuvqIHpwbL7O72Q87R3gVAO9yC1Jf2Uz77uN9opijUUHXjCwYFHpzZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772339180; c=relaxed/simple;
	bh=KXlbxRLwDnuQ9Jy6vHgMhpb2BCcDKrIFmwsO95AVSUg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=f4sAfDipbMsydjrMbw85rVSywYnT5NyVNDBH5PNg4ia+TFRl+MkUvQbmJKJ1TUxwir4OE4FFhf0NYNp1JGkECbWzv4EdY6eUxYGfqLkhIVPzMH6D/OuJX9EeajH8hBwNLkEEu3NM3AlruyMaKKkBEWK1k5rjwCT8spm0zPmP3Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=K7VbM3g7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=wx3R7ZJa; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="K7VbM3g7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wx3R7ZJa"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 1EE6E1D000D1;
	Sat, 28 Feb 2026 23:26:17 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-05.internal (MEProxy); Sat, 28 Feb 2026 23:26:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772339176;
	 x=1772425576; bh=IEv+G3MMbZwL+t+I7F/CKerxblIeu1ih2REldfhgFKE=; b=
	K7VbM3g7HK88vZAzJeXzbSLPkEUSXmEJVv0XfksRXqtuG8mQNv0CcCQYZd1GoO3h
	BYnOoCisY1XY0b/rdGy2blzW9LT8/HzwM3Agr8WmYNZ3RBmtuzWrGzEizC7ZCBC+
	H4/A7++3HkbSyEoxq9L4zfOqMhywfVVonJByWQsPRM8ojN71MRWEo6XgAePq+R/Z
	TnXoKJ+8TUC/Q6kFmrD2jKeUa7WIrLclXjOfPhpzvvIBeg37Xqu7k3+jNhZauNet
	SRCJJbKb3mNxV//+JHiFdLq+9hLFSa0nDrLc/ylZRlUCmL9IRq7JjKasHooi17nS
	VXtBjpivwO4Zdy9K9TLRZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772339176; x=
	1772425576; bh=IEv+G3MMbZwL+t+I7F/CKerxblIeu1ih2REldfhgFKE=; b=w
	x3R7ZJaV/mZDZjGG4jSOOZec4bFwlYoAQ6lNgzaOS3p53ufgAJfiIOpkPSQQgZGV
	8LJcUzXAkCZz/Eikkh3BXcTyenYdV6D+obghqZ3CQX2PDnot55Aobz2FJZdnnWF7
	32JLn/h0Z7Fz7/Q99pEATY8QoPcBrtoCKspWqcX3OEpX953601u1jE6iweFZbaEf
	CZE88EUHz8EWKrgofREUPnAltDnOmwwYahgBVdbIXJAgxy0GaNOEEaLrhLwsXK2/
	nMdTJNmMrL95qHi5Wm310lJfGR/l4ZJpYTAHH4Jm9MCKFAP/FuKSRgabjEovRWRw
	zQHP5f5vM770TXANKLs7A==
X-ME-Sender: <xms:6L-jaU8cTVQ5fPPWzCNwCmtgGIF1KzVEPL8PkGoXAFzWmmY4scRj4g>
    <xme:6L-jadG7JpFGpP9Oqw_Gp6eWXOJaC-hK2sg5gXUtTIAvDWs3xu1OttI9mF6F4WgwD
    ar8hyyDEHbcalVC77pwldUaqs2VU58hkLdclnqGz5AOwejOpanPKQ>
X-ME-Received: <xmr:6L-jabLLoXszpJYl-a7hN7qxsAg1z-qSyRBdnv0H9eiiyeaI3P41sTr2FpRFTG-oarMPOkHb_AUFwhloT2q09jD6jWsOaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvheefkeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfhffuvfevfhgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeelkefgteejkeejvefgiefgheegtedufeeuvdeuvedvheejjeehvefh
    ffffgfduteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggrrhhrhihnsehpohgsohigrdgt
    ohhmpdhnsggprhgtphhtthhopedvuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoh
    epshgrshhhrghlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghr
    nhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehsthgrsghlvgesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehgrhgvghhkhheslhhinhhugihf
    ohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehprghttghhvghssehlihhsthhsrd
    hlihhnuhigrdguvghvpdhrtghpthhtohepthhorhhvrghlughssehlihhnuhigqdhfohhu
    nhgurghtihhonhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnug
    grthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugiesrhhovggtkhdquhhsrdhnvght
    pdhrtghpthhtohepshhhuhgrhheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:6L-jaQdYz8JO20VTY_f_-wv8eldu2kQQSLmkJEQ2lXlx6NnsWvRwaw>
    <xmx:6L-jaYXJAQ9xiIvVjHYA-4rhciVgKyL4-o1cuI1YdYuLXeAgP5VKaQ>
    <xmx:6L-jaXHzJ8Y2F1qM-4-jDWWOSQVcKt5aDsEoYIQ3qtL_p-F_SB8Xcg>
    <xmx:6L-jaZXKC_Tvsv-_PmU2B7p2w4Mtg1j1hnkQWCDxXwgKUB13RoqqRQ>
    <xmx:6L-jaYmg4APVEjJl9t28anxcbjAcnHIRRXe_72WkUkO8tfHieS6uuIlv>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 28 Feb 2026 23:26:13 -0500 (EST)
Message-ID: <1a732eb1-4884-4dad-8a35-4b79d4bcb485@pobox.com>
Date: Sat, 28 Feb 2026 20:26:12 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Barry K. Nathan" <barryn@pobox.com>
Subject: Re: [PATCH 6.6 000/283] 6.6.128-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228180659.1583364-1-sashal@kernel.org>
Content-Language: en-US
In-Reply-To: <20260228180659.1583364-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/26 10:06, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 283 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 06:06:54 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.6.y&id2=v6.6.127
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
