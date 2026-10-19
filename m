Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE0519CCF5
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 06:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792389874; cv=none; b=P7TEF3rhpR+jLo3lBXHPkK2xrS0yCAG3yTxX0CG3VEI5FRSRZvqVFELB4lGUWEd31dzaIxwMOgysRYTvGiNWpAknyCcHTUE3SbJN10WnEs48ytZbh+rG1mFMeDZHd+FH+q22kQIST2MtttxKjy4U+2P7cT0NWj3zf+4FT0l2yHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792389874; c=relaxed/simple;
	bh=UpAbfxihf6NJ8F5ckaOty9uycZ4I7rj2LCsVKLG/4r0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qK9oic+ZQBNNlBLAK7X/bbAGCz2uCpAjg4WGW3E8uxW27IPOt+nFS0eqsLgll3aJ+P86Fz319vNp37qaGPsJ94eNIocWPuXa3/3uQ9Gzw7EMgWeAkwSUDPYCBQRoI7DB2jpy1oAqJ+dO5QlC512Zd+3ScNFRRBVg2Ki10Pjj5XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seanlyon.dev; spf=pass smtp.mailfrom=seanlyon.dev; dkim=pass (2048-bit key) header.d=seanlyon.dev header.i=@seanlyon.dev header.b=jhoDv9hm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dQoHNPnb; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=seanlyon.dev header.i=@seanlyon.dev header.b="jhoDv9hm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dQoHNPnb"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D11E41400056
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 02:04:32 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 19 Oct 2026 02:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seanlyon.dev; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1792389872; x=1792476272; bh=m7HxTsbSYO
	NKQfBmB6CvSOTMoyZG0SvkXRsK0VQtehY=; b=jhoDv9hm9WdY6PoF7qaYSEBv4R
	pxHg3nYoAZujLphTy4jXw4xgPneMGCB+FqtAgL5syl06BjWhkI+6Ysez5slyrUWK
	Za4lIjfr7hz+tl1BIVYDWbz2+5OG4kKn826mzEQGTGrO01sxAjat8olc71kEOP19
	U+Xqc9yUE1EOax2YIE++EPP4E1wqMZfzM2CWjLgT7OrLR98VyUm1onmTlxESJ/VK
	fZ91Tfdqg7Ju+9aIoht/q/n0J6xrniivaQxAMzqp2zVdfBXehMXmVyaK+Zk0e9dQ
	L/KGqR9lsYdrEDsdL5DCKhdZHBfzLnnZTPRtgfymTIrxnijoxXogrPHox8QA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792389872; x=1792476272; bh=m7HxTsbSYONKQfBmB6CvSOTMoyZG0SvkXRs
	K0VQtehY=; b=dQoHNPnbqzcAiVjCRP5REVcCK93kXQYawnRXBKR5yAAjMjgRhnB
	ll3RDVvnqojYL1wHgm+DJhUYkxr7+eltfCU+Zlsp/VqP/nK4apG0J/mPcTgNommz
	2jBBhp3x1zvRoWoD+dO0EoEX05E3gIGz/62sW4YyF8UcBXc6V6jUcGjmFUCFq2oV
	eoAsH4It9pJ6C9xmcx8DC/dZhSRs3aGlI1Fc2tyYVsYWx0fp6f2qXzOvJEMoXk+N
	4Hrf2IXuIVYNvFCYAWpQryJSRzAX0Lcjuz2+RPHD2kRTzKfZVnqWBhaXZXYafvO3
	BqqK24hb2w3txDcHk3HWrGcKSHEgMnsw1dw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=sign d=seanlyon.dev a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792389872; d=seanlyon.dev;
	mf=PHNlYW5Ac2Vhbmx5b24uZGV2Pg==;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm3:rsa-sha256:fWKEGYyfJROuNV1iHmbWcbxilfS/mga6smLY6URn45op21l
	/wLlV5NJW6Ujj9Y0sD3MaSDneEwtbBZ+sPMibwW8veUDPGahyrOfA6ebCmmH503O
	OPcbbHs0GmnfgmJ40McV1Ifi5k+PQO+s4k/xZiD1TtYklrx2p6bG2vwvVcpEs3tp
	6VFGozXpq7w0skoWHCSF2DNm+SXa+M/Quk4n4mEuZ68PBZpuyW/VL+D5BBLVDy0S
	m8Tf6aGozSY1XOBrgK8dcg66exRBhu4CQuMm5SUm8PxGNAix1DP9NtymLPHecWoX
	hc3SkFScPuKyRuTQ2gmuHUEjokPsFnEh9ViGOgA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Sh6CgQv2lVWYGjpmv4KDiE1snbVoBF0J5If67UmDqac=:UpAbfxihf6NJ8F5ckaOty9uycZ4I7rj2LCsVKLG/4r0=;
