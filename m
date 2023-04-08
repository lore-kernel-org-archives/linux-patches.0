Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC391841
	for <patches@lists.linux.dev>; Sat,  8 Apr 2023 08:22:49 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id e13so386944plc.12
        for <patches@lists.linux.dev>; Sat, 08 Apr 2023 01:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680942169; x=1683534169;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GltkJScZYSX+gCVv8fDFnm+4Lcp2TEGrI4CsgsLokKY=;
        b=hBybsKOi8iTMHwZ9Ikc0Cmt6Xe3w4OGcCWqYQIE2fC+MbNbxTarOitAGi2P0ZWwSeh
         iKPtVkSsN3nS0z43OhQRzLzc3JbxJdoNpZOSnkAe3eIiszDGzlx6bdrj8uK5D/3K86IA
         C43fnJLHf24T36c7gg8tfpMjvXDJMaohzqUhw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680942169; x=1683534169;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GltkJScZYSX+gCVv8fDFnm+4Lcp2TEGrI4CsgsLokKY=;
        b=vRRbkxHkjO/o0vzcnM+BkS59i+ZHGz3dbK4cIY2iLgFGidzbkmpemdv3UdX8rslHqp
         u9LSJMfurWneCVNaHZ+bUuTMyHbz6krR8SIHARaeHuKo3scrmk/Jt3LNtVyDI3bKFRWm
         vSGyr1utMt7V83SMlcZk0Yh4AHffH24lc7sLRhH9DP546STGSKqXKeYtpVvlu1NBk76A
         BVA9NYcNaCQK10zUvA1AANMTc8R3RccehxYpOllrGf53TF2Xiy7FmgkAwIQhQmnK/pPu
         pFXz4MIcUyLFSzoBqktPjcZz4uyDqoIuE+CNeqmbRdxwecGTfw6J78UOv9T2shukQ45w
         dwBQ==
X-Gm-Message-State: AAQBX9fSCvJ0zu9OpnrU39frJjHk7zZrXlRX4/k7+P/3Waj1bhaKIb+1
	C+/PbN/yofOZUE6KoXYttTpddQ==
X-Google-Smtp-Source: AKy350YUW70L/4lbimyDIKZoumBSIx5N8MLRIqbM+/F7jMO+dCl4QxdIyqtRfp3NsLC5KYpYQe4X4w==
X-Received: by 2002:a17:90a:4f01:b0:23d:1a5c:ff3d with SMTP id p1-20020a17090a4f0100b0023d1a5cff3dmr5920279pjh.37.1680942168989;
        Sat, 08 Apr 2023 01:22:48 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id g5-20020a170902868500b001a0667822c8sm4041197plo.94.2023.04.08.01.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 01:22:48 -0700 (PDT)
Date: Sat, 8 Apr 2023 17:22:41 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de,
	peterz@infradead.org, song@kernel.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH v2 1/2] Change DEFINE_SEMAPHORE() to take a number
 argument
Message-ID: <20230408082241.GA12866@google.com>
References: <20230405203505.1343562-1-mcgrof@kernel.org>
 <20230405203505.1343562-2-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405203505.1343562-2-mcgrof@kernel.org>

On (23/04/05 13:35), Luis Chamberlain wrote:
> +++ b/kernel/printk/printk.c
> @@ -89,7 +89,7 @@ static DEFINE_MUTEX(console_mutex);
>   * console_sem protects updates to console->seq and console_suspended,
>   * and also provides serialization for console printing.
>   */
> -static DEFINE_SEMAPHORE(console_sem);
> +static DEFINE_SEMAPHORE(console_sem, 1);

FWIW,
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org> # printk
