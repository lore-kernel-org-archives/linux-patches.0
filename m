Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C036D25D546
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 15:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740496865; cv=none; b=O6ilIMtQ/rm6eITkpGZl4dXUygHuyCWd3wI/HFO0CKIM9ibDsujxhhvlLnJejjyCL6icQSnMMsyCHL0I0ZmMpA8lCYaDV5iD7ZL1Png189UaliLyjL94Gm0tFyNoHeGATXdbrA3+PmIG4iChxQMHMaP90nrxvQMbB1k6HL+3Rqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740496865; c=relaxed/simple;
	bh=LEYExAvOlZQZSspB1c18HV8RXpGDdV5MPj6WidEcY3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NgHHb4FZ4oXd00q1xc+yZjNbmZNY71/6ZEX31tU+Feufm/HGEgfts5EwyB/lyhQfxSV9A0kZMqb5mXnO8P5dervFi6+O6aUtLueux1sKZ7mJSfMIpPgBupLidCZI6qofsAD/svvbVNAIlNmtXudwkzH2meyhXe6b3UNpno6Gg2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=kD1DhZl9; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="kD1DhZl9"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4398e3dfc66so50524325e9.0
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 07:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1740496862; x=1741101662; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R00iFC92M1deh98zQEz+YC258SvnhDWpARo05Vlc3R0=;
        b=kD1DhZl9ppIC2M5QQ7K/9y+5Rso7eCwRZ2Bca5+EH0ZnkjB78IcF6ytUg/DRxPzzBu
         04fDQvooQmTfZgL+6ncajUwb5SS7xwxePa4FanFi18kGFVtlUrnvZgXy4atT7Gxssh9B
         AUZNYV/ZYDlSjGb/8fS/AWbEmq3TIqguMhGgGW1Faxq/j78ItVLz7FMdi901pgsLyFex
         INUNhGLJnPXUQXc1WmQ6CGQBz3Yea2IpPTQmjPR6OebVRhLhrcT2oK4yQgdDN3lVeTBk
         eY4fRzQ5NX2o6XcYWhaE0XfNYwreglrCufDTI1Mj0TlqVJ2t1yVSpvWSn9Y6fYezNy85
         xe3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740496862; x=1741101662;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R00iFC92M1deh98zQEz+YC258SvnhDWpARo05Vlc3R0=;
        b=Zh2i4s1eKfb0THJ86//pFUS26fqc43znqZns3KXvHxfVgWT8BU28dQJ0dZdWt/KX3J
         j8cuWvcAJ9I/4lbO9zGWpDU6qvzP0OqBU40vgCf0AjS8XDS67ugHv2wFqpdkPllZfKeF
         aG4T0oeD4Y4Ps9hw4uxb6262yRTSaDTchyk++zxy/TzOZHx08CqEBl/8X4svLpvhlryt
         +9yqRyas8XJlHMnb0wt7OztOHykIjnEb/5fHHCGD5SfFWkksDlyq+JOaXthAhpFtcdSe
         ztqylSAxsQHxpX3Lfkgfl9ACNqLBHkIz9WQeHTN2C2q2IEqiuI1omthzqD3fFDimizlf
         KVuw==
X-Gm-Message-State: AOJu0YyBfO9WzpSUZPoH6NHV06DxZNOG/7i+2b5FyuE/igAARqNmRrVn
	vi/bSZDyI70hmz0Ycb4mRhQTvI+iu/IivBRS0sIawc2SIPor4VQ=
X-Gm-Gg: ASbGncv3uX3Mc6wp7L4s91KdQBnQVa6Sy9d9/qcp5pg0rBhj1FPqyTJwl7KZben7epl
	USDxWW3WrjcoweFjN4cl4tgGKWHmBY2TZeFbsr9wdcp+SsEZwZ13dzovBf4jSXeRbsueLXLgBnd
	QS9jGUnFBe5MfoVZTNPTKVANxsgsD7PHW0U9xAc4B+AyezA8dfJv9Jn8k1M4134tgSTpsdCQwRv
	ZQstcrK3A+saeQrVvvgJgTryxH/HqwDsXquBu8G0dOp1eD8F7MWAjf8GtmiKDogpVQPPNCs+FMl
	0sQnHcWrtiCRKM/+4qmL1zCpDq5GTTXnEaOFxkLdN20CgthvY3DAl5y4YPZSqU2CM9xBN/qYsMP
	Q1Nap
X-Google-Smtp-Source: AGHT+IFTmPOZNMUYbjq0xktjOwR/hrjcj7eKjTft/BEOywT7Z0vceEUrKjh0CqgKZ053FHdrLSzW4w==
X-Received: by 2002:a05:6000:1788:b0:38d:d9bd:1897 with SMTP id ffacd0b85a97d-38f6e95ef5bmr14241054f8f.22.1740496861848;
        Tue, 25 Feb 2025 07:21:01 -0800 (PST)
Received: from [192.168.1.3] (p5b2aca7c.dip0.t-ipconnect.de. [91.42.202.124])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b02d60c0sm143189335e9.12.2025.02.25.07.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 07:21:01 -0800 (PST)
Message-ID: <066123b3-127d-4200-946f-61b118de1a45@googlemail.com>
Date: Tue, 25 Feb 2025 16:21:00 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/137] 6.13.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250225064750.953124108@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250225064750.953124108@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.02.2025 um 07:49 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Like -rc1, no problems with -rc2 here. Builds, boots and works on my 2-socket Ivy Bridge 
Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
