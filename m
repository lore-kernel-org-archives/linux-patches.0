Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE88D2D7DC3
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 13:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765374243; cv=none; b=G/1Q0tKgYXH3beSEPyaQYs2jcaTmjuX1NnXHeL8tS/riWxLlSMJ3+Vw0/uhdykwCPltITzH58teob67k9Sje6Z6r3UFE2bISN4Za68rtSP/HMgFCvHnpCm7IIYk/0MwEEninCQVDABBBe+BUW+74+6rcSYujHbc+qK1nXovk5IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765374243; c=relaxed/simple;
	bh=GuM+APiDPr9e48rTQmVrItBOFGVB3BXlHw611KTw/Zo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wv8IOHffnDZweQG1Om/SmyuQrv1fXjy/QPjyo1CyxY5IO0P0csBG2KmFnUmSm7a8IuFZMEAljHWXSY8lUAU5jqIrzhe/4cDAf6ddmSWDc6HAli2+mlWku1aCEXRIWrX4mx72UPWpu8cQdqTO5MPkLVRC2u2uM2UttEVdh4NgouM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=zF7fnRLo; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="zF7fnRLo"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b713c7096f9so1031279866b.3
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 05:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1765374240; x=1765979040; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aTLaTmFVHHTzWGQ9T5qmByyocpfMgznjqq+AvfsV2LY=;
        b=zF7fnRLobkkklBLAKOnIZUJ2Q1YVyB/ETR7hOMbyDr8Z2xAovxpvAidsqfOBHLBGkK
         KJ0sQ6kZkLSCPN+hZs97x3ygVG5NlW4fKYWReAPoAAgVviAn0Nn8lIichLw673aVH4tI
         6zqW7TVlS8WMFeOlsHMwa5rLC66FafCtXjDQxL3HBCK0ENOCJXz81g+UWvNMdMFSYa4N
         eQYQEWMRaoONTdYtdSA2Xulmgc58ttteAAFVgStpD7EORZz+XZPgRJJt9ZQbVWYa9rot
         wteH3cH+dWlRwMZbRceN64GInRErN5N5TRzb7FMc7PVR63Sxx9AyvWnngIBWv+jCdN2/
         KWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765374240; x=1765979040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aTLaTmFVHHTzWGQ9T5qmByyocpfMgznjqq+AvfsV2LY=;
        b=a1v5C4ViG+wqyr7N26hH9vXpO5No9ZCMRMuDjl/YGM70ASeILDQQoDRuxZdXhEvaTW
         VWAOezppzjZRV50jbZLvULfCvGQDU6JWNjaGmZMfPpps1gxDkpFODsyjHwgFqcNOANj2
         EaO4rchdqmqTGtszie5/eAIv2reqnZziumB1QnHtwDDzcCy/Y9uXtDHOtqqPgnkvn/Rk
         Cpd8sJKq0oJCDYF2ln6sG7+OX+uxJr8/8+I6cC6wvR89yijZLC2H2tam3Ik2aVEkJQsr
         YVs96GjzSTzpLLjYd26VpFLyJ/aW+YaxhQ4RWIo+rrllBT+OA1C5Av5oN6yhQcm4pmr7
         N0bA==
X-Forwarded-Encrypted: i=1; AJvYcCWOXqnim+VfC2DsXNsqOEH6BwQ5w01QeQ62vqT4712xgFaYt60k3P3Risrax5057gKbi+IHHDsj@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8Y+s9SfFlbSG9L3kkg9VXYyjtlijb3JnYPcWWnWURP7Ugy06g
	OdzWKhgiC6Eh5NC+n3DXQRbvHZ2792DSVDmBuDg2ZuFzTTugjL+eaJ0bAqQkNPSprm4l1gaWdBS
	zE+uanlYcU+/xZ6X0mv3+LiSEwtrZEgVmzJBFLNzdUA==
X-Gm-Gg: ASbGncvcGfv6/RQLSKV3hz9AfoEvxl9t8jz0Ttqizt0yFnY6cFA82y81FZcaU5ynldC
	oNr13LIsNOm6Sz1GePR0Lrp2VC9zXW5zj+FwkPRDAlrkyVKH3599eIGv27BvFWmasgTE4wz6TXI
	E1ah9Ja21Pts9oRoyals7QuNeXsdN+XAVJku24SAk55UE312h0nWOQXunURxl6aEpm9ZT5B0msH
	N71RFbV4m3UjxWIPuyhYcJIYzcyEFbnj6H97WyiVL8che8srCYMxMCOxSo1xN5W0Nk9FlkwhhIE
	cCiX9Q==
X-Google-Smtp-Source: AGHT+IHvtVJSFJsmyCkxg0ppeP2eShf7CyJVRMpQ5SDFbZptqW8DOR5DKgVlDzllhxVIyhfcGmt25RM1UE/XUfN1RiY=
X-Received: by 2002:a17:907:6e87:b0:b73:4fd4:814f with SMTP id
 a640c23a62f3a-b7ce82ddccfmr258496066b.21.1765374240128; Wed, 10 Dec 2025
 05:44:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072947.850479903@linuxfoundation.org> <CAG=yYwm==BjqjJWtgc0+WzbiGTsKsHV3e4Lvk60fcartrrABDw@mail.gmail.com>
 <2025121046-satchel-concise-1077@gregkh>
In-Reply-To: <2025121046-satchel-concise-1077@gregkh>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 10 Dec 2025 19:13:22 +0530
X-Gm-Features: AQt7F2pb70410bF1kPgvWIQ_0HFOxEQcZ1i1TWdb6R7HcLPx6dIeqDxvlH0vD6E
Message-ID: <CAG=yYwm0bVzYoccKKcdheGOc-exuxVCPeXSftDixS68qZZ7W7w@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/60] 6.17.12-rc1 review
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

On Wed, Dec 10, 2025 at 6:17=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Dec 10, 2025 at 04:22:21PM +0530, Jeffrin Thalakkottoor wrote:
> >  compiled and booted 6.17.12-rc1+
> > Version: AMD A4-4000 APU with Radeon(tm) HD Graphics
> >
> > sudo dmesg -l errr  shows  error
> >
> > j$sudo dmesg -l err
> > [   39.915487] Error: Driver 'pcspkr' is already registered, aborting..=
.
> > $
>
> Is ths new?  if so, can you bisect?

this is new related. Previous stable release err and warn disappeared
(i think i changed  .config)

can you give me a  step by step tutorial  for git bisect


t


--=20
software engineer
rajagiri school of engineering and technology
