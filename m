Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A596F4028E8
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 13:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781096945; cv=pass; b=PubL+C9x5TH9ivetVdvMsoo3rr/dRKJUi2fou9Cvf7Kmb0lI2LCie3Y/7cKLo0HFJ160q+NC/ai8RQFU1V4ycbJkTP3hmhOLyLdsp2H1+xnUoyqHLPLqZbrPaLZS6w9pUw9eKnWUEXtbbDrLk+oR0kdVSzTrR6CZwzaYrbfxc0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781096945; c=relaxed/simple;
	bh=vMO+q+CyPLuQfigTmgGUaVN+qKKBldwqNdWDRJi9STE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FZlnixBm2/8h81zdukvrk2agG+7QPJpzWGNKpda41RrCHD/CyTTfvvK40S0pcY1pcUJmAhk0lNjBKml8XIs7SmxoAohjV5AadOydx93N9y70MxM4saSNB1xpp8CAblh9rg/igJnkDiwMQYsTvP51Xejp58F/bKsefIStm3Q3NqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pOYUglee; arc=pass smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pOYUglee"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-304d3d3d8f8so479106eec.2
        for <patches@lists.linux.dev>; Wed, 10 Jun 2026 06:09:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781096944; cv=none;
        d=google.com; s=arc-20240605;
        b=BaDMW/+pm7LkGumU3csj7QRFy1qqHnCuntBCWui8eiHc683eLJQW+ZTrryHPZfu2Uc
         dxgAwMCpX2RC92hWyzcy1+ZPzjuBGIU6GoZNnUrNeFNmJYlsPnj4M4JF7/3Y+zBpEsQc
         rEkF2nZ+sf5EsjqXeqBIjJVV15GKUdmrgVnsDAiJfD3N1IFah+HcuBkW44rBHnEWEc10
         AHBgxtEwF8Rr+eia2p4CVJ2BQhVYcbkuu78oX3u9INZ5R/ThmcoQhyDURxexZBEB55SL
         znMEgXkmlwQtmygayqkUfFIbX6C3xRPJveAJCdMlqo1pghg38zDvHqHFjXffyHIsDxfm
         hyEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vMO+q+CyPLuQfigTmgGUaVN+qKKBldwqNdWDRJi9STE=;
        fh=MLOcv99Omi9bsF3wREIIXDoEkCVZg3HPytysumQw0v4=;
        b=kZq4BtPNjZ4OzusiorQ5OSdNIAMFz8EvIJ3q9d/PnjeOcf247muR68Csh/eq0NCFb9
         saLyzEywh4MXSGNKBRFKGjonbfp+xsEWUyk7LQKFqEZo17oisPOCfo7f/TY7a3x6swls
         gQAb9vg5Vvv8Yez8pNkQkCX9GS/D0hzDi2jlHv5v6yXag3MMjJABITABZA9GloaenTSV
         rdIlZ2j6Cxv6rdM0rvcePx6OLFwEonohmqddBD7BMpQtVmhjnOepYoGArdACzdJCT01Q
         txR31ausrsrP+iEp+P2itnNSrP0IWGBhNhBm+iOLL/6GbHBCJ25PQl9hXGPbi57aiLBT
         MwFQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781096944; x=1781701744; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vMO+q+CyPLuQfigTmgGUaVN+qKKBldwqNdWDRJi9STE=;
        b=pOYUglee4NGd6o3xyGsW1i7EaB17WT3+zdYr47360GNynZWaAOomBDfY+kr3O8kLSH
         5a/prayE4zxFYtXKVt8+wmWwi86EggarrLaZBhivhdOjSRa7N9yv6TUSh1gHDJznIWcJ
         MD8cVUSSKP9OJuOsWaGrL9xSj7zIPJgF+K9nSmE+VEXWagBGp2RujsKSkRyTOS5m0t5J
         rjDkPbEkKmRA+zGVZvtSWNms02soOqefwWgp7rRmbLe96raHj+wSqSAtDIC8+/0g87w+
         q9uEBuKVnDOjsJpx+gFB1x05GsjuOHEv6IQ0ouAWSjouNO2Cjn+VGn8YstA8UQnbGSvX
         z17w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781096944; x=1781701744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vMO+q+CyPLuQfigTmgGUaVN+qKKBldwqNdWDRJi9STE=;
        b=Zgad2vkYq5MpLghfoR+5EnMWrz2oWOnqit2saz5aJELK7EV0wBayxXZNxUZQSM81Fi
         jd96hSNa9UIh75tk5XH8RkRk7JV0Mmu3xRXW5gekGqrOGN2mXAQNQGSRqSAuA0ybUU83
         8AG8SBZCUGkHZHolVwIUnIZTFIO05Uy469hCkcG7UA8/60+r044ahABgOFBQcXy+t15b
         O44IrIiBXnxhhsP3EjrZ0/twoHCTGirLi28PDCnw0YJlxhtpR8DkVzyY/TIQSvVEL4x9
         8eajZRQJU+8wYfs9Q57ntcfOy/FNMsRpsbGvWdJatXmB9XUDUReJXkBiMQw+/pcDby+q
         Th6w==
