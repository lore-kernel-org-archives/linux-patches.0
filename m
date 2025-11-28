Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8428032E154
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764336853; cv=none; b=iGYPpFBkoqA2NGN7EdQFqtq8uzahPjJqAM1eiqGwjgMEpN4y9wL6pgX9QPlqJRwC9QcWqxcV/47wt1XcpFTAjWRBlfRwVE46037dpVePLY+EcWd1jzvB5bJ+4Ng9d4rpL27oeRhcZbNpDStFu8EVWDDXQcA2Vlqj9WKkrkZVbwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764336853; c=relaxed/simple;
	bh=N7LVgPe4BHDfL/ikIaJUOBkx7jZTeSqHMuZCUFdGUVI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RZZZ3KSE0LE5zLtcwetspXIyfymWTR9Mjx7v/snmz1tC6ylIaJs/zJmKRAhFT5P84fYIfx9N05d/qKYJJytkfnAjOV9npPOyC3tkL+XtUyMdzsfn0w69eJiNE0XQ4VUF70ThuTtcOUVaMBA5HocNt3degtLGAzbbSTPcD88E9z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=uhED3qn2; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="uhED3qn2"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7ade456b6abso1546797b3a.3
        for <patches@lists.linux.dev>; Fri, 28 Nov 2025 05:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1764336847; x=1764941647; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rbtpa9RFO4JNYg5slDho7aqS22A5VSOruLlvcT1PDXc=;
        b=uhED3qn2AO5fJKWrSEI/nMm9PWd75yB3G2KKw+MhjEkUg1pWn5NshL8TFWGy1FXOet
         kh2tl59z3m3qDocFoJbHOzAIk6bBuqvOKLJVWiNE719Pl+ufa72K8l2kL4UIoKe+6siK
         xVFYfrZn6mIJuG17wyKoONV69FNm5/UrEaUj+hJszVpGBAs2IyidVRkZV01yGgXBGn/V
         Oi1I43qhI1QbwJbC1FyI6708yXJt7udujhN5i18r8ocWyDai6m8I8fkmNjQvrzGM0q+s
         K9i6lGYgY5lM+E+H3QRV3otz5vqXgPTM3v8SUXJ3HogFCd8qU/7J0PuSP7bFfbi6aaNv
         PAmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764336847; x=1764941647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rbtpa9RFO4JNYg5slDho7aqS22A5VSOruLlvcT1PDXc=;
        b=q1Ggpu9kzq4f2lpLEez2hpBZNlmIH6sbl6+cnlcZ9E1sZzbLJyVM0DKklnDRURBPlt
         c46xhcmfbgtdLXkhzy3KFOQFYzE+c1aPUxEZoq6AiRd/aPxTHf2hFFUBIGMCyCCFulks
         9Nn4G3sZ9/0MoYP8BkqKPk2av5le23cwu0g6ZBThmnRTs8vwY5CH3E41YpjrRfGRO63w
         jys4RwMBwTsqt72v3GUCbwx7kJYPjnssTkfZJYFBHefpmAKe9lkz84oAMDImC8UubCnT
         le26L4JUAMIWi/63cycJzIlUfm39zm+YywQ2fE+OM67jrPTDehHj9LgJOfh3CXgj3zOL
         wqIA==
X-Forwarded-Encrypted: i=1; AJvYcCVg2/ik4J+rsXz2Y+83Yq/61zFXynTQk9RKOPdKuBKK8r9kjEAxpNbztdLi7Ojn7i2VhoP2tX8o@lists.linux.dev
X-Gm-Message-State: AOJu0YwZ1GhFhmIU3uW/2kjhnsodE4PyChvwLnNKZjsSRnrxeOjuJDFx
	1B558gLdIy2VbrQ9hgzGapiwaffiZeJsmcOHxOZQMKpfRlVIv8GrPGRexV3mxZ/ahuP3dxvOsY7
	oIGrW669iIRWLxGa0gscHyKW7cnfmIqbXrWdm3wIjIQ==
X-Gm-Gg: ASbGncu1Qq02+/DgrpkK2RzLZzIMsNhz6JamldtDHo4fJn4eLM/9XxdD8vwv4p5VfL5
	rvntiG5qBi1Lu/cll3n6N76x9eVi5RCS11n7iko0mANyqYpfpbN3X5LGNt3SYatxHDwjWC5U5CU
	LEmhcqwqGXSNK9CFj/fp0sfuoMYYL5NW1odPaZ0bmrAg/Cg5MRRTSVBNQLy7nzqAZg/WNbiwKJ2
	MO83fHGEOcOr9Ndq/doCxtUHjJPEe54KXbrrXYuWcJ+Njkq/6j3vW0kxXOz4DZ3GtWriGMVAQ==
X-Google-Smtp-Source: AGHT+IGwm0o8aZuZ2m48OS+/3z/RTZBRrJEcimyjk2nYCgxroIcwnBJ2VdDKGAGeyiVfZpRcwlYYJqHTeB6yDAU3MkY=
X-Received: by 2002:a05:7022:6382:b0:11b:9386:8254 with SMTP id
 a92af1059eb24-11c9d87056amr18623161c88.41.1764336847187; Fri, 28 Nov 2025
 05:34:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251127150348.216197881@linuxfoundation.org>
In-Reply-To: <20251127150348.216197881@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 28 Nov 2025 22:33:50 +0900
X-Gm-Features: AWmQ_blvACtblrWoxRgJepaWWrl4iemJdPZsf-ll7gR5yH6QtKiNw8xHfLCkhLc
Message-ID: <CAKL4bV57MzMdQocXwJyuqjyrX88yufDLG0iXMDSfQBwVS5e9eQ@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/176] 6.17.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Nov 28, 2025 at 12:09=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.10 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Nov 2025 15:03:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.10-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.17.10-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.17.10-rc2rv-g6c8c6a34f518
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20251112, GNU ld (GNU
Binutils) 2.45.1) #1 SMP PREEMPT_DYNAMIC Fri Nov 28 21:50:43 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
