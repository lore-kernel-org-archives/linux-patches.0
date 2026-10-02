Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9928B43E066
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 07:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790927101; cv=none; b=jVXCDHMoP1lEZbLyLNB4vB0PChy6ekImgvAih8j0xzsl3QAXaOPPQALJjooiEpN7clF6oW+P8Xrx+Wenv00lyOWgt/SkekyxXJZHLhZ0KcmTJhDtmd7sU3YXtnJp+tBd4oodfDaFTDeJkuRjV3KPo2EItActR7GFKmXAMtOVnR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790927101; c=relaxed/simple;
	bh=LCowhYnbnLJAxxRVQo+xU8WuDn4NOmon65GBpuJWhT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H0VL/HGihlzcwgJx/L8ZwDYj2knXQjejKBzugdsC44UvUae11qXQqecWKyzGfUlcCb9ruIMPbJ3jRAg9a2b2v8dGTyCasxImocn6L0OP6L7fZK1zoRxdUXvIg+jcQRfkG72wJ1znO4JVi+8N57S7exjjCz4PBDUxNzi1MLVZUW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=FO6EpnZK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=pShE01vy; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="FO6EpnZK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="pShE01vy"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id C1B1B1D00097
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 03:44:58 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-01.internal (MEProxy); Fri, 02 Oct 2026 03:44:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1790927098;
	 x=1791013498; bh=vbej2bTTSB21ru4WE29aXHTSgKeX3cUAZE657bwipZA=; b=
	FO6EpnZK01mwyIxcSHQ3G1pL0AdnlY4lcI07zmxTvzFSlbHyZrFMsxh8sPg15JVd
	YiqtSrztRpAJk3YjWHxwtE8qSvq5Lhn+LOx9Yb6QFDHHjXyTb0x5Ci6Ybhkt/cDr
	nYZB8mvlCPabGs25yl6Ql3c2a+aWEm8ybYFYcH7Y14Fg7m7lB073fVXcbTVcwUsJ
	hGbcgLUSGdvwEQB9JNjj5ehMOrl32E4CKy1+xrsD/kAZxgoljONrF9MAXpnF4e8O
	XQ/HiI3RO+ztYKNcrax312xPSn8bZrJLabq4/R1cq2qeQmlkfuAmXkx+EnicdHDa
	tSnERlWT1nbnFhd0IS+vHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790927098; x=
	1791013498; bh=vbej2bTTSB21ru4WE29aXHTSgKeX3cUAZE657bwipZA=; b=p
	ShE01vyz9yw/MAbE8qP5wfq0Zxkdb7BGuEM7gZs8GkC6jBjDoRYIjbMl+gxzbvYo
	2EroBqFJw6MI/qOQFVCYrtQG/wSwcwOXhUGYlBBkWKF4jziH45sl9i0ntVFMPW7p
	zLM0hrpaNlbr/Q2X+3C9PCzLXb/m1rh+6NlzxdvvHdPaqnv6KovPtrN1iROm4dKo
	EIFtGCY59dRMZ7BtxFovQrIZha5a26PwoxNUfGM/+wCFM2eXc7tN1uEKIp8ltZsb
	K1nzRaCv1V4+l2UJsHuo/oNURYlhRiH7PwaJMHZAVV32jDFxVTBAx0/EXJJddjMt
	Fg7IR0gsz5jf7FGFL/ZIw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790927098; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm3:rsa-sha256:oVoWpbv4z5OCEozs+EbirGOmDZNRnwEvcqGw2gYCYtfxctk
	84SUEkUS24CKZOxlDUBALeE/8lT9rQlbRBdqJhQAK2JRCXTJr01ycoSKA9Ixfve+
	VssohjJS/Bih7srBNQPmJ+SooUh/2c/jylZcIJA6ZLF87JOjHDUbqvnPN9q8KA3Q
	prho2BcONs93VCaipcLJpqFL6moRjs7fBi2LMw6+fQEUON1OrX4hUrSFzerFjgec
	bcXAcCM1t8Jz6YNnGIuRwX8WzKZTotxsxqE19NzRAlcycT63Pl9nu4ttSd2poXOw
	HZvQB2DqpwSviI/1qIODt+LSaFouU3iIy2zNu4g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:Zpegsnv+z1EJ+i75zrU2zk17RqslZ38hPfVx60lh0lI=:LCowhYnbnLJAxxRVQo+xU8WuDn4NOmon65GBpuJWhT4=;
