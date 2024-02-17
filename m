Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE8333CA;
	Sat, 17 Feb 2024 07:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708155456; cv=none; b=nnTHBYn0Tj+et8bMiwnRAKMqbaXTmNW5xfnIPDGp0f3vzHX21Q3oYlHuRUIFpGpSgkbw/l6aHfIi971LZ40PbE/m+uCKbdOChLq4bVpK8lOUMuSsofjwBHhNzPshdiOG05NKgjCA/Fl18oXjzW7iroQg1cG+EvE9S/M03JKQ09g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708155456; c=relaxed/simple;
	bh=MJdfwLJ95a3nZBDSIHpCrHfmc00uODSlZOcxh2GfoVY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pMjtieFYxixvc3oJ7/jiLTo+g8yrkUEqQDm8vgFE0u8gWgp6oGaW8dhesFMQLmTqwOtjLutH5Md5qcgDlhhFrCg+IOsTlOyymgWhuPy6UOwqzELNdWvZtbozH0E4Pf4otEnDaA02IbriKBmPM/6aHZZhwPuvsSeWQzL1SDX5cuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1rbFGG-0003f4-D7; Sat, 17 Feb 2024 08:37:24 +0100
Message-ID: <00c2be58-b4f2-4d77-8c47-189e7d9ecf54@leemhuis.info>
Date: Sat, 17 Feb 2024 08:37:23 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 093/124] Revert "usb: typec: tcpm: fix cc role at port
 reset"
Content-Language: en-US, de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Frank Wang <frank.wang@rock-chips.com>,
 Badhri Jagan Sridharan <badhri@google.com>,
 Guenter Roeck <linux@roeck-us.net>, Mark Brown <broonie@kernel.org>
References: <20240213171853.722912593@linuxfoundation.org>
 <20240213171856.446249309@linuxfoundation.org>
 <571afc70-dd77-4678-bdd0-673e15cdd5ad@leemhuis.info>
 <2024021630-unfold-landmine-5999@gregkh>
From: Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <2024021630-unfold-landmine-5999@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1708155454;c124645e;
X-HE-SMSGID: 1rbFGG-0003f4-D7

On 16.02.24 19:46, Greg Kroah-Hartman wrote:
> On Fri, Feb 16, 2024 at 07:54:42AM +0100, Thorsten Leemhuis wrote:
>> On 13.02.24 18:21, Greg Kroah-Hartman wrote:
>>>
>>> From: Badhri Jagan Sridharan <badhri@google.com>
>>>
>>> commit b717dfbf73e842d15174699fe2c6ee4fdde8aa1f upstream.
>>>
>>> This reverts commit 1e35f074399dece73d5df11847d4a0d7a6f49434.
>>
>> TWIMC, that patch (which is also queued for the next 6.6.y-rc) afaics is
>> causing boot issues on rk3399-roc-pc for Mark [now CCed] with mainline.
>> For details see:
>>
>> https://lore.kernel.org/lkml/ZcVPHtPt2Dppe_9q@finisterre.sirena.org.uk/https://lore.kernel.org/all/20240212-usb-fix-renegade-v1-1-22c43c88d635@kernel.org/
> 
> Yeah, this is tough, this is a revert to fix a previous regression, so I
> think we need to stay here, at the "we fixed a regression, but the
> original problem is back" stage until people can figure it out and
> provide a working change for everyone.

Thx for the feedback. Yeah, no worries, that's how it is sometimes. Just
wanted to make sure you were aware of the latest report. :-D

Ciao, Thorsten
