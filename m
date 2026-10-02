Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1A54189C2
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 07:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926938; cv=none; b=E/L4lCMcFJIjCt7H7hwLqRbtxXBZVf9ArHCrj7jdWrRwE8yrMnQd+QUJu0MJAiyNKiCZjIu4JLl3q42dG4wxBs/w+8eUnkkdQwRsCXR1cjhz53I04gSb1z/PvKVWVSlWuTzCOYuW0Jm5+YPSEie5GH/yEncd2ZSnL03Pr4XmQTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926938; c=relaxed/simple;
	bh=+r3oF3KJa6nDKG6ojMwf7eYgUcgM/dO8XmdcYWxZgC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kLh7sGTroh7a0YjP0Xqza8IU++/MIP0QtQYvoOZGpFHBh0juDIgQoofOLbQcnPqMzwCS+UnSrdmEpVbN8R66b0bI8qTi63daOR/aA+Kny9GGhtS3c5CDMWt0gQmQ9sl+XJBqyr0kOyXzMcrexlPRhjcovOx81pBdoTDphBz9fLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=qxiA9lnO; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cx4FxcWB; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="qxiA9lnO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cx4FxcWB"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 254C67A00D8
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 03:42:16 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-05.internal (MEProxy); Fri, 02 Oct 2026 03:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1790926935;
	 x=1791013335; bh=wKje34qKlqYuWVpjC8LnCp3hkR3I0KohUjlISc6RnSo=; b=
	qxiA9lnObEJ0vS3vBsbfKYRtDjTflZWxahZ8F9k8ylhZMYqm55wJG3G2kpNqOE3M
	WF3LgvdbL2bxmA83oU9/XXyCtAildcc2taJ2b0m+3DH/M7jlOjJ/6R/903et3RE2
	EdrrutAFs3rTmo2tkYLOTY/s4Sd5gqAR/Fbf8pzvlkLgmJkkeLwq05mwEf2ov1Mb
	HdDrGBVhnNeHx/ma2L5qcWyCO5JRwjXWF3F4pp/Zv6h7sMjBbdZ5HpuxAQerKByn
	H9GZBqc57p0sEzjqWrTS1aoCr0rq5kUX7zEHrn2eFs7YAdMiyNv3X60QEDNwDfhV
	/ernWIoTqOg8LrbFX1zDLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790926935; x=
	1791013335; bh=wKje34qKlqYuWVpjC8LnCp3hkR3I0KohUjlISc6RnSo=; b=c
	x4FxcWBivcG3CWlnThM4pYqRTcBn3deQF1IxPUZBQyBm0cxw+D4c7Vd3uZO4kxUX
	cIA8+Q6V8mOFniI9bXPxNv9T12BpD7YsCI8YfGKfV1sMAcgXfcycDLKtkJEkcDx4
	ddHDCAPrFAmKZu7YLhgQCTGtUuFuqFFpJdnHlnL0k3bUsixSMFIesz7AfR0TAQHU
	mKBOdfqp2bXD95GW9SbWPAlKZVn52L7qNLyKsmxCzTI/k+jJMHo30POf1zfrSkjT
	lWD7swgiI5MDpR2iRoz1hPOH47adu94i1vrCcoU6naevdjhds1e28rcUC3pw7Z5c
	dg6NmiElVi5phg57aG8ng==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790926935; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm3:rsa-sha256:ZP90KKGPA0dqqX8ZQZI7GgYTp88S/GNBUTC/joK0o5j9zOn
	4LvDYxCc/lkGlenA4t4TLHa7Fir/JZxS95QGqISlbrLMYl3QfLb7ei1QDdVmdwUT
	gOcgsOUno1JJidtpR7/HEuS0QIdNDs6YI31zYv99wcuYDPRc25/ef7H4fTqDac7c
	6T5oLPCEeAxuTpwoIFfAAx8VlidjhIWoltzyiP9wcCze8vH8pklzQ/G12Jt/OT8J
	7K89n4CVdquRkbRh8O11ArjV6OnnNCJR3+JjtxwaLBEFzm7FIyGUZwe5mKXb4qdY
	KjjNucm4FdX3oHu291uOit2S7H3jDQocCXUAIUQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:C+lnE5vg0lxH2++CQgwb2zEwnZ6wpePXoCKkQE8lDOk=:+r3oF3KJa6nDKG6ojMwf7eYgUcgM/dO8XmdcYWxZgC4=;
