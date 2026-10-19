Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45ECF48489C
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 07:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792394889; cv=none; b=G74tUtDIF1/juaIl1VhH5GZ2djMrr10x7WpFR60vlg+0jHe6zh+/eZHr4gwOQpJ0F7CG+GvN3l3LB4c8R+dR3k20Kb3C8jJ0sKvMazS5MRasDFYIuvnmATKQXDX81rtbfGY/EY9eVw9wFwQW9WwvzCZxjZc+ITofx9H5LqGzuH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792394889; c=relaxed/simple;
	bh=N//A1el18IitjBVhxG0iUcW6/gMXEpoey422eGiu+qs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ch2Do0qm1uFYlHNM4Xzs0RK8fb1tse7146Ei/ndM0FBjQ831P3Kw+4yTUjiE9EzHnejHBRvDeSjq/imWDSve+M7Ff6mNAXcqJiay5D5kwKUPV/cGilC6Z4sBZru9wTR0frJE9kdQU+trnqQk+yfQyxfDMyEOe2e8t7N3mTyhB1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=eQJs5XHJ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BX+am6CS; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="eQJs5XHJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BX+am6CS"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 868221D000C7
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 03:28:07 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-02.internal (MEProxy); Mon, 19 Oct 2026 03:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1792394887;
	 x=1792481287; bh=nl0BUKkKX19Srep/7R7IuZIK7/sRXs+9OW/tyoDdAu0=; b=
	eQJs5XHJXQBPCs6K8j0wqTXmkxgVgWcZgxodNL6iTacr1iGNqVIMJLeGoyv9mje9
	WWuJRhA3dGS+eZ6HbD3D5oxVS3RdwxUI/BXUCVXJ9G332CRD2dDTgiEFkwEC4pj5
	IOQj/3mxXMBs7iJDjHkTJsnRuBwfsP7kdtA6qiNSBm1BUAh5XAVUqiys/uqDrcSu
	wWfkj75iZr/XLWpYEmWNwgavk6eppymgE0tU297P+AWIPHi2IXotGnFFn6sAbP3y
	dOuqUHVqkJrJ8z6KDtL1rUD6szk96uAORZWq76U+sLuU2AV4+kK9p3yKAXHPVc/G
	3L1IR8LG8R1Ik+kYuI2BSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1792394887; x=
	1792481287; bh=nl0BUKkKX19Srep/7R7IuZIK7/sRXs+9OW/tyoDdAu0=; b=B
	X+am6CS5xuAT0Y+ZzMvjyR2RtTtYg2eb2RMuriyg6hlx6z9Wc5+f7/Ijrcekwf5N
	icAlj6oc6fuU02IWqQwbJ9VixHEukQ3Q/9rbCOS3lUp4YgfjT2qPTQiXY5GH6EV8
	ijqm1pRE8CAMZaO5uRDyq7p5d+HvOpM+GeuCPbdqyhAFnMh24NqFcXIF6KC0XBNg
	CthDx5qwZFf0eFj7RLYVbj3kk+yAvTv/NaKxrJv/J/1aL2Up395jeRtgTd857Qfa
	MjhiL317iSbTV7THCGuvv2DI2TOeBtlkYc6JSXhh27TfuTZXQpgPkPXIXMY6CTu3
	QXL+NQn1rcZHrF58qMtHA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792394887; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:pvEa/jRojzw/+OlimbkECS9cukCp/+jEfSdV9auBUbfLFgU
	Dcg82dLQU/XialBjhjR0SI5JbDsPP4IDl7J8ZQ6LC6iyHevKKaW+amzGuDpXrzvd
	JGxeqiKHdxSLPNzw18jHZK5PKzQWgeOWAHWsKf7IUzT2nwgmbGFt5mDfaZv9alps
	P4UU2z+rPn9rMLNbWjQjL2ChbsoAm1PWrK5lLPOej+VHvyzoweYsHf4E6oDt2yNo
	Sbqgo0p2Ds3WLgFbYdu5hxwamF45sXglCyWTpnX8LhZyYSiRvv7qeVWFBsmZcslN
	nimo2EHinQxiKhXcVs6v9dEiLewN75wW6wIBG6A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:u/SMbgbsBA83nSqUIv2o2J6WwqcNg+qlZf0dHLhhi/g=:N//A1el18IitjBVhxG0iUcW6/gMXEpoey422eGiu+qs=;
