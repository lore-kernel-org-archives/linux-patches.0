Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95650180
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 00:06:46 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id 4so5141191plj.3
        for <patches@lists.linux.dev>; Wed, 14 Dec 2022 16:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Io4os3gTaCz4PVaBpjHUj2dUPT6iCaDC19vKypF5Q6s=;
        b=i/gqh+ULBL84l7W+HaI+YPVA3abaIfQIMOgVOnljOmr/KVA68zwjp++CaIKotf3jQg
         ZUOzQKPjmqqy4B/7LyynthiKp6gDWwdZ0BWj+GzLXpD3URXB/Z683HOwIBXxeh93b6GF
         S1iZx+2M8h1CY+bK9AdVvDyvmaaHb+Ig46C2A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Io4os3gTaCz4PVaBpjHUj2dUPT6iCaDC19vKypF5Q6s=;
        b=E6Jw6HWyLlcwXw1l6vjqRCrpJ5XZFfI0gNme1jdWfNkqHbWuyT6+dGmU8h1KlmNbrq
         lrPqN+wrcaQMu355vV86+CSSAwNQ7gUpfbB+pkTOt0IXq9HS/G8p/ecM3nImPr5OIIQC
         tqwDdvDQMPGFHYN+zrKt1uUGFuZk8pe60x8oNOEJ9xxDJWlqf8gGv0HUOdbdNrWVEiyn
         QGdoUTFsEmHP01LBvguZc1HNOhmnYTRiaAnn16xObSx4/RhysJq2s0aBV6HPI1NH3cuN
         AGyisHIAHJlQANf1LDLkNwYJhcNvXpdAX+D2KLhbE7zxqwQ6r9MKe5/sI6/aQv1CyaMw
         nEUg==
X-Gm-Message-State: ANoB5pkGEiGlzjkCq7mXE1SpsFKscZj5GxPBulxiD8/9FaFsEqmx8eAJ
	AYuL4RFVICQE5wTeh0L7Q2OZ8g==
X-Google-Smtp-Source: AA0mqf7K90bP3UUUfX9ygJAAX4zTnSIy4/T4H3TdPQBfKafxMyTh8efvMuJMEGl3HGTGWDSfjK9dew==
X-Received: by 2002:a17:90a:b908:b0:21a:8c6:c89e with SMTP id p8-20020a17090ab90800b0021a08c6c89emr27261520pjr.2.1671062806002;
        Wed, 14 Dec 2022 16:06:46 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id gj1-20020a17090b108100b002086ac07041sm1910624pjb.44.2022.12.14.16.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 16:06:45 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: ndesaulniers@google.com,
	nathan@kernel.org
Cc: Kees Cook <keescook@chromium.org>,
	stable@vger.kernel.org,
	trix@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	patches@lists.linux.dev,
	llvm@lists.linux.dev
Subject: Re: [PATCH] security: Restrict CONFIG_ZERO_CALL_USED_REGS to gcc or clang > 15.0.6
Date: Wed, 14 Dec 2022 16:06:19 -0800
Message-Id: <167106277582.3571286.12639413013649335692.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221214232602.4118147-1-nathan@kernel.org>
References: <20221214232602.4118147-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 14 Dec 2022 16:26:03 -0700, Nathan Chancellor wrote:
> A bad bug in clang's implementation of -fzero-call-used-regs can result
> in NULL pointer dereferences (see the links above the check for more
> information). Restrict CONFIG_CC_HAS_ZERO_CALL_USED_REGS to either a
> supported GCC version or a clang newer than 15.0.6, which will catch
> both a theoretical 15.0.7 and the upcoming 16.0.0, which will both have
> the bug fixed.
> 
> [...]

Applied to for-next/hardening, thanks! (And I'll send it for v6.2-rc1 too.)

[1/1] security: Restrict CONFIG_ZERO_CALL_USED_REGS to gcc or clang > 15.0.6
      https://git.kernel.org/kees/c/d6a9fb87e9d1

-- 
Kees Cook

