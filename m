Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005A036655F
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 15:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738976; cv=pass; b=oY8aC8ijbveoX1uqhEtsfpXwntokgnj6gXS5HBuWNE8UOQ+HhZqNr+NrvzXuGPnfQ6moSG7e2Vuf53u50KsAvTD1cYsXP+OxXHOiBgdxi9Mfx0TwWw1rQ9YGkijMkHhdk3hrsLrTsN6bmGvcN1InD0LlpVa6hAvDe45IQwU3VdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738976; c=relaxed/simple;
	bh=OAIEf0O+vVao9qslAHfoebqBUgeg/8PJahh0DJj5fLM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UaOk9nUfPdHwHf0knmzvaByHtqsa0UwORyv0J8VYUt4skogMt5RJ0M8wm0aAzbpLztuK4sLTJu+LMLf1dAwmiwMcV1/Mxf0iswZWyPjfklMx4Bn/1L5syV965nllqRmpV9EMvPaV8aEQmIYCI/qx8Wv3jU+sKT1bm4HACd8Irlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=ZpgGfi08; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="ZpgGfi08"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b8838339fc6so604303966b.0
        for <patches@lists.linux.dev>; Tue, 10 Feb 2026 07:56:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770738973; cv=none;
        d=google.com; s=arc-20240605;
        b=kAj3X/yDHP2EBt4f6ZiXAawaEEcductXqaW9dPEixcVGwoFpLhyRG+VZJXIKNceOsm
         VL9NbeGqZ1kq+kPapimyjXj342qhCBh/L8fARWZ243hbQelcEHDfR7rxx4PIQ1IKsPQi
         eoa4Bo6g40U9MidHbXMiz7Ng69BFZYG0XYujM5ZS0oQ84k/XQqB0Jg78yic/CaXaDjm2
         jEHL1ySnjzJ0dtWmFDRGDIbjqceF8tCd3fFFUg5d/8niTXtRvLzYK90aNQotd5x/BYqp
         aqYsKubL6aUzbUMtqT79pwb5I96Aw+03alzPT4/KwqQF3unj5diDH25EWiVSQ3mCz2cJ
         pdsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RHNM3wxM8gq7b7JGa1HDs6bGHDU6U4Hwkp51bCUb8F8=;
        fh=6c0r7G0qLu5S727PCp5galEwIIiVZEu3dZ0yUH3l1RQ=;
        b=OBf5C1z/PRTIW42ywSXsqLn7w0BJudKBe3Fip04TnGFrOfww/swjcvqW2sECoLY2a4
         mHphsJHYLS5Pox1W1JhY3wNCFxVwp8enDosrkvaRla6z6ZgxqcV9XG9EtysMZ3JipKkt
         xdPr+Cccc2BpgX5dSFGJ754GF4wZIf3ZiU+kBF+srea5x+u3u2RjZ8Ch0kiuAadd9NOF
         xL+3GCl6GdtOffuDr/0b1PDw9BJzO2J6hY4fviNaiq2oamgnFdnEBZteRVHTeB/L1ccl
         ITFaVVSTSEMwYeH+tC7qQpqvLAruIakjTb6UVbinj+AUubVTvtrJ/nygZ3AM0e2bBJpl
         Zqcg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1770738973; x=1771343773; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RHNM3wxM8gq7b7JGa1HDs6bGHDU6U4Hwkp51bCUb8F8=;
        b=ZpgGfi08yFgvHsm605x6tBFcL9iaeg1p2BDH7FhcKXrzcymVoHWmPrIxSO9jYj3m15
         I8K0nco79X3GtGQvMWbg4M+eZsNm2ja8My/ckm3pN3Lne4wasR5rsqQOeRVFuCgUONJ1
         pj7bBlB6Vjv2eMM5T9OCs5cW6Pbd9OBOkXWOl/3dqVBKVwocF0funrAKGIz4QcBCiJP4
         7TdY9DUx8Z/TiJB+TFZ6dhoykotiFqZ/9ofQ1COFRNgDue6s/7ti1mNwBmbcuta8Exfp
         r5YNn8W1SWQRP3MIx+co/NJkdyHUU+4BY3aQ1cbBgItkA4n3AZjzqqBiyatsTxVIGIQ/
         /CVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770738973; x=1771343773;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RHNM3wxM8gq7b7JGa1HDs6bGHDU6U4Hwkp51bCUb8F8=;
        b=uBhg+ZmdKCKAp/Nla6J2QBxa7ir54lP+5SdkupaeGWf7VI7ucmISBdBSsfcG66Ig3f
         pcOO5Emax9bY2NIcVKNgSCnz+rhE+SXGqlsuI0A9gpTFkARNRY0yqQ3FLpYKXw9y0kJK
         mjzarrL4jWkEGH68XaImh+j6CfJLdViWdTpexAAIkrX447H+Oil1ndSAlfVgUKoepfNs
         q+yDeWnvdds6WbV8meWmKy78KWydu7ebT1zKtGSLbuxXMsaVmZc8yM2xz9GTdOxR0UyJ
         NgeS3g4zm06zT+E2m0UsnVV3UqDuP0lGcWLNhRP1jByYEXT3mmhPUrNyNHnBz5MX3UQn
         /F3A==
X-Forwarded-Encrypted: i=1; AJvYcCUWTIJo8lqU/KIkr+hPEq43lr/2oYcsHd6GG0A/lXQOcFy+X35CXFw7nUKKwDi4vrDFuW35LmnJ@lists.linux.dev
X-Gm-Message-State: AOJu0YySbVssXCcEwhXaNFxkbpQD2huWdCKMVndr7tI/UiTujvJU64oE
	x7SI12UpO3tlghSO/wSU5k74wO6qbuS8dFcGN32miiu45hPlWmyO0AeJHO2LqnlqZGCgorzlA//
	xs+2GIKAIcepFhhs/OM8qA8OhIIsgctgNdNk7XsmvGg==
X-Gm-Gg: AZuq6aKtkMJ4uv2wdtia0cJf0N2h6obzY12SpKNzavaee7LCG2n+fkCvjs5RnI0Po5R
	JVjQ8bFfKhJTk8AHpowJ5nId4dvZ1sMkBTWF0nhyGpbWi4ZITP9gRtCXcnEErkKJEe2l4omldtU
	MHXBl5MLD7tGV24XJ5L9a8CBXzJQJ+61BJGkfBybaXZdu2s4c7X2na3xrRjxIak4+4HixKQJ4ox
	yz4TnYQWPN8em1/RUTHpD2R3Af5/RW0YhVT9JdDq4WplqEe3pWcjfRLmlLMOo0RdkVs+JeRHyQN
	ROXWETI24l3gOjYqDR+8dnOJrKANYK0pr1M4kyP4K2wapOjiqsaRZpyvxbG34LeNy9FzaQ==
X-Received: by 2002:a17:907:968f:b0:b88:23f5:3cfa with SMTP id
 a640c23a62f3a-b8f50cba6c5mr174846866b.31.1770738973279; Tue, 10 Feb 2026
 07:56:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260209142310.204833231@linuxfoundation.org>
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Tue, 10 Feb 2026 21:25:36 +0530
X-Gm-Features: AZwV_QgUraP5QxouttC8DAmvBsk5r6YbfdwZIJudFIlSp0DiJPGvGCnq-Z06DDA
Message-ID: <CAG=yYwmDgTBF89qwFTYzohZGoypkETQ6n29CXqVzoO4vxTNp6w@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/113] 6.12.70-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello ,

dmesg Stuff...

----------------info---------------------------'
[   37.458874] evm: overlay not supported
-------------------info-----------------------

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
