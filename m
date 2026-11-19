Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795090823;
	b=DrVndUyrNo8Ot2agch9gpgWMSxog1w1Zo+PlEoN+jkeKYUYUpOvG5cPh38virAFFE9d0
	 FVWY0UZbuDnc01IOEIV/ZLRn4GM/MLXPOd27bMAdPt7WU2KVb7J9uwhhSe09HEkjjFHB6
	 xaKx3C+OshtkX0mMtfotOacj1Ozrq+xX75iMLfGI6QDdYDXvogVFVbjlteVezdSUfawQf
	 Dr0afoOWLNcuJIRM+4k4h7Mk0iy5KXVopNIeAjEhfPPpOi8M82y8nYwtTpmDdyvm9ea3d
	 lXRdDYnptsixipkA1/atmlv/Cde3NhMRQdBdYGlTUGwiMClahz/+/jCV4ZxVz5VzgFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795090823;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=obCpA7NY4aqAl66oIe6lDpGamnUBgIspwnLY6IpvxLs=;
	b=tPQLHL0pWcOUHJN9zAPvnut/okQG8CreWVPwBYiYFqkAE5okIj9BLGTNhkAZQgytMhXZ
	 iVTeiGQ+MYRdOEBJzoxkrt+AvHDra2+3TOghAyD1t9Mg2AoJUJXntrATQTxsOse3c6Uy/
	 PO5qPhiXtXStSqjsM1WeRe2GaveRkhU6jUsbdZlutQ0lw+V2oIcnh8tNF0Wj2ZMS9F+/K
	 yaastdEonGo7cJhPy4QeiCcd0I537IdGjT4z6T+T4kJc7nmVHBkfPZwvGengLb707I0D5
	 ZnQ6kS6uQqmos533EtbIKAAABMddnaHh4VJNVF/0l/VMmqPLf72S6D/OK2TGTJaazDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=JmPpY9qU;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=rxI7hiza;
	arc=none smtp.remote-ip=103.168.172.157
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809CD606A325
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 12:20:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 809CD606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=JmPpY9qU;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=rxI7hiza
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A292D1400154
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 07:20:21 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-06.internal (MEProxy); Thu, 19 Nov 2026 07:20:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795090821;
	 x=1795177221; bh=obCpA7NY4aqAl66oIe6lDpGamnUBgIspwnLY6IpvxLs=; b=
	JmPpY9qUFiv0I0LvaalZvhc+q07QIBAJLQPWUnPndEAAYHidDT0ye++m2MDcQvDU
	Cibd+JNE4wncH62pWbtiThIdBQYuY/8f8GkRoAvmvptClFppwKVvxlZVJhEC3Yvv
	SpnH8F1xdfxoOwbkuDlMYt7a85HWL6Lk9N0dRyfwUPFgxX4gM962/HFZAVEESApZ
	IfYArk47zV7kWHKF6e0QRfV3mFc8/RsUvhEFKruJTdWYivAzrFRg4WoMDw81698N
	zhbu5AiQ/NDni27y6ctl1L6Hn8KQZqhPntp55MZ7hsMBv2L9kC48Ahcw0RnN7HRS
	mIFeDEa9IagODEf4wwPaZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795090821; x=
	1795177221; bh=obCpA7NY4aqAl66oIe6lDpGamnUBgIspwnLY6IpvxLs=; b=r
	xI7hizaP1bXRdz4LQ15p8QgbzXAgI5vOwLJM4KkdVX3DoppiFFIYx+J6wJjoKXXo
	VwzTMPGmNmxBd6CXahwBEqhfTJR5SaC1SLlaQ1+bZORcEFXHO+TlsXbHIimQa2qn
	QaV/0dFBN+aDl4aSFVB5ey0zYslFl8xXAfomxqsvHK2QNQT2egESamq9GGPzqf1w
	ojJcqAsXUITajOwd9qr2u+rbswakS/+nx0aXtZSSBWMjDedqeU7wpR9zawZ1gA58
	b1qI1KzmVLxmaxuY5238aKLNS5rkhktYk7ewHgWWghY6Ap0cXBu0bcGAUE/FMRuo
	Er0TC2zOJb6bedxeOp9eA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795090821; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:UauRbMMKSMD5z70Lq2MoP/6o6F+e7UdMA4qm7HqeOvQA4vO
	DXMP08OakfKCsdMQjImYiGsWBzTeQwc/zJJReoTt3JwiL7hWtRgcCWqCKl6kKFfL
	q/2xAZTbmXYUZOx7gXuHc8+KkQ0UM42BlL3KeeizQLfQYNyOyNraVIXvsz0smFu/
	US2uYE7z2kKKxgtHIAcWu9aR1AdjMZorAITiNOwM3P44bCqeBu68pD5A8XZXDo+9
	e9Hf6WTa86/MvLtAQUdRa/KCA9tR62iVvMld4CUlQi2p9y79FnVNZ8eJ7bQeObaB
	1hZ7hVTmwWpPccHnvEOSFXr3iCGSb916UORsD7Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:CGWQ6fVmA81tad2Cig6aq/YRRLRnhtKARkqYvuztOIQ=:bkgUajqYPV8WelTS6gtGJuD+ER7pbWFG4li4/uOxG60=;
