Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792865288;
	b=BXbWkcSeQRjS7kTq3haz9bIOxuWgZ10bjDqEm1ytuhGTU+iB70iPFWnA67cb/26RZxw3
	 2Qtc2Wsw9iCe1jp6o8V070XwtEfu2qumVpG5GB2vxaZa8UA06+wtlfrRvFQOlakcM5k7+
	 VurLsMru1Va8I3J6iryQL/jSRUDf7S+e0aGeIKgaR1zFigUDfhSiIrRkbNtNwp04IIvdB
	 W+nnQUUd8JTDACmk6VbCEbZVHjnkguyTTxrWPdsnwoWIEON5BsvFImJbbNnlX2X3Lvmtz
	 5OCUf2+WadosuGJqWGzbbMMHSPcLi23+9u8F0P/xYfDxl0ATrZqViMpJrIN/eZm1y/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792865288;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:From:Subject:To:Cc:
	 References:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=NtTMYowKSIMORjnfblyRGEyXj0hFDGCq0XehGYYzyDk=;
	b=gNhPWWfGaaugSskU0rHHS+6mY77lhXq/PJ37aK6inK9Pp80d8kvXsswkWjF2J/zAHy7I
	 QMFuV+6opWXsFVYA3CtEN70LnlnkM33MEyqAoI2XUJ/puKl4UXqmB9MK8RGMoXkLIRv5L
	 f3+Vk8wNkmQQWimSA93zjTT4tfIC6hGho8Uo892pzYt8VZ0E0MIs11UeF1eW2+zvUJio5
	 7hb6nPFguFEo3lv9dSlfdorNhlzKwpTCXd35KvR+rHh2rQtnAEtULe/xqO1vHRHpjblee
	 6Z+cdCTU+qoaKMS3+P6Ao5Y1d4B8lcrD0f3p8A6hGJpA+ISl7/Ag1QRm3v2e8rqq8Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=ayJ4jhHE;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=tKAUVvoy;
	arc=none smtp.remote-ip=202.12.124.147
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C21606A31B
	for <patches@lists.linux.dev>; Sat, 24 Oct 2026 18:08:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51C21606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=ayJ4jhHE;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=tKAUVvoy
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id C4E2B1D00119
	for <patches@lists.linux.dev>; Sat, 24 Oct 2026 14:08:06 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-06.internal (MEProxy); Sat, 24 Oct 2026 14:08:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1792865286;
	 x=1792951686; bh=NtTMYowKSIMORjnfblyRGEyXj0hFDGCq0XehGYYzyDk=; b=
	ayJ4jhHEJAHrgzGUkGMl0TvUcl6L17Mu0X8pxbRgnOxV3PjjZ49AjDMpzNvnOF7+
	NBoSnE1PtMUdG3mTx4GkL+Rj3eIWWQl8mHTLmfLA2riqwMkz7HuEBn+XqA5lR8lK
	/uH4n8VDFi/04vXsKfN/nLauD2hu3C5UbNNYXUY6IQw06t8nnI1hsLAaajZSty3b
	/Qogg6PkVsarXJDbDa6xgkkPPO9sN702fy5Th167qKu+Jnsf7kurZ84k96AD59YK
	X+GkQU2c9OvhoqQ5Otvek1K0sLYMIoWkCH8p3x2PWL4OFfr4QZdUrIEDYbAv5Y7e
	ZUYxdN4A5ALqi3TlfdlK0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1792865286; x=
	1792951686; bh=NtTMYowKSIMORjnfblyRGEyXj0hFDGCq0XehGYYzyDk=; b=t
	KAUVvoyIn+C7qpsPlWKUtAWUafkkGc+Axhg7Uoou6Qo3RqJ4Ae9INpf+RAwdnWlI
	LXduPD7T/SrLS9WQU47iG7HAxMc6aMHx2ldjjM+5CHnYmqUjNZsd53U/OQZkq0GG
	c+lj0XcP/JFag5/cmLqhACSz3kNE5cWyqi7vdq+VGs933O8CAp0srpkOTvNd9G9u
	naQg1FtZFTvrem+lDTY2hbMQSZitc1zb8evVO6aJSlWdL1whemta3m9g0EzIKoEd
	Xnp0o2iWHbftuQ0Q1GG/ZKFw83ECjTBfDODlACxPn+f9xQJkbuzCCZYMvI/ryLeV
	W6HBH6+axDF8bjTDlpImg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792865286; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:KXCN3kZsJW3OcgAdho+w+ncnMi/qSdCuqq+bc5gEdkvL7sB
	hcAbEWfbckDlKF6nWuTUJDyzr+l7lFmp/qbacSiBmbWqL8j3hDb2V0DfZW2T+8lB
	ssREvA/IpZAnhCR7gEvFeR6MWi6IyNlKZDeHnL9UA9gxfQ5duhUfEq4isysUea+H
	FylVuT8qBwdnnGirr1N5GXIb6pcT80G7vp4O/1R2bEdSBEmKhxYVf8xef6Z573iQ
	+N+RGlVDLZgCexIOqT9fyuYJSDP/JJUf6T1bu+jGF68yQmoqgNCgz5Y9ux4gxdpm
	cAu+idzceSNbU95njhRzgdXfUs8FicQ39JHeBAg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:g8d1SrDpkB7jFw1yVSxo1IHVwGPdxGif6JDacDKKV7c=:m7M8EwyUOl8ghFICT+o3uF8kldXOlLzyZO7zAE8a5XI=;
X-ME-Sender: <xms:BfTcak997IVkCQBPfnV54n_kMjVlcAXqU9z4J-Ol5o7fEp0FAZOktg>
    <xme:BfTcaomjHWEB4q7g5e7J23YIVcMJKz1k1hb1viT9_traXPZYuAjiepXdHv2-1BxoM
    eo8IgFFYb5yniN98gUCVhHQQaJTjrmpl3SZoE9Wr7k1r1jiXzYcV3CS>
