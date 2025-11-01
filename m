Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937B125A2AE
	for <patches@lists.linux.dev>; Sat,  1 Nov 2025 09:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761991035; cv=none; b=MlxK9Ogql1YBdQLFu47HNRb6hgS0GT5yZv2x+OgIlzDv8i9LADn4g1HF6w9uLd48W9yBayD8hdltq/PUC7e1gJ9e1+TGCt83Hw5SEZogFBmcleoAcRggEqmvy4wT0IH6qUWTlwY+OaydSTUPC6Li9P05I7cGR1PJT+3padiMTkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761991035; c=relaxed/simple;
	bh=EZYP2ZGqpOgoKSADv8CU64QeuXYdH8H9uMcFqy7wW8c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NM6Y1K8yWwqt+TmvMKmE/YnxLx0R+WsxHojn6jH4rB+HNeCoBeAiU/SsStlYalZH/k46u1VOqlFvD8HTCSTxCIucU48SzjrW2S3TeNPJxmf8WKGdUzYWUAfCokCwDGBGBapzZmYgn97xrXnClsGXsA5Ulfy2tktlt6uUghW9uqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=EBgqnMye; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="EBgqnMye"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b6d70df0851so593985566b.1
        for <patches@lists.linux.dev>; Sat, 01 Nov 2025 02:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1761991030; x=1762595830; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGFt2XQpdp9rBNdBCSOgkWHGSVJBimii0ao4cHcHnEE=;
        b=EBgqnMye0VVQBKAvLRFEPCFDM6svWEVUoPeH8cSWLeiI/KbXo2Oliv61mH4t85Ddx3
         ML1sOxgypBvO10m58iMlpMe4yHwhOFo0L9Fu6RJRnWHC5//YLrf+IKrNnHe5l1YoWXkb
         56h4kJdhIRQPCzPyeMDgitSVcvY9Q1MHd6mYCdhwb6hOr2yoWc5lMEX6QxmseCMR0u71
         lNI97lVcIq4jpZ+obPaNn6z6IypTMM0OWHXD1WWTNMwWykIEteL7unDWcW0uSGQL7Stl
         b3Eitjv3bwSAw9UzsRtS9l6LJBZJIUUmberiAyTj+ZoKLWLlYk2/pcB4jkQlbCHkc16/
         MFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761991030; x=1762595830;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGFt2XQpdp9rBNdBCSOgkWHGSVJBimii0ao4cHcHnEE=;
        b=cYLmtfz2yJu73E1ia7pgq4OBoFnLnd0F3YwoB6CiDm9QtFpHyi+28dyfSV69zl22XS
         zsS6xvKYog97CqDmo/DzVPFtLYl3+aUp4LCYA0OqKH7EvfIGiKiXrjJciZnzEGtac849
         CoEovREt2vhjSgtNrue6qN3lCdps8Q401uBh1GbAnBZAQAEb+yYFoK6LgKRPCyUkjuSG
         iEOy9dd+qZEoXop4gvB268ukSfPbZzyFAmAb08hJqv4bScD3zRV1zyd/A5Nu8sgVw+bP
         +c3MtrQ+bI+CHT8boy/yj6rrXugwbugzruDEfHcViSnniiV14/w+2Y6FuA9vQvfZBgw9
         NDGw==
X-Forwarded-Encrypted: i=1; AJvYcCX7W0yhJDM/QOSatH/6c+P7xgiZ2ExLBa3Mon+6R4fFOfwvxWIl5P2CvR2PAoLRJ+W79mGcOiI1@lists.linux.dev
X-Gm-Message-State: AOJu0YxHFNG1XaMlqEbFuHMJCQ+B/Wj5F2Gsl/J3U/1RPftL2g1WVQId
	t0jPe69RzY0B6zRksqDAjQTavy7DOnBDS8j7kCM+4xj85njg/S9n7vWBPW7V4J9YLTuyE4YSHG6
	CV8Af82iUKESButBEMqNm/XCO7jUEDcW7H6Wavr1RQA==
X-Gm-Gg: ASbGnctD+eineUQZ081XkJRK9sBqCV3zIoFfnd9n6nheZQQrwtooxsRD6vie4bpI76R
	WfVSSsAQKXLSxsgneq9nLjr72As4fKzkwV3ntq+pFy9YxbvgqQWXEjBiRKeHKcIFK8oPwBvr+mL
	MuAGlGBxeIACmb+WhcHwi9OzKAqQ9YfU6efixrRqCNQryTLnrnvv7TaFYCz4UqDOkYfs2DKG9gH
	i84G4amFiUpfhtUmb1U/gGnyK57dV2LvawHDNQZgfWOW7zJSzSVz85WyFj6VA1ZC0O+4gvF