X-ME-Sender: <xms:hOn-atx1A1sX_RRDQwNWw0vJGGVu0a506P-QJepA9y_jAEd_i3wk4A>
    <xme:hOn-apIlMCc-5evVx33O3pUabQeMlfjbIK5k88Vggo_GVcHMCkZ-AQLyQjtRypUQf
    1JnIWiv4hGaiT6La2cFXkJCs0hzJn3JzjUuTduNJKDh9PJm3OtxMPEG>
X-ME-Received: <xmr:hOn-ai0S7TgiYvz2exIEZPIC3n_LHAIXCUTWDunRFxOsnaNhHFB2zYz4UCSSfNRuYWv5Bayuq-M32LqzgCJSxcBwUAinQbqe>
X-ME-Proxy-Cause: dmFkZTE4w637iF2+06euw3pYOKHvtPT1HURgL8izvxy2CqrTadbChhY6tFdALr5WhJA5oR
    vv2+pJx1RbTLSvDQIwWguK/u6f872FXNKjthgVU7U0I+xFMztHWv3PkDwa6qKADSz5OjOd
    l+kvdav/mQ1lULa0n0TIFgNlbcgo33kC9++fP9v7QcZgCBtfccyo4rqvQagLFZvNTFXGRu
    XWYxbfOFMaJTzm56wnY7MwRON7IfG4/CooInHFXlKWR6m/w4JmYmV+PGga6ZaCqBuviu4l
    /e2XsLnR3RgHgZ1/gtSsQ1ODbor3OznLvalG5LP16rpfyq6DCO3GrOLBjRUHWQv6C9DUbN
    xaZZRNMmo96ry/MddUA4QMHRmXAlg3DyhLcJBs2QC6BGhQEtC+uKbs+zRrBYrroTwRPzqO
    efYii/vUaR+Gr7fg++6M8D+u7zHQaVx7skFHjdcxOty2Wmnjx0ITkhuOhV+BtXwKjz3s2o
    N0ktAgWGoy5enbNukJuR9jeiblpM9w//UWypIJJMekjmNNm3SBHAL3/3wWYTP+uC1Ma3E4
    X3apqHWSeOUKHi42UCvbTKovtA3bWJsj3MS4zGSm1aK6dwdqbRaCizVc5TSjyLvPY9UD67
    bZV25GF0eb45zQhOg8sR92YY0eWEyvYq+hZ+b258VHhUCsAepQyq8b747Ipg
X-ME-Proxy: <xmx:hOn-ajcVNFYy_tGSXN8F4oYjzStCb4yxmG4RcxClBfIk0JNla2tLgg>
    <xmx:hOn-am4rXDs-NepYF3s_etMWFu_SF8R81tLKC9H9DIiOAcPYizsShQ>
    <xmx:hOn-am_oBkMNwVQVvytSjUmNBZDdNJh7uXxT1IHdNq1VK310ffpTdQ>
    <xmx:hOn-atLS4lAda__gERvh4Aem7zaZzieyHYynnE0jZnRKO9yUqVVW5Q>
    <xmx:hen-ahG2yMoluE3bpKZJPeiTDD2niA8TsCpZ3oZScoqHclEjUgvAeJcV>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 07:20:18 -0500 (EST)
Message-ID: <85c8da83-8a27-4787-a5f5-fd38c709941f@pobox.com>
Date: Thu, 19 Nov 2026 04:20:17 -0800
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
Subject: Re: [PATCH 5.15 0000/2214] 5.15.226-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150009.797899913@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 6:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.226 release.
> There are 2214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.226-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 amd64 laptops (a Lenovo ThinkPad T14 Gen 1 and an Apple
MacBook Air 13" 2017). Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
