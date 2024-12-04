Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D9B15B97D
	for <patches@lists.linux.dev>; Wed,  4 Dec 2024 07:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733296609; cv=none; b=Z42k4MU8svYGR48DNTH3kE5yXaBOtiJpZFAttCVY9dO7wKhVsINGG7HoHb3ogBceIMbwATUnnmGRCRBgwt1BLSVs08jQNIH4Bxk/us6m+F38/l8qFAL7anhmh4Hgv6RqiMmETcqSWYSTe+oYZNDUuhid1klHJM4SXqmz1DL3l5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733296609; c=relaxed/simple;
	bh=OyLR3bE/putp0qpg8+pwfz01cSmMLOjPgcz4ysL6rjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YOX8fJmG6tSN8z+XrfalMVck4Lz7FAP3PHuTP/rqfubVIe2O5N2GtUQRiwddR9mzDfANuQZ/ets2OCksiLpV9+ndzQVH/r/yR+L5nDBF7b84orA+Q/nTIWT2fAAXTcoZhanZxo+Wc/G/FdHC5Rsq3GsxGSb++1ttxTY/6hqRLLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=KBB7oqhH; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KBB7oqhH"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-21561af95c3so32789805ad.3
        for <patches@lists.linux.dev>; Tue, 03 Dec 2024 23:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1733296607; x=1733901407; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jShvVE3mVoX8qZqeJ1TxXuJz9big4GN6ZMKFhtrVj6o=;
        b=KBB7oqhHh0p/se4KTTYWJXbMhlnyLW0OtetaMBc551S9eLtRbAsl+K6naDWZnOdTLq
         7msnpAUahOd34U8HL3EspWFusUaxAtVo/YI8T2GFkXJ4ZRkeIyoSBe9wlHjvUVJyp4gv
         QUYAfm6Ea6axUr4iVdbCxYyzK3lJiryWeDsp0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733296607; x=1733901407;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jShvVE3mVoX8qZqeJ1TxXuJz9big4GN6ZMKFhtrVj6o=;
        b=tEMmkeJJnCCY/Z8QYtwblX9lqKgng1HgBKSCVgGNusaxo3PpNsnBwE2AyWkaLBJ/e/
         URTna6fyoFlarS8pACwk0m3ebbziwVqtTPzizGzK0AQJJ4GRlOdmBxmzpSirqeD1QeeT
         hVXnEVLtXsjF0D9gFz+FeWV/HRXg2bpiKdZency7GATBpHaNDUKIz6lgepSD9UaOa66/
         k2FPa7iJTCMklSdZIHwc5Bq7AEBnnReLchPJk2acTEMolIMqlqeuAYJnCAxPHdjno5EI
         BbK8B4uGFKCjjBVH8pvcx+kpbGHgXoMzzVw7c/QrZnb82/PAF3uRBKd+PYhg776JA+UU
         JakA==
X-Forwarded-Encrypted: i=1; AJvYcCUVIT2w5ArObE41sSbgw1yK4anwXm7WbsMhr62wuCs7rthJNXsZJt2lCKZongBfBjp89hOHVePb@lists.linux.dev
X-Gm-Message-State: AOJu0YwJW5RADizcbJV9G+J9eijLD1UZmnnvVMFzQoMP2ucThUsoBsY/
	b8cl3k7SGVYSzWrxAayUtwH+l1fUyl1pr7L/MH6+98ehppdTx/kLa+Oa2ZBsSA==
X-Gm-Gg: ASbGnctzBaGiNX388TcfZjy0PZm6yuTndgUOgtAYqXl4Csv4BC1wP4GDBDUDd7s/mML
	9WTey+PZcOLRRbCkasHiWWQ+w5Av+7oCfOQiMUADQGBYm48ulUXFi15f7Cw5guPQjsWC6qiiBIC
	QKRC7o3SuQmGyRSEGFmALDOxwgchlDr8jRZAor/ttoLvjh8ztsiVnhuJxGyzYUn6aq7YAQD7oLU
	s33cVswiYwVCG0YDLgn6vInHqx4AL1ZsZNEF948FjrlXRkXCA==
X-Google-Smtp-Source: AGHT+IH7MwYL3y42hcABxkEztmhq2Q67GkUb6bnHPA6IoXTpf1xN74Ohq2ewMXk/zuqxOdIvT2pR+A==
X-Received: by 2002:a17:903:2447:b0:215:431e:e0f with SMTP id d9443c01a7336-215bd0cea0amr73075845ad.28.1733296607076;
        Tue, 03 Dec 2024 23:16:47 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:f520:3e:d9a1:1de])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2155be9b42asm71320345ad.135.2024.12.03.23.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 23:16:46 -0800 (PST)
Date: Wed, 4 Dec 2024 16:16:42 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Tomasz Figa <tfiga@google.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.11 207/817] media: venus: fix enc/dec destruction order
Message-ID: <20241204071642.GH886051@google.com>
References: <20241203143955.605130076@linuxfoundation.org>
 <20241203144003.826130114@linuxfoundation.org>
 <20241204031031.GF886051@google.com>
 <2024120433-paternal-state-098e@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024120433-paternal-state-098e@gregkh>

On (24/12/04 08:10), Greg Kroah-Hartman wrote:
> > > From: Sergey Senozhatsky <senozhatsky@chromium.org>
> > > 
> > > [ Upstream commit 6c9934c5a00ae722a98d1a06ed44b673514407b5 ]
> > > 
> > > We destroy mutex-es too early as they are still taken in
> > > v4l2_fh_exit()->v4l2_event_unsubscribe()->v4l2_ctrl_find().
> > > 
> > > We should destroy mutex-es right before kfree().  Also
> > > do not vdec_ctrl_deinit() before v4l2_fh_exit().
> > 
> > Hi Greg, I just received a regression report which potentially
> > might have been caused by these venus patches.  Please do not
> > take
> > 
> > 	media: venus: sync with threaded IRQ during inst destruction
> > 	media: venus: fix enc/dec destruction order
> > 
> > to any stable kernels yet.  I need to investigate first.
> 
> What are the git commit id of these that I should be dropping?

Upstream:

	6c9934c5a00ae722a98d1a06ed44b673514407b5
	45b1a1b348ec178a599323f1ce7d7932aea8c6d4

as far as I can tell.
