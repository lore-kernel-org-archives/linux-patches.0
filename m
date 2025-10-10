Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE5E1DF963
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 02:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760062947; cv=none; b=Lp7m9ZHyY7mZPJx6+z+0dZ4ul8WcAs43ohNjZNlD1fPKomIzQhP9P/qGSMAj4EvkkM+TQ8RgOO0c3tjdc7Y/tQB44Lt45gcxUmpyAk4Zol3m7KxMyymbKFz8BpVs4HXTD3VmzQvcP4BMB0gdlsfR3Y8/DdybITRBVipo+gNjO4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760062947; c=relaxed/simple;
	bh=Poc8CSat8DKSOJybm3/cRmwyiOaA5NMqn/oRePUZbI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sq2TfFn4SYz5M2fp/j2M5TS2UbWuohUJDq6ayOPXNnffvpgc4M2GdCEJwkybZJC5/X0vnXk98fLDURn2pdHOR0yzCZlHMFRQNi9C0WAGq6c3/S0+DEOD27WEEUTzGO5CkmY27W+j+MJfPL8fipubLznAaaydryfVHwraVPCeE1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ToMA34aJ; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ToMA34aJ"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-267f0fe72a1so11537365ad.2
        for <patches@lists.linux.dev>; Thu, 09 Oct 2025 19:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760062944; x=1760667744; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Poc8CSat8DKSOJybm3/cRmwyiOaA5NMqn/oRePUZbI4=;
        b=ToMA34aJ8JpQTp8p7Z6CUGaYUmh+B7qah6BkSGR7usNfgnmcluqYMxEIUL/jkC5Ig+
         3cZKK8oMPN6Z7F+inrGkfVYCx5HOCeoGvDaGy0NuozKZA3yGCkIRH+IfEweSPVc0V53f
         1orumePuKrrAzZYfoPXAGaAsvV/UU/SY+1d2A3EWdJ1lKMIjR17JR3eERGhjMl9EeV7O
         rduyyJykXpgMZEhhyLITkE0EbhDG5DjV2I3t0t4Zc/vBULmjgG3rnoxW3rgHk6UEulQ6
         8XUQWVNVLqyIjTFyCXI8fcdI6np551jd4g0oix/GUdoWQTDFKRw1gBuOmes4/uKvZj/8
         ZEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760062944; x=1760667744;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Poc8CSat8DKSOJybm3/cRmwyiOaA5NMqn/oRePUZbI4=;
        b=gSNZi/2fLNPdIhRphQckqkToS7NmYz+j6t3p7npDoxQsnC+gME+Y9AIZRS7hyEaVQZ
         +FKYRXnVDyibJeUEuHPfMw9OzaITGdOZjUVXMLXpL/Cgv7Xp1g1MRtutEJ0IiM95H3pl
         wHRFVV4WN31fDfNYPL5fyXBmanQIgG+rFGcvFjUDKRofIxTNQzbawScPBLOeNh9laqoS
         6JXPqwGcjGX3G0w8P4yNmw5sJ6kTrP1eOWzg0erIFeDKGcAcp/jSL2FPO9SmqJ2d6b9f
         mJjZHWjzjH/6tl5gRS43roosvF5UwkCMrcqWGQsxr6uzmQE28dn0IDyK7Kz5Cw+tHzCP
         iUjg==
X-Forwarded-Encrypted: i=1; AJvYcCXgoph96diHFvj7Fx1qKvreUerwhM8jXRZZUUPbjoVwnpOOcqiTd47Rpgd+DK/xmglP5DiNMUKj@lists.linux.dev
X-Gm-Message-State: AOJu0YzVq3Za9ThgFHW+BQ2nOX7mUnAJ7CD7NXsTafcavpKA4LHYHme9
	4PjrTsb5PNRuXsqGxqqrpYx7RQk+jzHCwBatJqHwvcNx/wnNamjWkzHG
X-Gm-Gg: ASbGncv/xBDuT75FZtdnbeS1X6+/6fj+dp+c7Qs/Vsxw0DjYkK+DVUOxks7CeHf3/h+
	hw0V46ZjUzVIjEL2DocDH3HQ2zsNcB6sKswm5tlFlyTdxstwvS/YmWHjzfLmG03jqV40gaWJv4G
	CdHaEzBNg3r80vU1sF/S5s1/Jc8OcpcYVwOmtKMVyPs1378MlicPY2oC9aqw/93rDAE0HrtXz0V
	7IFO6fJ06A0eSfNvpRzeNjj1UL75804RGIvI5za+je9cQ437fdg8i52lWSEdTvQt3oTPh7nqQV4
	DFMfQv/kVui4MqWXY850nnaYYc7TBykmydYcIrU8d49NKNnsNte0AZxNI2pC5cnIKTmVYA4EJoo
	Bk5vZ+5rlc4s+AGn2KOOh5IFssxCSa2scGZrX4JZI1Cql31TQtS3vamdHxgYshkSTvCvO
X-Google-Smtp-Source: AGHT+IG+Pf+n9YF9gI8OUfcmQ9dndEj32A/PkFqo3oluXmEOwiiZZVb7VASeukYYSqQxTR1LizxeTg==
X-Received: by 2002:a17:902:cec2:b0:25c:2a4c:1ca3 with SMTP id d9443c01a7336-290273448c7mr124825125ad.30.1760062943936;
        Thu, 09 Oct 2025 19:22:23 -0700 (PDT)
Received: from [192.168.1.110] ([59.188.211.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034e18557sm41839285ad.39.2025.10.09.19.22.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 19:22:23 -0700 (PDT)
Message-ID: <28f4950a-e3eb-4a54-b867-67bd269b8407@gmail.com>
Date: Fri, 10 Oct 2025 10:22:18 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.17-6.12] soc: apple: mailbox: Add Apple A11 and
 T2 mailbox support
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Sven Peter <sven@kernel.org>, j@jannau.net, asahi@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
References: <20251009155752.773732-1-sashal@kernel.org>
 <20251009155752.773732-9-sashal@kernel.org>
Content-Language: en-US
From: Nick Chan <towinchenmi@gmail.com>
In-Reply-To: <20251009155752.773732-9-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Sasha Levin 於 2025/10/9 晚上11:54 寫道:
> From: Nick Chan <towinchenmi@gmail.com>
>
> [ Upstream commit fee2e558b4884df08fad8dd0e5e12466dce89996 ]
>
> Add ASC mailbox support for Apple A11 and T2 SoCs, which is used for
> coprocessors in the system.
>
> Reviewed-by: Sven Peter <sven@kernel.org>
> Signed-off-by: Nick Chan <towinchenmi@gmail.com>
> Link: https://lore.kernel.org/r/20250821-t8015-nvme-v3-2-14a4178adf68@gmail.com
> Signed-off-by: Sven Peter <sven@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>
> LLM Generated explanations, may be completely bogus:
>
> ## Backport Analysis: Apple A11 and T2 Mailbox Support
>
> **ANSWER: YES**
>
> This commit should be backported to stable kernel trees (and has already
> been backported as commit 37b630a26d235).
>
> ---
This patch adds support for new hardware which is not just a device ID
addition. None of the hardware that depends on this mailbox is supported
in stable either. Please drop.

Best,
Nick Chan

