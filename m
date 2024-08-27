Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7605F1D31A2
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 18:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724781855; cv=none; b=SxE7CIeQOCwiu89C4M3W2oBYxgS0/bpXOFTa363qtE1e1TLAvhvVgtiOT0HZcQrmc+dskWvyK/+S7C3UiCJHUx/ot/6koz8mtv+IHhlRg7gPxq/xaQ2fQeNgKMKpxjylqu8/DqnkyjuCG/QnKgo7NVsQKbsIddST0dH6aRrawME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724781855; c=relaxed/simple;
	bh=dMLDKe44fCDwnHMVTWPeFlG+Xo4vnWXVI5dcdgD1bYs=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IkNMrpN18sxpia0s1Fq9QsZwI0uAhHKDt+w1VOtNMFlCVDFGHHlukTuD3tCoz8YPdG6hG+QQvOhqgTdcDMLfoJVTsYpokXPi6di97X+TeV5L5MSwx0DgG9m6pn2pap3oCZJqrDLdpy7iwcpimhiDXUaldsFbZcXy3CPDBRLWLAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=a5VkSKYa; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="a5VkSKYa"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e16582cb9f9so4396174276.0
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 11:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724781853; x=1725386653; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dMLDKe44fCDwnHMVTWPeFlG+Xo4vnWXVI5dcdgD1bYs=;
        b=a5VkSKYaFAOMhKiTOeIPJbgdcJZOSSHqzJXjgz4Pp7YMkPyutXl94g975yFeFdb7L7
         PENk+Ha+lVCBkEPZZ+oe/ysCe1xuBvsgWIMEd2aQtiUYTYFZSnDN4uGK/6lzKJ8L2JKK
         VyGkK/JVJ2x7JPe4q8EI6C1FsKDXOd+6LGYJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724781853; x=1725386653;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMLDKe44fCDwnHMVTWPeFlG+Xo4vnWXVI5dcdgD1bYs=;
        b=n9sEf4VjTG1+o3JUhiZ5gQzLEUOI6u5k2Gb8hUqbK1pcvpWdLoVVmn9EJxfqRvT71T
         4KK0udU0rO8jztVWaxyMMna6fMBDTHa0xPU8WErAiOzyusEVEl4/PIbWlyxGqJ8PNfmA
         GZpvFXjLEx5ZGVsdKyoRvVwY1u0LJL15JhkffHziXSQRxWCbthn5jZmNvC5A4FDeu8zV
         VIVW/Pqlzzyg9OlgJU2dfwNBMV6YGvAbMdPZGHb3kFE0UvP/qgfiNDQw6JFPNyLxms9R
         EYWRZC2YGuItdpLr9HY5Ng/6RHh+Tp326p3PMoRBvqkZWVVEpyy/db1zMWeM1tkGbOp/
         a0Nw==
X-Forwarded-Encrypted: i=1; AJvYcCUrkcmVxuJ5+xrZQw0Ij0CKZxtt2fxlp2POnsQTuHf5dii56gK669LKhKBtk0/tB0AAqHqDpVw+@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0rj2/X8LZeb7oF9544FjXArKgJ/L7L1KmPwJBjc5EqsT7Pfwk
	H4NgTG2jpuL9AOe2UqcgUlvC1K+BfSwMdjOB9W3WnPOLTQUZUOGzOZpHqzAGlXp9CGIL0R1jon2
	ymWGFKMOkB8TO07WPwNVryDX19L2Mg1rh3Tb6
X-Google-Smtp-Source: AGHT+IE0Bn9i/bUKuhoTzrKG4rVSXstRxEFMj4JTAl4ym01IvcLZrTD5rOM1gwCNkQJJ0jrFSUsDnYcxg59QUJYwibU=
X-Received: by 2002:a25:dcc5:0:b0:e11:7588:3329 with SMTP id
 3f1490d57ef6-e1a42273847mr72517276.7.1724781853199; Tue, 27 Aug 2024 11:04:13
 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Aug 2024 18:04:12 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240819233628.2074654-3-swboyd@chromium.org>
References: <20240819233628.2074654-1-swboyd@chromium.org> <20240819233628.2074654-3-swboyd@chromium.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 27 Aug 2024 18:04:12 +0000
Message-ID: <CAE-0n52xg2ts9dm4cG1CmevrD0Gn8d9x+VvK8av8Fn8esoz14g@mail.gmail.com>
Subject: Re: [PATCH 2/2] clk: qcom: gcc-sm8550: Don't park the USB RCG at
 registration time
To: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>, 
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	patches@lists.linux.dev, linux-clk@vger.kernel.org, 
	Konrad Dybcio <konradybcio@kernel.org>, Taniya Das <quic_tdas@quicinc.com>, 
	Amit Pundir <amit.pundir@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Stephen Boyd (2024-08-19 16:36:27)
> Amit Pundir reports that audio and USB-C host mode stops working if the
> gcc_usb30_prim_master_clk_src clk is registered and
> clk_rcg2_shared_init() parks it on XO. Skip parking this clk at
> registration time to fix those issues.
>
> Partially revert commit 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon
> registration") by skipping the parking bit for this clk, but keep the
> part where we cache the config register. That's still necessary to
> figure out the true parent of the clk at registration time.
>
> Fixes: 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
> Fixes: 929c75d57566 ("clk: qcom: gcc-sm8550: Mark RCGs shared where applicable")
> Cc: Konrad Dybcio <konradybcio@kernel.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Reported-by: Amit Pundir <amit.pundir@linaro.org>
> Closes: https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---

Applied to clk-fixes