X-ME-Received: <xmr:BfTcalie65NZxHZ5PMXOP5TsxLKCd6X53h6BxpPj3ZmHQ5g1-xh4M4XmKAsMxYBeJstJVGspAEI_SNhQ4rTrOIN_gKnhpQXY>
X-ME-Proxy-Cause: dmFkZTGCqH1U0fUyPYkYXCdWJpBt4Z9n+7HApp/XAxf2t172zYJ4sracn/P78U5r4VmMLD
    EobjwBoomajwoxxNIBNaNXhy/0bVfBocAUao5qQ/9DcmZhx2LhjLdoBVOYiTpnDtunHJpE
    LO1zvnf2Crm9730d4QgEcARhyR1oHpDXWNoiMZF3TLxRj3RP8VCWSsGFkYRttGR6AXmBOh
    lj4Ncmpb0j/IjrijolQfh4dH+iI7Ptg66rSDFsYMQIR4mOCJfU3ZjcD71DXRoU4cxlUePk
    5rqiF8E3EAqApE8/HTkI3GFtnAHfukY0XmG951lqQGKQPPfCMzEk7yprrZJATQyIlPiZA2
    zXyRvJUwHW5b1iJmWAL9bRMuzS0l4fSKfrAsdILtKzrhnIlAfK4ZpTUtut8/5Rm0ZSdfpF
    6P7RIzucL4nMWVCPmk2aRLxkwD6YSFugDmwgpqHELPfU8kkTn2VpM2P8ohJMZyL8cTQzez
    yCpnrSkGOcnYF12bZRfi+X4hZ7zj/Mh5TzoT5KUSK943X8YIdbAJLqVK5tW9gwNUo42BP/
    Jz5e9W8729g9Qb3/3bL/5aFzSDYyYaPWZfeTanppsBqOSexCL2hQ1jn1w1tu6jU4Ls1jUe
    zd1Oc3AVI8EgKPY7TkYoFsBokMwokCJj3x5jSDcFeFzyQ1v5UMfQT/y8irfw
X-ME-Proxy: <xmx:BfTcaoZlKEiEyRftZQxgra7xREaitfk-0OGQ1RqOM9B64tzKx6tsjg>
    <xmx:BfTcahFXXUuvLasybUVhHywGN7xt_IFnzE4ZJtsrDfpbvbdIE1CmFQ>
    <xmx:BfTcatbu_rQl_NTTgQr9YtzNLMbHJJw0KsV_3rBH6sr7StqVCdU4FQ>
    <xmx:BfTcaq0WMuZ0-I-zuS0DniuwzQ89K_sV3WflWE_mWbzjdGeGWgMA-Q>
    <xmx:BvTcajSAJPJSZaRnY6Dz_afdyaJkP9JjzoJttMVKymOqFjp-6JV9CYH0>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 24 Oct 2026 14:08:03 -0400 (EDT)
Message-ID: <c2227d20-c533-47ad-8446-aa0838f7c0be@pobox.com>
Date: Sat, 24 Oct 2026 11:08:02 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Barry K. Nathan" <barryn@pobox.com>
Subject: Re: [PATCH 7.2 000/243] 7.2.13-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261024064731.125251200@linuxfoundation.org>
 <a65e25c3-b1ea-4b8b-bf3b-c5de0d069b22@pobox.com>
Content-Language: en-US
In-Reply-To: <a65e25c3-b1ea-4b8b-bf3b-c5de0d069b22@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/24/26 7:32 AM, Barry K. Nathan wrote:
> On 10/23/26 11:59 PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 7.2.13 release.
>> There are 243 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Mon, 26 Oct 2026 06:46:54 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.13-rc2.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> With 7.2.13-rc2, each time I go through a suspend/wake cycle on my Lenovo
> ThinkPad T14 Gen 1, the following line appears in dmesg:
> 
> (NULL device *): Direct firmware load for i915/kbl_dmc_ver1_04.bin failed with error -2
> 
> This is new and appears to be a regression, and it is 100% reproducible.
> It does not occur with 7.3.0, 7.2.12, or 6.18.59-rc1. I will start
> bisecting it shortly after I send this email.
> 
> In case it's relevant, my ThinkPad T14 Gen 1 has an Intel Core i5-10310U
> CPU (Comet Lake-U), and it's running an up-to-date Debian trixie.

It bisected down to these two patches:

fs-add-umh-argument-to-struct-kernel_clone_args.patch
fs-stop-sharing-fs_struct-between-init_task-and-pid-1.patch

That is, with all of the patches prior to fs-add-umh... the bug does not
reproduce. With fs-add-umh... the 7.2.13-rc1 boot problem happens, and
adding fs-stop-sharing... fixes the boot problem, but now I have the
new message when suspending.

dmesg context before and after the new message (should've included this
in my previous email, sorry):

[   55.793416] PM: suspend entry (deep)
[   55.825734] Filesystems sync: 0.032 seconds
[   55.825812] (NULL device *): Direct firmware load for i915/kbl_dmc_ver1_04.bin failed with error -2
[   55.826364] Freezing user space processes
[   55.827740] Freezing user space processes completed (elapsed 0.001 seconds)
[   55.827744] OOM killer disabled.
[   55.827745] Freezing remaining freezable tasks
[   55.828885] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
[   55.828941] printk: Suspending console(s) (use no_console_suspend to debug)

Except for the new "(NULL device [...] error -2" message, all of the
others are the messages that normally appear when suspending.

-- 
-Barry K. Nathan  <barryn@pobox.com>
