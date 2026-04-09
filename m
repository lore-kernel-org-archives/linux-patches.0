Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620CC250C06
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 18:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775759024; cv=none; b=NstwDAe5Iz78vg2axXFqkELwRNX17asPA3SaztWzXK38ycqAHDXEgNddVbVUPldYl1oi6uKZGRQFa4x8IBoMsq75wpSNSSpo23IiUzmmfqNKWiL44/KXbIwXpKOZGsnyHiG+HjXm0N5qPP2FibZQyLndZADqrxUsTDsR4cPYLm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775759024; c=relaxed/simple;
	bh=oeq7s0lhK0zhzYr0w1Zc7cxEboofJvFkcR2pUaOGPIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u4LCTgbnKsV3C5ec/5TIs3KjH2TLVaSDSEvAd8lJNaS7sQvjceyzf8ibMRaweAVxf4A5Kj2tTJljx4Zq0e6yaTGwLnpMgFQ3sWtWpHBbxZBnCTYI6+FKWmYWwu2ZlGiZshTDOcDwHk0WMmr66D+uQJB4m8Qent/q4FhdRAIZZ68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RN8zHIuO; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RN8zHIuO"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d01d6b50cso1209856f8f.1
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 11:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1775759022; x=1776363822; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NBLtaC6G4hdKof7b+8a+fEjdvMltx5E+JMG1/EbDAis=;
        b=RN8zHIuOM1ajbcMJID6ANz5mLfgPUpeC1YpgW/qjlAQhAXPL+hL1hDE25jzcchyjDy
         7RemS2LFgkX7og0WZtj+mRFCEvzC+z1KsE36yrnPQ+aN6azosxSoDRWF/3X+s1N8ALms
         03Zp6VoAbX0RjquZtVQvk/d36F6ow1RiCKXARGhZhoLRzLv5xtKp4UdkeAW32T2X0v4g
         hlYRIWdyqrUJ9xcPIqlUImULWkmTjlFWwhTCxhpZQvsA27rttLvJ8jgI8X68a3/D1j4M
         fg78YzrWGWaDz5gVyKQ3dCf1pxBlDhsNxIzQ5j62DXH2jpf01HQjxBccePXEtoBSu1uB
         agcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775759022; x=1776363822;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NBLtaC6G4hdKof7b+8a+fEjdvMltx5E+JMG1/EbDAis=;
        b=R0yojOl1WFtsybEicKnCxyNvmJnyoKM+AX4N+/1EXgFvCoeQwnIvcAwoP+pqKWak9n
         FOEP7PiW8mZxUXdeuNQC/bjD/8d6JunZgLdXWaNhJpOlLJOMWdcq1v+gJLXKatT64aWT
         Zarp+1VD7zK0OFZgiAZrWkN4e+BNJ5/KDr7UcY83k8sPoX+HAIl7iQC1PYMDvzJaODgY
         5dzZWmwpmg4dSV/pbHSxjm7x0mFe5f+cneCmmiwZTVGbc05i+w52P3917MsgBHrthSyn
         hjPxt8KpaLhTVey3bzEF9TTa3ah4qp3CHJkWTx6a8KeTOXZlIDOvLtdggBkZTK9GsNqE
         iKYw==
X-Gm-Message-State: AOJu0Yw/3s6/xsCaJRnUmDBIecT5m54d7Br7INNYg59a0WsHvaPtQcfg
	/i49Yy+/kfhpNbMYwrDo++klu/y+uLIw8xAu3+Va/TT0dJIWxbKM4v4=
X-Gm-Gg: AeBDieuzaidPc4VXj2QFcoaDUV4CJFnIkNfrwC06m6EsPKWj6qCpt1AODH0x7vMD+wR
	tu4QaWPmPM8S3BwQ5jxkuEqEygpOFfsccJ37RkezkGuqyYSeri9wKPTjZ3nS4SfTQ2AtU97Ky1K
	XUJDTc8mL54VHf/gFu2VjB1T14mNsfDMBtic1X5qoZvhd+t+byVEWF1JIIJdDDpYL3hEzMPKdlh
	ysvj165cF8hA+WRbp9G27ufMZ/OZnThZIwoyN9QCX9RPiZeT5qtRoebAFUhvndMZzHrzCTVm3cA
	UDOMPp49nAsFOqkqPF0KvzL9rdN2RNZUt73jxpt0qxJAn+uewQwecYYxUG5Hg6fxk2JnfV4pmu6
	mTQUAlchI2brWHmPB66gG6lrpJdF2Tzhwa1/mojh8obCjD4wA5oDz1MSrH/vVpNUpU08uuLWXUZ
	fa09IpoyRi9sMzBnAhErvK74Ldp9nukdw0zcuqR/Wjq/l/zRzlu12qBNkx4slFyBRK+ZLtkch6o
	dI=
X-Received: by 2002:a5d:64c7:0:b0:43c:fbde:310f with SMTP id ffacd0b85a97d-43d642d35d2mr162108f8f.36.1775759021651;
        Thu, 09 Apr 2026 11:23:41 -0700 (PDT)
Received: from [192.168.1.3] (p5b057c8b.dip0.t-ipconnect.de. [91.5.124.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63dec27fsm721122f8f.11.2026.04.09.11.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:23:41 -0700 (PDT)
Message-ID: <14ab480a-d974-48b1-bc1b-2f2b16dabc3d@googlemail.com>
Date: Thu, 9 Apr 2026 20:23:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 000/311] 6.19.12-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260409091742.514769762@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260409091742.514769762@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.04.2026 um 11:25 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.19.12 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
