Received: from zdiv.net (zdiv.net [46.226.106.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461B0199FB2
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 13:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.226.106.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756906725; cv=none; b=q/X5sR2y5h5HH2NfH28CI/6GGCDF9JS0RyUGFfgvKb1aBv9/Iz6QJYWrvVcngmr2XyxJ1gJ/Q/lEgNJy8avlK4hTR/TqREcf4XU9afhhsMLiDEZnzFNkVNRz3t2kO2DQ7ll8eeWNCEV8pAg5VV3yV3BZMG9RpbBR3jqgTpY3KRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756906725; c=relaxed/simple;
	bh=QnjkmYqu/1Je2O6m6fzVTKlJEs++2r7mQWuQXxIDZDM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=Nc8q0VoCTfawFzZfHeL5BXS5qXwtSo+BF41goMUVxiRaKsWHn1y4BBRT92aHdo3Ez8mCxljiU2T8KeDkhMXAjTzzgkU/bo+nI4QvTq05nlqlxdNsWePYjE4vt+fDrCRQh1Yx50+PiDvQcNplqq8KbVx+rcTJs+PKS9mxVTeuw1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zdiv.net; spf=pass smtp.mailfrom=zdiv.net; dkim=pass (2048-bit key) header.d=zdiv.net header.i=@zdiv.net header.b=IbPC+GnG; arc=none smtp.client-ip=46.226.106.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zdiv.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zdiv.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zdiv.net header.i=@zdiv.net header.b="IbPC+GnG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zdiv.net; s=24;
	t=1756905121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=buwyaVC2eaieCu74ufQFtz+GGdBgZ65djZAMVk/mlGw=;
	b=IbPC+GnGiZl/5AJeoFyyU43MOV0ozSPsmh79WLocWspY0Jy3quSvhF9UG25cv2vLO0azgH
	AEQAlzaBGgcmRma+xPTZy86NkRWpR/CW92FQSuL+/nrFn6Xc6zfQ/lewoq0gHW1NMVIDN4
	0Ohk9dvMErhmaYdBrmjTxUl4wPUYcAxTh2KSNi/PtjsSVhw6zfr4usg7PN829sYbmJcCp+
	G7wp6dx72JU9O1jUjqEwq2ViU4uOFiRGtqXvj31wLokHhDpzN87tp6vMFAmaXcLH0lQ4Yb
	AAI9mENmjXe822gVl0VcjY5o55C/H7/X1uYPFK54bssy2vhmKv6g8D0ekoC8lg==
Received: from localhost (<unknown> [2a01:e0a:12:d860:c963:9436:23d3:76c9])
	by zdiv.net (OpenSMTPD) with ESMTPSA id 05f455d3 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 3 Sep 2025 15:12:01 +0200 (CEST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 03 Sep 2025 15:12:01 +0200
Message-Id: <DCJ6VYEX38V5.299A1614LE5I@zdiv.net>
Subject: Re: [PATCH 6.12 00/95] 6.12.45-rc1 review
From: "Jules Maselbas" <jmaselbas@zdiv.net>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
 <srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>, <achill@achill.org>
X-Mailer: aerc 0.21.0
References: <20250902131939.601201881@linuxfoundation.org>
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>

Hi Greg,

Yesterday i experienced an issue with the amdgpu driver on v6.12.44, dmesg =
saying:
    [drm:amdgpu_job_submit [amdgpu]] *ERROR* Trying to push to a killed ent=
ity

which causes the kernel to freeze/hang, not cool.

I think this issue is fixed by this commit [1]: aa5fc4362fac ("drm/amdgpu: =
fix task hang from failed job submission during process kill")
it has a Fixes for the commit: 71598a5a7797 ("drm/amdgpu: Avoid extra evict=
-restore process.")
which is in the v6.12.44 tree (but not in v6.12.43)

I am currently on v6.16.4 which include the fix above and i no longer have =
the issue.

It would be great to include the fix in the v6.12.45 release.

I am not subscribed to this mailing-list, please add me in CC in your reply=
.

Cheers,
Jules

some additional info:
CPU: AMD Ryzen 7 7735HS with Radeon Graphics
GPU: [AMD/ATI] Rembrandt [Radeon 680M] (rev 0a)

[1] https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3Daa5fc4362fac9351557eb27c745579159a2e4520

