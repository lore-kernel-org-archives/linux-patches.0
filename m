Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0E73C0604
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 10:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780913297; cv=pass; b=I7uffbPcvzl/ze534s7rq2aG+CECcST5oDotHqWfpdzrZki+YJbg45gtmzkWl2+24yLeX9qbqBz4mO/h56kfpEZ/lJoEEfwaeF6YwRNubWLTT8UXxv01oA/d2Wdil36CP7BQRALZruM69t+7CUnUHKf+3CH8L5CYQuEhjXANWIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780913297; c=relaxed/simple;
	bh=6LrKMFBGjj8ct9TTofDjqiF5sLmpqspGhITcv9oyCgU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qdyqDaNDxj+iP7LgFoV2mgLRNgOuabBtJlSlDgCooQ9hN9YPNSnsJQd6UI29hL1pZgWZ8ij97Pu4zf/RgscDbJD6HtOpQVkBlIvVW7g8L5jc22w/0ZKFa+mobkIMRXI5eIIIDOf5x5nv5jttfxipxt1qodaTxMxIHPXbLnIHdpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J4V9UqF0; arc=pass smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4V9UqF0"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-304dc707c7eso355846eec.1
        for <patches@lists.linux.dev>; Mon, 08 Jun 2026 03:08:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780913296; cv=none;
        d=google.com; s=arc-20240605;
        b=Iy87KpXrB05siLm7I2v4tiQRJHsam19iVb63ZwkoxqGHOmpO053qTCtMzZJ2DbYygy
         Tx2y+7rb3GsHURuvlcG4yEtev8OhbLft28e4c+QPMSNZZG2GwDYMYQ01Mlv3/x0tTWgx
         q2fCRWefSPKtodLtPIEiHBu48pnFxtLosYUnLNZeMWPhNKql+HbKkOeYH1Wuvgphofyy
         XFdqzap2EqrQFP8voIT3xgWjkTOW3bWx3iu/2FnwCFMQ/+4jHzvaNOhg8/sMJTns7FrV
         8O5SPed73ou7MTU9JKcfahoyC9qEwDRPrVdQtYVI1c5HaTfdYSUOjhp5tY0mG/3yvc4s
         DRkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4xs9GW8UG0vcJ1ziYEME099eUBntAL0P9yXVtIBd74k=;
        fh=Hgu6+LGFWQCGqqkw+Phbm/Eenb8wp+FX9L8MqZYeWco=;
        b=eZJcszgbTIJo3DI6KKrVj5lYBbjSy+PxfbckQMYaDqAqlgouN53szEoi9KzxNOFw6N
         SciqsOK5k99v+d9gZxdNj+NVPXkU105KAWsC02nsrPo90KTW5k3QVS8WIq1ikrQpf/6G
         NhV3Etx1aWH9/UWmzdwNYtjazzyEKDDQooYEPZK73PRWDktNSJSVj98vaqg8WNaHi9GB
         WbUv7BzrGumD00THq9h0Rrs0WT9Xo5Tpg7D0EYaixX4oQywRx5cEyB2ZOW+WmWuefMJa
         KpMBMMKGpUvtAkmi9LeCn2xRGSvu8rDYJ5rLnXY34PCI5Z43qsAM1brPwOa7VySpm83T
         cP1w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780913296; x=1781518096; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xs9GW8UG0vcJ1ziYEME099eUBntAL0P9yXVtIBd74k=;
        b=J4V9UqF0D8H/H//+WvFHkzA5CPqYnXNF8kcRAaRFMuAtcJnPlCS00zC3UmQkMDZChn
         B71+Oxh0ndsvr4Tya8iiG4HTSsxICvN05R192CU3iERI68ijrmdED8PBAlmSFZBYbGa1
         LXMsLGlbcsClM368zV+q19UXfDpZiFAGbQOyJFxCSRzMTb1hqlNjOl1D9asxH3FCSSa5
         Ep6lUEKCg56MaFJB50UY/A0/v4yhTz/mS+ueD09Y3RoAM47PtJfpXfrHXtxnFn3dT7Vx
         HAWTN2qc9/+0gGFEsO9NgtqHcZiR7nMafuQhpDwC/PjBmAsN6m6OvyorUMrbYxAJIee4
         Sb8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780913296; x=1781518096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4xs9GW8UG0vcJ1ziYEME099eUBntAL0P9yXVtIBd74k=;
        b=h2DjJLwaw26k6hUKInCKrT8w7w/Jb6Iq/Z4jaXyo/6JmPkig4B2u3rYt/uuBgjlPm3
         uItsbsCVx4uRBbH4qFkzQukPrNvzLdxlmrnVYW5fEsXDGUH/xyMp/Py560hBI+BhAPEq
         Q4HaOvrFdrcDB5rMF0+al2xaio93ujQuQrFbdmmbuxBQR6IH/VzMGBgJQnOtbir+oGKw
         vzMrUdUmDQrROg6EC3VIhxBhXCGJ3Jzj9cqJlz43FQHmIyNnLuxG3sS3slUWHtjCO8QN
         dQrEbYtJvnvXAF1feHmlJ9FMH2qAFbKsyV7Dvl6JhhqlxZDQu32VqVYZEetk7XhT40H8
         SFIg==
