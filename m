Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FFB5B1EB
	for <patches@lists.linux.dev>; Sun, 18 Jan 2026 21:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768772039; cv=pass; b=XMbgxd2kFryM3yl2hqhLlo3LfV2HmFIH+9GSHvg61cwn2hhXjgv0hNYK4r9BlbaD6ZB1ekB+9tCVsNv7pgnFqMT+9LIE/+P5PZfnCyiEwCjqo9qKP68axcxlTlxqKQPrcY4n2s6OOJDVkzBnO1zbNo+LSEc8HWs+x0PJRAyyndI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768772039; c=relaxed/simple;
	bh=dR5FMFlo246DjiayIr8NlGLupK4szceHEikbN1Luc1Q=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ZyC7oUjnoYNJid2dHBt+9qcHctFshUFIrL0zbSAY+mUubwfXBfQB785c1o0oSlV35Y8w3N6TJzkoDF167Hx0XWcFE4IBJz6G5NHyuTHzlKK42wl1j9uCloKvmPY8DG2w8fhPmC1465Qm2bbxhbWDHWEd6g8wMspkkyJ8c9wBOB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PAlQ+tcg; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PAlQ+tcg"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so639961466b.2
        for <patches@lists.linux.dev>; Sun, 18 Jan 2026 13:33:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768772036; cv=none;
        d=google.com; s=arc-20240605;
        b=PLmhRqfB6G4lUU+CGotOn/A8Qn6sUOZDrBIaiw3+/sho5fSzAYfroqKqlI3lcX2LyF
         wGoiX/pcdAXhnp9ivqzEm3uD9/wkYdd2h5ivDv6E3IaaFG7hR+WqFeukxP9wXwd9oj1x
         bI0ZoQIq74AdZzH0ZcXdjy+l5xoIMBbnoU+/wqDWKKiimMMVbUEwCXP1oh478EbuO+/d
         g1b43iMPgIbY9K2lgERk+2etego8ZJZfjFyaGk9z/BCtfVDbr4gnVo9H1UZQwYlqVXN7
         iM/XktFN1G36I1bdc78FhrPWOQvZFca1lFTrwRPS+gT7QaZuDEFboKcIfld5EZaCbaN8
         R1UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=dR5FMFlo246DjiayIr8NlGLupK4szceHEikbN1Luc1Q=;
        fh=dnschhrV2yTByyr3GI/U0Rws3zNCy5hKhRlh+Nrxzjo=;
        b=cKWb35FG1KmHpTQWCcESs7O4/OvVk+2TFcycFRdXEaGj1c4zAPz8U03VtWcDmErFPL
         9DIHQ2pQNACYlEGw1fUEL1bxUxkofsQzS0vsElMeZDrYWsIyfg4yOqhE/HACzr99rMua
         DivsBMu9ZxPqfQWH8SukpR8sAwfGk3p+W9lJFa0Thp/78uMHuBjfNe52E5fnSlQru26q
         DqtNOmO+Veha3xX4mF5wQ1hgFcPg8Dc7EKW59oeYHWYQHEzCangbhfLnEppclMX2xrj0
         99WDwdOWetA+atGgJiKGKz5euq9iGReiUYGWSRe/FD+OvE7pMLHg8sbUZNxclVmI2/85
         YH0Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768772036; x=1769376836; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dR5FMFlo246DjiayIr8NlGLupK4szceHEikbN1Luc1Q=;
        b=PAlQ+tcgvtByy1bQ1NlRfU+R/5xCWDAfB7NQPUNjlQP5tF7AIkkJG4pUZQdyicg/BE
         Tm16H8pZlxzdGH27i9mXDAjv5vRUZgMZCfDuzqimRXzVbCUruEyT0sVvSG5omWevG39q
         HTotVGVxQd4WC9XBgv4TXSXtlSDhivMeybzagj8eCQvstDwT41wU1XZjRAzO57fDFoaO
         wUG/iI2lcfqZZJ5+ic0S8gh/KFclW4EYcBvJ0Rx1aJKsJeP1fcrIGVwWUMQTq8WHoBH3
         Qf4Um5/aIXvI3K1oD6I3k9X0wQgGJpnjdQvJ1D2xqjWpETkV99y0otvR/yiwebjSgwyR
         Toxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768772036; x=1769376836;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dR5FMFlo246DjiayIr8NlGLupK4szceHEikbN1Luc1Q=;
        b=v+L+yRqck5ZmJEhlhcOLNeRj1rxelCLCHaYC2vgT3JNUcxcpf5w8czBbpKgJo44pdG
         8V5ICT3QifnLq9vF+WKumj3Tz5t7rB9g+xTsZAcJ6tJeSkxReaZ1TEmT5xm+OopiBWK+
         kVj1TJMrPeSjN1WZRSKxfW8yxxGJQ3nUsNjD6nYEEPxYpuKjfw9LKGPfNcdXYAfSPdj4
         yBslnMQ4UjJ4YRO3fGyydKAA13IQcR4BQT2JwvS46R4+9dDhdNGfyjla01DL7R2jS+PS
         +/L+0F0REWlRaEHBikNL8T/QoNwYN9txO5xx023yyw/IZfYg2mBwLkPiQnuOyZwtc46X
         sIeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHzishPzdoXPwz609L+JWa3uKiYNaB5qQLo2qWOohrUbkQcTNZDsykDkRHUOw/VufH74s2LiZr@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2lIwO+zqdbGsqf2g3PVkv/5e38VEWqmKlSZgBpJ7IpqUR0gRX
	/QJkUO5lfkRiJ0w1JUdFK3qvZ1/KT9qFwALBPL32RGwahZ7aaQOZhziP4XHIf6Hpwvv+Y8rredK
	jTp504LsTXsZ+Kcoer86ofbm7+xACwGw=
