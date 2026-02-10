Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C1531E0FB
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 15:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770735933; cv=pass; b=RrWx8guNtBn1sACu7isSUmBaCf2rB6j9teNWKLrXIPlxj+mwr+iP5nSv0Lq1lKNlWd5Q5YTyd7RMmXBTgD0V/N1C1lkAmGSgkGtKePcmceCRPo7rtXls4RfMO70l2qarRz361uqiAdiGl9q7YX8j8yaXQKi3VnKleq5g7UUvZSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770735933; c=relaxed/simple;
	bh=lMPk2ACbC+BT7FsHdf5d3nLYVQFBs/ErPnNxK/94ca8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VJmokgl3w/a/nOcmMrjGUMsXS+DZkhJfU8a35U4yNcutpQbJVgPpWLnKah4oIcZ9gH96ZTs4pa6ZF4s8Rl5bTh618FyxGE+imbXyrx5t+oYSGT0wxHuVnmba1/M5wFZ8rtOUjEyIcg0DuOWmKtvNWu19bfgxlLLi082p/1kBc+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=s9Iyx7Ly; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="s9Iyx7Ly"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6594382a264so7806660a12.1
        for <patches@lists.linux.dev>; Tue, 10 Feb 2026 07:05:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770735931; cv=none;
        d=google.com; s=arc-20240605;
        b=E28CsccbabHNKD4FLaizPLL3buSnthmZrDb3zNBhrLR7eUQf5h2ELnTAIMUsrDPs3I
         RkGeO1vxYlSDAJsiOkJrZCDjeE3JaH+lP6IBGa4gCVT/hZCPEqrks9Kc0rD9cEBpAVmO
         1mHBwNBUL4l1EcbjFWV5aWf36PVs78UCjMCmuuNPks/5XVrW9vRnSFM0FnvLGIwPtrLl
         cUDmtq1dknleVPL9455zZUVjgoMbAM6znZ3gktpXrt+sBUZEfyVPU2vJQ0CVWmB8ykSv
         Y9nbHQAUqOZq1bJ/RkBr1lixyWJwVswoXkVZylB1VmdC/dtis1W7pA0cI0dh5fWF98Vr
         6i9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=rLtp+aeqK918GHQyzuQTcFqlRkjQRR6EBeZu1C1U4j0=;
        fh=AKW6IECEMJnEYEpvgEf2KxXflxypfWWP+y9Nr0WAsm0=;
        b=g4o4DENkj+vbI35/uzckDvxnU0YbFkaMIOUzmEL9GAky5cP+IjALsC4RiGneZPr+Nt
         95NPRLH0H+SSRej+cb1iLCkdNcgFjQCiGiqlTuZZeAEJ1ZQlSLeEOxGoedpi3Fdh/t29
         VqJ3eZHSeo0IwwpdBTAE3IZd9xh+wGgvfem79TKTOqrw3ojcoypSXZZowoxLxwqhNKQO
         TAq/7gxPQzOsgUrE6OPFNuiv13Q2XpeyW/sHKH/VdIkCHKXhCmWAK16gsGEI8IgH0tTj
         NOo5RH4Cu74e3+1YLFtpwGLzv/g7h0APZbefyR9Uj5kKWA7W62EH8tm1BgaQJz+7Bc2G
         HIuw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1770735931; x=1771340731; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rLtp+aeqK918GHQyzuQTcFqlRkjQRR6EBeZu1C1U4j0=;
        b=s9Iyx7LyZ2OV98ovBC/8ML0aYSmYYt1EXMzG1YAV54eaIeGtq/xxM8ZE4F/TYZVe4F
         tGHNfOXY8sQ/6CUUfAptroPKeqhLT0F5XrHFOe1N+U0X/ysMj6v5vgjucpq2h6cWyRtf
         obmvh8baYPVrBGGtxJFatl8oF7FGGsF37faMDcOdfT0lY/m1ew05zQrZN6LrZ8Glh5AI
         MepaVWyoYVqExi2U4k5Bcd1hYri9pf+riHQnV0JrZkAYX0FOEQI33Nk78ay2/pQ1L3mX
         LsPFbs7JX6a503/xCXNLbp6tGqi7/Z4GfXGKcuE4sW3iKVx90dwq+qn1DWYal8R8Xyer
         /WeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770735931; x=1771340731;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rLtp+aeqK918GHQyzuQTcFqlRkjQRR6EBeZu1C1U4j0=;
        b=obCnIeYKSjkn/7NK+A9L4vlWe5r7K9xDNbFDz2x+QH27WaUAIKyqZuJkCdXPDoh6Rm
         acjdW+XFhxtKGcDGlmkEacsmNUMbLGPvHZGYjwfIjqxFujIs5DfdHJnKX1m0WVQlZyxx
         K73g46f/5k91CDrIi1atYs78DCJIJJlxSViYX113Aum81NUAHP+Xg3EU596n20oAfRQc
         lU3uLh+ueoan1gcvWBuWdL8fHnN9y7rVZIzZldnc9a3vllBFrQDCz/S80+i4N/tN0wUy
         PTqVUtkhQmacFBnImODkoyTo8Ohmf8kgNQk2khs3D81QR0YN6KNhBe1GiEmg66Spd2g2
         GOQg==
