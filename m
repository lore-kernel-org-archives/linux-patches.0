Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0686E7263D
	for <patches@lists.linux.dev>; Wed,  7 May 2025 20:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746650087; cv=none; b=tnzFuFBiVGdAWPCEFrWhmEZv85DqNuf1aQByMG5r6mZqGzuXMrGh/PFIZthLNXJ62ULaD9GO/bHG6mLCG58XoIQOUWP1U3FMQnK61S89G8OCz4RKayc7BvKx9retGYsIuGXPF5k7CRnaNCsPQYZOvPtNX940NQzTq8D8BZbsyds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746650087; c=relaxed/simple;
	bh=rYwPlKIrc8CEQvItc68MgYlI97CaizPLxQHNldaARzA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bBxiiud9w6noNoXK5aHv9kJZE/t95pFHtg+TjvYFkYKfkbd6edD4uPAU/3mL3kAT9i/AihwFsEHZaapgB2gUziEKnzN5VyRaKxtySwxfTT994QE7dOhopmhO21Rzw+qoDwnhW6foJRVsr5J0II7Ow6kJ48BgOUtbNn8GCWMeNqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eqSRilGd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eqSRilGd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746650082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZS/dW7f0IHeNiVWvc16YzMci9swdBRTEPVRyR/dZeo=;
	b=eqSRilGdJX4kCGYoFpb6nUmkqBTfzuv5+HnOo9AAo/VoajhBj/pDMtbPUoQwMg8onw/kQn
	U9XAxx9ixXZTf8qg3OZ60D6GnzC3p+z9C890boOCrjIGGjZ2daBsCkNsJWsKIV3AWQ2iCu
	LrUxz8ebSqIJnj6fTN1BlXVi1xvX3PU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-470-9veFRZ7bPcSB-rqEDZOkhQ-1; Wed,
 07 May 2025 16:34:39 -0400
X-MC-Unique: 9veFRZ7bPcSB-rqEDZOkhQ-1
X-Mimecast-MFC-AGG-ID: 9veFRZ7bPcSB-rqEDZOkhQ_1746650078
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 235EF18002A5;
	Wed,  7 May 2025 20:34:38 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A82330001A1;
	Wed,  7 May 2025 20:34:36 +0000 (UTC)
Date: Wed, 7 May 2025 22:34:32 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: stable@vger.kernel.org, patches@lists.linux.dev, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 6.14 030/183] dm: always update the array size in
 realloc_argv on success
In-Reply-To: <20250507183825.912392976@linuxfoundation.org>
Message-ID: <2c92ae25-854e-2d60-4b6c-a4cbcd5f4ebd@redhat.com>
References: <20250507183824.682671926@linuxfoundation.org> <20250507183825.912392976@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi

I'd like to ask you to also backport 
f1aff4bc199cb92c055668caed65505e3b4d2656 ("dm: fix copying after src array 
boundaries") to all stable branches because it fixes a bug introduced in 
the commit 5a2a6c428190f945c5cbf5791f72dbea83e97f66.

Mikulas



On Wed, 7 May 2025, Greg Kroah-Hartman wrote:

> 6.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Benjamin Marzinski <bmarzins@redhat.com>
> 
> commit 5a2a6c428190f945c5cbf5791f72dbea83e97f66 upstream.
> 
> realloc_argv() was only updating the array size if it was called with
> old_argv already allocated. The first time it was called to create an
> argv array, it would allocate the array but return the array size as
> zero. dm_split_args() would think that it couldn't store any arguments
> in the array and would call realloc_argv() again, causing it to
> reallocate the initial slots (this time using GPF_KERNEL) and finally
> return a size. Aside from being wasteful, this could cause deadlocks on
> targets that need to process messages without starting new IO. Instead,
> realloc_argv should always update the allocated array size on success.
> 
> Fixes: a0651926553c ("dm table: don't copy from a NULL pointer in realloc_argv()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/md/dm-table.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -523,9 +523,10 @@ static char **realloc_argv(unsigned int
>  		gfp = GFP_NOIO;
>  	}
>  	argv = kmalloc_array(new_size, sizeof(*argv), gfp);
> -	if (argv && old_argv) {
> -		memcpy(argv, old_argv, *size * sizeof(*argv));
> +	if (argv) {
>  		*size = new_size;
> +		if (old_argv)
> +			memcpy(argv, old_argv, *size * sizeof(*argv));
>  	}
>  
>  	kfree(old_argv);
> 
> 

