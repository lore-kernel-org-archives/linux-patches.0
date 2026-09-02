Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387A420E334
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 07:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335052; cv=none; b=MZXG2ocD/EuR3EvwMb6oboAtLEnBReXC+LmB4qAQxXHLSnZkJNblPyCp0bR82HAE9Jy7HbywJLorjrkr3ijAhjj149Y6dFIYWof7qsFgm1D+aRS8mlcbzJkQoU9yGBQOkpZU2POg3aU+/PJ1B9eMGvpbDaLq8OOGUaeLvnEfhDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335052; c=relaxed/simple;
	bh=xIiI0lg4PK2+9DUaFY0rE32lADtmm7ytlXzoNmcE9MI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LzFv59JHDB2USKFm/dopClP6j3t6y8QFp9SjZYwjXPYcyonavJu62gzFCRiMWa+rZ3SF5Iqu2CcvgLQBT1eo/0za25GJBguBVDKJoazWm8WQVCA/pLzmV8Y/Kp9oKtjyDtdpkevyFBpmHMy3PerLw1PdJnZO/inpDuQekXSb7a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=f2HEx2WR; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KDThgixP; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="f2HEx2WR";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KDThgixP"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5483B1400192;
	Wed,  2 Sep 2026 03:44:08 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-02.internal (MEProxy); Wed, 02 Sep 2026 03:44:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1788335048;
	 x=1788421448; bh=jgulC8yX5SXLl4FbbnEuZE+yJ3vYsVJVhHCUd3qdXbE=; b=
	f2HEx2WRIv46FNpOfCOqZo8CylRjD8ORZIDWzsep9nY3MieNcPTUPiXKO1b78eLf
	2ZMD4K08V10iFYniXVP3RUhn3vseT5+6ktQNTkQJ3e1ac/Iq4sT+Jgoha4gMjq0p
	AKbIeUPtDfexNGEOVCRMzasUmLWlYu3Pnby57nwejt7tM1qA/NlJDG80oUf1WmrV
	voX80wPGy/WaSxY5tzc1kVPcZjK9Nq2oNhk+G/kywBaVTykqvy6q9IQGkcJvuYyI
	syHVtKkoWPSJwKMciXU3E2uxNZIpKF+7ne56S+BhXkegsMA4aJ3S8KwPi9GULeT/
	Aak3P11JsCCU9RYZFP3v6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1788335048; x=
	1788421448; bh=jgulC8yX5SXLl4FbbnEuZE+yJ3vYsVJVhHCUd3qdXbE=; b=K
	DThgixPhcGSs5MiG/CkiT1e8CBUyDxLze1YfhkjuYrIOfBA4qeZAvzsUrqMtmxKB
	eqTXVGdlpPYKTb15JsUdm6YFgSAVDIOIUlDmtXHvc9cbmK/NRvuu3A0u0lYiQxM1
	wR5abFX0Vl8dTIU+OsW3l19KImS4sPiKa2IAxw7NP7S7DhWzgwUz2iMsz1HZKYyJ
	BWUms0wr7Xd6XrTZ3P541DUv9viA2o8U993m+AGmaDEG1QEHpFk3o7AKiCP/fAuZ
	BB72W+MmMGODlzqnnaOe8dglmu65NvsS/bd0LVp82zfmzeBfdDXXwuR11pxxMy9T
	rt64S4G4wnLWex+UgnT5w==
X-ME-Sender: <xms:x9OXaj0L_vU84lfWwpDLOA874gxwRpQWhndIzLCORdoH6bgMV01ryw>
    <xme:x9OXat_lghlrXMS8u_uK4I7A1oaXNN2aZr6A_YI92CFi1PeQDUYVHH6e6licNFXnN
    VEaR22klRSaPvYDEUoPiZ9ev2NWZFMBi4EisjAUStDTbp9qNxbaJw>
X-ME-Received: <xmr:x9OXavYg6svwG2j0tMMPQ_mSsLbQ-xDQ2LjztEHRWpu0Kr4_A2OrR51z0V3SW-CqLarGompdNO6d_BIIP2CrbEpE3Xe2WcsE>
X-ME-Proxy-Cause: dmFkZTEz4T5115jsAsfLajQ+UDt/Sbgr1vKjQ+JNUKUIHxFxq7shcA/u+SivYrKuDjwdeZ
    N+IO8v3nyYrBybDZk8tKcNx6hKijc+gw9uX1HqYWdxZc3HRwgRRzWIVwwxaaZaYMEv0FJj
    2xXqKLioZwlMxH13QpKDbsLyVLrMG3iD6yPd7lVe0x9nplnpZJ6L8/EuE/SEoEoTONCaxa
    TzgYw8HjyL+a3APW/yorNy414tw9F9WCBniokhgPrmU7HwdIrSeuST0hHXhpE0m34StiwJ
    L8OBfJX/gDgRFsf6nQ8yBLf9tkmSZNM5Zk0pXz9OR0Xfq1bA30WhthwZQ9fhtytdwPYHQB
    A68Wrunyz+fPp+ZJfYRKCgfKEZ6KPU9EcBOEryG+/BBeO61nNLOd/pgMIUa2GIQcTeOost
    H5RCwZfD4K/dw5Q5oTn4ch/r+uYTV9aUnJXlhhwsnMbxq3j6OB8/RCk66OTAfqknx5f8Jv
    hLNwl+DCh7lRxmav6mw83d2cgC/DXfWww94kTQaM99LUnN3H2pyTJI7Zrl9GGrRUCw4T9X
    7kxkImTYo4+NmW4+8i05s5JAFwdj0ReGPr5bE2i78G5i+1vLM/6kTF96KC03e0ONKZs9EZ
    lifKrCWYhfqeLNx2BhcglBdlP/Int66ezrrPSGWxjFO0Ek0g+FgEV8hm65Lw
X-ME-Proxy: <xmx:x9OXasz2hzbNd0edtbQwaa77TpALcCU6chWnfjC-PTwbryUoXRGKPA>
    <xmx:x9OXat8VG0fUfsALU3P5k5dsMyzMxf-vMhJhzn2bpAAqdk7WuJkz2A>
    <xmx:x9OXaoxAHujSLAX4gNk-d1Fb6c2cyG4qcOfqdDsCcHec71wjT7H5EQ>
    <xmx:x9OXaitlufWLcg_GQKYCEVO4Wi349XYzb2XjRs8G27ur9a8RbypTyA>
    <xmx:yNOXamuOsv73ydph88dp7RbgTB6KsmvaXkfTwc3e6OT58ofDyNb1CRkf>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Sep 2026 03:44:04 -0400 (EDT)
Message-ID: <5b0890d3-b297-43f2-a44a-40f8a683f820@pobox.com>
Date: Wed, 2 Sep 2026 00:44:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/83] 6.18.49-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.207714926@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.49 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.49-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
