Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1297C330B3F
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 07:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772607885; cv=pass; b=POqaBnlqHMKbmfyQYRkxWOj0c5Z6NlZn4B36uFwGCNxmZ/SyDkH4lgEgffj9DqwhiI7It37nmGCy4x5kozMQABMAic32Q5m93x43XRF7pjjgIVdME2eF5PQm0de+yJSdNzba3AbKCZnWKgWKANOJKuR9qlL7j8awYn7MW1Z+tQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772607885; c=relaxed/simple;
	bh=6dEl8w70zIx7RtQmGCGj7N9KErbBGgqHKuP+EANQx9w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g46/kcguaOQuwnLpTrQdJ8mfX4/TyDKOj7om12eR570o19cZPm6w0hNHG3nEs2Z7jDa3uqdDjTenV3gWSq5Qg/4Dye5ny14tTDPpHhr19mxkH4FsD2kK97SIBmV+GImeTQEcOFEMLHwYNVfhEpV2j/X46RvMgHn8dSU9uWUoIjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AwQsOpPm; arc=pass smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AwQsOpPm"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-389fac627c9so99786531fa.0
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 23:04:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772607882; cv=none;
        d=google.com; s=arc-20240605;
        b=apTx9a4Aq+9HeTXscj7HTUGTpTZlPvh8zf25+9e3c8hcfm6jiIT6fUr7xXQeUGL3Dx
         PfmGXpKV9c+eOB0T7cvOOoqvfkyMUPmzL59zG1N+kQy65K/+5kqHqvhrNk6vjN/R0UEW
         HOazfX7c3qkZUtDcEs+VF1HG2HpYzDoI8/B7X6TCoK6VsXSkyCMqPINStgHU1B/eaXsE
         jrQG3ySAzI1uwuM6n+6jNrwIUXT3oCOWTsd7RNWVR35c4WENYiFLEFiqVwfBVCpc67GV
         YqFz4gCV4sRbG7TgCurwwOVMB7tu1kBCXM+NAmnSiN4n4SLFG0xOyzTlm/feUpbrHbfe
         FJcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lhp76GkJEmISlLLUIZ/1Y1LEXHD4rOCe8Qv7+jklxAg=;
        fh=P8wcS48xQTHvU9a8ufeOUR0Ngvu21ze3muYpFNBBS/E=;
        b=KMUznEzwodQghy9/86FoKdO1nWX/BmVopxVSZknuwKU2ZZdhG9SyhID5afYGIODtWu
         3NSXMLQLkYdz/nCcdeQGiGv+bQlUvyBTNtzt3PfSiqHyWOJYbaoqydUAp9eFKz6zhkfC
         qP96mVFz0u5EnSzZhiw+3sW7FQZOeg86BXc6em9OEMhvcOcBIV4Dfd+nfG0rCr7pmMR0
         JMAzAuB52jsDO0UR35hVFLw70T9w+kwEzmOrOPoU2Z6u9Pwc/fC/kQwjC1gzOx/Zf7qW
         2q/oylmheMIuhfkr0wldSgQjMMB1HZ7T4CqY2O+nB4x9DjZxy+vuEaPCS1bFR8qDtu8N
         aMcw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772607882; x=1773212682; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lhp76GkJEmISlLLUIZ/1Y1LEXHD4rOCe8Qv7+jklxAg=;
        b=AwQsOpPmDgubq3PLsbV5U/ypPFuXfLlAnf2ByudZa7zlS2aiMWEm6jtmmPwGD3rubb
         5+Su5DygzpLdKD/70T750/COblKoNEK8J1kaBK4XGW26zQs6+DcbPyKkTRgE7Iaw5H6n
         zdyaXBUnqd+V8ggndVYDgJn50jyGg+w4Lo9LQiMQpX7x/Hi6kuAeOzF7vibG6onykNc4
         A9A8l+BAbbS1xFZKCPjp6O/yOgF5K/srdtAOxe8kw8YB77onzsTv+KW2sgijAPQlsuTO
         ZVnypzSPJTeQZ4q/dinVMIzE3PdsDt3GMxZjKA503wi1xMbQt1Zqrs5SidDIP4VIBdoQ
         NgOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772607882; x=1773212682;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lhp76GkJEmISlLLUIZ/1Y1LEXHD4rOCe8Qv7+jklxAg=;
        b=Of8pJaJJhzQBmgD8Jj8kEm5aJHmBGwf9KuYda+yQxWBybd0fZpz8eOlUAfc51Wntbd
         13Mab9xAZwVc3Q+p3riYgL0G4L94I2xyU1SQ8hEH5tYASFBrZjeLmsxGaj2qFQnwaIOA
         ByixL4TJOb88iXCUxHDGFMW6wAvrq2xpDzYgdDTEASJ2X0EH/EdFQyqIn2S057rXB53z
         S20U4fuvsf/Q4q1kOUQO4ZGvXsngz2dVu8PXS4QbpmHKmdLNyNa4yrlXLDCXyuW7Cgtw
         bTefr4PwP4YpKd6MnfPzLYxwyXJe2ErJb0Qw9RkcyJp7FyU4Td9zBEr6t/kOkDGPA3bW
         iqdg==
