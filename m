Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17818350A28
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 14:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765983298; cv=none; b=FJIRUlGP/fTd3EvpmpUW8IskykOm/UAddr7vtZ+xuLD6SZ/3ELotB9hBIFIDhTmogkVMsbTaKfPD5VaQ4bEj8oTbAM/kCarAAPtal3huaOEz5sKbKyDBooUfDRUZrGMGTbtmOfaxNUiWWskVUHgkgHDS4jNmzfjQD2UcGswc2Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765983298; c=relaxed/simple;
	bh=g6/no6anHRF3lgCDA4udXS7+7QbtWUA3YYAC/yXuZgw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rCfUe16ezgbH0E1tGaJwmYN332GC6Jwrn5ninTeQPxpbrK4zbVGWUZvkKD3KXNBC5F4YpWZkjr/DTbi+/1CV76Rc6tezJtT7D/g7FH/976nayZrWlGI22XmPzTXZodN9crJUKQVM/q57yTchwK8NIIu5sIBouFC8x1YQwrD7WRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=sq26NvwW; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="sq26NvwW"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6496a8dc5a7so7963399a12.2
        for <patches@lists.linux.dev>; Wed, 17 Dec 2025 06:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1765983293; x=1766588093; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pInPbMZU9Fx3oRHAyhV5hvN/3O3SpwSKQXfDb0tMMX0=;
        b=sq26NvwWpcLRXB5C0XMYBUR743txRKinp+uD9bypVgBpMfiePx9NdXarRcd0q/fccp
         R0nDe6Plt3DOsdI1MhOwqdZQu3IsLBXx78+arjbGtoQFS/RzB6A5A43K42xb2pF6LrdC
         aguElVOkW7AsPHpEPeVn2RUU/KFkK26nYAe3PJ44xrg9xWeY9S4fpi/RTS04OcPQxpUj
         xdLLq1qCjr6phE1KxmAB8bllTVTww4A7rvLF7s2eDF2zROROXmkhzkvoSA/M1jvjVWq3
         XU9/Wyrc8++kOuXlqSpLaVhWSyDEhQIBf5YFGNhX7b4LDTPQL8eVLiblLJVChONl7lef
         ZxcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765983293; x=1766588093;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pInPbMZU9Fx3oRHAyhV5hvN/3O3SpwSKQXfDb0tMMX0=;
        b=iyiGS3vBp5g0glRdwNiGJLE2yzaY/kAaOE5+IwZ7mRdMjpvQzdUObvN/YZyosV12T+
         Mwavl+UDKpxjNjiqJJkJcrLi13yKxtaEmKNwYmUKe8sRBDJ/OjKV6py7EvgriTZDrdjH
         /Vz4a6C3iomZsIQ3+9EnqFVdj3N2uGYLwjMaEJqMxONl4p8/m6CXVdb51WQZ7i7XRvmO
         DJybvj0vSJDXdPgpRmmLd80e1yR7lThstxShjDh0a1DsP7N+kszp2iO6OhhS1k3dUv3E
         BHqeDjpBRw8yWg46BxhUZ+sJkQueYWHn6MftWHDKMrOnMxqIQCCR1iosP+LrEyBV0Fxj
         sygA==
X-Forwarded-Encrypted: i=1; AJvYcCXvlnV+5e81kBo/lCzoDtvIUSn7zFIU5QBVf+xq9xcNDl3fHrHlrS+dl5ZlS6Mby3wvj5l8RZAf@lists.linux.dev
X-Gm-Message-State: AOJu0Ywx1en2I9e2uqUQ+h+zoAyylHvioW+K7Df3pcwvE7U1J+DBluFy
	Qd143uu9HLCYj+AS9kZGp6MkPsjIe3usjS50uHTD8y9+8Bw1McSCcTFiAri02erpkFzjrz5fWJH
	MlU+hN16uqWrtWC0TkGj75kmdaL4vJZA3BuqKwAd83g==
X-Gm-Gg: AY/fxX5QCq+mMh9/c+m0UEg9YhbUNSEXLgHFqsr7OdZuCfhXgSx0RUH0UPEKYIM61oT
	A/jZD9nYPHbpHk1loyCIU6OQ5296RFbmr9zLa1yN/I/OWLEuLuF+z3M1KB1O7/cUqp7tO8GMiPI
	A5nSmvwFQL+d1rkEcrwJjoxXnBykF4gbEmWvcSjx/hX8YGaQsNg9Yp0zRpc1nQoZVIFDwZNSbvi
	XFLw55BeHtiQFxCiAKEznf47it5N+PqPU0oennvDgdgs/loMvQ7VOPkV/rT7FXbccfuUbRO