X-Forwarded-Encrypted: i=1; AJvYcCUICnKpz8rw9uys46UoJ/4hfgbizRuWePmueqpKBLxZbzVreECqr9bag7lLcCj4hk8xm2jaVhSF@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4LRkkCgCh69lChVaSR81aht9GQnZiqc2NY26Dfwv7JcjOeXmH
	huls8dtef0hLZSzdmnll6KCdq282u6DbI57YPOqs68ooWsZjOZN3MwYBmPrrKD3QWTt7HvY1GAQ
	czqec0agGSiq3IjbJcvcRRyoELfnGCkQkX3Fnrxc3fg==
X-Gm-Gg: AZuq6aKZpndt3t5nJ2icJGrkHLrk4xhe3uu9Wnb9tilSLL1hHtVt5zY6tRRgc1Q7FHD
	7K/4M76VMjgB7Cxelg2VLRBHBxdQ0/x/FFetJVAY9kNOley6YAezWZNfT8qs9As5mUfC4oOduNn
	vR7AtAN45jck3M3QsEZfAgWsD1jcZIu8ifCujzI0O5Ww6hfmZyUCnY9wXfXveKFdezP2dykotjF
	HRPQqF9Bn9dLpgKDX/0GFtGLU3nx82rWyOL/ESPPIFXrWf4n9eQFQcqWiynrZp7EO/M6qkQghBF
	qsH7A6iKStHPHITPlp8YPiL+Md+35bjJz0bDCFH+FxUadJZaIYyb/paZ0bNA8oogWTVDpw==
X-Received: by 2002:a17:907:2da2:b0:b87:711f:97b9 with SMTP id
 a640c23a62f3a-b8edf2fb575mr929138166b.31.1770735930534; Tue, 10 Feb 2026
 07:05:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260209142320.474120190@linuxfoundation.org>
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Tue, 10 Feb 2026 20:34:53 +0530
X-Gm-Features: AZwV_Qj_gQ13wu0O2ImrZP1Y1_Vy7B8r-iGyvwPf5l9zCKza4knqIWsae5073_E
Message-ID: <CAG=yYwkhAAm76qUH_2dCHUp8+hGzvgT1Fm_288Z-=QRG+tAbfQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello

dmesg  stuff's ...
------------------------error----------------------------
[   21.307326] lp lp.0: really_probe: driver_sysfs_add failed
[   21.309030] kobject: kobject_add_internal failed for lp0 (error: -2
parent: printer)
------------------------error----------------------------
I DO NOT HAVE A PRINTER

--------------------------info----------------------------
[   64.066312] traps: wireplumber[1335] general protection fault
ip:7fa9701d14c2 sp:7ffec89aa4f0 error:0 in
libgobject-2.0.so.0.8600.3[174c2,7fa9701ca000+36000]
--------------------------info------------------------------

my gnome-terminal (VT)  stopped during compilation.
i forgot to get screenshot (sorry). i  started a fresh new terminal
and did sync and then   re-compilation continued typically normal.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology-
