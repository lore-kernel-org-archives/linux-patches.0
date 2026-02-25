Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77583D3481
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772038440; cv=pass; b=a52W9d7gSzNNomQjtTT3uyooXtf/vlbsEPHrfCilerHSr7Shv4Jad0vTMRfcdOj6CgcVJwtLqnqSeyWISbNJHHvuVtcBQ0RCrTGrWG6pMKi1OTkXd2xFqYgJ/id8DvdysyIuVJUTBYAX6fRdfbQ4B74ynTO4mCEkP4HF+5AOQaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772038440; c=relaxed/simple;
	bh=+jwwOMlDpF2XCSZ9kzfJ4KmiB+RpQRwJoSNMGbCFXMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hvo559jjDK1hO9wwar+YYBhpOa7lGPTKWLl+u7ukftt9Tj6BakWSISUJizkTQl7Fwyi+jzliClPpLvFixgUUubDk7uVrWo4lScOYf3ByeVBXIOe/BoQEOqB8QclRROCn4wVZyg41NTiBH6lHt+tYGqAcaZr5RtGBsQNBtPwF6is=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=TJVt72tk; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="TJVt72tk"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b8fa449e618so1094228666b.0
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 08:53:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772038438; cv=none;
        d=google.com; s=arc-20240605;
        b=ftwybgVdl21hTDIsD4WDxQ6CrQS1DI4UBmIDxhd6GSz68wXj2tlIj4hMwKU1nEugsz
         o4/xlWf3mMeF7vywqSqThpnaSwg69aXWJf9OA+ELvdeiHcplutJLUAOpj0KhBWB0HhUP
         qbCyFQKh5E1eaYkj1wO8eTumBqlTUSdjG+l/L//fqL6hIEJimuPeRdJ91nkn0JkthKgL
         taP0G67+2nTlU58qei/WX/6eRDTRB+8MPY1aQVc2LsEMe2A67NqwZYOxNrahsxAzKZpW
         LEsAiTL8368BcfFDp2W4ECmwJvSaB96S0+xkplfdpaqHFXQFoEuo6i0bU70otpI/5WQZ
         ajqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wi7RhDvs4J0GLmNN245z19usKf/YAkhKYx5CMJsLMlY=;
        fh=3PmFOYEretNzQhlLZDtqoNP6B8j85/hjHEAysaSRfvo=;
        b=My5EE9kCjPg7E5kPnNEWqEj/dDxcVVxrAtKpauNBnznsjJPDY+0lDxgFByOl+sOE6f
         GOMmShcncvhd7tR6YiyIZATXjekeQyRy8Xo2j0xAUAOWBwPYmm6XF28YQOOYQ/o/A/ij
         j1c4NRDIaCtOnSCI+Sm4IN4f9dT0wSO5izHBffPvFCtRARbxaowrvBER3C2eTbdxtgtm
         2SljFX5wfgJUeDwuFeqP9NXCc9qQWI6f232lFr6urxf+OfuDcfXMe2wbXA6qNgpPwQbv
         d4sMqE6QUhPYtB3HDLJtrwr9VnGQDB+TOeFecTutJOUqTRM8Tc1UK6i4hQ2LO/jJmTO/
         eBRw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1772038438; x=1772643238; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wi7RhDvs4J0GLmNN245z19usKf/YAkhKYx5CMJsLMlY=;
        b=TJVt72tkF5k3bAUNwf4ByovuQ+gT0jkaiVqW8gJFuQFKuQANwiw7hq3fEj/lDPN+ap
         K/GZ8OxWZ2RDldkPN2IW++rsb+26joXYpwakWazyixoVihhjkJZGG/qveyYFsYw4zhhW
         gkTQe/7iKnBSdRynfWbBEihpaRvptYO3ofFrpxaBULubTd4lBTvsSYtrAbIQ8SzeI1uj
         IfUbjwGHh+uS97T0PRWRaswF1EgKFDFQ3XiCtz+GkWqq2CEXGgmE4uWRShT4FQn8eG3d
         +R+VFMBBfWJfQgH/IIdb7avLpPvjCC2z0dFJEhuQjVtrqORo0VX1TrGIDXAtEH60qUu0
         8N0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772038438; x=1772643238;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wi7RhDvs4J0GLmNN245z19usKf/YAkhKYx5CMJsLMlY=;
        b=Q3R5WsldGuMJ3HGtem1Fayg6kvz1E3Ci6xHE28q+SA4rzH3Sm4II5dVmJfvK9Qxyi9
         CtrIsf+okMPOFZKXDWoNPPBtMOryZkT3uQ8HXSxHDEIYuiFKIf05q2WiQIs7MgiLg2lz
         MaD3kiijAdBE542bhVvBk7yk72hf5KLHRqrBnlFd4Ucl8DiJYygRgx0KOYYhuxLP/nsK
         p8dQWkWC6i1qZl8e35layYSdkOsUJtQzQ+EzqEedjwWkcvqXz/IsBADrCfbupGKt2/VX
         qwLkbr4k9HKoV2lDxgRYgv+a+r5ktM8s9G9mvwh8PFu7ISjYWOuTNs8vCIn27/QHoKjZ
         ys1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUIqEwlM058noMqZrTGBeY6wd/hiYj617+KFviTS1gxOWW7KAKeUd05mJlFinovjd6Q3DCRXrQ4@lists.linux.dev
X-Gm-Message-State: AOJu0YwG4he6BB2WIgOnGb+HYqATqwi5t2+2ntCPQrQN0fMTPCDdwE60
	PFeXdTUfMgU5lEPqgeI+b5iTEIFDnfraTs9mQ6yod0mJtQzW83qygEsy53XWa+PsWKY9+8yCNTi
	VONPw0W8ElYe5ceYiLFPxFelZpPwwp68oHqp9Su4DhQ==
X-Gm-Gg: ATEYQzz1sb985xfIXKigSNs29ghEZVkQJygkdmoT0jKHUgvCk4CbAcSd6CvvRzoxRlN
	mznFwpOX64XvH9bpFLVY5oFWN6ejABtxeMv2BY+JQLdhYqDqpOp75oTmQ6wy74+ORmvMuJtk5vn
	6rO47+61kERMDpMaaeAzr7/AZ/tEgQwCZEwiSwTqsC7mSOn3RDxxzmbCkYXbR0XD5yAJyAAYcdX
	pn1nV2RoOykFu4RSWNpieFcGDWyic+awALdTkXrY2sdpzFjHsc216OuJ+ucJ/0bon9brOPiYD4i
	2Fv9xqbaWdrD8nWiYFIkH9lhQ36NsPBtC2Oep/aqfIHI2QpXOXlPzFUhGdOCn7q89++b0dk=
X-Received: by 2002:a17:907:e105:b0:b8e:d04e:e510 with SMTP id
 a640c23a62f3a-b9081bd4308mr699613166b.55.1772038438016; Wed, 25 Feb 2026
 08:53:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260225155341.094945851@linuxfoundation.org>
In-Reply-To: <20260225155341.094945851@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 25 Feb 2026 22:23:21 +0530
X-Gm-Features: AaiRm50fFSBD47MI4HSjYIoWyJItk78BC39d7dR3JswEC-QWEai9UVWC3plMWyM
Message-ID: <CAG=yYw=0DgvXdfhEzeBYguw72gHy5R0ZiTeLZ61iy6uixKe++A@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello,

Compiled and booted  6.18.14-rc2+
No new typical dmesg regressions
.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology-
