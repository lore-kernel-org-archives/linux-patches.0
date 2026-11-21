Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795234153;
	b=k5dEAEez/kqCb3o0IsdevNnh+HopqMYkXH2bdtf4jcgw0DrF6kT/X6XBEzCepsx7pr9y
	 i7N0/vE3KIu9ydxpeGjps1cyguF0CeelMM59o3uzbdco7tPw2GrUgsCdOlkkoQVc+QvGF
	 K7UuCP4X+ZopdxhnkBqgt538pALG6EIBerruA8kuy4V9vcF+h6k3Y9gSooc74LjOmdG9M
	 kU1s+GkUlN4ev1EcWGR9+rIAVf9gJhEzu0SaExkFhCRF2wLqMaGRXzYWjEyQru+AdjjLx
	 9pAaW7OqbennPy2V6dfzSPTtTLLCxS5P64LfHWie6/CgAw1IrUsuHFnNnZQQsf1t39A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795234153;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=DU6QRI6/2rr3VH1bLHYHYKsx9+9ItmZMgLCzsJ11Jok=;
	b=X4J7cYVN54mHLmuo+VnfkKjjy76grYZh77INrTG9TS0vVhqHEgqBrMNo33cwLL5td5sx
	 wYEZtbEUIi+XIhQk5PUSsn/aQSN+Ml8kRCUZ5OWkR0J5to6/ZLZBKYwKjNBtlavxpBUbC
	 A7Us6Un2uYESRHuin5d8OoyuF9s9BpOVWK/Tms51FC4VbnmUQob135zJQ6CfvB2RJHaah
	 kd0QX53vZfyPyESv4qvNMRqwbJof3SrZnbjnOWERD3Q1p7b/yBUp14Fn/JxCX1T3421zH
	 mQeG6K14m9IG5FGMEDZC9OFK+cUwyZXMihYstI3h5OsKCT1od6ce820FbhfQtZ66JeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b="IEumyf7/";
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8EA606A339
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 04:09:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D8EA606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=IEumyf7/
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so15714925e9.0
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 20:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795234151; x=1795838951; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DU6QRI6/2rr3VH1bLHYHYKsx9+9ItmZMgLCzsJ11Jok=;
        b=IEumyf7/BrYNORBGPOrnv7wpEv2NEpGMkNZcXB0X072ZoZDjNqpw7BJxoplrgvZHsB
         SabVKI4B9eMXK5LQwLuKLieson0n06hPN/8T5hqk/slRpZ8mS8s7z7pSqoYiHrEPA95P
         VqXWO4pRq0iatXRqbFYZDH669z4B2N3v7HqyjJ0TvHImZKSbO+niI9cY48AvhNCyA/q2
         GVp6a3+QHgI8oGgpUclvsCAeo0lHPKwMJhQzWNEioO/bUUUkh0u/UAZciLpbHzPpa8fN
         Qap6iWdsZousWkslgJoIX2yoHczivu7oFRyQ8v34M8e4szlEjRtaFWBtWC6k1pKlzAOn
         2Emw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795234151; x=1795838951;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DU6QRI6/2rr3VH1bLHYHYKsx9+9ItmZMgLCzsJ11Jok=;
        b=y+HGy57hqAOP0xJ2JiHTSuQ4HK77Ed7XsK6ykIAx46gXaB+bDNHPlSHlwBX6lffX0F
         8mUBwcryAx/1DaPO3DdTJstxzRVwB2WWgF6Cyp/r5qErjN3AaPSiCBKyNHKth7Qt8QpV
         2h6kjM7rbadvhHMIW98nzo9bB1WtKLPIAXspXmjI/xl0F9A056aQKhc+Nbdrq8MBGE5Y
         mNDQGbDnAV1PK0+xwcx1n0QQ21KC3+8gZMUe8NRGDmq9+2pMyofNcFk4/9mbGMkMxsdY
         zyqX1lPH9WfA1iT5YQF26tAEYOEG90V6XUzPk5UuSPTXIOWAWNsIV5/4YgZs81u5j4I1
         ZyIQ==
X-Gm-Message-State: APuU4Z8VpLgu8fJ1cs56VdgTd1U/LT0pT7wH4+NJeYZhPM+PQgDsYPxs
	ne7Fu6jtzKQWy+UVM5Onh7CMwUUm78ksScyp6GyIdDUHCLpx+8V5C5k=
X-Gm-Gg: AZFdTZetmrTB6rPWb3BpCLIJQEf+J9w4liBbOyC4g7ZeD+F3MGI0zHcbqALbvYCA79l
	BmiLe9sn7MS2Xay8/28jYgRHbT6SoSNGMbidF/Jzg/YOJQ3cspMYEevL37qFk20n2jWaYacRZAH
	jWMMHC8qVkogfRU075EQycA5DdEtCrFBi9yO2b6TIpCcjXMuY8hV/hdegPPvLKl43fFb+97CyL7
	OEyFQkHiU2yvW+sZ3l9MTL9r0Acoc+fhrA+c9mwEPapfoymCXkhd1VhRubz8GlJLwKZFVrPF5f8
	3R3LU54DL5Xa8GyP1A5JM/Fcscm9yJ//nThjvbTDxwy+uR7yz1pWDlNQaN/CiDFWpgF1+DPlHS4
	+AcSJLw8f/gte+/MZl31iAWndiheLUU1s/8KXZHXDlpUdbIgeCacNi89nOtysb/wQjsxAV4ZwlV
	YnWpMpDtbIg45qnPPWFwxvqzIa0XfUc3XKZtmKnUAS7SkzErPK8jTl7eX5mqP5XNmP+MT7VZauG
	vrepvvpzWt5XeDIXvDDT7mp/odL8NPozP5tZX0cJLhBfr/aYD4KpK3BXd13kporyFg/NAC2J0o4
	bvXisi93OP1oqH+3OIKXU3tlx/9T9r6yLIPRYKl46TmFoCLHr6+nf+cafclG/hHCLwlOricS/UY
	0FAuc2kjivKVyrdAAEOZCB6JVxw==
X-Received: by 2002:a05:600c:674b:b0:4bb:6847:791f with SMTP id 5b1f17b1804b1-4bb8880f267mr111709805e9.7.1795234151518;
        Fri, 20 Nov 2026 20:09:11 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac65d.dip0.t-ipconnect.de. [91.42.198.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884865a2sm143043445e9.3.2026.11.20.20.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 20:09:11 -0800 (PST)
Message-ID: <c1f584db-61e6-4dc7-b84a-6d3c630c0023@googlemail.com>
Date: Sat, 21 Nov 2026 05:09:10 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 0000/2144] 6.18.65-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261120055114.182757740@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261120055114.182757740@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.11.2026 um 06:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2144 patches in this series, all will be posted as a response
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
