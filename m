Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDEB3093D3
	for <patches@lists.linux.dev>; Sat, 15 Nov 2025 19:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763236541; cv=none; b=noMAgoTTdrnvX8zuRdWoA5dfEGPhzilsFd/wd0AcqkRmQYWj2TMCWVuLHtBGW88uy0U6DO1Jfg+hTVmgBCYsO7/d5xSsa1o/ZF1GfQ9E7txknJGZCp5KfiEp7nvj796C6n9Xywd9VF3N+5XFAVEnIBFnKIN7/9yGlodFDVd0FL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763236541; c=relaxed/simple;
	bh=C+/K7Q5NqN1QoGmW+YDQcSan94kflPiyGMVUObBT0xc=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCgc1eA5ezYEe+tKZN0ZvUkJzvQF70YPMumKIlfIzD869rdCZGHFCOWQSuDC4O3FjDNGOP5doRNfIeS1mlO7E/hRmjs3V0njogVu9h/tMcTvOIfRoTGrFCQqW+RnwbqHuy0avnnvgSeydtZX8o/R79v0g5hqGz1Z31K8NNKH/Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TroO7oac; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TroO7oac"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42b31507ed8so2398896f8f.1
        for <patches@lists.linux.dev>; Sat, 15 Nov 2025 11:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763236538; x=1763841338; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WuleB7Uof+tsaQSPA6fNwqHx1Lp/3ZhdyDUy1IclBq8=;
        b=TroO7oacj16t5chzkHWifN3OS9qwS8apLa3rfIfR3IiUKDglO7vGg1iqtqfDFYpNSS
         SJp6Gs63yeKtRmOb29gsaq1v2SgfJhUkoS31E3hdgTzoBSR+TvjMtSHC4PM9IY8VQIJO
         LRl1uNddw4ZRhOfbFwP/i9BOubAboiuqJ9cC8vHPK1d/UtZjQ7Q1YlW2TJd4W2dsB/KP
         DeMPNgOIjqY6MGuFKBgh+JT6hMNjMITVZaYiOpTt9ARLWN/8SJUkN3EzR+/eyBHhwReM
         xOwEvtEmPFROToauTduc1CVjnlGhtGjWLFfugFUX1FegRp19K/maLM0v8N8jhyubmjJ/
         rTQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763236538; x=1763841338;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WuleB7Uof+tsaQSPA6fNwqHx1Lp/3ZhdyDUy1IclBq8=;
        b=Yw8T9YXDYmWudE1hFjTVYmJ/bcnVVLROkrIfWt16XbyLs4TSscK/KBwJikBRBrthnp
         LCpqzEO9rZBAoy+ThtMkDLqLUxdbOMLFg9CWq+MKhEHaOAyiZE6keL8A9g3MV8+cQO3m
         cdHxvVVvdQd3F0zFkCMD7/Z+taLtu+JBZQOG/PJhry9HVncEOPDBAlYc0+nhxkJa6XsN
         S0conZMmDSbLfkUAjMtJHYnQhkH3eMCCnYYHjD3ngJyqXpZfloKzaju/yplHHWUIo8ba
         XZciqJMYLR5peuVTxyCHeKY9+RLoCV7Tm5fWyq3L+Us1CYqA+EO3mSpb1nw0ynfp5ho5
         jgWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWkyx7oAjCJ6jmWl4pH/Jg6fbijZQmzw7Exqo4rt5qwBtXJwKUxh8hDxexULiaHrC32dFl8+ed@lists.linux.dev
X-Gm-Message-State: AOJu0YwoYWdzxYQ3t1kB47CLYNGL8xVcLTiSFsKZgCvmexDYIrFcpAcC
	MAkgLUIj0plladuxNzmsHwp6XV5pXQTziiB51ZnqeSmyov1mDWHM6Z0k
