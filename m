Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489502561A7
	for <patches@lists.linux.dev>; Mon, 19 Jan 2026 06:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768803991; cv=pass; b=oFLQjljJES//fEK/uknWQBRqZaBmubU1NHGYqRHvaHbdXoV9tNxBEi0mTfb81UrrGQxbmND9Wh6ylJGtr9sto2SiOwUG/yeO96bFOwhlWZ5gmstsF9WxF50o2vteqVXy8reeQabKSXuvI//B3SauL9WU6RXS5/JW/bX9vmvMLt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768803991; c=relaxed/simple;
	bh=OIjzeBWD6G/+7P95/hT4dCh+pMCak/NsTNO3fpWO1Yw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=GOqpGEFdotv+qVrrIDUhKgwsFYxqjT4LjRQqbSfk8S0QKO0PqkpLlWcMDWPPdq1ivV7y6omdKBm9Oe4zBG141H6dsPYpW0iNImkWu1GlwLrlBRjRUhFLurQt4O21v/fTpRMeAG3j8FNW2TzOvNK3C4oLLrm6NqVfhLEBLqrHwAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EjlZnDq5; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EjlZnDq5"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6536e4d25e1so5800704a12.1
        for <patches@lists.linux.dev>; Sun, 18 Jan 2026 22:26:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768803989; cv=none;
        d=google.com; s=arc-20240605;
        b=UZkySwjz+ObkO9KUdzU+MEc3UpyMrDH7/Sjwe+BxNeh9B1u5/MfoGN3Octra4Yjcg5
         L+pG65JeJONhkd8oH2ugCCdoix6+HWWKiajM7DB5qBErqGaou8y2VERdiVcUWNMzBGlg
         Ip2Ur3Iy+0tQcPbY1cXAfD1b2R3pF13SoGnwKkePXj+IIA48RfkXlM/n8AFx/5ni8gww
         F0yTzx8deuPAaohdLtvD6gwKKwPQJf0AH4kd2YgvdGJgMdPqwApgNFPdUjmBhqsnEFJv
         UaTq8/Rhl4Td02AkSvf65ENaysivd0CRTULDDhachjIAGjqHdKBsLz8fA6Nf//K9i66+
         n4Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=OIjzeBWD6G/+7P95/hT4dCh+pMCak/NsTNO3fpWO1Yw=;
        fh=mTHFkeURcIMwFpVhm+wDyeb7p60Cuh7C/zs60vddpHc=;
        b=gJXiej4rHQTo4UlSamtMFi1lVUYW66NcV1tb8BEGgbaPJj7fYDoH2rpxs4yBuTDSfx
         4p8RVdP+rWlFp4CdyHD+HT4zrYCgkYpfWqJ6OuSY1xYS/UBM0N9tDPgfGRaQKPtEVRGA
         kz6NRXiWzehOskFsWQrQwvDtYNzG6XQkw1y/fe431ZKlhiOlBt9lae6T8H9lc1fW3zOm
         PYr1NaTkBuoX3EHq56E/WA+vArulhT3yFUBr6gPbKaqnutBBBYXg0n93n70Adg3RHnNE
         G7elZy8MzeYqmYN8XV0OW/GSJ/yd3U/xXRjOcEzT2S3rjUFeelsSwRGIOMQ0dQwbDNAd
         v27w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768803989; x=1769408789; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OIjzeBWD6G/+7P95/hT4dCh+pMCak/NsTNO3fpWO1Yw=;
        b=EjlZnDq57e5Equ+tosKo8pxFWf/OH4lF6pNnhXtDWo+MEI0L1keVVU7KUef61OOHxn
         U6yX428WlbtiXg0iX53ZtMketeynTJ8a5BrTRnqgDWyt8peM3TPqgyy8yPOw6vvM7blq
         b7gs3Im+zEzEDWnJ2pC5DcUuYryHuZRqJzHZHm0JZ8nIrKy1Is/NIvjeDkpCvQ0P+9fZ
         dKxLerASTipvwXaj9lXaCnirX/PmvlIXhT5nAwjubSz7WTi7CBGeZAB3vwJE4xYYrBbO
         ZmV1GvHfQhgZy0EEhi9PY/+YejI6+lMsq7xaHiaZq/DKBeAsDB/a8aoY0uG9UlkMaHpf
         j38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768803989; x=1769408789;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OIjzeBWD6G/+7P95/hT4dCh+pMCak/NsTNO3fpWO1Yw=;
        b=hmoRqcWLQ1bq5iqui3zwtz0gqJQaVlCI5kuE6t192Ba3jtDePeCKE44imkkrooIwRx
         TcMMICVLS3NN5XEZkR3CcrUwuyGPoDyP6nLT8RMdqQ4zEZZDDzQ4Ri1ZtfuA/ezsAo3W
         JhkKrlnHj00inb0ZFFbdcCltkS83jct/sKif+1LLnXtLgub1sGYnNo/EMWYyc/vgfpKe
         qQRnvMXsWnW060scMvkWe7l9PbL/E2aYSzm/ZG45JhL1Jl1MlExz6TSy5WF5q423k4i9
         hZClLCHwtiMbGuKEBYDc8+HhvnzmU+MDahOw5lRV+yvnFldmcSeQn0svLaUdRIdK/Wqi
         8IlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUf2PcYIdls2KnNPyQjySTZv917Bd80cYFEpC5lV9SzeobY+iCXkYr58SX33AqS+lcJIrnEWNVW@lists.linux.dev
