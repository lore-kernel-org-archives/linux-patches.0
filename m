Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD08125B687
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 16:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755621115; cv=none; b=XgrGbIyfqiAY/HXzE7Me27UkzWNW/LJhqcvCU9dyjvwbXniH0MeC5WdQZntuCqZehb5z/AUrnaDsvPjVdqf8Bntec4QkTe5Aid+xqJdQkxSRy0vFe2SHgLeeUeG95qrNchzlWA5GSebKkiuHxlkPWMIy03TBuee28M4XFjlh/O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755621115; c=relaxed/simple;
	bh=WdDnQ8IR4mnQdX4Dza9pB4Wap25haIS4/SUcI4fWsOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PgdJOqNl511xn8VlWUSVhO8cHccy1kyF2csXIeVJ8DbWp2P12BLjS5NIEnD6k3y7kdwef9Qf0GDFfpgM9gYiMtXBcXDTB9nnVLS3ADWBCCqb6sgFTnFKHWtZ8P7CIe792Rg5LFIabvaLYV3KBkwXBcVqXatN34k4xyRe/21eiVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RqOB18lV; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RqOB18lV"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b9edf36838so3399655f8f.3
        for <patches@lists.linux.dev>; Tue, 19 Aug 2025 09:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1755621112; x=1756225912; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YeEFkpMwO8aeNeU/kCa7lT0/efhqRLkik5GKku1rBmU=;
        b=RqOB18lVe0Dx1+fY44Y/XUSVUclm4vnkdDLV4wtawWD0BqRWEbTcyMMsQ6CSJVCctr
         KpgyCaaIiUk5AOmZTorXTZWeQYlQWZ9YVcTVwqcdKWeL4UkVHwygptK0gfVbV/P1ehi7
         Kn2Hyt+cd7O8HvOtaCm+m5TUcFKSH7KZK+IUep2v0nxVYNEam4qWFXuhXCK4XFa7qdDS
         8RLv13RVvHjK40fHFw0iKv2e1OZONMTNT1E238BemUOenXoz6OBbOQ8XADjQ/wc1N5YG
         yl9Mms+VJVjh0CKbY+ANolrT1d+XqNW5gWtLygXAPajOLs/xCSUwXzpR7VvUqfLof3tn
         Q/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755621112; x=1756225912;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YeEFkpMwO8aeNeU/kCa7lT0/efhqRLkik5GKku1rBmU=;
        b=TbBzNjSl+kaB6aLfTJGTB300Z3DppDetQts44eHCqwF1y8/mF+LL7ZqObuup0t3fIp
         pFVKkTQXVcb/Xg8Q+lLYX4g5/hs58+bkxBD2OPML/CIUxbZg4JvP1G8lgB2ddrKAzpaQ
         shvQOaxoeVK8NipIEW35KYoKwXrc1IiHtbMjZC2Nm4Y0OxjkfC/T6iKu3KhchPHvPfaw
         PV3IQo9n+AJr9etE092KhHmbm/LlFFU8r1eEofwedCJQRLYJNyNWS4sW6sMwqKn4mHZU
         MlHBB0tN9QJE8YJeZE6y2oUOQYHt/mofF6NKMVyHCofkyNgVr6es0pZZGzgwPcCbLJvT
         4wEQ==
X-Gm-Message-State: AOJu0YyI1G2gsQJPKsacoTrC6whJ+EWzPHA3egmDxklOOXxb/SRh0/ZX
	r87mXHHRhVI1QYy7+WWbuP75sBmaeizsQkcjbED66JQYcg4OKhM8meo=
X-Gm-Gg: ASbGncsqZZUHWt1iOai/kazJEB3zV8q1a7qrdJIqniZ77yg3yROpKn10TmUCOyZZt0G
	x4FqEqX1kzB7Gwhmgk+XT1+tWHkKNWDsz/zkQIyG4jvJ9URlSKDOht+eGz/5RFdkSH/VGg+8vTA
	72SN4WEdh0rCh0r1skaI6hfRUjIJFyUcUpblnDfM+JQQRaf8yqUr2T1lGLAuUw/BS0Xm1DG5t0U
	hqcUaMpJu7tcC66NjW6poaU++TCgDHciEVScRa/DL4CMo18ZK+dOYhR5f/jdWvSq+XSy0rkERSb
	aotrO2JAaQge7EKa8oqi4AvoUQvr+9ei0TgDqlVS+BOQA4JU22jE+cXDggwSnpQa6oiy/4dJXcl
	Mn2uqn/9SN58WzvzaxhnNm/lo5Kg8w4KKSmw1dWun9pKg2aqzMfXR8lLLTjwFdXLwxN5CQfWrjc
	V51BG2i9XB2lo=
X-Google-Smtp-Source: AGHT+IHSZ46SqCnjtV5u8l5XC83Eq7ZGTy6ayoujfA49Dv9VI0FpvywRiwsDn2MEKzprm9N3LcQROA==
X-Received: by 2002:a05:6000:25c1:b0:3b7:7c3b:1073 with SMTP id ffacd0b85a97d-3c0ed1f2f83mr2415426f8f.52.1755621111966;
        Tue, 19 Aug 2025 09:31:51 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac4f3.dip0.t-ipconnect.de. [91.42.196.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c074d43626sm4201227f8f.15.2025.08.19.09.31.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 09:31:51 -0700 (PDT)
Message-ID: <c178f7ff-5aa6-4ff1-beb5-4efc953e2538@googlemail.com>
Date: Tue, 19 Aug 2025 18:31:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.16 000/564] 6.16.2-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250819122844.483737955@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250819122844.483737955@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.08.2025 um 14:31 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.16.2 release.
> There are 564 patches in this series, all will be posted as a response
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
