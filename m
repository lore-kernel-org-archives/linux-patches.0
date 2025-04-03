Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1632219E4
	for <patches@lists.linux.dev>; Thu,  3 Apr 2025 21:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743716696; cv=none; b=fuEUEEoqIF0DdVXU4aOF4+tsiHZC2pghDzzV5gW7USKlaaFWU1M48/3kWzdEC9AOx1XztnJTT4zP7Nr2R55LFS977mROx5Wf53A321vHV1Z9YRXfNbAfXYc7X+1ZTd4U0IBHUDf5rCE46KPhMGNUhwVsL9NtPlRgpIXbu39Jv14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743716696; c=relaxed/simple;
	bh=VsKeWx/5z9BSGQhMr+QuyPGurWoYs8YeA6BMBWvYqcA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T4fjJ1mxg2JY8FwbM2NDOZh31g7Nma+SpDeabrfTq8Sn1a3jcjBPebzQwyA93hYV7TWXtl9xm7TYCr6tYU+r6/zX4I6h+jSSOwvvQ8SMNHwmH+YzjfQ1gkwCNGgTJIrlQOFFBz7aVEwx56mOPBBhEVRLeNTSnVyKUN40e3/Obdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=U4sNgY1T; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="U4sNgY1T"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43cf257158fso9301505e9.2
        for <patches@lists.linux.dev>; Thu, 03 Apr 2025 14:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1743716693; x=1744321493; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=37i28HC0qMX+6A6d+lctFmGy/UQvwqNYdMvj7tEDVvQ=;
        b=U4sNgY1T/9ERuxqbQt4Guc0m+33HAPu0CjjiI1R+9WU6ykBW20GyIWeXLiSl1vR0a4
         TSZ/tk6WnAZ3TITb5y2+0EKSfjvf8OL/dSVMK9dQSAByk3t1eIsOFrLW3NSj64IxFvuY
         MT4aKqV2c92FB+X4kSIJT780QjxV5bTRywK2fdRQ7wNBmC3XSTHBWaFMKfvBNMsl3D23
         JHUFYFXGodfHV0nyur74FdUopJpeeOzsW5Tqjq+52GdgExKIOYQLosH2FWMI89tArUbA
         aJZFtYVs1PAvwvPqZZVrSO2kckjyy+mQ780Zi+m3CCfsgQqWWpE48BejXgXdJJh9NTo0
         naIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743716693; x=1744321493;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=37i28HC0qMX+6A6d+lctFmGy/UQvwqNYdMvj7tEDVvQ=;
        b=XGN4VaLJ6rtQa7EJolyQ9B61udYmznTCNmABYsSlKxGT67YR5jxLY2MqJ8k8CQq6sm
         KF5f4vWscMNlVAR3etGlDrvzykRLY4Eo6ZRiSz9ycmM39vUfEytbV+MKrUJMzBc8VFzK
         c7scybo8V6UTb0ido83iDubhvsfSW5LxR2VawQts9EZWbsInR8zrpUwn1vELrWij+kqD
         TtC7aHKCJMj2goVNY/exdITMkV95nVyXKa6CMjd/GJAVuizn72R+vpBqiMtlDpb0zG3U
         P1/NUAZG3CZOUKG2WbedbTexco7nN/EoZd9I0i5dx2BANfBJJPn+a3iVfBWxVEdSBJ2A
         WXVQ==
X-Gm-Message-State: AOJu0YxvHxIKVac+GAcb+1IfFS7DXcpVR77cNmxk/vLGOG1Ax0heSGiJ
	iHAN5mVUtuCIbhuEcTyfJ38eBvy2d/OYLb8f2RcYLwxnUlz5r3c=
X-Gm-Gg: ASbGncvVAU2L335MYH40V/5Y87q6q1PIliQvNwCCkaInvyYBbE9Xs7fzkvD4Z1zhdQT
	Z+ESGLZ/163gBA1rann8yZcmCSdkyZzpv0XFpA2wTJmeIfOePOg631KDx+zN50D4WCo7/Yuchpl
	zjy6lqHXlJuKH+AFqbeRyrRxsvtkRDnhx2KTXTO+4uiJkY7g8hgtKbv3FRI0sTiSIle5gTbYwcs
	M6HZBtD5uZK8Wks+6QJxDHkZLxCeIh6SVbbQm4evQx22IlmlJjien/1z2ySbzWULksuWClChfCX
	92v/anB2UObbPVfTYRqckgZZ8eC0iXDuH2wE8KX0Uv9EozwPabvtBeFFmg1fyUvix8g6jxdImT7
	TSph0KtAlMLHzGb188tjR8E0=
X-Google-Smtp-Source: AGHT+IFLgVvUktsx3KtqIiNk8P/LU11g7Dn00Oo0wTs5GCHL77EF+7bVU8+AjuqbTJBpFlLBso07MA==
X-Received: by 2002:a5d:6da1:0:b0:38f:3224:65ff with SMTP id ffacd0b85a97d-39cb357585amr623532f8f.5.1743716693050;
        Thu, 03 Apr 2025 14:44:53 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac393.dip0.t-ipconnect.de. [91.42.195.147])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec34a92desm28441915e9.14.2025.04.03.14.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 14:44:52 -0700 (PDT)
Message-ID: <d918b7db-9e6d-4330-bc86-3bcf0c3825a6@googlemail.com>
Date: Thu, 3 Apr 2025 23:44:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/22] 6.12.22-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250403151622.055059925@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.04.2025 um 17:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.22 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
