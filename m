Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992F73A75AF
	for <patches@lists.linux.dev>; Tue, 10 Mar 2026 15:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773157671; cv=pass; b=WEwYMUuPuGIncUzdVcBZy84Yk1UYzSkR3YZ7HR8ck2ySLk7Rc82tqkOVedUQ7YBheVhBVmOQUzlWzZ/qkd+Vo+0JbXDTZrbW4t735mA7Nq6SFabOu2zUGeq2iFzbEmifit3PJSrpxiB3pdmsIJpsLUud9otO5Zns5JYrG4N6xgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773157671; c=relaxed/simple;
	bh=EHyZYX7N2Ag7kGgS8fkw6KB+dSa0nCGCcgdsjQfQGSI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fzrAIwvf2uNiH+Igzozz/YS5NL5v3aR88VeMSPpgweG7paI0DCS8wDkzEMiayMadkORkBWtb/x0VtybZH1ifYgbWtgQEVg1GJ/ufZq95OE4RIZkp4FHI831537E5n+2bo1SpBIZcvbmszoUmeT3l+1rdBe3eQgBdR+qSLfoO43U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KZEhpOW0; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KZEhpOW0"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5a1273de95aso7652619e87.0
        for <patches@lists.linux.dev>; Tue, 10 Mar 2026 08:47:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773157667; cv=none;
        d=google.com; s=arc-20240605;
        b=lypBksaFCm4QDV+TGqOFXgbszwlYrLpNWdGSoFFNxXYkNe06DSKM9lNgqgu785bXJk
         EWxbzbKh0QFpb3qbsD1rYI21DgjPtROE2GZrR+Ydg9g0bsT1c/6S6QNZnW23XDZzIirk
         4LgbEWqm2qJitwTnuljrJrrjfvbzauf0j3t1BlWzOYzhNh8ne3LRslpycO9D8z+H1Jys
         qLu3HlTJIx/S2FOsbiZom2TyMORSsDCBxlJOIfp5X9ksuQUruFTU6/SmP6oRzfrU9l7d
         pf/+9pgRlW4OKhbpZQg/wqxCTJnj0516ptDG2EtEtMV1v37ROiOurf3fRLTsI3PvIRU3
         j8Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cCAAraqL1xyqLdScJ7c5oXD0oyUTfhfAt4hvbZXuzlg=;
        fh=/BfHq+qj7HbCYlhYKtbzrYPq+puuGtchKeh57rQkrUo=;
        b=Cd0QCaZkun1+rR0YN0wvNKTPk/qf8ReyL9I9UUo3qSDrQGlKUkln+2cSctoPFYGlcA
         73VLQmX/8eSZSR90751PgHQk2WZlQrm/NcFTZffy4mak/Nb0J/Tz8OkckW749rl7h5Lv
         h+LEGo2vCgmiQtx+o54uhOTYNnVKwzcwsnnMpQuxBjpKhtHGTC2z93zUlmJjk7EFTSBM
         merGzFPGCieFgEcWup8Sqdl06kDS/fht/euoe118luZ1qqykl24EzqG/P28yIBmYrwxw
         rNHIoDVXBDiZEextvXfykT6fjirifzVHYp4iAyl5quWXDHFH/HebCI4mGYmxu159Akan
         +9iA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773157667; x=1773762467; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cCAAraqL1xyqLdScJ7c5oXD0oyUTfhfAt4hvbZXuzlg=;
        b=KZEhpOW0qDQc0mZgAWnGdFXpx8izwT7PHEDeUGW3LpfyocCx91KB9taU/XY3n/+B95
         jLjMx6nV0QJAXZp7VuWnmEDvXYldUCrWjapvOqllPnxTxhk21PPaGIPlebP5rz/Jj5pu
         wRwK0cpxk4HVoR9lXzqVV9rssaEn8AKCEA691w4Up9sLvt8C27UKDrKW7WGBbQentkvM
         LGu5qAxdlJsTREPfCXnbxGZs9xPMFOE/8eOlhAar2dEViVcQWNoJYnNBKWr2B3O2v57K
         V5ToPr9BvBxhS7zpNt3y4UURJlkGRJHGMfKbLumqDPJw+VKqZ09p9B0D5NK2N3AglsMh
         WWKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773157667; x=1773762467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cCAAraqL1xyqLdScJ7c5oXD0oyUTfhfAt4hvbZXuzlg=;
        b=oya8EwTpHveJB5oahKX8b82NdCTaAbmvwKyyj5lcqHbSkycyac234Gf4V5DBEqORoF
         zxuoecopy5k0kBy2KRbflDhFc3uUujix3p6Xb7OohJuLGSyQjJJk1+iCH2we/kU7/Vuj
         Ybil2dvdIklu0hHyfRIkdF7m/7KDYr6Uml0DrHAyqhLRHcmbbHigMARWz/h0LoQGKCib
         aWPARHJjH4tlwjMlsMlJIGSO1qq2GhKqbdf+0DJuk6hPuBj5v4DyB+l6gGNcV6Wy0H0M
         683Ybx1l7e6G4oEiXTpa85ortvCQ1ugGAwt4YvRcaSmIiEqehw+rUis0TJGiFJgBCJWO
         PWtw==
