Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D145D8F0
	for <patches@lists.linux.dev>; Thu, 12 Jun 2025 05:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706303; cv=none; b=Efpue+EUa8YNLKWGdCPCi9NIpf+1hbbREM8n6zdD87OzLEHzshze8XjBAt+FzebwDUAySrJCSsP58nISiMs5pzLWPhNXD6LbN04btOCe98hHY1sRIFIUAzZoZxi7uBkzB+uoNK19wzpaRbXvpg1+nIEx1WPKHtnOzRFt2wblR5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706303; c=relaxed/simple;
	bh=pAfmlx+BmQK9NfGv87moPKxCj/f16d42B9nzOXBCu8s=;
	h=From:To:Subject:In-Reply-To:CC:Date:Message-ID:MIME-Version:
	 Content-Type; b=j4rTZW2TvDHuy5i162auIXJVsd9VcYvsZgJQ/SCJPQrzb/lPsRwn4thpGo2AcmZqXDNh+15IfDuKxYOd/uxsMnwSQGbag64WAZ3YeBDpmY+otk5D90gUZ7tUl9GnLhjN12nHMVsmneBZL/umXH9AAuUixx2UlxWTqWP/TMy1t7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VkmIPeEW; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VkmIPeEW"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7485bcb8b7cso585008b3a.1
        for <patches@lists.linux.dev>; Wed, 11 Jun 2025 22:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749706301; x=1750311101; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:in-reply-to:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lktWUmLs7jEqAY8KuG0D/bvZrVGge8j1xgCjT537Crg=;
        b=VkmIPeEWoLr4vqX5UyagsS7DieQJ8Dw0evjAV0pg5WmZegcZ8j9NV+U+X9VAjo4Fz+
         T1qABeY8yVdWYuqoSj+hOY1sBH4l/6mER/T7f6Q1QAM/QFh7/S6PtSWOJDDs3Lw/z613
         yfG4EZIfq/HLeBS5sXGas+fbdE50NRJIox6yfAkzCfVGP9clvDRGuxdkYNr8ssmI26gT
         NXs3MCMLrL5DR+lIBGYd62Rhr27BZGPLEKgMXCc8towOOURclV3I2DtjffocgRwL4P+U
         M4qY0tjFl2BvsZw/hwFo+SI9KHdZEGS7sLI2x3yGzO6dV/IChTgy5bEb3W6O+gUuumzN
         d8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749706301; x=1750311101;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:in-reply-to:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lktWUmLs7jEqAY8KuG0D/bvZrVGge8j1xgCjT537Crg=;
        b=CnomFMghY478bOX8hi5vZWfjciuNNRQOKs3OU/DVp/m5orXXmsNlD+92SmLAeD40xJ
         LN2L0FTZN78dSOmV7YAQgs+WYiByYKbqeyS13H2wX+8kmPXfZhHF4G//ysau7vtFTAt5
         RwZgR2wL39e1n2jfAjh/uQSTGa51mqb1MJCKb4UHXxAqFho7eAT7taf/qvcwNSRP3gqF
         EjpTvLT/dvn7f/r4b/p6oiWK5+NPB/uUlg/BGWM6gi3veane7UrOur+7GS6oHEL2APAX
         K+z89ETkPkNSZ+2GxG4Xkw+DORqwZKWrCuNzWzLMQqsoyf1CyBlmN174cN6XDUPlnTaf
         FOWg==
X-Forwarded-Encrypted: i=1; AJvYcCXmx4dpVS1/FraPJ15szw2sCwJEdB/M17tCyoXcLD5j02Q6iWo1w9uYh20iaGmXIp6pDw5xEgSx@lists.linux.dev
X-Gm-Message-State: AOJu0YxFbJtP5u33R3etdpFSJiv8vJGriS2PlRa2gTkvb2CwAhaeMk+4
	tjRRrGPgsIfmeVNvbggu42/pVdnBVpO6uIP2HPP4PLOkzhuucQIulUHt
X-Gm-Gg: ASbGncuaC/0fcnYeD4OPpFKRMvCkj2IB0xjftSaC06bYw+4uOzsZleFFJYzdxhHsXbE
	fNo6gciI5Jmll63i+m4xVQ/ya+m9nt+nuR2yrXhQPj7e87+pDJ3+PD3+AZDY5qPMfhl7kpLGOBo
	45LpFEl6KLtu9FXrDTMxpFFi1wMtx0SFjMfKjDHLcYpoJK6sJn2RegD4wjtPeH5UjvtYcRkm1Oz
	/QqYXpOzhDUXUFURB8UO3iGmWKCGc8jo+waRAizF25r/SAxR5/+U/Opy+UVt3EWGQfbihpBwKcq
	aSNvYjTKmXeJFPCIEBbmdS4tCDlq5qp7XOThhpGOMIY=
X-Google-Smtp-Source: AGHT+IHbLbkgVhnSojZtMqsW60jbudxe8NiIRj6orFZ9tx3bDS3G36H3CLu+xO5vv9pkZu0JCakBpg==
X-Received: by 2002:a05:6a20:cd8f:b0:1f5:79c4:5da6 with SMTP id adf61e73a8af0-21f86600925mr8143315637.5.1749706301046;
        Wed, 11 Jun 2025 22:31:41 -0700 (PDT)
Received: from fedora ([2601:646:8081:3770::53de])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748809eb0easm545681b3a.113.2025.06.11.22.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 22:31:40 -0700 (PDT)
From: Collin Funk <collin.funk1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.15 05/34] ACPICA: Apply ACPI_NONSTRING in more places
In-Reply-To: <20250607100719.931637473@linuxfoundation.org>
CC: stable@vger.kernel.org, patches@lists.linux.dev, Ahmed Salem
 <x0rw3ll@gmail.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Jiri Slaby <jirislaby@kernel.org>
Date: Wed, 11 Jun 2025 22:31:39 -0700
Message-ID: <87ecvpcypw.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Sorry for the exta mail. Accidently put CC emails in the subject...

> --- a/tools/power/acpi/tools/acpidump/apfiles.c
> +++ b/tools/power/acpi/tools/acpidump/apfiles.c
> @@ -103,7 +103,7 @@ int ap_open_output_file(char *pathname)
>=20=20
>  int ap_write_to_binary_file(struct acpi_table_header *table, u32 instanc=
e)
>  {
> -	char filename[ACPI_NAMESEG_SIZE + 16];
> +	char filename[ACPI_NAMESEG_SIZE + 16] ACPI_NONSTRING;
>  	char instance_str[16];
>  	ACPI_FILE file;
>  	acpi_size actual;

This one seems incorrect, as I was alerted to by the following warning:

    apfiles.c: In function =E2=80=98ap_write_to_binary_file=E2=80=99:
    apfiles.c:137:9: warning: =E2=80=98__builtin_strlen=E2=80=99 argument 1=
 declared attribute =E2=80=98nonstring=E2=80=99 [-Wstringop-overread]
      137 |         strcat(filename, FILE_SUFFIX_BINARY_TABLE);
          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    apfiles.c:106:14: note: argument =E2=80=98filename=E2=80=99 declared he=
re
      106 |         char filename[ACPI_NAMESEG_SIZE + 16] ACPI_NONSTRING;
          |              ^~~~~~~~

The 'strcat' function is only well defined on NUL-terminated
strings. Also, there is a line of code:

    filename[ACPI_NAMESEG_SIZE] =3D 0;

That also makes me think it is a string.

Collin