X-Google-Smtp-Source: AGHT+IEDhoB1iBKfs5vm3/J00wo8il4igp+uCMttwb/ZWLlcjAmzCZg4gkakB/Rt0mnzKz0uzI8xOT86iUQMfs+4m0U=
X-Received: by 2002:a17:906:730a:b0:b04:32ff:5d3a with SMTP id
 a640c23a62f3a-b7d2321f5d6mr1929697066b.0.1765983292936; Wed, 17 Dec 2025
 06:54:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251216111947.723989795@linuxfoundation.org> <CAG=yYwnv+EsEhOSUFFFGQYm6MXzDFzPKq=pp+wk2J5rvLupoQQ@mail.gmail.com>
In-Reply-To: <CAG=yYwnv+EsEhOSUFFFGQYm6MXzDFzPKq=pp+wk2J5rvLupoQQ@mail.gmail.com>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 17 Dec 2025 20:24:15 +0530
X-Gm-Features: AQt7F2qTROv9nYYvdZUtM_jmj-g8AF6D4GfRC4SyQ4qPY-C7XWgSq_nm5D2LE98
Message-ID: <CAG=yYwkuq=WCGMqYcuWh5eHuVY5rUFWRtbZKgcUb1Eg1GxgM3w@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/506] 6.17.13-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: multipart/mixed; boundary="000000000000db242d0646270637"

--000000000000db242d0646270637
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 1:09=E2=80=AFPM Jeffrin Thalakkottoor
<jeffrin@rajagiritech.edu.in> wrote:
>
> hello
>
> Compiled and booted  6.17.13-rc2+
>
> dmesg shows error...  file attached
>
> As per dmidecode command.
> Version: AMD Ryzen 3 3250U with Radeon Graphics
>
> Processor Information
>         Socket Designation: FP5
>         Type: Central Processor
>         Family: Zen
>         Manufacturer: Advanced Micro Devices, Inc.
>         ID: 81 0F 81 00 FF FB 8B 17
>         Signature: Family 23, Model 24, Stepping 1
>
> Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

i  have done a  git bisect  and the log is attached.
THANKS


--=20
software engineer
rajagiri school of engineering and technology

--000000000000db242d0646270637
Content-Type: text/plain; charset="US-ASCII"; name="git-bisect-log.txt"
Content-Disposition: attachment; filename="git-bisect-log.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mja4t20z0>
X-Attachment-Id: f_mja4t20z0

