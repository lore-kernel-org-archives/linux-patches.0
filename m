Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE924A33
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 02:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972112; cv=none; b=QI0N4+AEJLXZswtlQa2hkXWhQ14dpQXi7vnpvlih2KWZ0cwIKBkK5s4yRNBz05CwR2jEkta3b5m7n/nKXYptTlWWwVZGcK2cvLuSpGHDM0MIsumvZF1ohNjJk97vwj97VeKmnogNvfa/hw63Exh1h01w9QzG81+Ka0/+Q4OeX/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972112; c=relaxed/simple;
	bh=GyxW1LSGZfvU4XebzR5XrdIfOtKNClSFJWryvQ2oIUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WgWrdY1yxR7eHRwVNDZvayPEvIM4bj+Cn5WkHypdwRYGYzMUO1jBVwWVn0q5ogI6DtsPRQFIqEqeU5R8GajFlhxra2h3nLTdcxBqVUMsucNEoL1XJxwtj+NBqMc9if/pdB0USXqPo58V/lKhAeCX2ppPPpnGioJIHDLzHyvZ57E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=grlx8Dls; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="grlx8Dls"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-52e96d4986bso219359e87.3
        for <patches@lists.linux.dev>; Tue, 02 Jul 2024 19:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1719972109; x=1720576909; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZimzjAy3hV40iaFntS7nCwCZ/3PORpa1R7y0lBfvhK4=;
        b=grlx8DlslurSPzclWrt8xu0eudl0A9x3fmmY6wg3QnVSJA6z6HqFwCW5zzerqQDrdb
         cZwdZlWNGXjxXkpOl9Rc2mb8ylEWPQc9YTI7nxFppLsRtvToy1hgSo/FoRLE2NRJCN0a
         xO1VenyDAgOImbH3Koe7Fed6nwSSxsv40XIlcanaVHlcMkqRSSdjeiIa7Y+046g2DlBM
         r6rTVImA9CYK/GBU1zTMx0HkcRJfAumnYx9LZkmLmexy7Y1YxYJcuJDDpqpS5VR3+rFq
         qe/YEldaWe3cHCFhsxNFjGuY+iQI1i2DBLuzRHjazgLYe1SA9Tp3djdwRQ8Lyql6d6js
         NlJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719972109; x=1720576909;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZimzjAy3hV40iaFntS7nCwCZ/3PORpa1R7y0lBfvhK4=;
        b=Kff8wvJMcRaxsPgs6HODbmn0ql69Eph9dkP1du3+nJfTHJx6fSdK2DTjXAGbBS5sts
         JL5o9oPOVgFR2qv0V844xUNeYQyWG2XGb/KemQLEfm6ltbj9ei5BJOeO28NMtH4lKnG8
         kYOjqos3yxEcXaVLSWCPENQQ/b/Sv4SUG1s2Px+oVsZ9y6GnHm64YmaltRl5pyse3cyi
         g9/Jn5+FGKXU+SFkd0dLVzAbrHRCYJV2EUo/0c9vYNpWFpYi+tU46SXn6Y9yQt3gbk6t
         5nLozc7Q4yP9DUHQsRvvavtYYMzEnTytAR4Gq87wZF/H4T7rr1aC1CdRIC4fHQGG3r9y
         pV9w==
X-Gm-Message-State: AOJu0YzvCZpFxnmMBw1XrRO42AEzFzaHwRNKh5eUVbH6MPno+7XgPtVF
	sMfspGCFEYSP2OhsaXBwuLhgUYd5IdfDIHXNtTnWORYLoIITOaw=
X-Google-Smtp-Source: AGHT+IHfhfrPY8oWGWypTj48byXcQCaGINoKBU+zHiwUjmYNFr9TAJEGGv8pRIRMNDJg2zzJWLUbmQ==
X-Received: by 2002:a05:6512:3b81:b0:52c:dc25:d706 with SMTP id 2adb3069b0e04-52e8270172cmr6797187e87.52.1719972108756;
        Tue, 02 Jul 2024 19:01:48 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4fd5.dip0.t-ipconnect.de. [91.43.79.213])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4256b061095sm207739955e9.23.2024.07.02.19.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jul 2024 19:01:47 -0700 (PDT)
Message-ID: <c88b2b98-a1a7-4397-b646-cd75b112dba1@googlemail.com>
Date: Wed, 3 Jul 2024 04:01:46 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/128] 6.1.97-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240702170226.231899085@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.07.2024 um 19:03 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.97 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
