Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D02F1AA781
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 20:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736368633; cv=none; b=MGbFwnkflsN6MGa1pHCnA7zn2uUyUBZaQv7LiLVrAD2ieyllOBgPvFXSdx5qALDVI/q7cNDRAA+hJzH1ByUU6+5k8JLUhXHbvk2lHvkDJGwIdt/kXlHj3HlcoWc+14cT98WsFMxAZgHyW0dY3LAW1tD+cS0dseAhvGHY5nLpOX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736368633; c=relaxed/simple;
	bh=FoCj2wZOlXVxbzmakk66/ByIg+IO7g/sdeHyyuKYxGk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QhMa67rzIoWqfYwkArC9zJzrihnQ1TbGsBeRQJjXxXc33mXuGKMTIENYa7VQetdEoQpnLEKaM8OlOHEpojGxzM61QLnkpOeoMXCsIQ4szuyP2oUY1r5qplxkDm3Ld/LbK/vdW2uAPUSQivXNIF5mDQC+3BhW0K5BDRg5Kmsrrac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Za/4viTI; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Za/4viTI"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-436202dd7f6so3159625e9.0
        for <patches@lists.linux.dev>; Wed, 08 Jan 2025 12:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736368630; x=1736973430; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FoCj2wZOlXVxbzmakk66/ByIg+IO7g/sdeHyyuKYxGk=;
        b=Za/4viTIiBzXJDBqyH7kt6amTPfS74wo2RY8LUqgdViWOm4poC8Kemjn2rQ+2lZza7
         TXMHAh8q+++GGqLI4B5wXupcbkL41zm4GDSgWepolTXR1s2Hu0HI42tnX1sRUnJK8Bwe
         xQqEzociTtL2dbhOBvy7VGBTbwbkHMK/gM4MIpa6JKksI1wDrAOEHVg51HdrKhjJla6q
         /ebLeWIey+YWZff5TgMUwHtpDEHDIRLP2wO4rA8ZhQti4cCQ2W5lNEKun4YzxVos6Z3h
         YoadVw80WuagjFKEAEC28DTX2rhd0bSIgt+QNKQI37ri0BV97o38lEarSulTTRbXWsde
         2iXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736368630; x=1736973430;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FoCj2wZOlXVxbzmakk66/ByIg+IO7g/sdeHyyuKYxGk=;
        b=c5P1ETHOwZuNzgQuQ+rlEWN3NkFOpOqvmwCC5NsmRoma/S/N7ITQX1AwqudTGxEiCE
         qVkZRtgN6ROl/j0YW73fYLyyu3N1h/MtB/4CzMp1gwHvTGxhMioa9jNeAJDUqtasinN5
         899IMfu67ML+I6CcrV4QTZxtN8v9NSRTeachjGHqZaYzQH0aBjSCLwKm0O5GdoQq9gCv
         3Af/KPfECXd1BBSXwChIwzpp2GF7e7rNGYwatfxt3VPCkkbeWxSLrBDpZWiEJlCUjmWs
         XlIoVChUwmeC0o7RpMCGzVsb/87OxU3C+5uAmkb/+FfAU4LtET7Xi1PXICE5Jf6bs3uS
         D4VA==
X-Forwarded-Encrypted: i=1; AJvYcCW39akk6DaP+zOlC3V96IQsgz8OY3sjV14aMAoyg0JOKEJ0MszyI0pk9ezeklhToROPzf3VoQ/f@lists.linux.dev
X-Gm-Message-State: AOJu0Yy++xNEG5KFXvFZMXzuON1cRsfCspOVilS6rEyymTD/nONXZxwh
	5B50+CwMlyDNPK9xaEc0r0/bKP71T2db6t9fjzlKZ42uMZmyDaAJ4csBRkRpLYTVas9pW9T3v8H
	j
X-Gm-Gg: ASbGncsqHr/spsdENy/h7VA2+YYWgH+l8uloLog7l2JbqlZNnfIEuhNoMcfLmkUeryC
	su/rLQ7QnMbmN22/FWWgYvy9I+VLp6Us4aO0HnizvlQKoyxfXHuHwlbvWyOG47wHN16dTfH9FTU
	yWzueIXvd+b/mfdRIS9XEeW35zDQSpd8UmRNqQoTs2LkQHXXUYqFAsvl2JUF5nOyaiSjpzJo+np
	/GV09xJWgIEkg/aVSJURkTN0nnI9J7Lk6uz0HLZIiNQi+GBZrE5uGD9453j0deezUntyFeWTWyM
	i5VwYHEfUjblkly7nzWsTGH+BSY21yv84wQ6gDDgQWf3JcCbUbCNxm5lnGuZ5EXpClvRsvGIAIl
	4ge/DuCmlKuwW
X-Google-Smtp-Source: AGHT+IHpnnqDyxLOQ/nirgjGGOdJ/ZH339XOXDS+je7JQQB/3fm1iDtTpuu0EuN1RG6e4kTXU5QFmQ==
X-Received: by 2002:a05:600c:4e0b:b0:434:a7e3:db5c with SMTP id 5b1f17b1804b1-436e26aeeeemr34671985e9.11.1736368629554;
        Wed, 08 Jan 2025 12:37:09 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8475cesm53429771f8f.57.2025.01.08.12.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 12:37:09 -0800 (PST)
Message-ID: <f693d9e8e0ece410ea6a8d1cfc26945286178231.camel@suse.com>
Subject: Re: [PATCH blktests] nvme/053: provide time extension alternative
From: Martin Wilck <martin.wilck@suse.com>
To: Luis Chamberlain <mcgrof@kernel.org>, shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org, patches@lists.linux.dev,
 gost.dev@samsung.com
Date: Wed, 08 Jan 2025 21:37:07 +0100
In-Reply-To: <20241218111340.3912034-1-mcgrof@kernel.org>
References: <20241218111340.3912034-1-mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.2 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-12-18 at 03:13 -0800, Luis Chamberlain wrote:
> I get this failure when I run this test:
>=20
> awk: ...rescan.awk:2: warning: The time extension is obsolete.
> Use the timex extension from gawkextlib
>=20
> I can't find this extension either, so just use systime() and
> use system(sleep) for the sleep command.

While I'm ok with Shinshiro's propsal for working around this issue, I
wonder which gawk version you are using? In the history of gawk, I can
see that the deprecation of the "time" extension (gawk 5.2.0) was taken
back in gawk 5.2.2:

c3c6419 ("Make the time extension deprecated.")
6e195e4 ("Undeprecate the time extension, add strptime, update tests
and doc.")

The NEWS file says "The time extension is no longer deprecated. The
strptime() function from gawkextlib's timex extension has been added to
it."

Regards,
Martin

