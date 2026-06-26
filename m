Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A9037F727
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782496588; cv=none; b=pYVJvFEDjRNzDFR2ZrUsdRoR6z3+JkIulOoVNJTPBEG4+LnzyuKMrMrRnStYWP5hus4GdzDFicdJOffe2oEMMzf4FlNizMVzhKayXCyjLs3cVt4k01MW+28erw1sn/QW8+6POsKP6odcShLmMP8XWYSFT1n1asZJZ2DXZ9yY5vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782496588; c=relaxed/simple;
	bh=QFdhdzcUL0orhGT7Yr98m0IH+vUgMv5RxV9hC6+Dgtk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hs+FqZFnawUGRD24hHc5Xs0cLTmiiUelOAWh2tfrwd2ZTw0+/0KS6jwo9unHpwmFxlkaHqEzfk1FrLAlbPXiA8HHSx34VlmKhqIp6ka4DQJrMopp0X4AWDbcz2V2qRwl1iJyOBmlbxjzwC7YjiNyR7L7XeCr4PwCJzqIJZ7O/MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=Ogwpuh5u; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=N2ZoJ5Hq; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="Ogwpuh5u";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="N2ZoJ5Hq"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 261451D000DA;
	Fri, 26 Jun 2026 13:56:26 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-02.internal (MEProxy); Fri, 26 Jun 2026 13:56:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1782496586;
	 x=1782582986; bh=x+IZSo79L5d786Ze9SgP5T+ZDMTtg4MvJShj+brkfOU=; b=
	Ogwpuh5ulGIfgj8Jp75EJCQWyEBe1lNnu1fk1Ne+4A1baSfyBSY0rUDPaNkG1stO
	Q8vfF7BgLrTR6/npjgMn+qckMV4IEHbVv6iyHItWxfKxO3DnNksFV95Z3IJEkdN+
	ajBw0qepSEGMMxY7VGUIvfJeaPBfdMNVtQqMr317r+BP6S/QoAw+fZ0OG6BFl27s
	xYJa24tUl0Up2FGW8wHpPgEzL401aUOE+6i+RTsd7zV6rtKh0jCDaL68JOhbL+f0
	jQLFuxY59FgMJsWq891xraYhR5w8buO4vlLMuGZ3D1oppAI0SbfghUCYOFJhePNm
	ybJ7XubTPFffCwXFHVFo6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782496586; x=
	1782582986; bh=x+IZSo79L5d786Ze9SgP5T+ZDMTtg4MvJShj+brkfOU=; b=N
	2ZoJ5Hq4GpQsRlXxuUpVdtLStsCYpG+5s5dQTev8LBX6LaANK6DT0hX/nXB342dT
	PGr5x7hBEh+Syb98/luBUiZsKuhfQILkCa9lZum0+6ihMAHIVzq+JnYQojTxJ9mQ
	bBqaIR8hZsby637DDXNzTrD1yXg77HsIzZprznYKsG4JXi+Jpq+r46AnDfGEqVau
	FI4zKuoQ4Vx6JkzAZZ/wJK7wjD3dB2OpKF075qdKpccq3Z0QsFzLxt2KehgZ9TeX
	+AZuoYj1H5+XqdN6z+eg/dVcJPvPWpfXkp4Pcoy0UtDLIZb3cu5y4K0d09erXQlQ
	mFGdN/z0trG2yEFNNjB6w==
X-ME-Sender: <xms:Sb0-amPQYRPgYrhGWo1gHd5Sd3RMRrMmVxpDM4G90DWGDXxxBSVvbQ>
    <xme:Sb0-alVgMeEvYKkcpPsxec3nv7cmp1yNkl9jz6iIzmQCs9aXzAo8TtlodxXUNH8JA
    f_x0bTP4co9WKs5HLGDsQJ-qATVzgPTlzh4TKMQuVyLbmxFarMeLA>
