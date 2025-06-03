Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A3D38B
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 12:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748953119; cv=none; b=KN5mF091rLsdrzTSIRYMs+JSMjYP/bdBBYaabqGCrmnInrJOUVWa5y22K8+OOzUSlYBgr4PH9mGpjIQAypjQke4WNFlh9AykO0ppbgnD8z1cRgs8mMEnQANwQ99iraFCEF8HHzU835nUJsQibVFSAJzPk6fycmUg+nG+TX1V1Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748953119; c=relaxed/simple;
	bh=hRBfjkyXDEB8n6PRaJohwZBVd9S/I2B0A30GC3UZkSU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ODBcf55PRk1JefZr+q7sFCPZz0sy3I9WDbbxReQhIjqFYyMbsMuDv8UF96aP8YeR2KYhsox14+7wsGWKKQj7FpFGb/ZtDnEmH5YLCGtlDStj14Ji9eOdI1tsZiNODn+4hSbQUKNKX9FWnKJnIDjoEcxyV8T7JIH0jU0mtDYJZ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T0Sfa3Ri; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T0Sfa3Ri"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748953116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ffXIBf29sZb1K6xWm0mL1At/DHNtjLOFFnwn7PxkVT4=;
	b=T0Sfa3Rie7IzQAXADlI4KSBp39IWb7EJilsQEEdHfLmjWva5YYa9hDotGPe+bI3wHjCdvI
	z1HHWvcpGNfHoYtmiJfdtMGsDGMkVSd0Iy5vaoRNleA332CLXsHJ36v1FGB0QVwV0+8bW/
	bOsee/vqL1GdZQu0SWMNTnvTLgTP+Uk=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-YaIvaHeuNWS8nwtYlavPag-1; Tue, 03 Jun 2025 08:18:35 -0400
X-MC-Unique: YaIvaHeuNWS8nwtYlavPag-1
X-Mimecast-MFC-AGG-ID: YaIvaHeuNWS8nwtYlavPag_1748953114
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-605f8bca0e3so4473167eaf.3
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 05:18:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748953114; x=1749557914;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ffXIBf29sZb1K6xWm0mL1At/DHNtjLOFFnwn7PxkVT4=;
        b=iSmaGazs81sI77wemYccp2W0lh0u+ZCOmTLFUqPrKQ+Gb/WRhSHce1Yv+KpDuW1O4t
         Ir3nzewMSaZ70KsEWVxsZsJbFkWHAoMLRmgNNCAQz9XKEClSklh2tffBMe9B733hqsta
         1jVsHg3qLKPlzl9TJYbjUczgq9nDjhU9QhMMm1KqNPyvUWx3mhnZ1jdN6xQnBtfw0cgQ
         70WgjU4x4i40m2OFjErGvT3GiXohwOmfdzSkLeu2NxrwjMoet3q+2Wl4wWGkyEaVoxvP
         2N45Vlj7zDEc6D+WY2suhaQRvrXQ3PGQXM67VWunqc4xt5Kb25U1c2nBPeCouYEDVKx0
         0Vcg==
X-Forwarded-Encrypted: i=1; AJvYcCXVYhh5hdhHWhSQUQ2SAsLAoLhQe1NxJZ45AI6fC3U9x1DFQszpeHKfnajBzt+6BSU1yBnilin/@lists.linux.dev
X-Gm-Message-State: AOJu0YwTBglLCVwxkYZm6JcsqyWa4B22z4KK3mxGGn/niVtOtWqCmPgN
	hrN82wzOheQmLpy3+8grfCAKarNHkoAfU+5e03wwjTFShamozQvh6qDSzs9PYEch+jH2/GK2azU
	WT1hhPgVlTOtohQo3yqGE1cSnG20vwexQc5qJtTiEgAMZpyCg2f2W0mJj/+5CWdShsdRA4f7I38
	ocosJO+yf5yixgN9SxZ1M5bNZGAaHxUfCMvO2blkxgYLW2
X-Gm-Gg: ASbGncueSkpL5luPH+pqDUl24Fo2bxXIHrN20Bye0UlfQ0rXu7GpDvn7kmMQcPHHcVp
	rKh0PG9YCzzRV2UehEn8+PLi9bgcYT+LHNPWAlmUeWZidqcEwP/lIV5J4moGn2PA61942ysoclB
	JbtA==
X-Received: by 2002:a05:6820:a02:b0:60b:d676:b666 with SMTP id 006d021491bc7-60db9ea6bf9mr7320165eaf.5.1748953114239;
        Tue, 03 Jun 2025 05:18:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8KvDsdDkgI+1PNoaL+B3Q6bgNuhvgw/iB+KFAL38XMwrBiuIXT9ZI7YntDi9tKBM5UX0PsshNsCF2QikhX9s=
X-Received: by 2002:a05:690c:6e01:b0:70e:1ef7:6eff with SMTP id
 00721157ae682-71097c2a91amr162686157b3.3.1748953103596; Tue, 03 Jun 2025
 05:18:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250602134340.906731340@linuxfoundation.org> <20250602134341.897528821@linuxfoundation.org>
In-Reply-To: <20250602134341.897528821@linuxfoundation.org>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Tue, 3 Jun 2025 14:18:12 +0200
X-Gm-Features: AX0GCFt5-R5_l1JcZoLRDhSODZkzwizMtWUfInGyGiuuSHRx5X0zU78Q3RYWgCE
Message-ID: <CAGxU2F7fRUn1H_-CF5SJJ1DZDEt3xfm+er0kqa_XS9nn6uJi0g@mail.gmail.com>
Subject: Re: [PATCH 6.6 024/444] vhost_task: fix vhost_task_create() documentation
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	"Michael S. Tsirkin" <mst@redhat.com>, Sasha Levin <sashal@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OwrB36uGTTGml00YRNK-RB3n7d6M5ocQvyEDbxRohB0_1748953114
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Jun 2025 at 16:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.6-stable review patch.  If anyone has any objections, please let me know.

It seems that commit cb380909ae3b ("vhost: return task creation error
instead of NULL") is not backported to 6.6, so we can skip this patch.
BTW it's just a fix in a comment, so if it's too late, it should not
be a big issue.

Just for my understanding, next time should I add a Fixes tag in this
case, also if the patch doesn't touch code?

Thanks,
Stefano

>
> ------------------
>
> From: Stefano Garzarella <sgarzare@redhat.com>
>
> [ Upstream commit fec0abf52609c20279243699d08b660c142ce0aa ]
>
> Commit cb380909ae3b ("vhost: return task creation error instead of NULL")
> changed the return value of vhost_task_create(), but did not update the
> documentation.
>
> Reflect the change in the documentation: on an error, vhost_task_create()
> returns an ERR_PTR() and no longer NULL.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> Message-Id: <20250327124435.142831-1-sgarzare@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/vhost_task.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
> index 8800f5acc0071..0e4455742190c 100644
> --- a/kernel/vhost_task.c
> +++ b/kernel/vhost_task.c
> @@ -111,7 +111,7 @@ EXPORT_SYMBOL_GPL(vhost_task_stop);
>   * @arg: data to be passed to fn and handled_kill
>   * @name: the thread's name
>   *
> - * This returns a specialized task for use by the vhost layer or NULL on
> + * This returns a specialized task for use by the vhost layer or ERR_PTR() on
>   * failure. The returned task is inactive, and the caller must fire it up
>   * through vhost_task_start().
>   */
> --
> 2.39.5
>
>
>