X-Forwarded-Encrypted: i=1; AJvYcCX20TbazLDIi9l2iFtesRU7kfu1jdJeONRw5tpe1BIAIikPaT5ceR83zAXURYNWfViffjQrGFJ2@lists.linux.dev
X-Gm-Message-State: AOJu0YxxN04yf7hmdK9tmH0hA7LlhfTokf4YGwNzT3r3psKSA3K1bKU1
	obT5pK5SYDF0UIjjOBm8ZwHu9q2r8JpsKFJdqMy6xeNmhCUbjod5U4CDR/I9DWfY6qo85MZh6wy
	g5y7uCi8bd0ux+A1X1iEOMkq+aL9BrDQ=
X-Gm-Gg: ATEYQzztIwVnl9C09xN8cBJtEtr5qw4xVrh1xcIJjNh/EG1QqvtdHsrpHXrefiw1A8m
	epUeHrbSd7S73AsgG79BDg54/oP0Z+nehUHF2lfaH+s2B9OvAYGIIfHVlNRltQt6sFUMMjwUC0d
	377u1LO5XGqQNJ5B97MZXRdv6LMuuc2NDFbwISP1fElPfUeuQuGEZi1rQJ66ObDj93ymBXY0Pnz
	SISciKOYoCN70fAwaKCKtAceKoRZHKqi8SAJmhBCiYFAE2MizzfinXr1gF/LHpDKXqjVMc/TkB+
	LQ4VgHrfup3+zj08cKF+9SCtU8+ekwItKYFb9Pmh2zyRB225gSrbdWo=
X-Received: by 2002:a2e:bc05:0:b0:38a:519:f788 with SMTP id
 38308e7fff4ca-38a2c58db91mr8351931fa.2.1772607881955; Tue, 03 Mar 2026
 23:04:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260217200006.470920131@linuxfoundation.org> <20260217200007.474729104@linuxfoundation.org>
In-Reply-To: <20260217200007.474729104@linuxfoundation.org>
From: Evans Jahja <evansjahja13@gmail.com>
Date: Wed, 4 Mar 2026 16:03:53 +0900
X-Gm-Features: AaiRm53Vja5JYzpG6D8Y2tyXvfolXw8N_dbbJiJeoIODtNRKq8EUaFhzuL0pkbo
Message-ID: <CAAq5pW_ETivN5trn1CN4XPbHf=uya3TmjTmvwmaaMZVnjqf=8Q@mail.gmail.com>
Subject: Re: [PATCH 6.18 26/43] arm64: dts: mediatek: mt8183: Add missing
 endpoint IDs to display graph
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Chen-Yu Tsai <wenst@chromium.org>, =?UTF-8?Q?Otto_Pfl=C3=BCger?= <otto.pflueger@abscue.de>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	Thorsten Leemhuis <regressions@leemhuis.info>
Content-Type: text/plain; charset="UTF-8"

> 6.18-stable review patch.  If anyone has any objections, please let me know.

I reported this but unfortunately life gets in the way and I am unable
to test, please go ahead with the release. Thanks for the hard work!
