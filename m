Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244C91BC41
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 12:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765975570; cv=none; b=pO24xmjcjXy5UTAhFqkqzFpOylJyUnlBt11vCtugiRZHIAUGurQQlUCg6Trcaz+npdWsOCNbqZNT77uTTTuP1ezGXYQi7iBgzhdfavqLUptmi+hRhoc8x9AGs2anYFs3WLvWrnkSI8gguAWtBW2RgOS5ZDMsC7OCbNlPuE1A2tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765975570; c=relaxed/simple;
	bh=kIrnbk4/ZiLKouPoZ5Dh3mMzz7GdLGWKgaWh09ZGAhQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mGNN8jilffw6zyEaNJZWrE4xrv6NUBTYpt/y1XtnsVFYCRcf15iwggzh051/uI2sF/7VVV992BBnj8fzkfoezpRB30161C/QrMFgoSLG+48Glm8XJcHwEBJ8Qy273Mpu0/tBQ1Ji0ulz9zk42yimxKWMXzi6gXztudE9MT7xOGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=o/XJ8MBM; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="o/XJ8MBM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1765975535; x=1766580335; i=rwarsow@gmx.de;
	bh=Dx6lRKtwNi4bHpQb/Zt1mdmHtvs1vaJLrsH2JmKiPEo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=o/XJ8MBMmGOn/rcnOCSTC7G8v0wdDw2JnAvSoEgJt2Jd1rcdW8g/7Kv+9vtN985d
	 DkweS1bWEOPrVGqH93sKf3bjxJSbD5GhYssFIkRn/TsiVVhxv8zqQErPEhcQpw4yl
	 UMHnNEJtZlQNku2LltgtnXAYqg4PqwAAm+ekMbgfH0T+2tnSs5ehosfE5DUhSCjPW
	 nW5O3UoTafz5deeTGZwwCxlwRsyGXX9MWspuDHlx21VihGoHGKo7unCJvvLKMgBll
	 /8W9YIHsIBpQNEmMwlGQHOoL9+M5T/sowv9X9P89wNUecHTxt507A2IP8u4i60Inn
	 ZpRaB1iLK4Lj5YdNbg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.16]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MYvcA-1vRVIl08Q4-00T1nG; Wed, 17
 Dec 2025 13:45:35 +0100
Message-ID: <797b868d-ffee-401d-afca-466394a03738@gmx.de>
Date: Wed, 17 Dec 2025 13:45:33 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251216111401.280873349@linuxfoundation.org>
 <1056aea9-1977-440e-9ad3-8a0b8b746288@gmx.de>
 <2025121714-gory-cornhusk-eb87@gregkh>
 <b72d4821-d3e6-4b29-96c8-6acb1fc916a8@gmx.de>
 <2025121708-chunk-sasquatch-284c@gregkh>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <2025121708-chunk-sasquatch-284c@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fxFEsm64vZDQ+xWH1AEmnh3hkpJQq01rSvqUX8Wc0yomwVAXKlr
 tE2SuqlIf/EtRma5Hc6bar9YbmDAK+z+xwdhAx1xdv6LOyBCuL228b8TVpPjFK1l/c48mFa
 0u2PCYsNdXMHyIK42sQQjrbUjMybIFooYLaf4OGDDS8zybuBSZmisdtV/ARMMo8zZ7yYVKA
 AHhRbjdN7N0+RrwdoVH+w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:PT/k8OEWI5I=;bjfxZlDKPXdanD8RBTS+32tG4PE
 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
 GsjrNgg3MPfh8xT43EOepo7KftNyHAEhbTxqhn

On 17.12.25 10:36, Greg Kroah-Hartman wrote:
> On Wed, Dec 17, 2025 at 09:27:49AM +0100, Ronald Warsow wrote:
>> On 17.12.25 06:47, Greg Kroah-Hartman wrote:
>>> On Tue, Dec 16, 2025 at 05:06:56PM +0100, Ronald Warsow wrote:
>>>> Hi
...
>=20
> Odd, as you aren't even running the driver that this commit points to,
> right?  You shouldn't be building it, so why does this show up as the
> "bad" commit id?
>=20
> totally confused,
>=20

well I realized I left out several steps to do bisect correct.

I hope this time it's correct:

d84236562448e634208746f0e04f725a509d4648 is the first bad commit
commit d84236562448e634208746f0e04f725a509d4648
Author: Matthew Brost <matthew.brost@intel.com>
Date:   Fri Oct 31 16:40:45 2025 -0700

     drm/xe: Enforce correct user fence signaling order using

     [ Upstream commit adda4e855ab6409a3edaa585293f1f2069ab7299 ]

     Prevent application hangs caused by out-of-order fence signaling when
     user fences are attached. Use drm_syncobj (via dma-fence-chain) to
     guarantee that each user fence signals in order, regardless of the
     signaling order of the attached fences. Ensure user fence writebacks =
to
     user space occur in the correct sequence.

     v7:
      - Skip drm_syncbj create of error (CI)

     Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel=20
GPUs")
     Signed-off-by: Matthew Brost <matthew.brost@intel.com>
     Reviewed-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
     Link:=20
https://patch.msgid.link/20251031234050.3043507-2-matthew.brost@intel.com
     Signed-off-by: Sasha Levin <sashal@kernel.org>

  drivers/gpu/drm/xe/xe_exec_queue.c | 3 +++
  1 file changed, 3 insertions(+)



> greg k-h