X-ME-Sender: <xms:hsbVagWV9rX_jb1G_fGvB4yUjXeq6RNm1ldrOeJWw6_bHjUFd3jg8A>
    <xme:hsbVagdAf5YVq1o53fSwWkFs_s60xZhnwxDObHUqKKTNj9JaeqAgsQDQXPqZtTqb9
    u2Nnv2fNXwqNG3mtC7w8IGecTk92G_Kg_uQvGA1j0uo9fhu5PhJfnYg>
X-ME-Received: <xmr:hsbVav5zPIkOBnfRswp-sFtQyIN9T1bCCOZGk0x9C7JTwXFuQo04EmwoOP-abSIhijFwa-kmEKtQfVyhePzfnTcgB2M1UaTD>
X-ME-Proxy-Cause: dmFkZTFmDQbG4f+zIImbrULE5KD57pgO8qS6q3vsE8rHGP/N/as75OB9NC21g+sbNJ95xy
    cdgcsSfka3OfwtG2dWLK0Y7olLaaTSTb9EXL1Q8Ah48oz31SVmuJEj0v75eYXC8+EnECcV
    wOkWs8wbF7q0auV0qVo92eJAbdGO64mA24FEpuklvN3TtUyDlb5pKY5ndr3mGfqioArD3g
    z9w6GWygTmud+Lmcx/XUdZmeTFYp3dHUyRa9nfNyxXSvH4RiLfFtES8+x0Ojmo3NuMq/Qd
    suVvGzBamezXqLgY0ZW3A12b8ivwNFGiYKRRF6ZsyJg6pu9lhYkq/c5OA83fLwtexAu6eQ
    +B539L2DrA7bdi5rPZTyM/vkUBzn971xGRoB2e4AmCQkCnBDvaeLn2irJWBaOIv+bTwxG5
    ZCB42upH9KJiSfzCgiGls3VJtDF6g9E7oUhLlAMNgYsOEhSZizKWsoG107pfiV9BcD2h7t
    otO+nBdEgBVdRabHj4T1OJx6Jx6vBR2WUHcahG4QxlLTLGEgUOPtGSnAixDDHzHsHeIJsJ
    RFtisAbVXAOREkkxD6i/A6Sg/3XwTNMQY8MAMA+3rKaOrHoR27PNjDYGjZyx9pUCniW+KM
    bQwwQk4Gr1KqSItoS9S78yiij7hAZZ0b3gMdTcc1gZ9TJHpj0t7ClPxEz1Pg
X-ME-Proxy: <xmx:hsbVajSBjkSkKxW0ozHcHUhLwthAqGX9KvdtJKEofcdA-NKAm0GdkA>
    <xmx:hsbVaid0HegBEwYX6AytR0rf12F6MqCa0sp04luZD8zsnfI7uUyvEg>
    <xmx:hsbVajQVNfGdJUallUgKH8X_dNksQay7QR5NLZoqofHwCH2pPIsqyw>
    <xmx:hsbVarPgYBIt8nTH7lNnQocUmQLqJksgDh81pBUm1Cn_YMzWoP9HzA>
    <xmx:h8bVakryr0eXCXrt-Z8T0dbkfOrujSF6N-C9nVQqqWroTqllsR0meJRU>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 03:28:04 -0400 (EDT)
Message-ID: <be5fe4b1-585a-44fa-9b93-a0176574442a@pobox.com>
Date: Mon, 19 Oct 2026 00:28:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 00/10] 7.2.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261017155059.698368299@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 8:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.12 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Oct 2026 15:50:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on my amd64 DIY NAS and an arm64 virtual machine. Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
