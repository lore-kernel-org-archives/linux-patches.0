Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833FA128816
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 00:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770941798; cv=none; b=fFroZGS9YWINgPFKLOrKjIyfRfpam9ruH1B/hReKfujsLyRBlgv7CKpJ5GcGkEKE/k5B1xyRljvE8m/t3Rb37aMDxSzChZ0vST2wJXo2i3/Qe+I/Us43bIUbuYruPQ/+xxt8H4gw4j658OcoyW26vQlu/FQZBpHSI2rWlJcG+1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770941798; c=relaxed/simple;
	bh=Bjue3QOpIjKbVkSdodL/+toTxYDAijaIIOR7ocEymxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nSw2lGD1sb+kp12O8b10yn/l4Rcb4rJDLICslnP0vKnDOn4omUBDQy1ebhURXA6h68qcxGnht9dUUVrm6sozCPMVfeD5pCRGXXPajN501jtUo2yLB1xzhv6WY05mOqfcqse9Z3ymT9cOeXd+XDEklAzKjikh3QPprZQ1FD+2VOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nxnlli9X; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nxnlli9X"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ab077e3f32so1475285ad.3
        for <patches@lists.linux.dev>; Thu, 12 Feb 2026 16:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770941795; x=1771546595; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rJJWFT1l7GNpPMZ8f5fVGYkrxp6Tw+LeNuPObvL9Fe4=;
        b=Nxnlli9XyAoz34JsOMeST/8EHc0j9ms075p8nMxl9u92rkTcYdYXk/AEeBRrn72Olw
         gUijMN3GLusalyuGGB5GDNWVvwJV6hKPaRRgcBKrE6Wzg+TQnCvddm04IMXaizZ0yBOh
         Wn/koBM/M4c9ggxBxrdZK5EI6EqR81ddfXq+NZgdW2/isLzVRzOoslVcg7lzCE02W09m
         J+iZcU6JQcbT23HsCw6M6lsg5/aUnDWVzVQUdIQJKIGKW68iXyTCQB0v7gX3UlJTBQuj
         +cbsUe1l7jgwq2NUnwovEsYLruu5kAUtPvmSc/b1WUipDO8sXqh9JsxKZrCvqyj1NNDz
         4dlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770941795; x=1771546595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rJJWFT1l7GNpPMZ8f5fVGYkrxp6Tw+LeNuPObvL9Fe4=;
        b=lsz56iSlle+DnP1DH0XgGZk9Va1du1Vxd2/rkGg/VXCORjzCNZr74qr57VYee0VmM7
         4ElvCBfE+uhR0kHCE+BOHEX1wgXTqZmbIPAy+s0cZnfMr9GiX42dPOV9khyA6xRUL2mD
         UBBLyptAimsUiJhXGKlLepsa+H3tvCgaOGn4U59vez9endz+X+sKo6qdptkr8pzYASJZ
         +aHmPddCwB8GjHkU9GzWUHtT8VhUEZuBuFcQjFepTgX1mK8jYMn+f5lNFL85j0zZvt7O
         4sDlMb/hQD5zxtKrRRn6efTk1wd6TAq8JmSUqZ6IeIHeHjUiVa8m1YKGVCPAVE0KkMoU
         PpkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwUpIcAQbyXaeCzkfJSWRtnImWA6kolTXPef7KDFWpGIApM1dVVu/MpXvFlHdAKbEfXV2yDGgz@lists.linux.dev
X-Gm-Message-State: AOJu0Yzh4I8Ra8K1bTV6ujcKYV5JR+1QMwMoTEbjI5xZMbLlNaBrZdP3
	UB1OiNEdJQRLK4WecBYvXkX8fphjsKl5TlEcaads1ekDG6QD1EiO8Fca
X-Gm-Gg: AZuq6aKH0gm7VxL6cFJkNEWgHvMrb1kh9wIT2/Qh+2ou/Q/IodonvJOna8Jk7np4Moa
	R37wLt2NiANmHny4CD3Pk3QdPt5nrz2NePr6nXgFctqpfbsU2nZNRJcKa/EfwnOCnatO1b8yezc
	3ZsYh0qq+IdaehEdgXqLQxck0vmc4xc0PDyJ1XiWbkiPdmRcNqMfXb0xA/2BmOTZ9/KemrKBGsF
	qEzwzg23tMviv12xnfe0nukTkyZoeRWg92yFXlN6Tbjl5bjsbOWMuoWbHVgclsn32tUyY9l2dfi
	sOMEuUIuqycEw+eOcUiZeDEfWaYxpdPata8gKKwbWYvcHYKWivlg5F/z3LqLeUARzYhhrehIwfU
	m5zF5yJnaLDUI1UIo2zLVtigDSG/ZjeiKpo6j121XYn7cv7UK4faPUnIhwxxrKFgQyq04Vg6wQL
	nB/iE25gRRNCfTeK21Vi+Av/2r2qsnNlmnuIuX
X-Received: by 2002:a17:902:9004:b0:2aa:d5ea:4cfb with SMTP id d9443c01a7336-2ab504cabcamr353655ad.9.1770941794707;
        Thu, 12 Feb 2026 16:16:34 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab29999c80sm60524925ad.89.2026.02.12.16.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 16:16:34 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 12 Feb 2026 16:16:32 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Shida Zhang <zhangshida@kylinos.cn>, Coly Li <colyli@fnnas.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 30/87] bcache: fix I/O accounting leak in
 detached_dev_do_request
Message-ID: <df94d6c8-f236-46a7-9053-40b00a3a1a5b@roeck-us.net>
References: <20260204143846.906385641@linuxfoundation.org>
 <20260204143847.995871393@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204143847.995871393@linuxfoundation.org>

Hi,

On Wed, Feb 04, 2026 at 03:40:28PM +0100, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Shida Zhang <zhangshida@kylinos.cn>
> 
> [ Upstream commit 4da7c5c3ec34d839bba6e035c3d05c447a2f9d4f ]
> 
> When a bcache device is detached, discard requests are completed
> immediately. However, the I/O accounting started in
> cached_dev_make_request() is not ended, leading to 100% disk
> utilization reports in iostat. Add the missing bio_end_io_acct() call.
> 
> Fixes: cafe56359144 ("bcache: A block layer cache")
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> Acked-by: Coly Li <colyli@fnnas.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/md/bcache/request.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index a02aecac05cdf..6cba1180be8aa 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1107,6 +1107,7 @@ static void detached_dev_do_request(struct bcache_device *d,
>  
>  	if (bio_op(orig_bio) == REQ_OP_DISCARD &&
>  	    !bdev_max_discard_sectors(dc->bdev)) {
> +		bio_end_io_acct(orig_bio, start_time);
>  		bio_endio(orig_bio);
>  		return;
>  	}

In 6.12.y and v6.18.y, the code continues:

        clone_bio = bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
                                    &d->bio_detached);
        if (!clone_bio) {
                orig_bio->bi_status = BLK_STS_RESOURCE;
                bio_endio(orig_bio);
                return;
        }

The NULL check has been removed in the upstream kernel, so the error path
does not exist there.

It seems that the above code is still having an accounting leak if
bio_alloc_clone() returns NULL. Is this indeed the case, or am I
missing something ?

If I am not missing something, is it necessary to add a call to
bio_end_io_acct() into the error handling, or is the problem theoretic
and can be addressed by backporting commit 6ea84d7a92cb ("bcache:
remove dead code in detached_dev_do_request") to v6.12.y and v6.18.y ?

Thanks,
Guenter
