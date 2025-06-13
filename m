Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38351DEFDD
	for <patches@lists.linux.dev>; Fri, 13 Jun 2025 02:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749781048; cv=none; b=CZW4UNXZxW3Z+o/+uS68LXfHoI+ejnSnVVmmVqpVltZMBlu+oeUYFX+uXiXXpYZuABQeJuru7pMS+gFexWBw+T4alfFworW9GgA3Rs8QSCRKgOG1lyVIGQR+tbX65ecmhErAsKj14IUgyGl3NLY0HCPdL1Tf2NPCBdF0K0pU8vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749781048; c=relaxed/simple;
	bh=NUDxPMataEvCFbMf4ol6/OGJGbZ5DtNd4C4vpmftFMA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=c0tJ4mgb0eqRSePt2mLEj+NSWTVQ84SP2ejJ6NFQ2/YICBFPC5M7j4mYAc2zpnoBA+q09oFfn/ORcuUGu4V2XSVpcGELXyZfHn21zIvJ8eXk8h0KX9w+ymp2uqzEYIQzXWUgqhoPyQ8pS+6uUTy8Td8O7O0qDFQ3uRUhscuQvIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XKSANjG5; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XKSANjG5"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b2c4476d381so1448447a12.0
        for <patches@lists.linux.dev>; Thu, 12 Jun 2025 19:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749781046; x=1750385846; darn=lists.linux.dev;
        h=mime-version:user-agent:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NUDxPMataEvCFbMf4ol6/OGJGbZ5DtNd4C4vpmftFMA=;
        b=XKSANjG5M6CDtTfgeM+CcP1G3+5pk9fuclKSsrVeCA2FuMo20B20j+WIIEOIKWlfGH
         7OaAfvBAJ4x9sWbEpHr6Bz4FapqKAPB+VlnLA9X5qm3kmv2YcUC0BR9i4LW7y6qLBOYX
         Nb+8HPIJwu31l4gjrEsoxr3L7UNVKPhuG2V1V5atzcqY32ZR1cPqva0QO0UFN+alij6R
         WfHajFssH5EuzRluBI7j3/GO9pZWVeKue8qcl3Qt49v0jFsz8obtGrvy6bBbBlxWpwBG
         lWVMAWy1buya5bBO8AmFV/ijIqEE8RDOXQKo5h/TYWWwufmVC7oUQPV1WbQjPsYHfpVq
         8d6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749781046; x=1750385846;
        h=mime-version:user-agent:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NUDxPMataEvCFbMf4ol6/OGJGbZ5DtNd4C4vpmftFMA=;
        b=rFhbR/7N/i74XqwAC0+g4F54mckdL4UxKhs9I6VwcKqMqhRMGBWK+l8nEkEzwpIYMu
         vbQEb6+/esSxozx3ueu13nYPeLWEGWB4pHBS7xmKXtIM1JjT74WhY4MnLXkYtKr9HPty
         /GnLuHmG1S9GDUNWYN6WnNl1BYsU+FcYzpZPqToViw1YzRb5HLUBi19i6H1hWSMsZwKD
         Ot7V2VZkEZW/oWkzhrZbQs5asXoYqtvtZWB2pHRZLRwQNcvqRpBmgLQWo2J8hDrMpZhz
         3+uskzaS6ZwRtP0+wj2/Q++r3BCjD+tat1i+KzyfGQJfqVrM4SX6pI0W7cHkjuafdMeH
         QiOg==
X-Forwarded-Encrypted: i=1; AJvYcCXPJclp/eA9NwVR7nF9OT9iNn4aXTVgFQkhkw0uXP60sRlMNvrXgwUjzHK6R/o/HPvIlYz3vsZH@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0/bZAhJAA7JKwYdOtAjlAFrjqLTTbi64atbD1AWMGYRoxnBjG
	4OOqtdZFhZr3bMyZoRsGTH98G18xjJF9fagyHxynnAhLUXefOyZvi5wB
X-Gm-Gg: ASbGncsLG28yy55BbkbPNhmQjt3YyZYb7VKPqOtFHdAV0ZwKzRD+lwdjbKMrUaSwbQT
	iIBT5Yb5KPpK7tgSbwz0hewKGRgd0R3PpAYNCJm5IPzsR1bsPXrU5hm80Q7RjtzzA32TTjIulDT
	jpRZHmiYoVQWp94g6AYqN7Pm47C3GGu/pBP1eSIySMOrVX+quqpjGqaD2fuVp1T8Nbt9V7HCEF+
	esR8uwdIZwnO9TyXtC6qBA8+9pGnAdkzMdE7RTbmGSEjcCEBJH2BKhV6S0aWDhULDnfed5o+5lo
	SQmRdQT8rAwNlIH58Fq2vYUxasq0T4gcRtWQweFEqg==
X-Google-Smtp-Source: AGHT+IEw5WjanWEDLG1X7eGAa5C3gNbnzr6H4t+9xgEgCh4Bs6rTuwlJibxIHRYrLNDWh6Unpvc6nA==
X-Received: by 2002:a05:6a20:a11b:b0:21f:54e0:b0a3 with SMTP id adf61e73a8af0-21faee4e610mr1073126637.2.1749781046083;
        Thu, 12 Jun 2025 19:17:26 -0700 (PDT)
Received: from fedora ([2601:646:8081:3770::f55])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe1639f44sm412874a12.4.2025.06.12.19.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 19:17:25 -0700 (PDT)
From: Collin Funk <collin.funk1@gmail.com>
To: Ahmed Salem <x0rw3ll@gmail.com>
Cc: Jiri Slaby <jirislaby@kernel.org>,  Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>,  stable@vger.kernel.org,
  patches@lists.linux.dev,  "Rafael J. Wysocki"
 <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 6.15 05/34] ACPICA: Apply ACPI_NONSTRING in more places
In-Reply-To: <3nobung2ragvykho52thb2pouxgjatmh5cjtc2vh3aro72lkk4@bp45zihoq6v5>
References: <87ecvpcypw.fsf@gmail.com>
	<5c210121-c9b8-4458-b1ad-0da24732ac72@kernel.org>
	<3nobung2ragvykho52thb2pouxgjatmh5cjtc2vh3aro72lkk4@bp45zihoq6v5>
Date: Thu, 12 Jun 2025 19:17:24 -0700
Message-ID: <87zfecs7uz.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Ahmed Salem <x0rw3ll@gmail.com> writes:

> Thank you so much, Collin, for shedding light on this issue!
>
> This is now reverted in upstream ACPICA commit a6ee09c ("acpidump: drop
> ACPI_NONSTRING attribute from FileName") [1], and pending merge.
[...]
> Thank you so much, Jiri, for the attention to the other issue.
>
> The above issue is now reverted in upstream ACPICA commit 4623b33
> ("Debugger: drop ACPI_NONSTRING attribute from NameSeg") [2], and pending
> merge.
>
> Rafael, the upstream PR [3] is ready. My apologies to
> everyone, and thank you so much for the review and efforts!

No problem. I'm sure many others made similar mistakes while attempting
to pacify -Wunterminated-string-initialization warnings introduced by
GCC 15 on existing code.

Thanks for the quick fix to ACPICA.

Collin