X-Gm-Gg: AY/fxX4Dk6Esymgj5mhroXnQNSsyqQOcqQXSIIwC5eVXGxlFAV6aCjJ+Gb5Nl2mV/7i
	nHPuTjvs0FKjcCDaBOT0UpPwr2yZZaYf4rqWlZc1kBPsZfH2Lx7QWE4bVRi9IwhY3zsth9OgWjo
	eUkE2QDzO/KWw4/DPz9fCIfGr5uyFw6XOnmHNDvZdvbNRIZDI/GNi/EUDuT1DnYOkLeocK/V3dR
	hZttotlOzHdRC+REIILxLWu1zd2fyOWCeqzn8qUANwu6B3+lEtI3RrY72C8xRLQ4l5DqB95wUkS
	G1icdFvK4AafEtITE09UxYq04xkJv5XC
X-Received: by 2002:a17:907:930a:b0:b87:2d79:61c with SMTP id
 a640c23a62f3a-b8792d36328mr832751066b.8.1768772036000; Sun, 18 Jan 2026
 13:33:56 -0800 (PST)
Received: from 860443694158 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 18 Jan 2026 13:33:55 -0800
Received: from 860443694158 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 18 Jan 2026 13:33:55 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: zynai.founder@gmail.com
Date: Sun, 18 Jan 2026 13:33:55 -0800
X-Gm-Features: AZwV_QitwGRIZkGn1QroCS8h4qw7XwJi6e3jAKQi37ba990QzWONC4TZTkg9-wY
Message-ID: <CAEnpc1b7fMJvpaub42Oge4B+h3wZo+HOAi=ombo27AwLhWwvkA@mail.gmail.com>
Subject: Is Your Dentist Office Losing Time to Manual Workflows?
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, 
	patches@lists.linux.dev, info@morenofamilydentistry.com
Content-Type: text/plain; charset="UTF-8"

Hi Miralda Moreno Team,

As a dentist office, you likely struggle with repetitive
administrative tasks and manual lead handling. This can add up to
hours of wasted time each week. Our AI-powered automation at ZynAI can
help streamline these processes, freeing up more time for what
matters.

With our solutions, your team could save 5-10 hours per week on admin
work and focus on providing top-notch care. Would it be worth a quick
conversation to explore how?

Best,
The ZynAI Team