X-Forwarded-Encrypted: i=1; AFNElJ8LveemS9yPS36GvbFYBMUmlW+y84SfJzapT7WClxJ1+kxp5cHIwuc5YrutwLQUVInOOHLxgnju@lists.linux.dev
X-Gm-Message-State: AOJu0Yxzxlj0iaFKI2r5cJi9ygLazoao+UEeeVYeR9y3ympjsWB6aeWf
	KOz76wIO2BDh6l66IPPjk0Es8JS/nTjMOXnTS+9PVIK0XGZkeKKY7egdB3MZfE6JCSKLlsJ3Diy
	1DQqObq9F4u5A55NIife7Y5iLYmpp4bE=
X-Gm-Gg: Acq92OHvl4sk7YfdACS92hnS+asZNcJD3Vsn7ir9pMIGvZDPRafMI2yIRQgAkm7kgcx
	CK9F2+/UVVy+aoALuoeANarjPHK1E+hUmpell5+Tvw9aZaXBXcehN6tQdHrJqYR13QSNFvCVnMs
	uC/DEsBffSNJhFV2+UbSXirdckiybHUMv+WHvWRWmUsPbC25bTEr8mluaNMALJQP6RHFC7bf3m4
	0HdiZWTLTVSg74w1DcrW7JIK8MhDR37T7dvZpHAWO/LnDjKTzKfvRmR2EO3w2sQqhvxtX8MDtT3
	6kXv81S1EK9O1FRPV5OArkKqxD2oh21lMvyI8OOLjDhOyal6EQZhCiB4c7D7MYJSIHn12Ol4qyN
	WEE6XcD+vihOSyIkRXK782z3tpO+W4u/WtaJn7k1kPHMJ
X-Received: by 2002:a05:693c:3945:b0:2da:a813:a629 with SMTP id
 5a478bee46e88-3077b223afdmr3586110eec.2.1780913295620; Mon, 08 Jun 2026
 03:08:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260607095727.647295505@linuxfoundation.org> <20260607173214.92693-1-ojeda@kernel.org>
 <CAM0EoMkszTXv82To=KnEYTgzQSmEdRW9XrAMVtJsUaDn=Akf6A@mail.gmail.com>
In-Reply-To: <CAM0EoMkszTXv82To=KnEYTgzQSmEdRW9XrAMVtJsUaDn=Akf6A@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 8 Jun 2026 12:08:02 +0200
X-Gm-Features: AVVi8CeZqXycb_mHPYx-p3hvMm2G0q4sVMGiMxTvH8pjrUyAWon96zgP6NZJLr8
Message-ID: <CANiq72mJNbNzYO37VK7s=ua5v31xBrRp8EnHDvEnKF8Z77jDmA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/307] 6.12.93-rc1 review
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, gregkh@linuxfoundation.org, achill@achill.org, 
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org, 
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com, 
	linux-kernel@vger.kernel.org, linux@roeck-us.net, 
	lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev, 
	pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com, 
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org, "Kito Xu (veritas501)" <hxzene@gmail.com>, 
	Victor Nogueira <victor@mojatatu.com>, Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 11:55=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
> Thanks for reporting this.

You're welcome!

> Unless i am looking at the wrong code version, in the current code i
> see m_eaction is always initialized before being used.
> m_eaction =3D READ_ONCE(m->tcfm_eaction);
> Probably a compiler false positive?

No, it is an actual bug -- you have:

    int i, m_eaction;
    ...
    is_redirect =3D tcf_mirred_is_act_redirect(m_eaction);
    ...
    m_eaction =3D READ_ONCE(m->tcfm_eaction);

i.e. the assignment goes later.

Maybe you are looking at mainline? Please note that this is a 6.12.y
-rc thread -- are you looking at the commit hash I mentioned?

Or maybe you are looking at `tcf_blockcast()` instead of `tcf_mirred_act()`=
?

I hope that helps.

Cheers,
Miguel
