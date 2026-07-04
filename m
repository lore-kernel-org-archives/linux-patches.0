Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8D92741A0
	for <patches@lists.linux.dev>; Sat,  4 Jul 2026 07:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783148470; cv=none; b=oNh+iXhSXNH0CRAwfyBgXPbE4cQ8zK3KO86hDuy6637mC557UCtOiebZGs6/XPBbNC+XSHIHdfKaVwtjVDnZrunmXmjsEZVtP3W9gH7nY0+MN510MXkl9hSa/eTki/NLKLHCIg30wJnmjVDZdhhprzCmpIuyGEUH7+7rAdMQVuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783148470; c=relaxed/simple;
	bh=pa2XnLmEnSof3NnJJZTkXkFMXoDDb635dvs/wd7hiY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oXgcyhX0qSM411HQF6dEMsgGfIZzGLXO61n/Emljk2zqnEOkYDYauxsW61hcCrd10E6F9h7FSF/3efykjKBy5fqNIqJju0Jp5asERzD7+5AhsE8dc3XqhWHrmYcEPviYupbveTTa6xre73wLdwca9gYy7byDKGCzPm1mDc94kKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=Ed1GqLr2; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Qtt21QD/; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="Ed1GqLr2";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Qtt21QD/"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 3E2E0EC0013;
	Sat,  4 Jul 2026 03:01:07 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-06.internal (MEProxy); Sat, 04 Jul 2026 03:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1783148467;
	 x=1783234867; bh=9EOjRLEuXB+a4hPiemdXkRVHrXxozs0Cbz3kPa9tKqA=; b=
	Ed1GqLr2FDb/Ah7ORLdmjgfferEUoc6CAFZ9bqbgy1+ubmUerhJxUXMKfA2ty0A7
	EjsqtvjhLIHG8kSHiBpM2PPHBC2NgXlDWrOvGG/u/MfWNiZBvn3AUwo3bULYvNAZ
	eQfnQmB8wZOk5zJJ8chu3Swj04j5WDpfbOfmO5okjlJmpjWwP/7J0kT37UPcJuDr
	mj0d+c6gn5uksZD6QsKUvmeE8w6Jm6C0HtK5OCRphcW6PfkRc0Cc3qJqVvYOn1LB
	aAcwqrqdoseQZgOsiHlegr5HYndSeKGnSAHNtj1FPQwL3AxHANTaV03ra3ZSxtjv
	S52HBDbDSBBqRE5O2hnrKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783148467; x=
	1783234867; bh=9EOjRLEuXB+a4hPiemdXkRVHrXxozs0Cbz3kPa9tKqA=; b=Q
	tt21QD/aERYh2me4h09QU3B5FW3X8x7XkVXG70WTux4dMu1h5kqV/7VduVTxpIwz
	z12jGaTJ0uzIK7Nwt74PUlP1Yme8o99NNKZc3Yhk9LMeaoBgDBOYIhuj0lzlJ+DQ
	F2ynqv5b98jTcJ0fXW9vi2fHxbG5OUz7GsZKghkzJLrUo35UlTIYMjn3QPkNG4Ei
	tWfQnkGNhTbXKiCx09QbkFciPTkNuIqzoGAA4CqaX+EYf1mc968nL9V/t7Qp8e3P
	A0Y2ggf/kBcjDfejkihO6LGdydrZKVfGxzISWki1vMofmjJdz7SIWXIw1N0i0bBZ
	AtxmB5YkCygriwLQ2xOCQ==
X-ME-Sender: <xms:sa9IatXA1rxsoOR14dXwZ3z9AxyV0uGQZs6T4z9OFyj88BZ2ZvCsPg>
    <xme:sa9IapfHDq9CXlv4RDeZpjlT0BY35k6-482dE9nmBiDzWfzTOKCAXPtdyweEwxkO-
    ZVY5WPqlweMeTSDK9x0HaybkoeoY_5Sxnzo7MLM4qwwD_vlm5NHxrw>
X-ME-Received: <xmr:sa9Iak6M5MpKbnEavrT3lkm1TCNRyyvQdPYpUVnSKTGoazuzubPCqa6xLLRIQmHf0pcbpWRt5mMsTkXMrrtKvXuxiSsSAZBP>
X-ME-Proxy-Cause: dmFkZTFxHw6jcHRCtK2k92Ffh+A4E7u/DM8vkB0pS1S+nJ4J2UD1YdfBAnxln3I4qnM3+G
    6WwWCpSRifZBZDUi806MCa5KM/8L54F+OzcUx4pfRp6cMOHF900aX9ZdBzM1ycha1Y9cK/
    EsMxhJmmH2uAPCEbl0M/vIfjnafvDOe13Isnp29WPiCesbtQgen6d9eAZa/RlZnDYeyhWX
    UriMP72oxHvwPjO9D/eRLB2YSIaG2YjFJ288Q+lQ/ildpienBEyV/i/eJW3J9PsYs8UTHB
    s4rOgOC1d4HM54kuJKeUpInMQ6S8ay15/GgZCv4hA49lRHdaa7VNW520Pq9Ap5iyLnRoRU
    lOt9Q9cJAOLuiEFos/jFp6hgZlLmnIrCApwx9iEkk0J3IqoJOrb34ZzChnJA9jSa+jnzwo
    USLAOwlq1UAqx6EH/UQK4o59vA0QbTu5jbjtWpd9CcmzM0O78NLn/jvMlzjqaWmXOLJnO0
    4V41yCmaj8u6+d46yQ28qkeUbc//VXas9HF/lC8lfN+9fQQaNx43HLXM4px7s7MUFaxeSC
    +CLO2pwiN/+2zoyUz/QRWwqu8CrAhl0qhgO4H5zhDMnMxER68eqLxKBVDszSnFvxe48s8J
    5gKYMzZXRR9A6L1xwkH3BmzM56YnuIVUCpp6wX0JSWt+QyuS+TWif38W3lEA
X-ME-Proxy: <xmx:sa9IakS7uAhceGYvsI-Ek_UpZRfqOdxnocedIhhPjhkpmH8UQCy3UQ>
    <xmx:sa9IaveMAsX5oS1_0NKkI3MZKKEa9GoSIw6eB68nNHsKmcYjwQwp_Q>
    <xmx:sa9IasSFyxLnSlveB7yApl5RZaGBzI9u_-hYDlGs76e7rQa67trspA>
    <xmx:sa9IagMuUC15IUhfkvlhDRqV6nw_RkJlFJMvffbdNSWNJTRMw2qkPA>
    <xmx:s69Iahqjccp0IFEFEchPz2-Xle-8RZURBTAMGDr9oPUjFsP2JL45vieL>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 4 Jul 2026 03:01:03 -0400 (EDT)
Message-ID: <0a78d284-b05f-4468-8248-0a6bf5bd1ab4@pobox.com>
Date: Sat, 4 Jul 2026 00:01:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 7.1 000/121] 7.1.3-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260703072822.817328079@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260703072822.817328079@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/26 12:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.3 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jul 2026 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 3 amd64 systems and an arm64 virtual machine. Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
