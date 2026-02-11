Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85C635E53E
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 10:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770805437; cv=pass; b=Qqr7kX6u8rMbm4de+DT8RN6t0cse6tCjZ46hyfo0zq4NbQIaVr69ZbQvnwG7oPCjdZMvsSyDHUBDzstXjX8y+oQKnEl3e+tieusrezhoef3zA/rS2Wg8QeHUNKgdOBQ3Lgtvr4BtDN3D05YYyepPXYCcogKI9OirKbtBlJCImhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770805437; c=relaxed/simple;
	bh=GJN3JThm9HVHgiMb8j+F3eZ0lgRN+wnA0Q7Lj0Wkr5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DVWHB9ziBkPtmcsWgc6Of0W+CcsZF0Q3zEYdUC34UWY9c8lX0DgJ063ZB3y2oVaZUr8uiNIoY/qRGpdTjubkWQLDPuJeKwJRM/z8Ti5w1018Yf6IHBACzgUuGfUUD+IXy/7KxuckWs4dT0nyPN+ezO6EUqJDB0msxUx67AmR0aY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=uk2Waqt+; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="uk2Waqt+"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b885e8c679bso698095666b.1
        for <patches@lists.linux.dev>; Wed, 11 Feb 2026 02:23:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770805434; cv=none;
        d=google.com; s=arc-20240605;
        b=EJQJmgsDqZVyKOfbBU1EHAwVPbz8qwmnGgxwvca+IeZKMUkCKDeMmTfGcKEZdnnA5o
         Eq4F9WHARSuShQjSrD9fXiQjR+I5b3Sug57l9wD7JOOdjNanR2e8W4T+1/hFq4sGOIZh
         AItpcS+sRh80I+8Z/tpyCLvtO8KVkS5KRW5XbYp/wFkGU80qEqYZbSPpw9GMX5Ku6SwO
         x8da6w1ltoHw7QB3TZmuf2yeO26HSX/rbarVF+yEa2wYJ9icU6SGf5nDIXFTMnvIsHnQ
         S+7dsCItd4SmJjRtq1Qyzrt680T5OmONDvjbYxmi1o0q3nFqYRhZDXqVxj04tWuWnYkv
         6xCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=v4tmqZhYNY4ez4j9clJooVuPTcvKuhrRqyO3PCivUnY=;
        fh=JZYdXM9rGodShrAKXBnZvSFOAd0HC58UJ+8OoHlGUrQ=;
        b=k8/Q5+z51EmvXnOluoFX8Km4gw9HF3etZRwSFK1joP17p2idxnIoxrgb3ecbpfFN7t
         PFhHK2vTbZpCxFGI2MN9UBem9WoZ/mzHAtMb6bN6yOFwCXNo+Uzvq3ZKPS+S5PS7dw0Y
         q/UtCZlcMd63W7NWjCffeQR509Pbx7bb477G2t9x0FjgA8jSRe5mVPwFhP2j9AiP6Tdz
         0QYxzGEFdFhX4DJxLj+uOzGjAiNZketrgjhEzwJ70sXb3emtn9iy4/rQSvTamfoywHc4
         BssXTmkYSkw4Od7o7zD9sxULPkNiV2e3Epz6PhzpnzmWZl7iv9gFj1u0wxNkV+z45o/d
         oU+Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1770805434; x=1771410234; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v4tmqZhYNY4ez4j9clJooVuPTcvKuhrRqyO3PCivUnY=;
        b=uk2Waqt+Fp7XAM9H6vIbxQRnycqFYKSA5PQrU8Ps9io70IeXTK3Xpo9xIMy+YSP72k
         fMiKsbRGfOxliXxDPEiubELmeMftzgkkXULjKFOdYBqQM1CEmGdL43apTr7EXF1AY7DV
         dL3FKzGTsM7lHIzAFB06kGbX/o3RMLOs1o6u5kMmtepj81vd0kU7DPpmX3DppK1f5XWQ
         uqeSPZZz57Db5dmVAheQD2t/iHeLqob2+5VtMDDCeQiln9bTqVhwfgaTm6XWfpTvJOfv
         S7pP+RF1Wgu9lXw1C2J0CVtLzB5LIv55HcixScUofRdPkLdNRLqKrtPTHzMxpEvc0Bdr
         A8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770805434; x=1771410234;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v4tmqZhYNY4ez4j9clJooVuPTcvKuhrRqyO3PCivUnY=;
        b=CEWJwCgKqAGwXpDCNA2URToKoRwVSRNhwFLuYUgZMR7LEUUTBB5/GZoMy+/zXOqMdA
         q2cX8Lfw5/vR7zPqztbGO3/DSAISgCJolIrBYzzPZkTGFhrr135GYF5JfqWjGKbRRnAL
         D6SUb3N+aXDonyHelnqrpEBRT2vpmp8B5twjms0QuuUW1Wjwpx6NSymggaeRPQ3kh3/O
         thyWraSKhStwxP03G+XcMcgAwGscIOF1AobI9rCvZNuMhy10OQt+89wwZmnQ/37vIu+k
         P1dEM9Om/eU3SkMT+t2MKUxj9zq0F++wDOdFir/8bKqFMvhGzgvcxSNB34z+24x6Y9Rq
         nIcg==
X-Forwarded-Encrypted: i=1; AJvYcCV91XIUUXhc9sCzQWl2uv5FD4FvhSaLSE/mFJJZ8XzfnaNoWRmHza180dU/L8SqanRDHt7vHWnc@lists.linux.dev
X-Gm-Message-State: AOJu0YwGVvdOVysxm6rVv6iiJkqhbWIRtdRXWFuYDbmkO7Ag/f5r/reY
	TEHBi3T9hFejVzPP20pzn8g06iHNAF7vM3j68maXsZvdz1h1z6752F5KY8+Z9zu+nXHTTD0ww8x
	OpdEDuNOfCmbnReTcXQj3LiggHawk8n2l/eSWfsyEMQ==
X-Gm-Gg: AZuq6aKi0n9FzQVMfvlRGMSqKP8IWFepjrBAqtWm5f0FblI+bXM/SkBJq6frue6nYDc
	i9+WgNeh99CaN0PwooZvBNntrT5hxiKSUZpLsgGRremC8BdU7Z2q8UIuAkZ82M2La4ZmdnF8Rjy
	2bR9ce6dt44UGECDErOrfydQ1vAIKiivipSIUvjUd9S4pPQxfJ8UtF1x2YVeOZtFELi7OFW+8lt
	IPMFUBz+AuN69LubDW82Z1K2PExFMLB20CE4BSXR0+KVogtMt6Q30WIj4xV/Sj6wSPCq1BW8LIP
	jU3sxcB4Rexe1DTsjkfz5w5oEnm8GDuWUdEA9nvsJZqYy64LbxaY7FW/+buEzFgOZScBdg==
X-Received: by 2002:a17:907:da17:b0:b8e:7d43:edda with SMTP id
 a640c23a62f3a-b8f6aa110b2mr114508166b.29.1770805434267; Wed, 11 Feb 2026
 02:23:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260209142304.770150175@linuxfoundation.org>
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 11 Feb 2026 15:53:16 +0530
X-Gm-Features: AZwV_Qi8WkFzLyUcNMT6WAEOAamSKCAjyY14DahhzqQC69_qgGWcKCTYt5W4tP8
Message-ID: <CAG=yYwnOCr-zTW4ND39LG-_G37iJC-CEoNR7PLYksu1hm2L6tg@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/86] 6.6.124-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello,

No typical  dmesg regressions

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