X-Google-Smtp-Source: AGHT+IGs4uAX3yencgx0/XZuSpz5r9hsMQdALphD2vGQGD03EeAm6F6Xe1h2PTXFJBtX+prIK2L0qcVEIjfa4HGQf4Y=
X-Received: by 2002:a17:906:9fc4:b0:b6d:a7ad:2fda with SMTP id
 a640c23a62f3a-b70700b5861mr718340266b.12.1761991029382; Sat, 01 Nov 2025
 02:57:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251031140043.564670400@linuxfoundation.org>
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sat, 1 Nov 2025 15:26:31 +0530
X-Gm-Features: AWmQ_bmibL6tpkqJQn24nQT7RZtlAq2etQdeb3xjOE_tEFUjo2XhoVmekwL8ago
Message-ID: <CAG=yYwkDgbkvR0JD4ihRHsPPd1a6oZLaYn+E_0qPKFo6Ugy__A@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/35] 6.17.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	lkml <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, 
	Shuah Khan <shuah@kernel.org>, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	Pavel Machek <pavel@denx.de>, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: multipart/mixed; boundary="00000000000067ab4e06428581f3"

--00000000000067ab4e06428581f3
Content-Type: text/plain; charset="UTF-8"

compiled and  booted  6.17.7-rc1+
dmesg -l warn  shows some,
file   attached

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


-- 
software  engineer
rajagiri school of engineering and technology

--00000000000067ab4e06428581f3
Content-Type: text/plain; charset="US-ASCII"; name="dmesg-warn.txt"
Content-Disposition: attachment; filename="dmesg-warn.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mhg3x5060>
X-Attachment-Id: f_mhg3x5060

