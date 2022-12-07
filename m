Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28953376
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 01:17:11 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id b11so16147411pjp.2
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 17:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I+qLY3EPYZFk3S8t9GrwbvymykpEf3arJ9+0HtFcXNU=;
        b=fjxxThz5ilAc81V5nEwm3dd/bCA0zYXEjNzp1v0Gm4rtpssjcl6lCv5ZT5xQwkJEwI
         ThMhPc7S8fh0CnEh7m/CtQ39yIw1qLN0JfhfZuj3En79JDp30Guc5RUH8rBl0RV9WFEY
         Pl94WzpVWSwnyf2ZVxJHKFhSluUobf0gWhpSvhipad5Yg/A8hHTHoA1URSpaE9b5WMxH
         jVsBc7BDiXat0+cV42MdWNQa4EVTfdul7kg5lg0hri1gtOsqeLuMh9B8IxuT4hXHlmuG
         plRooBm4sq0VU6Yeb0lH+PIKC5kf84bPWe91xWvYEaSVGgIX6lvBpDBQo6FZrv19CsXq
         9Xvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+qLY3EPYZFk3S8t9GrwbvymykpEf3arJ9+0HtFcXNU=;
        b=hOKkf/c/JOCh6H3VbB94RGQTpMC7ICbkmZdjL27SnXaAzymFnxkK7RSWnx97EI2Xio
         Un2wXw2n3/HE6Xll3zrz6aKEVDnU/MFB/sF8cMkCeqsm/njQZEaoZAr2iCeRtx+nZFHB
         553pwCnOLEq3hgiF0TSRm5Lkp/2nwOnA9L/BX3KBIVfV1U0RMrGYZxl/yT1EzRN2R4FB
         EfTpt5vMVcnVfPxIVCT24PbRW8zlBAXrie3qaecX1w7h+c5tko/3A0Qt4FIP16ltUtvR
         XCy+qD3a7vhqXKj+vy2+GHNh7sorgupTAq3CHqL8K4ppB8QystWeXYCAyCF1SHKQoCW+
         u9Lw==
X-Gm-Message-State: ANoB5pl3soEG1fJu5JTwddell7PilIkvzWyeNjtqkcsBsDqI61agL8C+
	hP8UyRgsN/HifkVNGlTyrfo=
X-Google-Smtp-Source: AA0mqf5Vw26+iSPBq95kHhdzX3ISKNub3Ao5W23bX1P5KDcEaq8mCi7EAvfTnjFqiRRS+ayD79/NdA==
X-Received: by 2002:a17:90a:e556:b0:219:b502:a2d2 with SMTP id ei22-20020a17090ae55600b00219b502a2d2mr17823250pjb.230.1670375830461;
        Tue, 06 Dec 2022 17:17:10 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:7a61:38c7:d37a:7f43])
        by smtp.gmail.com with ESMTPSA id z18-20020a170903019200b00177f4ef7970sm13326204plg.11.2022.12.06.17.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 17:17:09 -0800 (PST)
Date: Tue, 6 Dec 2022 17:17:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, linux-modules@vger.kernel.org,
	Piotr Gorski <lucjan.lucjanov@gmail.com>,
	Nick Terrell <terrelln@fb.com>
Subject: Re: [PATCH] module/decompress: Support zstd in-kernel decompression
Message-ID: <Y4/pkgE+xHLt9Sm+@google.com>
References: <20221206215318.3955400-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206215318.3955400-1-swboyd@chromium.org>

On Tue, Dec 06, 2022 at 01:53:18PM -0800, Stephen Boyd wrote:
> Add support for zstd compressed modules to the in-kernel decompression
> code. This allows zstd compressed modules to be decompressed by the
> kernel, similar to the existing support for gzip and xz compressed
> modules.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Piotr Gorski <lucjan.lucjanov@gmail.com>
> Cc: Nick Terrell <terrelln@fb.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks.

-- 
Dmitry
