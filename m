Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EE522258C
	for <patches@lists.linux.dev>; Sun, 18 Jan 2026 23:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768780025; cv=none; b=eCE0yrASefI6eV+Z+sONCEeFeGhresNaFN8OGOMKCu4EzGYl/bWiQGKRTBxbYq/ZcDM/LffsvU6wauSBPu7Clyx02jqud+57uJdjYGzrq8e4gnEoQ3QJxnz2ovuskPc1boyP9HaW6BV0RFWEHVLYBOgnU9uUTl/sJcNS2kHA/go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768780025; c=relaxed/simple;
	bh=oM0XhPyvAJ9C00Onx0erqFBFaGcGHeVLlrf0/2NGCAI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=IsotC6iLn7fdE6Vvyu67ISl82+jYCxe/VanRpx0P9uuJGU8SEbh5EcjsEWmGgZFrcMGUbzi9mhO2uB5LMZgrwA4Zl29bnL6br0+Te6/feaoIZOcY7croFRL+Zv3VEcIZUIvivsXsr6WLO7c8DkloeW8M33uKPmb9kU3rRJ8eUEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kzeClR7r; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kzeClR7r"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64d1ef53cf3so5008927a12.0
        for <patches@lists.linux.dev>; Sun, 18 Jan 2026 15:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768780022; x=1769384822; darn=lists.linux.dev;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oM0XhPyvAJ9C00Onx0erqFBFaGcGHeVLlrf0/2NGCAI=;
        b=kzeClR7rNhCBQF6KtLQjaVSwBu1aq4j42450es5Dn/WO1zTqBri1wDssjTlMiE9QjZ
         R60QZcf2S5JfvWwu4duMAIFqMc9leODyKyWgYKF1ew6yc0dUA1j1G5K97zfOXPskpfnM
         hovRwXmPsiiucspew6ZzYqZ2r86yuEoJOt+nwu3+6OUe/dCp7STYyilF+WpLLyYUmEEC
         ugIn3ZKUintGVt5NtFdIsCFh/Ma0FsXiW6wXwijFpuSz0j40M0SoHtKNTi3+QohypE5Q
         0STnRXBcBTr+Yg1sP2hIOoXicHWZiMgzTphf82NfX6goSQTo4xybFS47q6OyhZeJ3Fq9
         bp6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768780022; x=1769384822;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oM0XhPyvAJ9C00Onx0erqFBFaGcGHeVLlrf0/2NGCAI=;
        b=BHQH1BvlY9ml6WIoWw8c2zjXnOGRGtIGVHcu4nA/pbp7e2MxRgpeUGxuK0RMpzqJGl
         fyhiKLbmbDE1AU5Ci2uUrkvNPCprSBy7G7vYbKqyKjqOfuiuR9XtG426uG4cuMnoCPzX
         QuizGOp2kTV1qwdwYHPo0kEjZjwZb0c2t6SkXiW/DCsJBEskU7YPIDiANA5aaBuZWqyW
         s9aBkY2z/UBLNFnNnnqGKr+GsPZLuEB4Ni8aF65wpC1QnqYfaQsCiTDi3wAR/rSHPnWR
         cnuALda4u/NT2eO14BL30VbAKalAETdlL9Y52Bt0Rvl64nJGXVPPl8C8OuLIM1KZxP9w
         qHYA==
X-Forwarded-Encrypted: i=1; AJvYcCX0T831Wy1kSwZeDwxs3CfEJ//lL1/tgbxoiQe3BrjBQe9SQrvc9QAEm0gPw62w9+vp/Qhm/fuh@lists.linux.dev
X-Gm-Message-State: AOJu0YxnlYn8x0nHFGGHyzQof6D72ujJonEukas0SkkNRDdDjPtdoEu/
	m/KJ4o3riPRtMPK74BqQDUEW/uuH5aJIUGXHwa3YST2k/jYyoOh10qpjhu9RfsH4KC8ODWYO1hI
	GYwmOTiSGGexGFNVh4sz5T5m8CYI6IXQ=
X-Gm-Gg: AY/fxX6zNOQ0TRVbN44gm+VwGDvUEdsVNl1cccSHz63Qglfaw3Ly2A75FWoZfHaOaWw
	J/wGpvVQ7dciQygICfKER0e/6GjRy/ze+g/N5QLrijiGlURBXvgAh5M+AhcH+N79QHMFN5btEi8
	EkvTmztV5GztVIj9L3X80pgb1ICrBruR9YQ3g9PSyQzfgo9+ZzbN8LDxcshoPJMOWvdlzsVws9s
	/GVlKNJmsR1bqUSFF9Xv29ePIryYrB3v05bZG2UPJ5yzA85HGsbaCB6+HbtC/zd+LsRYWVM2yLo
	1df7P70RtfGmg5Nzx8tlxnHievQwqYTtsT3RqQ==
X-Received: by 2002:a17:907:980d:b0:b87:d826:8113 with SMTP id
 a640c23a62f3a-b87d8268b60mr100195566b.54.1768780022098; Sun, 18 Jan 2026
 15:47:02 -0800 (PST)
Received: from 860443694158 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 18 Jan 2026 18:47:01 -0500
Received: from 860443694158 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 18 Jan 2026 18:47:01 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: zynai.founder@gmail.com
Date: Sun, 18 Jan 2026 18:47:01 -0500
X-Gm-Features: AZwV_QgvnSRCr9U9GbrPqfghWNTFByROLEJHYlQeH1Na6GVQpzxShaCgo0MmOHg
Message-ID: <CAEnpc1YDO64c_iJEJ=Y5PmzT8t-yeG+BMK8BissNqRe2UqMJ=g@mail.gmail.com>
Subject: Streamlining Your Dentistry Practice with AI
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, 
	patches@lists.linux.dev, info@morenofamilydentistry.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Moreno Family Dentistry Team,

As a dentist, I'm sure you're no stranger to the challenges of manual
patient scheduling and follow-ups. The constant influx of new patients
can be overwhelming, taking up valuable time that could be spent on
patient care.

At ZynAI, we've helped numerous businesses in the healthcare industry
save 5-10 hours per week by implementing AI-powered automations for
tasks like lead handling and reporting. Our goal is to help you focus
on what matters most =E2=80=93 delivering exceptional care.

Would it be worth a quick conversation to explore how ZynAI can
support your team's efficiency?

Best regards, -ZynAI