X-ME-Sender: <xms:VmC_akbf5-l_09xFrVJWQj690-R7AOaKTHyHtMMKTOHdW6TxLDKe9A>
    <xme:VmC_arRD3k4K0Vmpvtf_DVE-vLXXJRZkvMYcQWOIqlxLv2lv93o2wJuC-F73OSr9U
    MJ3FHhYS6wFjpMWwdzsnqMU7FzBkAUwZYDoEqPRUIhtyEJSIl286eI>
X-ME-Received: <xmr:VmC_aqdyetBDNXs_bdNttcQ2k7NL6qm3cRlVx3py-O6mVDHqNy4LOKH_oqSJlvbYBOqAmIBJ8G2kI7XqVRpFaYhtWti4hgmV>
X-ME-Proxy-Cause: dmFkZTF/KvG14L6SoNmfOg+TwWUCpD3GD5fO5a5Up/H7w7pZTyfHzcF0fRTQ2O1u6hQ9R4
    Q7nfL5vkCTEXPmhB2TmivQ3nxJZyYb9oMp6craEuOpvR6x+bBvlp+mjWoef/3nPUR9+sjR
    KbptPwzO09bXD+oUF7wXwHtN8EvZQDnpeafnMDqZ3QczrPFfbIXz0DEXdMAklvLZ45W1dn
    pg7KIyMYPOHuK6CRhLjE+D6ag8B3lADj4di6wXE8CSgE101HCWeqPHeeCIB8c44GqZLXSp
    0/M9Z46IE2FWptS0HefnVORB0TBKGFgVNM7ytAPcjhr9Won4cicrR/JL0TjFkhcmtKPDTj
    RiD+UNwBHBeq/utCwzdqbqyrJDNWWVwzYukVjszPAlLPmeV1TQLXVkF8uC+JAg5jk1vgK0
    RhFUTUnqc8+qmfj8I4qC6Urc0R+NDdxqcN4tkO4UxaPbFuIltj7k070Zh+ojlDx3zzb8in
    mKrt15g56KsRtfq2ST1fqS39zzIJub9Zun5HMj55kOdMNiJ+Dr4kc6rtUrQ3rnWBwNFe4L
    yMpbWQYGalQovsWWW5X8Heqt8U4zxAobryEnRxjj84yPu4JoTlFkLbQiVpmfecdYTt1t3Y
    dayXcsFmHsd/NE6+lWkK96g/1gexDqVOuBITOSr21on5cm+/BcwvqVtdlA1Q
X-ME-Proxy: <xmx:VmC_ainFi54mGhaGvaVpT33B1Y2QwrkpsfuzSXw3-BkQc0yM3KIGxA>
    <xmx:VmC_aniB3d-Qwe43HFsDK326bdWAlYLMeGiN4clTEaUARh_ofoM1Ow>
    <xmx:VmC_arGGnX57Nk3oRyu2DGKDeExMVIlQkcnrdbvkGk8A7-H78PhDEQ>
    <xmx:VmC_auyACyPdywHWb8ZAgJgjEfZu0vt6DtoV81-EB4smre2DMAfnrA>
    <xmx:V2C_ahsnzylZtSpb0gg-iK7fxYlfdZ-0I1-oceBBStt76wY0I-81Y7D->
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 03:42:12 -0400 (EDT)
Message-ID: <79fd8985-1c19-46b8-8cc5-ca9c76142cd1@pobox.com>
Date: Fri, 2 Oct 2026 00:42:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/752] 5.15.222-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152358.131179731@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/26 8:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.222 release.
> There are 752 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.222-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 amd64 laptops (a Lenovo ThinkPad T14 Gen 1 and an Apple
MacBook Air 13" 2017). Working well, no regressions observed.

In particular, the MacBook Air that I used for testing has a SATA SSD
and was affected by the SATA booting regression in 5.15.221, but with
5.15.222-rc1 it boots again.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