X-Gm-Message-State: AOJu0YyQYmMQayl3sg3ob7ZpK5EXKnMvnQHccTZmLDufy6TMVcAmq31W
	Y4M3i0hoWBWLxy8Ctfs9ctW7saJubT/s1XZceqdKpTHiI+bfIoQbXY6Cnhfm78CPEyfDkn5j4hh
	UFVdwA1kuNnfWWMqmCMO53uoHjMEz3gE=
X-Gm-Gg: AY/fxX4Cvgv1Sgtm/T9yeV3iP4vnVTH8Xh/ue709fa+sbAxl0dlUbuTpaEsGbVXkJrp
	7pLbmhGxyyjb2ulCAF/kwOPm/WPnjrfoeeULlEAYLZ6iXMXX8ZHxaXnRgO+H4w5FLzNHDfEYvj3
	O4rVkOtJZo6Ik3tC7IgxQEFOfKlthsQxMWwmda3Rg7/sinF9bm3HA1XYTdeCwXyNGZbMn8DP12/
	5wEsDfh/PyL+Gv9kL3FJ+aCa4dvouh/Pw1t+mQSd1JEOYg7P1rIxIsFW/IrMU6ja/D9Vu/Wvabw
	gcAYQ6YUYw6b7q33kGwR5ID6WqOVlNt25mNTpw==
X-Received: by 2002:a17:907:26c7:b0:b87:124c:5f65 with SMTP id
 a640c23a62f3a-b87930408e9mr948920766b.51.1768803988646; Sun, 18 Jan 2026
 22:26:28 -0800 (PST)
Received: from 860443694158 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 19 Jan 2026 01:26:26 -0500
Received: from 860443694158 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 19 Jan 2026 01:26:26 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: zynai.founder@gmail.com
Date: Mon, 19 Jan 2026 01:26:26 -0500
X-Gm-Features: AZwV_Qi6XDSFA_U2na8XtIpwcJHOlx1Ktn1gzOVWFkswqGUefYYzi7MxmnFGNFs
Message-ID: <CAEnpc1YcccwVsPBqCSDuoJppJwVqSs8owWVorgCTKYT9ab=ftw@mail.gmail.com>
Subject: Can AI Help Your Dental Team Save Time?
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, 
	patches@lists.linux.dev, info@morenofamilydentistry.com
Content-Type: text/plain; charset="UTF-8"

Hi Moreno Family Dentistry team,

As a dentist, I'm sure you're no stranger to tedious admin tasks and
manual patient follow-ups. With so many patients to care for, it's
easy to get bogged down in paperwork and scheduling.

At ZynAI, we've seen dental practices like yours struggle with
repetitive tasks that take up 5-10 hours per week. That's time taken
away from what matters most - providing top-notch patient care.

Our AI-powered automations can help streamline these processes,
freeing you to focus on what you do best. Let me know if it's worth a
quick conversation to explore how we can help?