Z2l0IGJpc2VjdCBzdGFydAojIHN0YXR1czogd2FpdGluZyBmb3IgYm90aCBnb29kIGFuZCBiYWQg
Y29tbWl0cwojIGJhZDogW2Y4OWM3MmE1MzJiNTA3MTExYWNmZTFiODNmZjQ4NTVkYzY3NzIwNDNd
IExpbnV4IDYuMTcuMTMtcmMyCmdpdCBiaXNlY3QgYmFkIGY4OWM3MmE1MzJiNTA3MTExYWNmZTFi
ODNmZjQ4NTVkYzY3NzIwNDMKIyBzdGF0dXM6IHdhaXRpbmcgZm9yIGdvb2QgY29tbWl0KHMpLCBi
YWQgY29tbWl0IGtub3duCiMgZ29vZDogWzZmZWRiNTE1ZTdmOTA5ODZkYTNkZTM2YTM1NzUyZTZk
YzJlMGM5MTFdIExpbnV4IDYuMTcuMTIKZ2l0IGJpc2VjdCBnb29kIDZmZWRiNTE1ZTdmOTA5ODZk
YTNkZTM2YTM1NzUyZTZkYzJlMGM5MTEKIyBnb29kOiBbNmZlZGI1MTVlN2Y5MDk4NmRhM2RlMzZh
MzU3NTJlNmRjMmUwYzkxMV0gTGludXggNi4xNy4xMgpnaXQgYmlzZWN0IGdvb2QgNmZlZGI1MTVl
N2Y5MDk4NmRhM2RlMzZhMzU3NTJlNmRjMmUwYzkxMQojIGdvb2Q6IFtiZWYyMzkwMzc5ZTU2ZDQ0
ZTVmZWQ1NDAwYmJhMmY2YzI0ODZjZDZjXSB0cmFjZWZzOiBmaXggYSBsZWFrIGluIGV2ZW50ZnNf
Y3JlYXRlX2V2ZW50c19kaXIoKQpnaXQgYmlzZWN0IGdvb2QgYmVmMjM5MDM3OWU1NmQ0NGU1ZmVk
NTQwMGJiYTJmNmMyNDg2Y2Q2YwojIGdvb2Q6IFsxNmJlNDVmYTI3NGJlZWZiYTM0YTI1ZGEzNTUx
Mjc2YjlmYjQ4MzgyXSB2aG9zdDogRml4IGt0aHJlYWQgd29ya2VyIGNncm91cCBmYWlsdXJlIGhh
bmRsaW5nCmdpdCBiaXNlY3QgZ29vZCAxNmJlNDVmYTI3NGJlZWZiYTM0YTI1ZGEzNTUxMjc2Yjlm
YjQ4MzgyCiMgZ29vZDogWzNlNjE5OTY0NDM5MzM0YzIzYzA3OWZmMzk4NmZkNjJkOTRkOGM4NDJd
IE5GUzogSW5pdGlhbGlzZSB2ZXJpZmllcnMgZm9yIHZpc2libGUgZGVudHJpZXMgaW4gX25mczRf
b3Blbl9hbmRfZ2V0X3N0YXRlCmdpdCBiaXNlY3QgZ29vZCAzZTYxOTk2NDQzOTMzNGMyM2MwNzlm
ZjM5ODZmZDYyZDk0ZDhjODQyCiMgZ29vZDogWzk3ODZjMmU1OGM0MmRlMTU5MDY3ZmEzYWU3YTVi
MWUwMjliZGNhYjFdIHJ0YzogZ2FtZWN1YmU6IENoZWNrIHRoZSByZXR1cm4gdmFsdWUgb2YgaW9y
ZW1hcCgpCmdpdCBiaXNlY3QgZ29vZCA5Nzg2YzJlNThjNDJkZTE1OTA2N2ZhM2FlN2E1YjFlMDI5
YmRjYWIxCiMgZ29vZDogWzk2YjQ4ODc4MDQzNjIwYjA2ZTc0ZjVlNDM1ZjBjYWYxNjEwNWRiOGRd
IHNjc2k6IGltbTogRml4IHVzZS1hZnRlci1mcmVlIGJ1ZyBjYXVzZWQgYnkgdW5maW5pc2hlZCBk
ZWxheWVkIHdvcmsKZ2l0IGJpc2VjdCBnb29kIDk2YjQ4ODc4MDQzNjIwYjA2ZTc0ZjVlNDM1ZjBj
YWYxNjEwNWRiOGQKIyBnb29kOiBbMjk5ZjA1MDc1ZGZlMDAyMTU2YmJjNDZiYTdkYTJhODkzNTdm
ZTk0Zl0gdXNiOiBwaHk6IEluaXRpYWxpemUgc3RydWN0IHVzYl9waHkgbGlzdF9oZWFkCmdpdCBi
aXNlY3QgZ29vZCAyOTlmMDUwNzVkZmUwMDIxNTZiYmM0NmJhN2RhMmE4OTM1N2ZlOTRmCiMgZ29v
ZDogWzBlY2ZiNDU4YmFlODllN2NjMmNlY2E1Nzg0MDVhMDE0YTcwOTBjMzNdIEFMU0E6IGhkYS9y
ZWFsdGVrOiBBZGQgbWF0Y2ggZm9yIEFTVVMgWGJveCBBbGx5IHByb2plY3RzCmdpdCBiaXNlY3Qg
Z29vZCAwZWNmYjQ1OGJhZTg5ZTdjYzJjZWNhNTc4NDA1YTAxNGE3MDkwYzMzCiMgZ29vZDogWzI1
YjExMDBjYjlmZjBkY2JkNzI2M2FiNTdmY2VkZTY3M2JlMGVjYzRdIEFMU0E6IGhkYTogY3MzNWw0
MTogRml4IE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBpbiBjczM1bDQxX2hkYV9yZWFkX2FjcGko
KQpnaXQgYmlzZWN0IGdvb2QgMjViMTEwMGNiOWZmMGRjYmQ3MjYzYWI1N2ZjZWRlNjczYmUwZWNj
NAojIGdvb2Q6IFs1ZjBiYzVkMWQ4OTJlN2JkMjhkYWI3NDNjOWU4ZGNlMmI2NTk2ZmJjXSBBTFNB
OiB3YXZlZnJvbnQ6IEZpeCBpbnRlZ2VyIG92ZXJmbG93IGluIHNhbXBsZSBzaXplIHZhbGlkYXRp
b24KZ2l0IGJpc2VjdCBnb29kIDVmMGJjNWQxZDg5MmU3YmQyOGRhYjc0M2M5ZThkY2UyYjY1OTZm
YmMKIyBmaXJzdCBiYWQgY29tbWl0OiBbZjg5YzcyYTUzMmI1MDcxMTFhY2ZlMWI4M2ZmNDg1NWRj
Njc3MjA0M10gTGludXggNi4xNy4xMy1yYzIK
--000000000000db242d0646270637--
