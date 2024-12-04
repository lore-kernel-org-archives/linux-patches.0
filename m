Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2002B149C53
	for <patches@lists.linux.dev>; Wed,  4 Dec 2024 03:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733281838; cv=none; b=HdMZNHWvaM+g6V5SlaIPFrKtXE5b50qNerS2MGBVYaEgiVEYLAlzLD1MGE3uNkBWi5SuDr3vs+7GBzxw+m3KxGrFOzuuQW/Wdk3Ds9maqT9pSDEahlsqTDd2FaCVD4Dckw5KOcohmyGsp2msN4qUw5yffIlwMmfqYD6qtix+USU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733281838; c=relaxed/simple;
	bh=5BJcVqk6DTq3D6w4oC0l72ZIPdhLBjr1W7ee3Bk5PEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AhhQQXO7sazixMs7lXBxtr5fMVoFHj/y1XA6PDPQbQysuJSZ7mELW9ATagDC0CxYbKnRE4vO6OMBqES6zmnuJ/XAkwn9scIj78H4Mhg6oSEmRQhJB7OTbEmF8TIM+uj4ywU9h7WbjWPm/4OHmCCnO2pNYUZD9UCp8UMd+MO+qm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ANatuMYy; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ANatuMYy"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7ea8de14848so4372935a12.2
        for <patches@lists.linux.dev>; Tue, 03 Dec 2024 19:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1733281836; x=1733886636; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iNiwGOMCqkTh/NdTdB70sdVoyZNDTHaO6MJHeQ4EdJQ=;
        b=ANatuMYyj1wjCFM2rFCNPvijVJFYU0N7LpUGcGgMIoBrjOCYINUOdW6MEcYrq5afnA
         khUjz2SmreyDy5j1fzxEpiLCU8jq/Gm7uO0R+wU1GREjkuTvlEulYnhjnkFrZ5ZNFyLe
         xGAJIi4ykWBiTBRWk/tR3k+nvqxOALjxta04M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733281836; x=1733886636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iNiwGOMCqkTh/NdTdB70sdVoyZNDTHaO6MJHeQ4EdJQ=;
        b=VWRxWawvKp3N8A9LOtVuTv7oia42hmCr22kuzmYu4A6FDdvkCnNFW/0ReWVaW9TlZC
         Op7YhDUnAfa3+sHgZaNOGuML0xknhKPAK4eLmA3WMw8NmvMKbqF5ZXwKWVoLjlwgrUiz
         S4Zf7Hc3M/r/QLe5urWd52RhMz+AzrZYmWsRmy4AjwVBOL7R1MJh4bUwmNVpTnja/NCS
         f49tTWlNx4JwEko3fbYj0rdrKhTPBBc35YPmiv4aYdCweGSnxL2SXJIAMTerVWzmND7h
         oK94rd1UQLkZa37muuel6SfK2wC2sQi0ISsVGXdH+IyP8Mu6f3vFOgNQmr+JydFhKDFU
         iBhA==
X-Forwarded-Encrypted: i=1; AJvYcCWSlelQclR0JZa0LdzxlBbfl3ZZ+xgoLNcw+ljHEpHFnRgWYuYzs5Hpv+4IbmyfQ4Samq64WVs0@lists.linux.dev
X-Gm-Message-State: AOJu0YwTN/M4coDAQ+0p1mZYXfpYpIzyIWDm6tAsbLrUFtGwT1oqKu4D
	H4mmnBR5XKYlOvZvvu8c7AKZGOOyUhr43niNN4tugg/Pmc4AIpdmFHopju1/Ug==
X-Gm-Gg: ASbGnctWSvmj2rMEI/olAy0cAEOMxMBnxkzOyagTq24u5oBNh2DCNqRJURFRdtMncMS
	+uH3oaI1i90EF6IqTK0sfRlbt7EdnXdqDw9e8N4cvMoRcOreDvMpgY7rFfJTjUh8WEyocYoxX4j
	fNHHH7nFsji6oarJ+5a5E+0miHft3SwCx7hgeEABvVZzcVVsRu6WdkGqGx3aYF+juMkVwheoA3i
	Mvp7YxDuR4P5g4mbdaCsHa9lGHRuRus1ACfaEouel7ddEB7Hg==
X-Google-Smtp-Source: AGHT+IGOh6c6XB+Mf7vja/zLx4pOyQUTl+vZY1mp61nLNQMy+svMsSvj7/cb2KEHjHiTEcma/HAwBA==
X-Received: by 2002:a05:6a21:78a8:b0:1e0:d632:b9e0 with SMTP id adf61e73a8af0-1e1653b7c5amr7319355637.13.1733281836467;
        Tue, 03 Dec 2024 19:10:36 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:f520:3e:d9a1:1de])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7259056e0d5sm151570b3a.81.2024.12.03.19.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 19:10:36 -0800 (PST)
Date: Wed, 4 Dec 2024 12:10:31 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Tomasz Figa <tfiga@google.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.11 207/817] media: venus: fix enc/dec destruction order
Message-ID: <20241204031031.GF886051@google.com>
References: <20241203143955.605130076@linuxfoundation.org>
 <20241203144003.826130114@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241203144003.826130114@linuxfoundation.org>

On (24/12/03 15:36), Greg Kroah-Hartman wrote:
> 6.11-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> 
> [ Upstream commit 6c9934c5a00ae722a98d1a06ed44b673514407b5 ]
> 
> We destroy mutex-es too early as they are still taken in
> v4l2_fh_exit()->v4l2_event_unsubscribe()->v4l2_ctrl_find().
> 
> We should destroy mutex-es right before kfree().  Also
> do not vdec_ctrl_deinit() before v4l2_fh_exit().

Hi Greg, I just received a regression report which potentially
might have been caused by these venus patches.  Please do not
take

	media: venus: sync with threaded IRQ during inst destruction
	media: venus: fix enc/dec destruction order

to any stable kernels yet.  I need to investigate first.