X-Forwarded-Encrypted: i=1; AJvYcCVD7YZ/Hj+h5E3vKLkeLAJ1Gql4p7n2kA/WKyhkXsfl02taxJsxQT8WlbTXJbIuMtiJSmxR7f5k@lists.linux.dev
X-Gm-Message-State: AOJu0YwUDj4LH59KwscX8LwTl6JItgQwR28ljCsoR/8AcxXKw7dlq9RL
	ZmE5mAGTUoq1SZmW2+V7hiikf3HCi+hfL6OhobHvSalHOC1/slks91DCF0d0gptIGhxX+5hI8KY
	KQrTohAzow0Yy9ShqtNBb1f6NIsR2RFQ=
X-Gm-Gg: ATEYQzyNaRq15wI9TjNJ0Ia0/DhhQGJtdlMjRIr/QIhxD4TOrzMQ4bIreqsb4rbIxSq
	n1EwX/BiT74eXFU6lGKMUyJDj7LjCT2kpmQgM3hG5ta/sOC3TzOjaNvRe54i46r4MoeCdcwhHXG
	lj/cCakTOcof6sW7jCrbGtmx4yRpmodilQoDiW1YksJyKzii2evO5ZPB1d+IS5S7jgB4xpARrW7
	NJ56x3Yh2FGg4L1o8yZNabqiJtOP9F0TgMhv5B8F6I7BfWK6wHIqzalYp+E3tP5/gckiOdEIAlc
	27jn5GLdXuga3dniyjSxpkf3Kxbn+7yLm/p0p59D
X-Received: by 2002:a05:6512:1109:b0:5a1:422b:dc0 with SMTP id
 2adb3069b0e04-5a1422b0ed0mr4137551e87.26.1773157666153; Tue, 10 Mar 2026
 08:47:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1773140654.git.sashal@kernel.org>
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Tue, 10 Mar 2026 21:17:34 +0530
X-Gm-Features: AaiRm53OPfP49ME5AEVwojA0eEJs_aTtVA6RtOSPJr4AW1MZH7v6HCVm-4alwC8
Message-ID: <CAC-m1rodmWhAkFPNUaLfG9w1iOm9ORm-xR34PxNXZ_tFzFtpNA@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/311] 6.19.7-rc1 review
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 4:36=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
>
> This is the start of the stable review cycle for the 6.19.7 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Mar 12 11:04:16 AM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/rawdiff/?id=3Dlinux-6.19.y&id2=3Dv6.19.6
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha
>
> -------------

built and boot-tested the linux-stable-rc 6.19.7  kernel using QEMU.

The kernel built and booted successfully in a virtual environment
on the tested architectures. No issues were observed during boot,
and no regressions were found in the dmesg output.

Build details:
Architectures : arm64, x86_64
Kernel version: 6.19.7-rc1
Configuration : defconfig
Source : https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Commit : 2867504d9c53260444ef95c17adeebb724395237