X-ME-Sender: <xms:-WC_ar9DNaBTqTwZNdLv-ehPfZtYwDwhrcnVVHuYfzy_RUjh8JD_tA>
    <xme:-WC_ajnBogNieaN5RSRRRpxJyuxcq6jqeW8l2e47Z11aEup1kF7yBGOZ9c2mDnQR0
    zZhobDaA9s14YVNu6_MAVodloOEUaoBTGdJ4Tb3FWMYVFpcQkaRHhI6>
X-ME-Received: <xmr:-WC_akhihV1JmpAVRAIzmE3tXUSG3xloVFGtseRWKM1tObdk3Vs7cgHWWNvlfEYIUDMDRdNrWpLs2NIb805ZISJtjH66okCW>
X-ME-Proxy-Cause: dmFkZTF/KvG14L6SoNmfOg+TwWUCpD3GD5fO5a5Up/H7w7pZTyfHzcF0fRTQ2O1u6hQ9R4
    Q7nfL5vkCTEXPmhB2TmivQ3nxJZyYb9oMp6craEuOpvR6x+bBvlp+mjWoef/3nPUR9+sjR
    KbptPwzO09bXD+oUF7wXwHtN8EvZQDnpeafnMDqZ3QczrPFfbIXz0DEXdMAklvLZ45W1dn
    pg7KIyMYPOHuK6CRhLjE+D6ag8B3lADj4di6wXE8CSgE101HCWeqPHeeCIB8c44GqZLXSp
    0/M9Z46IE2FWptS0HefnVORB0TBKGFgVNM7ytAPcjhr9Won4cicrR/JL0TjFkhcmtKPDFP
    xznIvqrEpncKk9+jTnqctjvKZwCDpCGcbvoFf0coZfuGun22dcEpY6rByVwpTXV+nJkBSr
    kMgTPNBpBdYF2JzwZmJhqyaQ1Zvou/fJB7mf4AoA+jzd7HDXNnsHY0LBX66EDgFmlOvYxC
    0rH689BKlb1CW2jkng8NrSxCe8Ht5QRkQmvdQi/Wl6SPToBtHwCJLgOXWCaLbehAGJI2m0
    pOdzMwVHkvL3L+RqLi19c2z7GN0vFJyJiyC81BjfCWwZObgxPCMcAfzEhjGGRSaS/CPwpE
    cmO9AEAw18YY8xErVFnL/ZbWqxE3RvFmZYkLJYnzwBRNz0ImxXK6ws1qehmA
X-ME-Proxy: <xmx:-WC_arZy6gUS2dzYVLBIYQHaUFFp9JfDQz6pW7-WJEJ2gmtJQo2laQ>
    <xmx:-WC_aoEUFjd6eEUDDFrZCzzcEzWJnBlHRdvyj4FPLX_nnGlEwuutwg>
    <xmx:-WC_aoY3GtAR6dml2jefi_dyKbbsWszJl316sIbzGGBUHDYCoJgONA>
    <xmx:-WC_ap0pXpZGVexq2pXC_K8A0GGQIlikhAHElAbe489ZlEDMVYSmvw>
    <xmx:-mC_aqSFKbS7K3itCFMCpIXQ99U7yNy8ZSH1PgySMt54-MozPjU1KWHJ>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 03:44:55 -0400 (EDT)
Message-ID: <0113c472-9893-4fb4-9e6f-2e38b68d59b9@pobox.com>
Date: Fri, 2 Oct 2026 00:44:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/457] 7.2.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152346.024115587@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/26 8:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.9 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1) and an arm64
virtual machine. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
