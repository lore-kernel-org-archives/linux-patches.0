Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795142957;
	b=EVO79FLBV/KqA2976riBWWlxmDAmdaF8gArBoYgguQcYCa9FDayLum0j6G19w03CshOP
	 7oagxrAlwe4ClwY6xHQM9kq/r+U4mJbY0kp8Vq3Qjf4f/3Cgmm1nWJDYNR+ToFUMhjqED
	 xq/Kkcuwaocmd4Wn5gx/y1Yg/8XxF5V3AnPxqDzUIo8qnUtCJqFhNwVBbFj9GxJQEJMEY
	 lIjJsqcET46mrq9qZuEgOCQCN3AxatOnL+4ABj82XglFfnieHNV4OLExfhuhT2+fMo/GO
	 /MRjgwtSFlslDjGMwzUVZAlDlVjN6U16Q3gXBatS4WPY2YSolhE/cHNV6udjOyLAb0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795142957;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=6VLGH5lDRuEoZxm3qN7wUhKBcZZbsMUuJmVHOHEW82w=;
	b=ZK0U4ElilILELPTFTx+TOVDtJLan3Rtwytoc7yDQF4QGVV8YfH2UYRbvmI7/TWst3k/o
	 9Bsfnt+8CsVC7GONBteJocJ586rt8hSdIIr5cKNg2kCWZ4gs2X7NgAkEf/MlygQ+y0uwi
	 LiULWxdvsRzz/7WE1eLFMRfmPDookTHdYkSMg1EUy7THTEII6Tbnhv43cBC+FrpBmo3qq
	 JvFPYZkoS8Qn/IdRk2N6MiYs+di6eTrN5jMt81LyN+trixvRPoyuSXFB4Y+Lb9GECpx/1
	 Fh5mKeMfHjsXciAvL+IJgKb/35p6TTVbSk/GDqcVgT2dXyChY9H0o7TGjO8+rNw6Qvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=seanlyon.dev;
	spf=pass smtp.mailfrom=seanlyon.dev;
	dkim=pass header.d=seanlyon.dev header.i=@seanlyon.dev header.a=rsa-sha256 header.s=fm1 header.b=rsBXwUOM;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=FWTq521k;
	arc=none smtp.remote-ip=202.12.124.145
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D7B606A339
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 02:49:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1D7B606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=seanlyon.dev header.i=@seanlyon.dev header.a=rsa-sha256 header.s=fm1 header.b=rsBXwUOM;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=FWTq521k
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 3ABE91D002D3
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 21:49:16 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 19 Nov 2026 21:49:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seanlyon.dev; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1795142955; x=1795229355; bh=6VLGH5lDRu
	EoZxm3qN7wUhKBcZZbsMUuJmVHOHEW82w=; b=rsBXwUOMkqseJ0vA1rgV83eqyH
	QGSBcKk/ND6X6ONsnuvFyIyvdcaDFFIvHejMTHd7Bd4eWG1SO6SdlcVjsA0vmohr
	BUB4Gvq1rF7BRRbnPfv9eLkVdlGhaemROUdS/D3RTrrzziHef4msWaMpLzviiB8o
	bow2SealgSsmiHRkhCGp7+kWE48rB3QF9HeWOOXBzvwnaII/RBhybzAs1pSwUVdd
	gmo/dVq9K/C7XPH5D1q4gpWw3gr7ptPISNXXBbnSTk9Vip9LUhahZekCWdMcmT2y
	zMuQ5GETvFZQiysBUlDfrCFhzuXJVeYB3/WsMVWyciEqZVp/17eICbR5foag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795142955; x=1795229355; bh=6VLGH5lDRuEoZxm3qN7wUhKBcZZbsMUuJmV
	HOHEW82w=; b=FWTq521kmSJbu/xu1YUzIZ0XzcS7pUWQta3RL+tO6Hf8Ub2Ebrm
	wz5W79TrORvfZJ7cxB8ND0cmw3uBMuGZnuUuL79TETveT/79i4ZTFccuiRnEnI6K
	xC+D8DjoSK19uP3lT6e8uOCMZbn/y5uxzQN/pVNSjwqp4+CldytCiixRsy+y9dy3
	L2l0YnNRXOlTaNfqYoL0c00tRrvOoa2wAvRzO5UtEq3Ysc+xOm33PGLZw/Vg+onK
	cFOx+bWw7Wbg/j27x/59VJGSQ02gakCYCFKWnCNNUhg4nc5kuctNCYS1Nlg6X+Sc
	zJBfsZZ82S1yw+dtugsws/XeWTqCd0PureA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=seanlyon.dev a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795142955; d=seanlyon.dev;
	mf=PHNlYW5Ac2Vhbmx5b24uZGV2Pg==;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:kqtkf1VJd4QI4BoRTBLzejNTFovjm7oVgJV6Y+IwiiAnwjg
	JxcTuuJQn7wG6QyBozi1/TTiJFMZnunhQRAWk1dnhyYemfxnTMaTwQfm3Mp88vcU
	+o+JdHtN/mwjz2X+Ola5qRvVwrJfxk2zwuj8mLEdr0YVrZ6rYfcT4WonqhotIf3T
	e9G+etbD2abbmt/GV4I7oMHXqCxELdnYCBKo8MJmfmIgag5t/Wm20VkCq97eixMC
	a8/eyQqBAndpa+GWYAhxA6GBpwkc9wW8lOJVGBrKsUTeGQTYu75hr99lvN9L/LH3
	E8HNRSVXbIOxVaqv6hI18W5wyKeFKASMSvF1rKA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:GfVbilHG2S9WlfbFppnnbQ7kWCkq2iDTBeP0x9IgCss=:iBcyE1DcFnt6Ci5npq1nXA5h946qJXAbK8vYDTI2uuk=;
