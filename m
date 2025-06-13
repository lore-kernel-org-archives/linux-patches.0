Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B600F1EB19B
	for <patches@lists.linux.dev>; Fri, 13 Jun 2025 02:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749780780; cv=none; b=EzYZY9AcUKBz5Oqhs9G5qbc39+xDlBnFtLNmGnUqM8pRo1+a37Z4P2dhkih79WNtrlOHVCfdmpu6rpF7Hnb/wH9XHmjpYJEHzl4kPbONy686dA3TTGIBbYJ82smzXejEfQb/q8Swpn4gYrXxX1Im/DuooOjHjBZb7XEsjv2u7OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749780780; c=relaxed/simple;
	bh=0n6xKtbuDQY6G+0/L/F9fnARyJe2FFGoyAd3+Bcd5ng=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kN5t4LAx96TH5teQLIP+9eBvbpUxbJrML0lD59QgZyZttNhiGeYnDA5oYdBkWkKkVVzCprgNA1/gLyGyu+w4SibXPh2RY6dZAc4OEMtIqqBMwoYbUWT76C/9u9qUvN0ca6PGMaIN7po0ke8Rgq5zjaMu31a1zwVNNaw1udb67Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gjVkeP7T; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gjVkeP7T"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-af51596da56so1296865a12.0
        for <patches@lists.linux.dev>; Thu, 12 Jun 2025 19:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749780778; x=1750385578; darn=lists.linux.dev;
        h=mime-version:user-agent:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hA5PNUdIZ+JmMrzptJYJdiFK4HF3VPgHYOcvKuhG3Pk=;
        b=gjVkeP7T2ri4uNQBIthJq15BLOx2oXn6joenGkhJwnmHor8u/L8AXFZ5n1z0kF1CHb
         nS/DRqmtzDevVGmSL9yZ/C8mRDSu90h3ddi/G6YUWesQJGw9gGbv06le47qGzUjBRah2
         POzSebUCf9D6xH8K4jNejAmTF5SVW4KQst5MpP1Pmu0dGhHAa+eA3qAZ7cDxJwYHP0Jw
         CQLzSt/UbKd7d2MyrMYd4Y4JzNcFhr9aSXMf6EWwnGwrrf3Y/FnXGQMLp2J1qZWvRKo5
         3AJM5TlLrDyNcTULrwbHNGnbGloq8IpY/owYYbaYSFzOdf7yPiacnM0N4/4T2j/J38OA
         wZWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749780778; x=1750385578;
        h=mime-version:user-agent:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hA5PNUdIZ+JmMrzptJYJdiFK4HF3VPgHYOcvKuhG3Pk=;
        b=YhKUx9Bh6PHrIGC9MVQKcpRYDbLC76yjwFyFusEE7U0d06+0Kskz3tudOjSfpNq7ft
         TQHPR2QbGxek71Qc1GEV41SZs039rmYo0sf/FKX6bYAhU7f08p0OrPZzEQU7JCk9cIvP
         yL+OqPM07fEABh6fQejK90jc8xHHfMDYQPvfnziGht5YMHQt4RhPxdVgGPPCjW05T7Kn
         w2xyabSVTHhCRUgsOpR1VhO8upa3chiGMVG//gfDTKWivoGMPZZC9hI0jdmKqncW39md
         WGCW6BfkOl3+xm/nbwwCS86ptJBt+xKeIE9z6QQmYCU0DqaikHUaCsJf06sxWu0Y/+hC
         0kIg==
X-Forwarded-Encrypted: i=1; AJvYcCX9K77TgdTDaZglbh1jPU9jGyS42cc6UIVbnQtRBG2tvp74ekqnhIBmEspWrOxQchlubtgKvdLG@lists.linux.dev
X-Gm-Message-State: AOJu0YyroI4n1iw1MK3HwQbl9sz5JwaRqtbhKGE70VuE/MfD7lLfxQ7M
	zZYxwAYCjyth7z2TYUmVw/Kh350NQLClSj4jkbACThSt+ABbAW+lqewU
X-Gm-Gg: ASbGncvBe4ONvnla/rCu02otC/Zdux5+OsNEdaKdriGhBU7zLMcS1elaT5yKGvDu+16
	DiqZ4aAF9zK1tIajLmVo7DW6FJU/P9aPL3ObCE/l3Lkjf+EMNsYaMzUd2G/vpyGX7als/Wr3YWq
	yVRg0sCi5J9mSAMPIlWiJncmUtN0Q5AbApwqpYAMSZjIuxpZLxZhTgMp0QWlqa2Bx2C/LCYRq6Z
	TWepzO93eMh+mOH4tcwamiI8ERJQrfI6jIHlBk0ZbmPpihMyz1ThI2fy5qubGWp2PkD1hkEwVEa
	RHpq2R9ccOZoktxsbYxP7RkWpZQvMH1yN7IElC6gxQ==
X-Google-Smtp-Source: AGHT+IFd0X4fVlfy/Sj7SKCnZ2+k8ZfFwMQcvcYO+UMt1DilGhPBBy1wimHt3DWPorXsAVAVimbFvQ==
X-Received: by 2002:a05:6a21:a343:b0:210:1c3a:6804 with SMTP id adf61e73a8af0-21facec4603mr1757128637.31.1749780777994;
        Thu, 12 Jun 2025 19:12:57 -0700 (PDT)
Received: from fedora ([2601:646:8081:3770::f55])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe16805c8sm398181a12.44.2025.06.12.19.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 19:12:57 -0700 (PDT)
From: Collin Funk <collin.funk1@gmail.com>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
  stable@vger.kernel.org,  patches@lists.linux.dev,  Ahmed Salem
 <x0rw3ll@gmail.com>,  "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 6.15 05/34] ACPICA: Apply ACPI_NONSTRING in more places
In-Reply-To: <5c210121-c9b8-4458-b1ad-0da24732ac72@kernel.org>
References: <87ecvpcypw.fsf@gmail.com>
	<5c210121-c9b8-4458-b1ad-0da24732ac72@kernel.org>
Date: Thu, 12 Jun 2025 19:12:56 -0700
Message-ID: <877c1gtmmv.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Hi Jiri,

Jiri Slaby <jirislaby@kernel.org> writes:

> Ugh, indeed.
>
> FTR this is about 70662db73d54 ("ACPICA: Apply ACPI_NONSTRING in more
> places").
>
> To me neither the above, nor struct acpi_db_execute_walk's:
>   char name_seg[ACPI_NAMESEG_SIZE + 1] ACPI_NONSTRING;
> is correct in the commit.
>
> This is broken in upstream/-next too.

Yep, that's right. Wasn't sure if it was best to report here or upstream
ACPICA, since I'm not sure how often that is imported.

Collin
