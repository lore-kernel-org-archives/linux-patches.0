Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15567385D60;
	Sun, 11 Oct 2026 11:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791717217; cv=none; b=g0f4ohP6NASgyVd9ZWmD03I2gtHmwePAd6TvdcSJpC/Te3Pu/jRbZQ/BGp5lI4Ysw2bFVl1IvDJaEfzAHSi5N70k0bj2TyyrSIqVI2NxDeszPSFAR4ftfvggJqOurWAfjSExYgbEs7sLaDKNVdHHZRn0bOueX3tJPkvBQYJ6tZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791717217; c=relaxed/simple;
	bh=KeqCzCw52zxDpQWG6vCrdpzulCR00DtGW3W0YNkgYFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZdebJHeex8Dqp8ahR3Qd1NMpg3CaOZF0h37IPmG5VVH43bLh1As+XB5RqYQPyPXoePBiHI1axZnOQM1G850h5PsCMhzO1ZWDalUlQdVfPTGuUrNC/aLZXVkNPO4DElGGa4pkHQN/++TTuv6x5sCiNKKA6ceyCactWJbBLfgrsLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQO+66Lf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQO+66Lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E27C1F0089B;
	Sun, 11 Oct 2026 11:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791717215;
	bh=AkNUTOHJTyDBQaniJJDYuernL9IrnSLlom+qnrPpUk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQO+66LfzD72ruGUEsdTW5B9RLKkNFOkSgvWMYNjD5Pb1539A43RkWokoTk8BLU6H
	 6VPWgExC+NZHgIOGBpPWwEFIWN+qXM0x0J+v5vvLIJRInnBAAZF78QSlpk7KaB+l29
	 yTJ9Hk3ziBaj+MfPk8G/FTVlH3R0ufkcPIachshMSwPEUPkr2DdyV+BduCfyy4yL73
	 OrzPWetz+vjxU6N/CrtzzhkZXXvtcv4wTzVu6eLOxjHZR977DkZWjhUiSVvprGvG4k
	 zhPYPxlhYPpSlQAbBMW0NPsNmzH4HWlGi1RzRQfctnq/A9RhXCLON2J0ljU//folwR
	 YIi+Nx8tB8KHg==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <christian@brauner.io>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH 7.2 000/428] 7.2.10-rc1 review
Date: Sun, 11 Oct 2026 13:13:12 +0200
Message-ID: <20261011111313.27648-1-ojeda@kernel.org>
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 09 Oct 2026 16:05:37 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.10 release.
> There are 428 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Oct 2026 14:08:23 +0000.
> Anything received after that time might be too late.

Building Rust Binder breaks with:

    error[E0061]: this method takes 1 argument but 2 arguments were supplied
       --> drivers/android/binder/node/wrapper.rs:86:50
        |
    86  |                 _drop_outside_lock = owner_inner.push_work(&node.owner, node2);
        |                                                  ^^^^^^^^^ ----------- unexpected argument #1 of type `&Arc<Process>`
        |
    note: method defined here
       --> drivers/android/binder/process.rs:173:19
        |
    173 |     pub(crate) fn push_work(
        |                   ^^^^^^^^^
    174 |         &mut self,
    175 |         work: DLArc<dyn DeliverToRead>,
        |         ------------------------------
    help: remove the extra argument
        |
    86  -                 _drop_outside_lock = owner_inner.push_work(&node.owner, node2);
    86  +                 _drop_outside_lock = owner_inner.push_work(node2);
        |

(and similarly in `drivers/android/binder/node.rs:74`).

It is due to upstream commit:

  dbb17c9ea756 ("rust_binder: move (e)poll wait queue to Process")

which added a `&Process` parameter to `push_work`.

6.8.y breaks similarly.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>

I hope that helps!

Cheers,
Miguel
