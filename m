Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0384349E5C2
	for <patches@lists.linux.dev>; Sat, 17 Oct 2026 22:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792275560; cv=none; b=Df09xvftLwc2YJ+prdJvey9nWMER1zXe9OUGVpgyHPSXOVfwJhyfXPKQDduOnQuJIgrDavAEb8ZctYS224P9DBGDAMvXmDOGX59sbQnGBL4OShCVl6FLKl28UpSAC3bfVctDMlpTLvVdiUrEGTil2oiMKC2G9OBXCmxImB4Cges=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792275560; c=relaxed/simple;
	bh=fEZZqs/2ON9aIF0WA8+r/aO+iqtvUwUqKlBtjbwzNe4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k4GQy0Bj8epkVLqQ1dP6Wl1VMAMmJ2DAUkv74aZiDiiZD65xOoN/UcvJMbgjbg0nwnG7bRL3Iyn7RTSr3dxNdZktegmL/MfYWIaANmd/C1ejZaDvplYeeQGSXHPbaWv1effA1RPd5fmG9QRFh4shH6cAwiy+3p4Iozbk2SQHlRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=dB+gPz+T; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="dB+gPz+T"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a1dede3c2cso6928005e9.2
        for <patches@lists.linux.dev>; Sat, 17 Oct 2026 15:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792275557; x=1792880357; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1P3vBDxvZfLACU44clWpmAKjc22PaxwE3/MUdrEQfXA=;
        b=dB+gPz+T80P5xiobet8yDbo7V/4YOPw5OA7yPcSrUQOfT9hRCyS+TfvpzWSs+0cGB8
         fvsBjCT2VxqLmNxSaBYv67ux/gQWAc3/wazagzjZmuBx7FTLcDiZILbw7p4fFL1rQckN
         EDqiyX7zlw04DrQixOUTmotiWc3wA3HW75hFL2E8imSqza509SVaoxlUWjkwMOpxjyPo
         Ey62Eq4cyUgQTkkyVSRkeAaldGVzV+fbtuIRQpjDB9gMcjmUz8pM9pjXkQtmtruxtqn/
         Zneo8/xft4daZQq4ryk3lNHA3TaqOz7sDFo9RyKc6PUcb/UKb8yWH+0II15IS2qJtS4X
         3+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792275557; x=1792880357;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1P3vBDxvZfLACU44clWpmAKjc22PaxwE3/MUdrEQfXA=;
        b=IBMnyzn0aUQJZlMOUBZYdpHGyd7GGNgHZT/sgTMzOtEjQejWDbhAEYpfPxQOtT9/eA
         zqYlDaMBLQ1k4XX9A4ZOEvdnPvPclXEgEq6GXunLP7KNEXkesZjN/5L3mCmfYal0cohF
         uhIo9pUoLGYcGXNzuJUlbYd45DosJbaZqh7V23wdHtQszMRcBAyh2ibVRZtwabl6DSom
         WI8Ct2zWFeyOvPQLCVEnK8ltWVH9/ZSOCSWLcn+GUxV5TAJhDKTQ+5uRcxXH0Kp0g1l5
         I3EoDPX/t5EizynTztqpxLRF0Zg4op4qAXLxtHikfQhYWHPezu3D/GN+Vg/eYu7TQozN
         /gfw==
X-Gm-Message-State: AFq9FYJaedHCiVNg6N0Og6FnNW0z9W6k+H6vKUpAmu2pWR46ivwDvmYi
	zDo10fpS4zG/CFe9JpIjZaeX4xPvS9o3iT49Rltw9IUSAt62Jx97zNE=
X-Gm-Gg: AYBFou19CliCEEw8qtD6GcO13AV2YUi6QGf6uV/RESOTilku9A9eWW7E/CNnic8KdfD
	vSMBlxA82cvgOOjXZ1tlfXHCQMKR/vcFrNSeKsuXLaxMcv8Dhh2d1u8thjiQTMoRMnp75EtuBkT
	QbOaPNbEIR4VSeSPATEBAE3bJkSCNNt5VtW64V2UpHjW/l5yF3RmpRXZO/H+sjkzwCdVMeDwuHC
	n4tdzOTtVc14SZOcpbbbctLPUklXXvBYLe4Am+1TfPE7+KtAoH886njj/bhLlX3Oz1KbUawfC2I
	PT/NXVFQgNyRydKJSjWZcst9xCn5Fwyo4qzFIjez2GQC0iaPrgGtHQ6UbInejlrw/ZX2VWeHNJr
	EOtaUhHRa2saSIFZ5cXfTT6PdUaIVAZB5T9+KjztQa3jgI/Wx8Z8q2h6b40Z/tE5E/7QZSdBJUw
	NXkRwYuourF0VZAMzifhGvWEJlOiUrcz6RV7HttW9Kw83MGlh7yEcOUvWKVRd8EQET4FPxq84+9
	qSRI/+l3n2DjC40zoG8wX66LeV6Jw05g70/CvUBfXYyhlYM
X-Received: by 2002:a05:600c:4595:b0:49f:bd3c:bc24 with SMTP id 5b1f17b1804b1-4a1d762168amr82215755e9.31.1792275557036;
        Sat, 17 Oct 2026 15:19:17 -0700 (PDT)
Received: from [192.168.1.3] (p5b057d26.dip0.t-ipconnect.de. [91.5.125.38])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd47104csm14989798f8f.8.2026.10.17.15.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2026 15:19:16 -0700 (PDT)
Message-ID: <65c9facc-377d-48b1-8d48-aebac14e8bbb@googlemail.com>
Date: Sun, 18 Oct 2026 00:19:15 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 00/52] 6.18.58-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261017155104.830766652@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.10.2026 um 17:54 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.58 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