X-Forwarded-Encrypted: i=1; AFNElJ/Ow1HAFYAv0NLQamxPvuKMvkLcdK4+tvIMpTwJ2o5h49TIWV5wUzm+qPJePYaVVhgmHisBiEbG@lists.linux.dev
X-Gm-Message-State: AOJu0YwnGWCmeAoUg0r9kGw6tIvSBw9K8hyyftrZ/Rf7R8c9wlqF8rW+
	9n6RMrPIpq1Jd06uhnyIuPIhVDWqfs8KsKVnzK34/eyp+oPzQU3UQbGuVgIfw9LfwL3pTQ22uUH
	swD6NNG1ZtHPaPsk9w0LYAABo4/Ir8zI=
X-Gm-Gg: Acq92OGOXfr8S4+ZuDrMa95ux4mSBA5lEdByI/dDH/NtnJJfootenv8f/BUuJ76VXE6
	kq1xmFhK7AVPhI5/5PYgc6ALEOR37Pw3QTnqeKzQcrV0NAAz5J1PkJj2Q0lNlqQwg02uUTkTvUZ
	7uqLtBvyXs61jDCibFlIXWY/LBzzMJXOhDSku0a34eMunBYchu2V1zOzVHYnpeBMCVTZBFbrfO9
	yLfTuQr9nlPXtqmohTjiGJ8431g0NElStVOoUGlrJB1uxjgWCZUckwL9uFf+3b451Tc7jGio7O+
	/cmdR/KwbhZlsy52WccLYSnm2NIlG+v2bAyd//cEjywqQX/Vu1p/bwCem+pH6dat5cNHkRZsLi3
	3MXBwpwydeiCiI0r/tkw7EFu2B8O733aLrg==
X-Received: by 2002:a05:7300:1352:b0:304:c73b:79ea with SMTP id
 5a478bee46e88-3077b576885mr6517116eec.3.1781096943682; Wed, 10 Jun 2026
 06:09:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260607095727.647295505@linuxfoundation.org> <20260607173214.92693-1-ojeda@kernel.org>
 <CAM0EoMkszTXv82To=KnEYTgzQSmEdRW9XrAMVtJsUaDn=Akf6A@mail.gmail.com>
 <CANiq72mJNbNzYO37VK7s=ua5v31xBrRp8EnHDvEnKF8Z77jDmA@mail.gmail.com>
 <CAM0EoMmHd10iivCpDoEd3h+eae9fSnoGWAH_AkwFhrnS6PN63g@mail.gmail.com>
 <CANiq72k6J7FYT89svtX5qbCUWg-MKuhUHaT07cjk8o7PqaF8+A@mail.gmail.com> <CAM0EoMn9EA_TS80QzXsTscBpCgfJHssq0GHtiNbrMU3FAiP2mw@mail.gmail.com>
In-Reply-To: <CAM0EoMn9EA_TS80QzXsTscBpCgfJHssq0GHtiNbrMU3FAiP2mw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 10 Jun 2026 15:08:50 +0200
X-Gm-Features: AVVi8CfHlwkVTHo8xz3kijx6SbCXBkd0w80sby_--JSQFG4p4xR4OJZ4-aRIac8
Message-ID: <CANiq72ki_YW=0UbadZ8pp0Np3Je3W6gLvAw3GJgRmzjXZ5RBVA@mail.gmail.com>
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

On Mon, Jun 8, 2026 at 10:36=E2=80=AFPM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
> I think it was too early AM here when i was looking at this.
> The answer was right there all along in what you said: The missing
> piece is commit a005fa5d7502

No worries, it happens :)

I see a005fa5d7502 is now in the release.

Cheers,
Miguel
