Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E28B7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 02:36:31 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-63b4e5fdb1eso4965575b3a.1
        for <patches@lists.linux.dev>; Sun, 23 Apr 2023 19:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1682303790; x=1684895790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Er9IodKAhu5Xy/24MmuM3ISnj8SFsqKhcDcV85YYtd4=;
        b=Myis4J2Z9lmx+G/UGHQV666UFM6OJ8EKtdAre2rvRUUjU2E+rQLKwJ+D0eYgmT72Z9
         5SaX6H/C77vylvdgFXO4tn7m7ArVvZvZSOxiW6NiLDX5h8w4cEfp1YoxEuHlyRXPz09e
         5JgUmEmUJwM1H8XEmuezqPmJ+lzP8zXU2UJcc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682303790; x=1684895790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Er9IodKAhu5Xy/24MmuM3ISnj8SFsqKhcDcV85YYtd4=;
        b=dpk/MvoES5pXTZuXA5FDDo1USGeS6usN8/6SF4m98uQhxs8HmLPTN2PRG9mBCDXTuc
         mk0gcoIIhbpixzQ+aYh5EbYaSCGxnnFrSRovwZkw69EsBza1kqKH8yIwq41dz/SEeqcS
         UeBQ7clt2vVhkmpwdVBx0KaWykbrfRbbqt6JZwDh4NHObzMPH/aiSnt/AUixV2crFXCW
         ziC/NSGd2hL34JDmAjFOmVUzMRP52A2FAUFcEyo0taUyDhm+X9xp9EQd4OtYC+pFPzWO
         QcaxFZ7Zul1YuGOt6hOFADMhnWFgy3SlpeO02gn5wAwnqlQeeVhkIMQt2PufJ9NKErMj
         4dkg==
X-Gm-Message-State: AAQBX9ee47OYa0rmPQQnfc1wKuIELI81ym3NkN5pgowxPu/koPYhu9+I
	norI/VULyr7b4G5FNGXWFYwkog==
X-Google-Smtp-Source: AKy350a438RODTsIQbvbOZb4mhoGqhZ1pvzPivBPJ5Ra5hjJQnsR6/IRQqkIVQmM+kaUu2d3rd1IMA==
X-Received: by 2002:a05:6a00:2406:b0:63d:38aa:5617 with SMTP id z6-20020a056a00240600b0063d38aa5617mr12656579pfh.6.1682303790512;
        Sun, 23 Apr 2023 19:36:30 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id h8-20020aa786c8000000b0063b8279d3aasm6183422pfo.159.2023.04.23.19.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 19:36:29 -0700 (PDT)
Date: Mon, 24 Apr 2023 11:36:23 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
	philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com, hch@infradead.org,
	djwong@kernel.org, minchan@kernel.org, senozhatsky@chromium.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
	willy@infradead.org, hare@suse.de, p.raghav@samsung.com,
	da.gomez@samsung.com, kbusch@kernel.org
Subject: Re: [PATCH 5/5] zram: use generic PAGE_SECTORS and PAGE_SECTORS_SHIFT
Message-ID: <20230424023623.GC1496740@google.com>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-6-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421195807.2804512-6-mcgrof@kernel.org>

On (23/04/21 12:58), Luis Chamberlain wrote:
> 
> Instead of re-defining the already existing constants use the provided ones:
> 
> So replace:
> 
>  o SECTORS_PER_PAGE_SHIFT with PAGE_SECTORS_SHIFT
>  o SECTORS_PER_PAGE       with PAGE_SECTORS
> 
> This produces no functional changes.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
