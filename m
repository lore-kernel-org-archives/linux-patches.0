Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC14EC3
	for <patches@lists.linux.dev>; Sun, 12 Mar 2023 23:31:10 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id nn1-20020a17090b38c100b0023d059f427cso1030504pjb.2
        for <patches@lists.linux.dev>; Sun, 12 Mar 2023 16:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1678663870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xGsRfyWirO1vSkNZurgVxrSIuOQUCszDrkoyMT09sQs=;
        b=NboYJvQ0YuDQbYw2M1vU9JVEzDJsjSLEbY9WsRGsLeDGylvi9+jWzHvjyQsXInv/vh
         5dUJGO59oE44kzMCqDvvyK9i0mAI49aWsGk/ZzRr4oHwPjQEyOFnMSvHgALiQGhLiXTr
         JMikS88mniyswWrjBAkLMdqzfLSR8DccSOsu/MwTwTCb7kPiUlrs4CTmAffKJiqXcxuq
         gwVJ9E1bcqrT8qMzrAWeleGhPrt7/Zdr9E4DiOXQgyCY6+E+CZMhIIJcw+DDvxKI9NQF
         2wxmm4cljnXAien+Q36htyf30E7LxnGeEvszsGg5zaVw4uLiKB4Xr5qJiFuqmHC1KEBY
         H9dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678663870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xGsRfyWirO1vSkNZurgVxrSIuOQUCszDrkoyMT09sQs=;
        b=QAUFQtSSBwjk4VGndXZAyG4HU1+e+bLaOEI/fi7fKlY7AJyLGttYfvKMoZYVaSSWsn
         Shwse/7SYIHC0PN/DrZTQYv+uaLJ0gTYRAJbkvUCRviapzWZAydQfAx4mxyHYfpLJ/cV
         HuaC9uUuwhX9AJUqHL9IEXT9y5FPrGQTCVAfIKyHCYi2tZ8eAxjTzKO83hw985wwKAgy
         iK8jEdyIz7KA6qvEPPKnFs/kXnjNnJc1AVRtZhSLce5tA7KQuyatwZCBm+nytZ6jlDtd
         0J40IgUHWNfqrskqWSde9AMPXsNWqa91LhiAGGAzIn6q0UDNmzGGdQZKYjPHW+zZ/wPw
         fWJQ==
X-Gm-Message-State: AO0yUKWPyjlqPBcskFqOvZfEK9t2zG6fs2w0Has2Bwy6nRkMhswNzh/4
	YPcVaTso9uqrb98maNrayFwETQ==
X-Google-Smtp-Source: AK7set8Fgsjo4bRIW0pN3fgU3x2K1goOzHfUWcYXBk2t7zY/FyA9xynwVPuBAWLpp35yhUEYeP8MOw==
X-Received: by 2002:a17:903:120b:b0:19e:82aa:dc8a with SMTP id l11-20020a170903120b00b0019e82aadc8amr37238346plh.22.1678663870328;
        Sun, 12 Mar 2023 16:31:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id bb12-20020a170902bc8c00b001933b4b1a49sm3311784plb.183.2023.03.12.16.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 16:31:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1pbV9e-0083Cw-KQ; Mon, 13 Mar 2023 10:31:06 +1100
Date: Mon, 13 Mar 2023 10:31:06 +1100
From: Dave Chinner <david@fromorbit.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, keescook@chromium.org,
	yzaikin@google.com, j.granados@samsung.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: simplify two-level sysctl registration for xfs_table
Message-ID: <20230312233106.GP360264@dread.disaster.area>
References: <20230310230219.3948819-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310230219.3948819-1-mcgrof@kernel.org>

On Fri, Mar 10, 2023 at 03:02:19PM -0800, Luis Chamberlain wrote:
> There is no need to declare two tables to just create directories,
> this can be easily be done with a prefix path with register_sysctl().
> 
> Simplify this registration.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
> 
> This is not clear to some so I've updated the docs for the sysctl
> registration here:
> 
> https://lore.kernel.org/all/20230310223947.3917711-1-mcgrof@kernel.org/T/#u     
> 
>  fs/xfs/xfs_sysctl.c | 20 +-------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