X-ME-Sender: <xms:K7X_aiadElARPanKQCeMss6NSx9B4BLa6DvQ7_MtsYsv4kLmb2xhKQ>
    <xme:K7X_ahRcKIDu0XkfTZntbfnK1kc4DVd1OoheTcCtvPhVQAWAg9rDBWFm6lDrVNFfb
    FxodBVDABBqdNZn8O1Awn6_VpqeXFdAQVfM2_d-EEWg1cwLPgfvRqj52w>
X-ME-Received: <xmr:K7X_aocTbReGrWRL01cgE7NYJXoZywWx0nLD0wawYPKGEJGXXvW20Jo-_ChS_USYAttnWK4i6DfblTsoZcwMv1TjA-E>
X-ME-Proxy-Cause: dmFkZTFj6X27r/4o2z+Bp/YZc8Dd+snsJg3Yr/5+DBZDNFJlGVYeZhJQxOMDnIPTkUI1me
    2ZuCwx2kUkyNtC29DdildTgJR8sxNPGT9QqW5SWn+d9p40yckkLFVWEE3DuynVZ3z4DZ83
    RNOjpiHfaHh+RVzzRmLTE68nS0yX2pssGY789lEzWPalYJ/aZEGcFUamvguixnpv1yAMk9
    1ZLQ89ZdzHYeFpSgO+hIUPkksTxL24oOV/To+MemT4JsMSKHkDBH3cW9U2uVkQSzn4QWiR
    tW8wUlWckwNQ/+qa3H2lOTv/mTf6qOKlX9dxuT1hZQVwDVm7Bxf7GgZxF0no5xeU1s57qG
    tURWoowlC5uu+yc/haSfhWh8nvSKw6uNRTxt8TAWKk2LrB0ZPcpebIU7xowp0qanQ79/3X
    B12nwi7JPVKqiAtQZ9jtjAwFaDx2KTLqm6E8DPprsjPXigxp3mMRs3UlZOvR3U6Zx9mWVh
    uvtCiKDiKXBE+IFkEFzMhQGL95axruGr9AaUeH810vkPrt13X94/hSAXelQ2TXqB4AScKC
    Ap2ASCKQjI4sIb/k+2wo0GGmEhPVIji9CcuAQIlsdEth5VSoiwrwYhhZtehaMy00hsXhFq
    v+AcMmrBehhr5Tnd3cbSUQFUkI7SmnJDhvp0vSsEsLmXPU1HrY0RdDyFCDJw
X-ME-Proxy: <xmx:K7X_aomE417Fop9n6J0ZB1bjHn3PnaFXb7mlIITHk6MPSkRtuIBP7A>
    <xmx:K7X_alg9qkeR6O9dq04mYdu0H24fQV7sKo26tSTdamnZ6hDGMjip0w>
    <xmx:K7X_ahHFFBRC1A969b--Wyx_ct3wz5Mj89Fs64Q4eYVgttWGjjG6bA>
    <xmx:K7X_asxPW6kDmw9qHBIU20QqLT86QMrhtR9VsNyDAx6g-CDgXPWO8g>
    <xmx:K7X_asv3imRorE-HK6XsEJSkPNcEvOZMVmh6bDNFIw3YksN_zdTZk8Py>
Feedback-ID: i07c64b5b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 21:49:14 -0500 (EST)
Date: Thu, 19 Nov 2026 21:49:14 -0500
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
Subject: Re: [PATCH 6.18 0000/2151] 6.18.65-rc1 review
Message-ID: <av-1KpYIUgQtPs1A@ncase>
References: <20261118150121.603863898@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>

On Wed, Nov 18, 2026 at 03:28:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Built, booted, and tested on hardware for x86_64:

- AMD Ryzen 9 5900X, Nvidia RTX 3080 (nouveau)
- Intel N100

No regressions found.

Tested-by: Sean Lyon <sean@seanlyon.dev>

Thanks!
Sean