X-ME-Sender: <xms:8LLVarksXwYdKgqUn72rtBdhf55W784kxdSSuKGdhFqOV2t8I2jOSg>
    <xme:8LLVaquPQ73m3vDC8FmnT21G_BOv6nnEEUz1ZHEb3GW9n-htUsX1Sh23-dj-dnWky
    G4QCwgAxePGztmASOLaMD0PZV2lB21K9g5CBi2LTkOTp15RkSl2drAp>
X-ME-Received: <xmr:8LLVatK0jw3YGwjilJWNZKx5Bh0Te8ooyifyegDw-C7epcB10CsPPl-2pqNsO87e4eLSU6uLr--jZp7uWmAUXXoSiQ0>
X-ME-Proxy-Cause: dmFkZTE+hzeJAZQnGrgLhmSW9gh/tQXt9DaFejGM570UW0kAlfkbKUO/i4O0N5sEnRhUhq
    6/YaxA5ux0CJfN5JfG3K0/FCNnt3PuSbFKfF62ypE+ZI4Vw0iL7W8Gl4s0awi35f/5rhmQ
    tA6DJ53sxwc9wDhkCoXVtR5SY84HXgmRKi3r0lMtCLHGbpiDtF9BEn66ulkg8komwp+QuK
    p9E0a+6botTksQxdE9E230skmR3By5GWLKYHAMMfTvIciY9IdGkiSfGWDnWNS32hE13qvn
    yExIF4LQxpmlqUM2w/QiMpY06JA63uTXp1XmC7xz+lH1p5sRf01m2uU0m1b/1hQvaFNJHs
    okWxalxq5oW3kCQVXVM41D3ahyaAH0JIcjKmzkYEq7LW/9Tn8FgxylazxqbIcPZqpHzs/c
    83oIBzigYJNZKURMqSA5y1gUIa1xlVMinYaXSr3Tq0vMwNFaRbRjuovatRFGd7f8l/gw1n
    ydDysFDyksF47U+q3MLQ6HxJ+0Tit/U/XBjg0p0yHgtx5qEIPq3ZkW5FZ+jTNCJBhS/0my
    stMBQYMHay2RsAtFaysDC8YCSpPY6H/TYcGvSrTBrS0/aYoxGdwgREZVCXqyWRfQsAHQFE
    +jWhrdcb2drQkUSAZS1h0kC6nR+PMiB1t+7nQ1sM0+oz+KapgTkKuYMuEzOg
X-ME-Proxy: <xmx:8LLVaniTrwOMnY2br2lAA44HCyVZIdWfWwHIzu8f1pxnsxj8XzWDow>
    <xmx:8LLVahtTS86Ty8etF4BaO_rMUZ6pC5PeFJNGDCm2zrAq2mSj_YvRmg>
    <xmx:8LLVahg7_ElxYOIWJI885n963vZKf2_jr3RlFQOHXBwml_rnf9FQXQ>
    <xmx:8LLVasfaZnF1fnOandJzrLyrL7rpV27Wdi6IvM000Qu4BfVmhr-wzQ>
    <xmx:8LLVaj6XJLjQZHNSilRn4Q8vtkENakwqO-i5MnPqq9cmZM44_LfvpwU5>
Feedback-ID: i07c64b5b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 02:04:31 -0400 (EDT)
Date: Mon, 19 Oct 2026 02:04:31 -0400
From: Sean Lyon <sean@seanlyon.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/52] 6.18.58-rc1 review
Message-ID: <atWy75eclKHeeE6N@ncase>
References: <20261017155104.830766652@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>

On Sat, Oct 17, 2026 at 05:54:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.58 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Built, booted, and tested on hardware for x86_64:

- AMD Ryzen 9 5900X + Nvidia RTX 3080 (nouveau)
- Intel N100

No regressions found.

Tested-by: Sean Lyon <sean@seanlyon.dev>

Thanks!
Sean
