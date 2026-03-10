Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F0A175A97
	for <patches@lists.linux.dev>; Tue, 10 Mar 2026 03:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773112616; cv=none; b=t2r5cMHYORmvpFHO40wW05YR0TDUVY/9BzKPLM8g8gtxOwztQLYIYbPOzTVbezkZmSMQMgtmtEJ9oxEgoa0rQL7AAjfHJlMY1Zw43lrvvK8zjPekSzGBa2NNWayawDkKKqjMs1iAdWFQ4HL3mm/uim7T/3pBrB1k2HebyVH57jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773112616; c=relaxed/simple;
	bh=kypLUIpa+hG/hxMKpxLiGtUToGhjkCNpD5x/99R8CXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MftbPQu0b6avZO8GaSLRiNYFLrbwYbbEocEUCxbwRWzF/ZW5D/q/p2zR/Gc+CXTBtJsDF68UP4Ni/sLKnOrews35jjqy08W2zquh+68hJVK39iN+cFtGGaCe3GWKrd9YP2EErqixNpE5foMiPtj9xgtPOxkn4mHHCA/LSMwfWLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EGoFCOLe; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EGoFCOLe"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48374014a77so146194495e9.3
        for <patches@lists.linux.dev>; Mon, 09 Mar 2026 20:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773112614; x=1773717414; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kypLUIpa+hG/hxMKpxLiGtUToGhjkCNpD5x/99R8CXo=;
        b=EGoFCOLevq46gf46k/fjDKW5S1YMLwwhlpTOSqsAMxIlttuMLmjimLVqPVAUmGrTAB
         rWalY6q+MmDIKn79q3i0OTT57pny4jzvVMvbumGkyUvqgWDvGb5+SgSnYnGsEPx0h5sa
         qWm0sUuee4gf2Oul7S5QZdI444BOvZSO+UK/9Qv6veG3C5FCj5Jllpq+0MqDipl5GNKf
         Qima/k5nLovKO6fFxZWpdvdxfGJrw5s2lGDe/OgUvCzavkNix1tdrDaXFM7jUYWYiTU2
         4LfyG3Iv79APDXbuxCocvi1xOxpseJUW2VSf4K2WR00yrUkEtol84ny5FADPHMQkyyTT
         5S/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773112614; x=1773717414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kypLUIpa+hG/hxMKpxLiGtUToGhjkCNpD5x/99R8CXo=;
        b=Y6QwYLJIEiNfOE24qpOYyGU845k4sxRnSh7U6w4eN+oI6TdwV5OQ5ilwuZIlj/XTBW
         aeR21G1O2x/5/5cz/49EX039Bb7kNaoIZKcBZBwJaS8TVUZeiQ7tehHpXwSFmkaazF+o
         CsZVly62I41vYSQzH+DHGIqwdR102BlH8e2rL1ULnpEGm5DJ/e2StoMerAKtbbIDW7UA
         RUtU1Ryle9nsGZ7/9jhrEX0kfgGo/Sfcx1dcVw86CziE9xlfc/4q/IKkC0XRwWBpEJpg
         B7nuaT8OXhc9xycHeOn3vtR39bHiichWC/S+iaBMRlbTbol107enpfvkY+zdpsV5DQPA
         xjig==
X-Forwarded-Encrypted: i=1; AJvYcCVeNwVarvpiwW4whPkrxMTTQoIcwEJHkaLNsfjHGRV4t/kYAHipjeN4j/9zD9FnEiiFrMseTiC+@lists.linux.dev
X-Gm-Message-State: AOJu0YyBGJJwv8tImv8Oz+6ETbMWfQ3piiYXZvmopewCndoS3TLcIue6
	UusPD6LWqiTvaIaeSU7R84zJHyAPNu+je2jqGTcUL6sni+L46X60bv98Rebpx76WaRg=
X-Gm-Gg: ATEYQzxIyzmEOIO5F/hXil2g5OjMHMwfJh1jiEdoNddEgBXQUwmUatRS3ILh++f1zCz
	cbk1S8zqUhxbzlm0+i19eMkgXYjH+AjjQZJlH2WGBKsMj/lStOSsbAuXEeJLgf+Wf6fgX5EelHZ
	jvU+Pc890HZ9N4FCNl/5uP1hUWIZlBE2hxo3ZYznlradhRAw+lwBbkis2ibikuRwEsfeVq0jOvn
	3OnCexOAiTnuTH0IPiG0xCReIPMXNOB8PPrBQwijIyFUljZxA50qQ+0jOHOHRo6pnPUl270plI2
	ziAsxS69KPKYF267ykfFsCMMM5b75pjJ0IeSWWOfIWcHfLe/HPDlKK0ZeTeTbKR9xViFyQ+B5yI
	JQlr3sNkYWtkRfo1NOC/auTDQvTHiDFg8ZdYiEaWhtuom86/+LWUEVYzMb/2kcUJuwrx85vwOHY
	UWPlSE+ZAuG42CaGTlJg==
X-Received: by 2002:a05:600c:1f13:b0:485:40db:d40c with SMTP id 5b1f17b1804b1-48540dbd6ecmr46089435e9.3.1773112613741;
        Mon, 09 Mar 2026 20:16:53 -0700 (PDT)
Received: from u94a ([2401:e180:8d01:1fb3:e42c:360:78fd:1fec])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be4f8481c1sm12689470eec.15.2026.03.09.20.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 20:16:52 -0700 (PDT)
Date: Tue, 10 Mar 2026 11:16:37 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Patches not posted as reply to stable-rc reviews (was "Re: [PATCH
 6.18 000/757] 6.18.16-rc2 review")
Message-ID: <iy7dogrbld3h5ygezzkhp3sebokfibu5suegpidlsrmp2ibfwd@fvstv7j7dcfm>
References: <20260302160853.2519610-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302160853.2519610-1-sashal@kernel.org>

Hi Sasha,

On Mon, Mar 02, 2026 at 11:08:53AM -0500, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.18.16 release.
> There are 757 patches in this series, all will be posted as a response
> to this one...

It seems that patches were not posted as response. It was for 6.19, but
not for the rest (6.18, 6.12, 6.6, 6.1, 5.15, and 5.10).

[...]