X-ME-Received: <xmr:Sb0-auZvqEEBU2-Dmy1EcsUffG6G414gTIrVCGavqCYzpTx7lFlv0MGpeGZq3LMz0otPsr7yBSRayZvDs0L0s_U8p4PGj4wO>
X-ME-Proxy-Cause: dmFkZTFAaUqo/uEEHncEkuOnwkupeLhuCjBbGn90FZPQlh1vlrygtOoZ41ShuFKY4QHHuQ
    jYMJ5J6/0jFxI+GnOpYxOLJnAdfZVZHmjXhL06MSpl+X5LXBx4LmuVhaSiRAmlOkWhnSvj
    oj9M1lYSBhSe4+hykrhfWXmCQ5T7VqI2h53/nggBxLg82xIRS4J708zzPEaIDG50LcqIjr
    AMrKIVZrEkHGpWXgKP1K3jVv+5WL9YT+JtWBdj230XXEkkXMxUWra8LHy4zzP5pXtWwlQq
    A5KP993LZKiv6O+Ve3mNKCpwBhKwiJWze2SLg4aDFiLtACbajLWH2N97LEl6dKsdaqloZT
    SYNY4tQ0/gahmFgN7eCUheQPfex/6OxS0kblVWj04kGaUp1kFLHgOxdy9t+UFTCe/xk8sh
    +XVX/0gGHv31gaI5z3uB1yB3siE3sHgpCi6fcq8muUbxKf+srYmTmYeVujWXVyVebOp18q
    we8m3VAtFYkBxfvkA+zldriotx0L5nTLeAEQCwIOx7FxrspjNHQpT+V1MNoj6F/TZBOxKT
    uAYC2lEyr26Q6LP1HJPPVjb8Pv5JEfOyfZytmNcIIhoqs0MRMRH3cji1ngKMdSg+QmIKQC
    KWKks9Awe3iao4hxVz/tSphMlU4dQec0Fl7gcHmzKvNxEMlvXla68d1gkSBw
X-ME-Proxy: <xmx:Sb0-aiv6GYM6LYkCDSz-B_LCzmCKh2aoHwQ2DbVUNK519A-NbArHNg>
    <xmx:Sb0-atkqpa03HiMA30V0u_Hw3Q1MsgL_rQIfr3IaDwgN3D2d8aIWrw>
    <xmx:Sb0-ajXcmaw8OGTbffbw4Our8JC0WHI7ZyzgMw3odZtBq9PBwInCzQ>
    <xmx:Sb0-agn-W_bX_X3AeEWI-13nfajg5r98h56q-9X9px27DStNsa0Qog>
    <xmx:Sr0-ak1nzaL7KBrZeddB2mDIMd3Qs78NxbQhl5O60REOS4pq-TQ-veLN>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 26 Jun 2026 13:56:22 -0400 (EDT)
Message-ID: <b7bd471b-e9da-4bfc-ad1d-24b378bd1e44@pobox.com>
Date: Fri, 26 Jun 2026 10:56:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <20260625125613.243729608@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

(cc Dmitry Torokhov because this is related to two of your commits)

On 6/25/26 6:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.2 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Unfortunately, 7.1.2-rc1 breaks the Synaptics touchpad on my Lenovo
ThinkPad T14 Gen 1 -- the pointer no longer moves when I touch the
touchpad. Potentially relevant line from dmesg:

rmi4_f01 rmi4-00.fn01: found RMI device, manufacturer: Synaptics, product: TM3471-020, fw id: 3972349

> Dmitry Torokhov<dmitry.torokhov@gmail.com>
>      Input: rmi4 - refactor register descriptor parsing
> 
> Dmitry Torokhov<dmitry.torokhov@gmail.com>
>      Input: rmi4 - fix register descriptor address calculation

Both of these patches seem bad in my testing. Either one, individually,
causes the pointer to no longer move when I touch the touchpad. If I
revert both of them, then my touchpad works again.

I have not yet tested 7.0.14-rc1 or 6.18.37-rc1. However, the problem
also reproduces on current mainline as of this writing (commit
51cb1aa1250c36269474b8b6ca6b6319e170f5a5).

-- 
-Barry K. Nathan  <barryn@pobox.com>