WyAgICAwLjI0NTYxNV0gVk1TQ0FQRTogU01UIG9uLCBTVElCUCBpcyByZXF1aXJlZCBmb3IgZnVs
bCBwcm90ZWN0aW9uLiBTZWUgaHR0cHM6Ly93d3cua2VybmVsLm9yZy9kb2MvaHRtbC9sYXRlc3Qv
YWRtaW4tZ3VpZGUvaHctdnVsbi92bXNjYXBlLmh0bWwgZm9yIG1vcmUgZGV0YWlscy4KWyAgICAw
LjU3MzQyOV0gQ291bGQgbm90IHJldHJpZXZlIHBlcmYgY291bnRlcnMgKC0xOSkKWyAgICAwLjY0
NTczMl0gaTgwNDI6IFBOUDogUFMvMiBhcHBlYXJzIHRvIGhhdmUgQVVYIHBvcnQgZGlzYWJsZWQs
IGlmIHRoaXMgaXMgaW5jb3JyZWN0IHBsZWFzZSBib290IHdpdGggaTgwNDIubm9wbnAKWyAgIDE1
LjY1ODM2Nl0gYW1kZ3B1IDAwMDA6MDQ6MDAuMDogYW1kZ3B1OiBmYWlsZWQgdG8gbG9hZCB1Y29k
ZSBSTENfUkVTVE9SRV9MSVNUX0NOVEwoMHgyOSkgClsgICAxNS42NTgzNzBdIGFtZGdwdSAwMDAw
OjA0OjAwLjA6IGFtZGdwdTogcHNwIGdmeCBjb21tYW5kIExPQURfSVBfRlcoMHg2KSBmYWlsZWQg
YW5kIHJlc3BvbnNlIHN0YXR1cyBpcyAoMHhGRkZGMzAwRikKWyAgIDE1LjY1ODkwM10gYW1kZ3B1
IDAwMDA6MDQ6MDAuMDogYW1kZ3B1OiBmYWlsZWQgdG8gbG9hZCB1Y29kZSBSTENfUkVTVE9SRV9M
SVNUX0dQTV9NRU0oMHgyQSkgClsgICAxNS42NTg5MDddIGFtZGdwdSAwMDAwOjA0OjAwLjA6IGFt
ZGdwdTogcHNwIGdmeCBjb21tYW5kIExPQURfSVBfRlcoMHg2KSBmYWlsZWQgYW5kIHJlc3BvbnNl
IHN0YXR1cyBpcyAoMHhGRkZGMDAwRikKWyAgIDE1LjY1OTQzOV0gYW1kZ3B1IDAwMDA6MDQ6MDAu
MDogYW1kZ3B1OiBmYWlsZWQgdG8gbG9hZCB1Y29kZSBSTENfUkVTVE9SRV9MSVNUX1NSTV9NRU0o
MHgyQikgClsgICAxNS42NTk0NDJdIGFtZGdwdSAwMDAwOjA0OjAwLjA6IGFtZGdwdTogcHNwIGdm
eCBjb21tYW5kIExPQURfSVBfRlcoMHg2KSBmYWlsZWQgYW5kIHJlc3BvbnNlIHN0YXR1cyBpcyAo
MHhGRkZGMDAwRikKWyAgIDE4Ljk5NzM5MF0gc3lzdGVtZC1zeXN2LWdlbmVyYXRvclszMzFdOiBT
eXNWIHNlcnZpY2UgJy9ldGMvaW5pdC5kL2xwZCcgbGFja3MgYSBuYXRpdmUgc3lzdGVtZCB1bml0
IGZpbGUsIGF1dG9tYXRpY2FsbHkgZ2VuZXJhdGluZyBhIHVuaXQgZmlsZSBmb3IgY29tcGF0aWJp
bGl0eS4KWyAgIDE4Ljk5NzM5N10gc3lzdGVtZC1zeXN2LWdlbmVyYXRvclszMzFdOiBQbGVhc2Ug
dXBkYXRlIHBhY2thZ2UgdG8gaW5jbHVkZSBhIG5hdGl2ZSBzeXN0ZW1kIHVuaXQgZmlsZS4KWyAg
IDE4Ljk5NzQwMF0gc3lzdGVtZC1zeXN2LWdlbmVyYXRvclszMzFdOiAhIFRoaXMgY29tcGF0aWJp
bGl0eSBsb2dpYyBpcyBkZXByZWNhdGVkLCBleHBlY3QgcmVtb3ZhbCBzb29uLiAhClsgICAxOC45
OTkyNzRdIHN5c3RlbWQtc3lzdi1nZW5lcmF0b3JbMzMxXTogU3lzViBzZXJ2aWNlICcvZXRjL2lu
aXQuZC9saWdodGRtJyBsYWNrcyBhIG5hdGl2ZSBzeXN0ZW1kIHVuaXQgZmlsZSwgYXV0b21hdGlj
YWxseSBnZW5lcmF0aW5nIGEgdW5pdCBmaWxlIGZvciBjb21wYXRpYmlsaXR5LgpbICAgMTguOTk5
Mjc5XSBzeXN0ZW1kLXN5c3YtZ2VuZXJhdG9yWzMzMV06IFBsZWFzZSB1cGRhdGUgcGFja2FnZSB0
byBpbmNsdWRlIGEgbmF0aXZlIHN5c3RlbWQgdW5pdCBmaWxlLgpbICAgMTguOTk5MjgxXSBzeXN0
ZW1kLXN5c3YtZ2VuZXJhdG9yWzMzMV06ICEgVGhpcyBjb21wYXRpYmlsaXR5IGxvZ2ljIGlzIGRl
cHJlY2F0ZWQsIGV4cGVjdCByZW1vdmFsIHNvb24uICEKWyAgIDE5LjAwNDExMV0gc3lzdGVtZC1z
eXN2LWdlbmVyYXRvclszMzFdOiBTeXNWIHNlcnZpY2UgJy9ldGMvaW5pdC5kL2ZldGNobWFpbCcg
bGFja3MgYSBuYXRpdmUgc3lzdGVtZCB1bml0IGZpbGUsIGF1dG9tYXRpY2FsbHkgZ2VuZXJhdGlu
ZyBhIHVuaXQgZmlsZSBmb3IgY29tcGF0aWJpbGl0eS4KWyAgIDE5LjAwNDExNl0gc3lzdGVtZC1z
eXN2LWdlbmVyYXRvclszMzFdOiBQbGVhc2UgdXBkYXRlIHBhY2thZ2UgdG8gaW5jbHVkZSBhIG5h
dGl2ZSBzeXN0ZW1kIHVuaXQgZmlsZS4KWyAgIDE5LjAwNDExOV0gc3lzdGVtZC1zeXN2LWdlbmVy
YXRvclszMzFdOiAhIFRoaXMgY29tcGF0aWJpbGl0eSBsb2dpYyBpcyBkZXByZWNhdGVkLCBleHBl
Y3QgcmVtb3ZhbCBzb29uLiAhClsgICAyNC40NjM5OTldIG52bWUgbnZtZTA6IHVzaW5nIHVuY2hl
Y2tlZCBkYXRhIGJ1ZmZlcgpbICAgMjguMTc0OTc5XSBrYXVkaXRkX3ByaW50a19za2I6IDEyNiBj
YWxsYmFja3Mgc3VwcHJlc3NlZAo=
--00000000000067ab4e06428581f3--
