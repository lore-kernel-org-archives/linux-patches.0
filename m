Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02387212D83
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 16:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740070054; cv=none; b=qwEonZOYjj+RRBs9BAgkS6TIb+E5mAq/XnfUXtk/W//y6WO1UnP6SriNcInHmKtjrjEg6uz+ZTnAf5P6//x8G91WLH4iwc/Ygr2YBRZW2dXU1usjT7/m6+Mf/nR72Cn1arOzpNcP7kePAaUbDNjO5AmF5hb7eCZg9z4p6kpoRps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740070054; c=relaxed/simple;
	bh=G8Rvj1+RYM5PtCvCGhsKpVb42PxUTrWVFF4NYbTXBoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cyq17Ffd4gkLwsjATkqn5JCEzFKGGLEN51Sl6vTgVZWh7uJPp+ioc39s6uy04F02Whf+83Co8NFNWIY0O5OvxyO+YjoaPLyrK2l7DXzMUAbyEag/60KKvvWlzcaXT9IWhBGpyc23+qLa8V34A6gBq30s9KK5MRfvI/gZtXa9E0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=Frzm7BDE; dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b=K7gTzbJm; arc=none smtp.client-ip=148.163.129.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="Frzm7BDE";
	dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b="K7gTzbJm"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5AD6C2C7410
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 16:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sladewatkins.com;
 h=cc:cc:content-transfer-encoding:content-transfer-encoding:content-type:content-type:date:date:from:from:in-reply-to:in-reply-to:message-id:message-id:mime-version:mime-version:references:references:subject:subject:to:to;
 s=selector-1739986532; bh=LvrmbHNdQa4JVysc/FIbRXhYNUaX8nkPjWm+cWDvugI=;
 b=Frzm7BDEU4kl2jqh8juk0J5UlPtaXXXlLuw8tOmbJq6uzNIeLF1assocYXiP/dKlrFBL1IwVTVTohchj7kFNkwYvLiDQiJ0q5c1fyNxEqGtK7OUWO1TFk4Es7QdSTqOyfOM8+kXtKWSH96FCguHwDI5zAVmm1o4nSFyhiZjI5LCk8QkcOW27vkmyxwLX3kFnH4njD2Ze+mD+Cf56VIr+nVRjy6pAI7B0zqtaq7BRWXYxP3Y/yNHXxsifzBsl5DVS06xwZk5j3lKtxBjrg2GGVQ/D+PLgiuwX1vdy1wmnlpqX+jtruy/s/NosjTMfPwBySVg72V5k3i1wHcQdApjeZw==
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D02DAB8013B
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 16:47:22 +0000 (UTC)
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ab77e03f2c0so164141366b.3
        for <patches@lists.linux.dev>; Thu, 20 Feb 2025 08:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=google; t=1740070041; x=1740674841; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LvrmbHNdQa4JVysc/FIbRXhYNUaX8nkPjWm+cWDvugI=;
        b=K7gTzbJmUto2iKFgCluh/L53Hs/ZwfaqX3jTQXunldJB8jUIm4tSzjuzhee+4sQBKj
         2/uvnbMn2I0ECktbOThuHcRKVF0LqodXqAMMKvFMK9hFlF7hBoIdkbU8d2zr/nzttSMV
         nEMdhGVXbZ1NMxs/8P0zSiyCLwVgLsoMtv9zhIx4LMqUNCsL5oPjGfOAmuNMvhFxZta1
         BgnquncmA/bICnftCCBv5sh9DJZEVDVERFE975c9eyYJbfiaQA5QlvMtOLmjc0zAaiC1
         BNroLb+tUC7Tr81WxgWvRHS2dqav3KFax4srRvq00PNBWpGUgQv3SIX94bCAvyfUYHtE
         ++hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740070041; x=1740674841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LvrmbHNdQa4JVysc/FIbRXhYNUaX8nkPjWm+cWDvugI=;
        b=SZje/9T5LcuhxIRbWJKZAYe6pD9185YsYwzFs8vgJzdQ5vlZjIHWBBqMWEqr1rb6h2
         R092sthSBwSjHiwDREg7rS+nYjvSyVR7PNySqQX5F5ORuylCpKpWgaepErorosJWJ3Ui
         mDslazslO4Baa49YdVzywIIYJ058H656MekvLLhDBWWZ5ey2uSGO1qrsVEKOCiZlnybq
         uocWarY54tfQvdcBhNrtqTTcgfnHtgrxVXHmWyxkGD12EVzLjPaZiYaaSW8jllb/s/aO
         y6UK2WP8cOSZYkgBuRomGGHG+6hbhqNkSJQ9P2wkeAs7Glei+WoesCoUDXtnW0KX7/2Z
         V9tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYxT+OUiRirQh0fp+SAjbBCe5CPoKi99Jjnp/VWvAWCfcGmCIRdNxke8X0mLKAszZBnEHfUBAT@lists.linux.dev
X-Gm-Message-State: AOJu0YxCp8l0OpzS0tYprOKVZNgt1ZzNPNcSUqcCELrip98U47z06kMD
	WtXLH5eHgNFRnPo5e7kqfo3/osyOhqA7Pz+qeuUHdwv1j7o2aMCQtszAhdveBlFSOuxouoSXR22
	6RP9FQVsc+3d9V/AT3lPM5LcVRlsDU3TG+31yRih2h8ZCPO+73lBay9Xoy3pBGKkhO53HtcqGtF
	hoeAdJPgpmRM8veeDa74EMwHKW+25KQYTlxqw+0ekaIzs4AcOHO2M=
X-Gm-Gg: ASbGncue0gEr9GgoBbBVx1thonBOkT1gO9MvtizKDn9b5zoBeFeE98//KKtZpQVccBz
	1iHHtfebiMRJ6eBdG01/VhZ2RpYaSBJkVQwJPFLtsJkXrJLXEHUzUXmbTKO+tXQ==
X-Received: by 2002:a17:906:3083:b0:abb:83b9:4dbe with SMTP id a640c23a62f3a-abc09c0d19dmr509166b.47.1740070041337;
        Thu, 20 Feb 2025 08:47:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEBCENTa9zojiB6+sevtUZcBrd1NLHq2XG6gSAX9QhN/ExTmOHUxbRZ1VeIW36PUVvO/3J3D44f/zHm02o796g=
X-Received: by 2002:a17:906:3083:b0:abb:83b9:4dbe with SMTP id
 a640c23a62f3a-abc09c0d19dmr506066b.47.1740070040871; Thu, 20 Feb 2025
 08:47:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250220104454.293283301@linuxfoundation.org>
In-Reply-To: <20250220104454.293283301@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Thu, 20 Feb 2025 11:47:08 -0500
X-Gm-Features: AWEUYZklFFz99Wzn4U-bFKpzlTK9ociJQmc_XORzn4XFpW7PpwbbhCLQN7WTZQs
Message-ID: <CA+pv=HM=0yKe74WT8dDHYvxFvCSsHocGwjz-82mMU8oosn2mAA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/225] 6.12.16-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MDID: 1740070043-oPKxSFE5bwEO
X-MDID-O:
 us5;ut7;1740070043;oPKxSFE5bwEO;<slade@sladewatkins.com>;34a45300d431351f6eba03f8f221989b
X-PPE-TRUSTED: V=1;DIR=OUT;

On Thu, Feb 20, 2025 at 5:58=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.16 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,
No regressions or any sort of issues to speak of. Builds fine on my
x86_64 test machine.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
Slade
