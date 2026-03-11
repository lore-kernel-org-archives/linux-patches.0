Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060AB347500
	for <patches@lists.linux.dev>; Wed, 11 Mar 2026 21:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773264319; cv=none; b=UpucsQk3HizF48oJR32wAqUzmGJLaSFa409Kyta8gU9z7PTef5mAJR4JHYpWsbUjdVjCWzqlK9KDMTBqb95of4t66II8wYtBzPw1WdRaJuFEk/Yh3+Z2/YJs/PUNJ4rwA5dpIpGAA3MndrckTBkKgUuTfYd8GD2grwhOEOtZS94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773264319; c=relaxed/simple;
	bh=POWhdQgCb7hB8EmbrrSBu/BoBMDgLFq31Y73wq268Xk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QhQVXVIylGSTzRZguYIPZAHFTWJyt8MSYvDKXk2TS0Au1eyuimLTem1cidiCc3A65Szkvq1ok69UYFCCGe0mqEp1UEdavf0C11PylK5K5jDcK/IkjeDQdfXc25RpTD3J5QhXBd8+Jx+bnUK+nW2ExAbBlcOTdUmuYZ6O8+aKFeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=PnZFHoX6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=h4fqX0z9; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="PnZFHoX6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="h4fqX0z9"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 1F754EC0BA8;
	Wed, 11 Mar 2026 17:25:17 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-01.internal (MEProxy); Wed, 11 Mar 2026 17:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1773264317;
	 x=1773350717; bh=Xn0oaURp9HOFFRG8tZABUfEy4j84q9IfWoeNgfEWEQ4=; b=
	PnZFHoX6uwFn8AbpbUkczznI1a1JcmexL0F8GdxelDsgqh8YcT1wtWQWYFGcH/Fv
	xvwXr2lqDEw3JqL27MUocyLUoSOJy5Mr4yVv1mQcsgSrjBg6uKF0M6KOLMchXOYW
	28lg3ltpeTz5u6fE3T206Ga2fRf7/dYjO4sRy6cr8D43cnd6BoStFcH5LZrwAvym
	zuHUKTEDNyEt8K8PNrafgcRd69H5BRJ0gTMQcmvGgdMDB3LI7/GFkITDE9wwIje2
	7+KKvjvmloIE805ll7862VJx7KCSeq7GtEW+jue1QUH5ei6uMhw6m0Pgs1XKhuv0
	HLqf5FGL3V5NgGRs0EdhHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773264317; x=
	1773350717; bh=Xn0oaURp9HOFFRG8tZABUfEy4j84q9IfWoeNgfEWEQ4=; b=h
	4fqX0z9h2UZqbCeBWW21IL/6c+Fblt+3ab0zFlEC/EGvNh+gdSHnqBsSWOoKEI3A
	vNF8nWmbVYK1T8vsIblgf5FMa6KvR0XuUhu0bFifelv4O0mQLceaCSjaDdiIR5RA
	HBL5vVhcQSxBNR5N3Hm1Ky2kgC16cFWajBZG8AiCIHFGdK9M5Rxb8xT5mV7t4WWV
	bPgbf1y1B4IZfv5RIeq3AsQf4MUEtKsyWZZ3oT4e+ySyyGVE+0wwxImcqtZAv0vn
	2CXafwkfWhmZVi54NYFBjg0iPq4zsUZdtPvpf8zUwmEi1BXKDLqpTJTH4fcK4ZLh
	JEhD4puzKjhakOd8cpfXw==
X-ME-Sender: <xms:vN2xaVpPyRTVK1-brF8__qI0PypAfGSRINUCn35qYbf9qrPOhT-apA>
    <xme:vN2xaYBZCLShu-O2MEEOd3KrKwy2qADK35O-mZ1AT1BJhqT60SJxiz7m_bNIkuu_5
    7DbqgT1cDYEl_51eKEXNa2efst3FsPX_l6wxi0aLI0ckyoc1CbcHHE>
X-ME-Received: <xmr:vN2xaTUpsSgP5ZvdcgHiYpLbdl_LgvuU41nFbsL-xyQ__apfEAdtvwa0dxNwOYRw5SX8Qt6-S8y5kR7pAWoCGbiTeE1V8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeegleejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeefleehkeehleekjeelffefhfdvleejteehledtieduffevteffleet
    gefgfefhjeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
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
X-ME-Proxy: <xmx:vN2xac7aIQ_pDVtQqPg5P7zJCtzVPPEA3cjiFy6PKMZ7olDryMH84Q>
    <xmx:vN2xaUBCFtFf8caaS2cjFys7YeKzLrTFf4Z6S-oG4TaDUR2JQqDfbA>
    <xmx:vN2xaRBdu0O1HSyPJC6PM8cK7YXJtIzNfXm4GHhVBbfxfvMmEatuMA>
    <xmx:vN2xaUidSB2AD_9TIEGWY8EMlLYu9ZBtcYgNNJwshQX702YERI381w>
    <xmx:vd2xaahqvLQizCi38mBghs698qvQkgv8URBt5beelmBxJbVVnO317shH>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Mar 2026 17:25:14 -0400 (EDT)
Message-ID: <08101401-229b-4265-87af-456fcc6b8bfa@pobox.com>
Date: Wed, 11 Mar 2026 14:25:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/314] 6.18.17-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <cover.1773141554.git.sashal@kernel.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/26 04:19, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.18.17 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Mar 12 11:19:16 AM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/rawdiff/?id=linux-6.18.y&id2=v6.18.16
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Tested on an amd64 laptop (Apple MacBook Air 2017). Working well, no
regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
