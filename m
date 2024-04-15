Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0336E8248E
	for <patches@lists.linux.dev>; Mon, 15 Apr 2024 18:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713204908; cv=none; b=U5lUmQYgolY8DjUQWGJtRlTW6khJWGAsts/ORNpgLP9rLkSSoDwyCDm8MOQHyEWn63L6NutCaY2+O/alufcEJDl17/31kJWMc+QDMpCyc9Fnx85szJMMvw1KH/UmoPJjYby+U0o54PHN/3G7O2RlCJAXguasdSdoPHyKUBS7h5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713204908; c=relaxed/simple;
	bh=xJlCsH2KZxgfJnrn70p96Pp5me2d5wgAhY70zdBr8Zo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTza+r6D8Mlt4WRZ33ODw0Y1EBhPFXuCV2hAOFg6fdnKx5S2EF4kzd2WVHI9jBMQMx4F0xAFhknS/Dy3zmIWztsGJyWCbSraAEYuqODvdD7FsHaxJUdqRyJYa/IOKq2G//WxGcEVLEhxtaT9rZziMEfzj1xgEXeSY3nbQZWr9/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=I00S7WEW; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="I00S7WEW"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e2b1cd446fso28250165ad.3
        for <patches@lists.linux.dev>; Mon, 15 Apr 2024 11:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1713204906; x=1713809706; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z81tdQav+LyTu/btyN96bE62/fspTSImr1x25zqZPAw=;
        b=I00S7WEWv3CyVhZLThW/QXytoImWwEx6JJ+H7Tv3exNjk0YrkPDv7IDyO5OFEZ1WKV
         erkFlolD+9GqyI8eCr730h47o/0XuP65h0OTwayfUiRXlpU0VLbDvPu2S+ESaQBtbbZZ
         Vh0W5zdpQ0o8dxt1C/5FsC1/dCofa3FiT+RFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713204906; x=1713809706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z81tdQav+LyTu/btyN96bE62/fspTSImr1x25zqZPAw=;
        b=JcFnmV1vjuasZrzd9vT2x4AnCOvi6CAEJ3vmsTfqaLOo3MAsmcCIRsMjWVeuaQACf+
         z8SplDJ4DKcdbKu/pxqxZ3iTvnDsYfEZrNQkacaT7mHhLS9OeAvjAo5TmsS7GNsyIM2p
         Jz4//SkTayCQPvWvV3WmFiAnSRp7jNrchRN1DlOsNcTstGBBihUKN7PzQNGY5vnS2rUi
         xr0mjQzQVS1BrCnATMHdVSIJkKAj+IZTRWevkD1Z1JUXl4YCe3QolTzCx63gNVtv74kt
         ZpM6G4foRX1wZcBeuEdXBF/t3P6Nc7vaZuHsOUiP40C/eeZNFHm7CiYHblO3o0BSCAqL
         xBxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlk6BWg1rPliYQw1u5W0Inj9FfrPDgyqdrVjHKJjbmfZJJkgvpZyqNZaYitSZUXGnUpiOvIkqKAKPP3E4YMNccBtHpAWaSoQ==
X-Gm-Message-State: AOJu0YzVf5eUnPFra931keYXrPrykNUd+gxV1J57Xs7MHBizoYj4C/Mp
	CzhQxYGhBi7gfT1Z9jT9iys0CNvf311zUe6Tmr2DMzdPHQPabwaAUrEn0/jFkA==
X-Google-Smtp-Source: AGHT+IG1vvF/zfZ558hmDrGr0zzfkFPMPanPF557a7a1vjYonvdL55LMMeNOeGjFW4f1Tl7++mOqtQ==
X-Received: by 2002:a17:902:f685:b0:1e3:e093:b5f0 with SMTP id l5-20020a170902f68500b001e3e093b5f0mr13784066plg.8.1713204906345;
        Mon, 15 Apr 2024 11:15:06 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id u9-20020a170902e80900b001e2a7fb9441sm8193736plg.51.2024.04.15.11.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 11:15:06 -0700 (PDT)
Date: Mon, 15 Apr 2024 11:15:05 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: gustavoars@kernel.org, justinstitt@google.com,
	linux-hardening@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 0/2] configs/hardening: Some fixes for UBSAN
Message-ID: <202404151110.8D4AD8E@keescook>
References: <20240411-fix-ubsan-in-hardening-config-v1-0-e0177c80ffaa@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411-fix-ubsan-in-hardening-config-v1-0-e0177c80ffaa@kernel.org>

On Thu, Apr 11, 2024 at 11:11:05AM -0700, Nathan Chancellor wrote:
>   [    0.189542] Internal error: UBSAN: unrecognized failure code: 00000000f2005515 [#1] PREEMPT SMP

Oops! Yes, I didn't update the (arm64) trap handler to notice integer
overflows. I think I need something like:

diff --git a/lib/ubsan.c b/lib/ubsan.c
index 5fc107f61934..a2fb19f75825 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -77,6 +77,14 @@ const char *report_ubsan_failure(struct pt_regs *regs, u32 check_type)
 		return "UBSAN: alignment assumption";
 	case ubsan_type_mismatch:
 		return "UBSAN: type mismatch";
+#endif
+#ifdef CONFIG_UBSAN_SIGNED_INTEGER_WRAP
+	case ubsan_add_overflow:
+		return "UBSAN: integer addition overflow";
+	case ubsan_sub_overflow:
+		return "UBSAN: integer subtraction overflow";
+	case ubsan_mul_overflow:
+		return "UBSAN: integer multiplication overflow";
 #endif
 	default:
 		return "UBSAN: unrecognized failure code";

>   [    0.198326] Call trace:
>   [    0.198544]  cancel_delayed_work+0x54/0x94
>   [    0.198810]  deferred_probe_extend_timeout+0x20/0x6c
>   [    0.198988]  driver_register+0xa8/0x10c
>   [    0.199122]  __platform_driver_register+0x28/0x38
>   [    0.199258]  tegra194_cbb_init+0x24/0x34

Justin, does this trace match anything you found running syzkaller
against SIO? (I assume not -- this seems to be a tegra code path...)

-- 
Kees Cook
