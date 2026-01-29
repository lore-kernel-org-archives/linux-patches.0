Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BBC29A9E9
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 02:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769652603; cv=none; b=o624eJUYzsKKb3w0wxJ/kRQQUhXHCG/2JsbGSJcHldBib71D/ojpYPwTWW1Mfvpt8gaVt4+zeV9G2yI9g92jkawzi8lKuyGhhQa7TNSwQOu8g3he3E0/ocIQBOYpZBsG4psVDYVmBxHp7Ueao3QSvX33HOx4FHqq7U6/eET/Grg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769652603; c=relaxed/simple;
	bh=DdisuJYQPCAap3IIi+qFKZXxHQf9hAWBIV59WhcPkYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HpZLt/ftnXFPN9qx6Yp7urpj3YOnm6sl6hhvxLRNwI+qBMqMfiRhhNacCAT5kvPGM+W7qbtDPRa+8qMh6+SRaCPp45IVkFIpqEw9OHKp/ziIsVoIh7qutZDgP+ijn5DsYusuicXc9OOZvdO6v8wCTJl6/g3x+ouo8duGVMBvHqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FKSOPGMY; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FKSOPGMY"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4806bf39419so9733355e9.1
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 18:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769652596; x=1770257396; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dqjMtN7GBxYjxl0g8AFWei+r0EcmP6xP0hMaaJE3YQ8=;
        b=FKSOPGMYAPhxNShq5gVHWHVtiBlANA2mB/VcWpvgr1kDMjw55FphW1BSWAMOkEr1h4
         sHt6NlYqoywm+2dzt2bx8kiY4zYiNOJ2ptdm+ysamW7clsjOnv90m+4zuIXpF3+1r6pV
         89WPo8hRr56i+MvSawA22LHNuUbnxkYuOo/Sr6INwoAmf8nWtYwPH0JsTKu6NHYkOwd/
         464ps/o8yHBlqGHG1UTKVL74MAFTMZlAlRHariAVWo3NcuRrHakKK/y8mepIJkY8fF2z
         xuykshkRB794UWR4wT/hNmjCDvXU10XUOvS13YPciWzwJ8g8KSggpCXUfv9xOINPovbL
         SWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769652596; x=1770257396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dqjMtN7GBxYjxl0g8AFWei+r0EcmP6xP0hMaaJE3YQ8=;
        b=J8CU6EVvrCz00XQvrPJy5UdkyigSk5Jmg6a3dcWVRsdGi1yCAj9f7yzM6a0R3k1srB
         Hp7REsbnqTKy8nkMqHhMeE1f70PjAClr0UdZLeVg+vVYElae4ajDQwGW8/rrnoFPZ+Lq
         F7/POqQc61kliMMJj5EFvcXnl9QhCbOM/HzTj9LqecQPstuOGG1eaOGmRQArhCyKos9J
         LY52Hy8r3M9EqYCbsx5uMyXiSB13WUKWpzFhN/ONBG3Vor6hRuTXkOcR6jevhchyVrtY
         TwB/+SSk33bVFibDqX7+r2CTeXRH86I9+P66XKfW5Vuoq/VD/T4WAxBn0ukRgrbPLs9B
         mmxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmvKJ2tb/2tV18X++3wyeK09xxSYpOEZWSWBOY+SlYE9zoEIv6Bnbh51zwBkiYQqQ1+OsRyCTV@lists.linux.dev
X-Gm-Message-State: AOJu0Yzs79hKnJUpK3kMccsZ34QXr4JNUelTnli5dwpX+0Su81OD2+v1
	TN/eR0L6ngWUdl39acdtP8ChcvXdc6Fp3H4qaHlny654snn99mBDzuxKpQwUKN8PDHQ=
X-Gm-Gg: AZuq6aJqjD3VM4mtq8ovfYPswmSHq4YPmLjj9Xp2cFYbhOLfjeaNRZ7rBsj/7E8hV1M
	NFsvwbSHCSF7AjhvBxRtwoslLqsoK+2aNP610F2y8WACiA1k9HZq+wN6NuVhGeUM46HYZ0Mc7MV
	8KNTzRYBxMoFt8uKIcEkreFRxjSYFaoveSi1IvLBaZ0+UR1OgaveoF1Sdry1S2ADqa/QSchSdd1
	NAGhU2BUE9L7pUkO0SdWq5BTnnGgq2ZyfEKz3ON06/+mHCtmtM0AXJO15lNoFOxJEXwYY40SxXD
	mng4Lp5NWtHDUaY1JSflDDpsqi8IBS5380B/qzzV+9WGHM6xLkMtzZCiRRAwsfq3bbaOmqWy6AS
	jFegVBAxhgoT8h6Cd0IwxDgOERHCvUbFO1FRN1OP6nAx7rEYKBZNvYaZ7tO4aSjTmUE3YG1przR
	STpiEoOA==
X-Received: by 2002:a05:600c:559a:b0:477:9a61:fd06 with SMTP id 5b1f17b1804b1-4808289208cmr11692625e9.8.1769652596348;
        Wed, 28 Jan 2026 18:09:56 -0800 (PST)
Received: from u94a ([2401:e180:8dfc:3cc3:8fe9:e99:6cdf:244e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b6e55efsm33397185ad.89.2026.01.28.18.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 18:09:55 -0800 (PST)
Date: Thu, 29 Jan 2026 10:09:48 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/169] 6.12.68-rc1 review
Message-ID: <rnmchlhjn2tq225wyh2kxk3cfjlp42dcwmwtp37t675odwwwjp@4ncop4un3neo>
References: <20260128145334.006287341@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>

On Wed, Jan 28, 2026 at 04:21:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.68 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/21450963930/job/61779347559