X-Gm-Gg: ASbGncsSqmhldb1dC9sILzyb1MC9LgqgsPKV33YhlrUAAPBw+czONcjqEIuadiAg+53
	kdxBhXMtTAKLQ06EZF7ovZkRZmcLzQagTzaX961xXD+4VQxSwCP9U1xOdrF16Mps/72YCpf4jjq
	ImaETsv76nbje9P4IEG6+ka7QcqixyjHZkX6Skzy6eQHAYNbMAJeAGhavpFwkkuvCesGDD3pJwg
	xLV24xumBy/4FwKLOvMcN1iWbmkLpm3QXevrfZ99BMQ9Uho9UZkbOeUIRLIpih1Y3VfKlg7GtlH
	VioVmNj4FukESj+SKf52vTvAsnw+ZjfiBT/CnDolF28Ui7T7iG45k6Upb9Tr0JhSnMnYMzVCFUy
	qljqRbz7Wrt4Qux3dPXiv/xzW7N2lM7CH5v+wiqCS1GX7ZKPJRYxS+Np8i+CANrfIrh+Pqd6C1m
	EU9ehOmpHmNNQsy+N8I4mT7h7ugzVrCYVPRI0468c9fXKm5jN09oFeWgiCuB1AABo=
X-Google-Smtp-Source: AGHT+IEf62GmYjxzwvkFlgA1Y2k3Lbqy6ScY6eZSdDpeSqLPl8AdyiMH5V2WcDmQSZsaAfQG8l5H1g==
X-Received: by 2002:a05:6000:1447:b0:42b:3a84:1ee6 with SMTP id ffacd0b85a97d-42b5934e2d7mr6759730f8f.24.1763236538325;
        Sat, 15 Nov 2025 11:55:38 -0800 (PST)
Received: from Ansuel-XPS. (host-87-10-15-59.retail.telecomitalia.it. [87.10.15.59])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e84a4fsm17126800f8f.11.2025.11.15.11.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 11:55:37 -0800 (PST)
Message-ID: <6918dab9.5d0a0220.170613.3fe2@mx.google.com>
X-Google-Original-Message-ID: <aRjatPM0eXV0N5XZ@Ansuel-XPS.>
Date: Sat, 15 Nov 2025 20:55:32 +0100
From: Christian Marangi <ansuelsmth@gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Sean Wang <sean.wang@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-mediatek@lists.infradead.org, linux-gpio@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] pinctrl: airoha: Fix AIROHA_PINCTRL_CONFS_DRIVE_E2 in
 an7583_pinctrl_match_data
References: <20251112-pinctrl-airoha-fix-an7583-drive-e2-confg-usage-v1-1-d2550d55e988@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112-pinctrl-airoha-fix-an7583-drive-e2-confg-usage-v1-1-d2550d55e988@kernel.org>

On Wed, Nov 12, 2025 at 11:44:30AM -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y / W=e):
> 
>   pinctrl/mediatek/pinctrl-airoha.c:2064:41: error: variable 'an7583_pinctrl_drive_e2_conf' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
>    2064 | static const struct airoha_pinctrl_conf an7583_pinctrl_drive_e2_conf[] = {
>         |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Due to a typo, an7583_pinctrl_drive_e2_conf is only used within
> ARRAY_SIZE() (hence no instance of -Wunused-variable), which is
> evaluated at compile time, so it will not be needed in the final object
> file.
> 
> Fix the .confs assignment for AIROHA_PINCTRL_CONFS_DRIVE_E2 in
> an7583_pinctrl_match_data to clear up the warning.
> 
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2142
> Fixes: 3ffeb17a9a27 ("pinctrl: airoha: add support for Airoha AN7583 PINs")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Christian Marangi <ansuelsmth@gmail.com>

> ---
>  drivers/pinctrl/mediatek/pinctrl-airoha.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
> index bfcedc7f920b..706532a820b0 100644
> --- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
> +++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
> @@ -2993,7 +2993,7 @@ static const struct airoha_pinctrl_match_data an7583_pinctrl_match_data = {
>  			.num_confs = ARRAY_SIZE(an7583_pinctrl_pulldown_conf),
>  		},
>  		[AIROHA_PINCTRL_CONFS_DRIVE_E2] = {
> -			.confs = en7581_pinctrl_drive_e2_conf,
> +			.confs = an7583_pinctrl_drive_e2_conf,
>  			.num_confs = ARRAY_SIZE(an7583_pinctrl_drive_e2_conf),
>  		},
>  		[AIROHA_PINCTRL_CONFS_DRIVE_E4] = {
> 
> ---
> base-commit: 57916750bc0886917ea2c6209ca6a56acb7b8182
> change-id: 20251112-pinctrl-airoha-fix-an7583-drive-e2-confg-usage-bbf4cff20b50
> 
> Best regards,
> --  
> Nathan Chancellor <nathan@kernel.org>
> 

-- 
	Ansuel
