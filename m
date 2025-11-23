Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E6122A4F4
	for <patches@lists.linux.dev>; Sun, 23 Nov 2025 22:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763938018; cv=none; b=pEnvdXuy+3DCZOn4Ftrl5VBWAsxMbTEz3/ym/6CFW2obAr6bVYrMRUTsgbjxuQSTdHg+/7YxqAKZxXrVfbOXduKpiLxBF2k2WjtGEo6C+gclaM+D9NrTh87/yNE9QxGA8W2XjHMv7wDsTOlg+jpO5TEmwQUIy/RN12K0QExr8aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763938018; c=relaxed/simple;
	bh=e0hceDboA05xFP5/VRqZHg1h4iO4L8U3n4dUraP6p84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fL8OCsF4dQ5xeuVO1PsaXFl/GX8N4DmowXmAVH8hlUr2D9a7pK6M2tokNjsGmBIPER7Ms7wIdJDaHypdgKYAKRJWGbr3He3ygClS6eqZtijrm/bKw1x/lE9J+IV5/5OrxNHFE8z4RPvoMhe/e9vChDexzo3IMyW29K/QilOFgYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XQY3qien; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XQY3qien"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-43326c74911so20260125ab.2
        for <patches@lists.linux.dev>; Sun, 23 Nov 2025 14:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763938016; x=1764542816; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e0hceDboA05xFP5/VRqZHg1h4iO4L8U3n4dUraP6p84=;
        b=XQY3qienQ27//Wy+NjqDig/HCZc9LTsgGFIp1TvAUJ0yego9ZkcGzzRgGFkVMNoAsc
         gamcXrDDApGb/SatoADYl13NTqh22S+dHZYwvfFxqybmnyZtTV51TmfZXJPXs71iOIC/
         4hBBuZ4CK5l4XZz7B7G0PQ3IPFJaPIK6LvTDUE/ZHdzjoZBqb2BAVcUmqo0S9Zb9W35z
         ObHN6/OV260YYz1RieMvIamA9k06Vk3q9j3CFPxu3EvODP2vYI5gzw6lNs08mn+vQ8K8
         K+ajMYDcdJrFfSOoSZICkqDGv4PZ6jUu/iDXjHM6MbCgHp6LvQaVCLlytqTAtgBWX66d
         lGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763938016; x=1764542816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e0hceDboA05xFP5/VRqZHg1h4iO4L8U3n4dUraP6p84=;
        b=a4V28pkD0YUFE69n3GdXqrKFoyn/kPeGKPQnFT752wLd1XfGztOaQrofwOCCxj49G8
         JQxIxfadjXw6eoQ1RcRc7UyD4oRsmd1vkjs8dAq5/cpsZfBn8TK5gc8Ec0v7xQG2LYC8
         aE0lTguxsZ8rhizXztThV++gaWKQdDnVfUSOufzXxH3mB73QJWlGaDf8kgIUe6N0pTm3
         NtAF6WF9Bo7KcXzXz1Pj0/Jj1uEjD0yEpe3TV4Aep1F51UvOGSepx6ITTKlg8MQGBZTK
         EJQz5bwPekYCowqYVfRy+CLpF3l5IvDqc4lgNavrjSMotTN1MsXyrNLerq6CRPAAvWZM
         QOmg==
X-Forwarded-Encrypted: i=1; AJvYcCVD8ju8vfGeRjtgWxaoTRmOgv+qGsX0/OqytvmrZJMYtONiBNTRo0pyR430WKlm/0V4cGkawccb@lists.linux.dev
X-Gm-Message-State: AOJu0YzlMuUC5jfmKjVCz9BKsNEGE8spyio5tCDgJtcm/+802HMtHvCT
	zdr359YGYh2Z9DKPTo4Zmxwvp5zlwf1ceT20RZ6+KQAdDHMtdnYVapwjBtvyj1A6eNbz7AIDglq
	OPRouZtzzfaWaJBONHub8IWL7h96wE+Y=
X-Gm-Gg: ASbGncvJ1aXgIja2V+IYvwJ+bhxUUl/WA3fQwc5AjXArVLhhFmva0JtvzvAoUgSN9eL
	55jIZfd53Fk/9GtM10an3hyIAhTXBwJqCuGUZnLkJYpYrkxIZHlNAgcUHOP+5LoFY80wtm1KIFY
	+OwBgavGGHYvw3vW7yDANfayLV2Ihjg5MTqGpW3Dt3ayWHtsFo5fp+bamNupOLYK9DTkrT3yt/A
	LBDG6Q0efZiyrNcBhcaLE3NQpAgmJ9J4jX0mr7qHHXmuHhcYtkQKkN3dW7q0bFpI9yebobHQmn2
	9hQ2cB3ziYNv
X-Google-Smtp-Source: AGHT+IEL6wOTWEIzN+6uRLqQQTohjNaYVb+umwdBrXzCY3X3aIAhRgkHGXdTXdnHIwE08xwvTjQQuTm0WFDj2WHSS0M=
X-Received: by 2002:a05:6e02:2190:b0:433:5b75:64cf with SMTP id
 e9e14a558f8ab-435b8e5cbb2mr79300195ab.21.1763938016377; Sun, 23 Nov 2025
 14:46:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121043750.298843-1-y.j3ms.n@gmail.com> <20251121053633.1594703-1-ojeda@kernel.org>
 <CA+tqQ4LX2ihwY11VJk3LNNE-STsONJWF0rdDa0Pq09oA7YRXEw@mail.gmail.com> <CANiq72=Yo6-yLzQ6f047vXk1e-mm8=EH5t3dZRpLaZN1iuRNMg@mail.gmail.com>
In-Reply-To: <CANiq72=Yo6-yLzQ6f047vXk1e-mm8=EH5t3dZRpLaZN1iuRNMg@mail.gmail.com>
From: Jesung Yang <y.j3ms.n@gmail.com>
Date: Mon, 24 Nov 2025 07:46:45 +0900
X-Gm-Features: AWmQ_bmOB06MctdBZgf6VDX6e1eE8DqG-67ueFQMRQg_sxxFTTkFLalse0DNJMQ
Message-ID: <CA+tqQ4Leg_VZWe92zXkygrp-gwRNPwyysYMWLwupX2bTt2R-+Q@mail.gmail.com>
Subject: Re: [PATCH 00/18] `syn` support
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org, alex.gaynor@gmail.com, 
	aliceryhl@google.com, bjorn3_gh@protonmail.com, boqun.feng@gmail.com, 
	dakr@kernel.org, gary@garyguo.net, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lossin@kernel.org, nathan@kernel.org, 
	nicolas@fjasle.eu, patches@lists.linux.dev, rust-for-linux@vger.kernel.org, 
	tmgross@umich.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 23, 2025 at 9:51=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> Great and thanks for testing! Do you mind if I add a:
>
> Tested-by: Jesung Yang <y.j3ms.n@gmail.com>
>
> ?

I'd be happy for you to! Thanks for asking.

Best Regards,
Jesung
