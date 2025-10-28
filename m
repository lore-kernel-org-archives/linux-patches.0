Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DA1331A69
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 14:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761660563; cv=none; b=LlQ7i+xzYX63zsXQuHfSfjFD2Gby+H47clp6vooVLudZxUxXXpMz8qH1AfODA1iJvOGdKprBQ0RnpqAY4luHZnO0dhAzDChiR9SNgmhldxphqErCHVK+ZErBdzKiqU9BKDtY1G8SIk4DBN0Ar3nf8pe+lbux2yULTr5OzecsbY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761660563; c=relaxed/simple;
	bh=AdnRw7U11fEVAUyQ3c4ltusVoJvhyax3gV4Hxys3+Bs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NekHFp8CfusDNhUZ1IwXf1y/82EQqvexMI7nO500urly1lAVEWJM1+a8MNSd1odosppWYc4dRSVKmDkXbKKaNVOcsnsecJue+aGciYvLqcvsf6Y+rCnzCWDuMqKp/VYtNJ/9eV+qJDcmTzdDcSBtJuQQD+9KEmPUd6MGpCUdpp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=fx6mLE6l; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="fx6mLE6l"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-88f2aebce7fso629505085a.3
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 07:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1761660560; x=1762265360; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/zcU8dbk3YPaQpFZh0LEGbD8GL5cYg7PwFTIPigTrJM=;
        b=fx6mLE6lXzh4yqFMYNLETdA025H/vOBzZuF9KqJN9GnLswRi+ZsivigYO6uXYJl3NC
         JZMifcJTBcg3m/S4qKze1b0BHYdxFard8t5lheXqYOEPE/fazPmOxvA/quCe+9XVDzA5
         zXKp7WhVhBYn05hWbUzwg3mjps7T1hWw6f9TR/ejyUEyEEA+DNHBlQeKdlmt3xt3ERpN
         FCDfJcrysM1IO+2CLB46VptM4FKatwmmUi5lh+C2NPvdi8nsbuJbfPoZrd+XDozCHQMG
         7r7QM7OadDcWVSfTjpQReUCkWwMkMg4YldFCMb0DuDwkVDaE8qjd3RsiroBNymktuwZW
         89bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761660560; x=1762265360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/zcU8dbk3YPaQpFZh0LEGbD8GL5cYg7PwFTIPigTrJM=;
        b=pWvRHGTapuNK8j/LeKCRMIn5d9MjlYNQjAnqH+XkER/y9tefzyFzyr0aqjNs6GmIlu
         J6k1zuE9SWBlUVOBc8UMVA6TgOtZfGTtMw5u4eMjoFQ8HkqBw3XK5EWHZ/twBvYNhpR4
         ggEPf4rMZaLQtyFracsmhhNpjAnE4EHtmJ4qo/rd1mF88QnXfmf+MZLHOqt2jNZyOzDm
         3Lc7TPR0tsQeZrdPyua9oFR4rQbS5I+E9aOp2mCmu++gZ6OahkqlE5BPSL6HfZ85RQXO
         6nm+g/MzHMLRpNldbMIpoYfsY3IHszU2nI+7k9RwrwsDVKVvW/sugZIfiLvSTAT/7Ojz
         49ow==
X-Forwarded-Encrypted: i=1; AJvYcCXi5z8DX5pYS4M/qDZqZxDfiCRKHmQ8vZuIFRLUjBABkeG5bMSUkRCPxavSLiNwWRHJWzBPB2K1@lists.linux.dev
X-Gm-Message-State: AOJu0YwVoDhxOPPwhpT/N9u0QyDh9tgtrUd8iAPa1dXCFW8dNUi69bwp
	PsWb3kSzgVejgCLkU7YA97GYyLgMmKLI6mUJAhd6CY5vZH2AoeN5hp2JdF5I4FFXG6h/IL6PzSI
	3c5AJOEiOUzpXF7tTctOBInDdjtpUca3vYWPfrVN3iQ==
X-Gm-Gg: ASbGncsdE6taFxkQiKzIYPfEPeez0i1adAg7dGbj0wDWbsAYW/zZOaFFbA2nlEOu8T6
	JPPcsoFUpJcH88WM2E+UQKFfhyqGRaoydIkyrdnlvxTuaGCo6Z2mjQj3vr6P3VapyCeB0UnCGpX
	0jVB6qPeIaCeu3Im9ED6MHckbsVU34DZuHrHAedRy3cEZa4QTVu5E61yGgZpEAxzO+86nwrESE1
	Zq5q3DspiZteORhcF8X5g6rdHd0Od4TwoI8EtFSmRPBlmAz983yIn0TreQfbw==
X-Google-Smtp-Source: AGHT+IGeD0rlHtRDBvGxpdgqlidUafHqhsh8Ky9XoEDN3FLfwPUswXwdlMrdSNVbbnKnTlU7nlSS8qkTv9BYaTfYk5o=
X-Received: by 2002:a05:620a:4711:b0:856:60d8:3688 with SMTP id
 af79cd13be357-8a6f78fc5eemr447314685a.47.1761660560137; Tue, 28 Oct 2025
 07:09:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251027183453.919157109@linuxfoundation.org>
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Tue, 28 Oct 2025 10:09:08 -0400
X-Gm-Features: AWmQ_bmdkmfhBJpXFY9QIg-9Nu9KvuWXlnvP1dY6QfRsnqg3ap99m04OvaHDYGk
Message-ID: <CAOBMUvjZR4OL0Ffq_yZq_-4nGNAQnicFP8mXqgc1tCtP0VvVsQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/117] 6.12.56-rc1 review
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

On Mon, Oct 27, 2025 at 3:31=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.56 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.56-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
