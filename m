Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B34301719
	for <patches@lists.linux.dev>; Thu, 26 Feb 2026 10:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772101881; cv=pass; b=eFj+lqE/q/gmFAUBLYWl8UUUOE0tfiHWNqChihGe7dkoRtaQ/BofP8H5/wG7BSn6k2/HNceenRXC9yf1LOSs6S3Bf4vU4NKnGWpBcu06W1Mv50rUNKH/8ZYPru8C+XcmN+BI+sKfySONwUNZ6pdcz1IqkvG9uRh2soQ5d/LZ5TY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772101881; c=relaxed/simple;
	bh=anYMqxwpR+nu7UEQOFNVZ3X5XYdS3eWHbk0GKrFqOOI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GUJd9I++7zCSIOHeWKOGRu2FFB3ZtalNGDYq+Zlh1iKn2iQukoznFee4F+SJ6C7fj631IoXZS3D9FExCq5usMfOeMVBThwKc/y8/66Pxjdy+imOynjKSVu7CvVOEhaTbD3kj6MAo5wMyVDifY1k71ujap88B9llUqaet4F2D7WA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=tQE5tgGM; arc=pass smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="tQE5tgGM"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-12776bebe9fso420127c88.1
        for <patches@lists.linux.dev>; Thu, 26 Feb 2026 02:31:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772101880; cv=none;
        d=google.com; s=arc-20240605;
        b=UYVvcHzlKjIbaoWoILshhizYSmDMGAdKTntfXt8Jjy9CPTlvws6cCCafYFZ93rY7yL
         IuSXEEHt68q77oSi82Z75SqLp3PyZiIcPYWdPuCmZGP8SWorHGX0vQZnLj+GBSJWnyvV
         rQX5bdIqDj6MYck6BIe/QDQkQsh46Wwq7YVA9wR9X+tKqpgKtpQTVvPFHNngdrKCW2SB
         xY6deTuFMwGgBf948SrCbU21r6feD6GSB92xmj9DOTYrKwK4wMT6O0b0q07p1JjnfQNU
         5PR5PXne2EzoaTzAgPR5rzGqgAl9jJtibd3mwIRy9w+YHor5k9T2uOCmodD+VhydJzVl
         oCPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y6Xg9HxlpIibWsVNQjKHCybD682gjh649PRqD1j7+c4=;
        fh=9s8o91dEaWPPdYOSRiXrk6Q5BHV/vude0pygzKeponc=;
        b=MdPt1aK2lHmN6NUsvTZPYMGS//CpKAcY7qnFCb89F4/WUMUkVnuaf+0SMCO9D/H4Yh
         8lgQvsFMCWgUb6iNmZdZLAVxIhgAWZ2hxFfF8d3VUr/QgdiOHOrhwx806eb7Kn4OxbHn
         nkHtaZHeGBkcjxbmaJcces9CXHbFUb9JNR3HQyd9LVU2qHUa8YZsvn4ZAnNzVnW/MWlY
         q7KIliQSVwO8BGzwn+yu+SUF240/h3R/3cmmmaeCwV3KrNh4WqkrKPvxP++R8fZdbLgF
         QlPMFhSdzhIOkib8TOZfBGEkIt83vd5ZXyoMndVWfMBtEGRJWC0VTXZU7Eg49oNw4oXM
         JfYQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1772101880; x=1772706680; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6Xg9HxlpIibWsVNQjKHCybD682gjh649PRqD1j7+c4=;
        b=tQE5tgGMH1uUVGrQncwWLCWezsLH7mwyzkXH5tWnhaS/vyOQRH5Dso9txoNJVJgLh2
         wNVaWqSrIcsYwyPy7yNMwPzG/Ysj9/AMj9k3aQS5r6aYiGLWFypIcyOVNl6G/flTV4Yi
         jHhLZLfMnO2jdB0C4b1LdcPj4Akk2H2/meRbslR7m8Z3EwV5z+yg1WWMh25jeRLXlYOC
         qPrXdOLl9qb2nC1jzXxd6lh/IM5GfGLlcxd63h9UzzXZgsWB+fc0KL2An4iReQN6wWU0
         Secc8dmwgmy4Dwuudq4n6dP38Vcmmcwt/N3a7HZLgReHapZV9s5NElhpYKkH0Ri5amdn
         Hv2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772101880; x=1772706680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y6Xg9HxlpIibWsVNQjKHCybD682gjh649PRqD1j7+c4=;
        b=EX+LrRZncaCZa0S53Wel3pQZWSkIVPWl66d2wm8TESMyx1bQPSLivDgiJqoffy0Gbj
         zJvvr4nxBJWqa5/NZCQXVySnoL9pMVQbZBHq2cHiW7HFhbMx3luFVFGCQ72SGtG74ZNk
         UJ90xp+r5LlfLlDV0K8c3/Y8TMhSSGNz2esGkRzDBKqEMYiJmNKD+Xe+FpSzbS/RzVnR
         XSzGTmzcgyoIHETHSkhSIcQYLwFxWezYIMJQsv7Jghw7BN+v5BDLo2XzHE87NgvKmzZy
         Ef+LtDDSiU5CLz0UlmOieqnhmjmzRoJsOsAHhjw63pAozsp7sRI2MdSPn3+Gfv96lBtV
         8sqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXF0ttl1Be+Fh18qdFXxHU3IyAEwLyTj2/92S2K33y9keJsEoEhsZuDqnjEk9/I8DqJ9lYcKoVq@lists.linux.dev
X-Gm-Message-State: AOJu0YzIEtOR5JN2yui3SIZV+FCsXpS/oDmQAtNQm/dRr25SXFMhGiYH
	0LEYTReUPGGbWIomW5oMj8/d6CjqtTK+EU/hzsP6YuLJv6ZQ/SHr5hdWaWe2j8PP3ERA3yFDZpI
	rErUc0Uyqfjd4vvJ9l1sANzm8LIHw9lw2w7OteFTDLQ==
X-Gm-Gg: ATEYQzwVhck4i/7zT3PW6rC4P9OgjfZ8nqWNKMsNGEGd2u5NJXD7ttHc0M6iJvVRP8X
	c7P7V99KO36jRNPoKsQoL10Y+Gz4Ace4oq2up4cmOWrFnUJXPWG8CxyS6PovaB+cr10dDlgC2Xh
	LliZwMvlQE0kUC/bs2nTz35Jq04PS3jdHhH125iHpWMVDOJxbYCOqdPd1A5Myd2akw6eRgyo+8l
	/yKnal8n6OKhOXGPunzrHE5vIdzGMFD1VZfTYhEh086Fy1uu+XsceEzpe7YSvyWQ1gccbXuw6bg
	SBq/95O9fNSHIx/fY7E288862Oa3aP5ZuZzpOdg9
X-Received: by 2002:a05:7022:322:b0:127:337e:3301 with SMTP id
 a92af1059eb24-1278694d544mr1508180c88.12.1772101879559; Thu, 26 Feb 2026
 02:31:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260225155341.094945851@linuxfoundation.org>
In-Reply-To: <20260225155341.094945851@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 26 Feb 2026 19:31:03 +0900
X-Gm-Features: AaiRm51FIIwYhOs-UxDvDGXiVZilXoc6wP4paS67hi--k9N-ihe-yynb-S9YUzY
Message-ID: <CAKL4bV52Tq8Q50Gn-zyd6Gdnm_c7YB02dsxQRYeujWkRyPdKCw@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Feb 26, 2026 at 1:22=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 27 Feb 2026 15:52:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.4-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.19.4-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.4-rc2rv-gcb2d80377c4e
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Thu Feb 26 17:16:20 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
