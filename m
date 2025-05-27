Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F871DB34C
	for <patches@lists.linux.dev>; Tue, 27 May 2025 17:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366846; cv=none; b=MicTAwqonjjNX0EKJkEzzejbAv5Faf3kBV0iiWW7GDUNv89Ng57uD5zxGDRwtYHrvgVdS9g7sLkisFYgp8xc9+PPZHRFdF2YFXJzKnMis78Bt/yNFUKWFbzmzNCDJfyKkN6iT2x7OvGmohOeWCxOar92NT3RI5DRmwJ2OQNGhTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366846; c=relaxed/simple;
	bh=A3wIyJffHxPfmIV8B1isgc1zlN/9ZV21pjg8oWliHrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dp09iJ7GacFTh890OJTRtk/m2AJMfTsdbpBBJJW+TgNwX9jwg0+y2ARN4lL6C3gDQ3t4kLwVRlWXtcsQ8RXhs+6H4h4RtnA9h/yDV2nkFB+MOJfFgG/xdnuHoNbAo9unYkIuIlSHBc//fBmC9zP5xH7hhzS6XbPNZIOGfcovKhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AzDaCaCF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AzDaCaCF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748366843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PQzpXQ7vkWBPskbjX+BkGNGUSRzfgukO2SXDGxgoMMs=;
	b=AzDaCaCF4Y3ylYfcUkiBqLK5qlzS+N0tccFQG/Qdvl/Te7OucCJa8itqegihMc5dnfQksK
	9cjS7msL42dHiDgAAAkzL94IM6gXGKtR2kZfrevt4yORQdYR5ZFz2Jl8MBhD1XsLMr4/FO
	DKpsWszYauEYJKf1grCTjnaVwh63vTQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-ZmVZ5dvBOx-jPlACpX6mZQ-1; Tue, 27 May 2025 13:27:21 -0400
X-MC-Unique: ZmVZ5dvBOx-jPlACpX6mZQ-1
X-Mimecast-MFC-AGG-ID: ZmVZ5dvBOx-jPlACpX6mZQ_1748366841
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c5cd0f8961so700068585a.1
        for <patches@lists.linux.dev>; Tue, 27 May 2025 10:27:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748366841; x=1748971641;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PQzpXQ7vkWBPskbjX+BkGNGUSRzfgukO2SXDGxgoMMs=;
        b=Zmcq/i+58u6zYclONSFcc9xx4dMc9egWzTSNCYBX3gUtXbO3sDRmnwgNwoniEA/R5t
         mxuUwbP0pfzJXEK7UACTcrwkQyfqCkkg5dpHY+K/8Mm4ua99j9oJNNVK8RXmlYjaVz2B
         LpFgKYZx0/zbF7uTKM7/1Yjg/Ak9xxV1uEhMA4CtjjjHUafXqrWAUqF603VQApaKIyF7
         KwFNFaY+2GWw74hNmZk6i5yygrlb+jGtS8hiT7n1zy6m1vwPfoCkH2EqWo2v39Q/HBGh
         Zh1Ze+VeedhpIKm19+Z8QojhcscbNsmNCr7HpWkq9EdX8WXkbkBjEdpKLMOWULaN+MWO
         TM/Q==
X-Gm-Message-State: AOJu0YwJUrMMbuer0YtMhnt1vv8aJtMlCEjL49IZSP6NgFPO22wUC94Z
	SMvE577GKuTEAjc3jWR1UAy84kJiCw5yRugDyJz2HLHSlMc83bLqDKC+AtQ9M7noAMWQT61geAO
	QFH6jaoYsqCbgnBlCepxW2H5573Uk5ixEUzbPTWPwNdUQxo4nKgu4p4f8CjU=
X-Gm-Gg: ASbGnctt3Fi8C1iqUgMsP+7UAzCpyjQ7ytdlJEj+l+69B4H94gbAbNpRK/R0HBNCUqO
	pzPTlpmWCC8DsZZNlg1keigv9xQpVIW9T+6g7Pu92jJRkw9eVeKxKozBw06gzf+vevCJbR9FnBp
	y4X0YSYKKXItticPsGWgV09MIYp70rQkX0U2WVv+Qm7mdGMzvRyeSGBPTu0NH1Nz09VfVLdot+3
	U7sC+uKuGcbNnrvLV+lplxcp+1KYIHDAZDBS/rmNiQA1kMWB+Cw/VW/IdqPkOoePa1uE35C8QP6
	6WBBZ5fSX57Am/WB++1wD5/ERH1MosZW2UysncTcEWg4XpWVoFF626YNoOU=
X-Received: by 2002:a05:620a:f0d:b0:7cd:40:351 with SMTP id af79cd13be357-7ceecc33e6fmr1955055085a.58.1748366841212;
        Tue, 27 May 2025 10:27:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEV8ht+49lI5qLVclM9XNHjng2TBDERfNRW0n/yJWFo6Oh60ZUmXJ0766q4+2Vo8i8akgpwrQ==
X-Received: by 2002:a05:620a:f0d:b0:7cd:40:351 with SMTP id af79cd13be357-7ceecc33e6fmr1955050985a.58.1748366840741;
        Tue, 27 May 2025 10:27:20 -0700 (PDT)
Received: from ?IPV6:2600:4040:5308:eb00:a77e:fec5:d269:f23e? ([2600:4040:5308:eb00:a77e:fec5:d269:f23e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cedf7930b5sm770956985a.89.2025.05.27.10.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 10:27:20 -0700 (PDT)
Message-ID: <ccdc7888-68a2-497a-bc28-f0c0297473b4@redhat.com>
Date: Tue, 27 May 2025 13:27:19 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 472/626] dm vdo vio-pool: allow variable-sized
 metadata vios
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ken Raeburn <raeburn@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Sasha Levin <sashal@kernel.org>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162504.171843154@linuxfoundation.org>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20250527162504.171843154@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7SKVsYh8s8osw4Y-uhdaALTfXAbDHbhOVdhqGQXvPOQ_1748366841
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/27/25 12:26 PM, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.

There's no reason to take this patch for 6.12, it can just be dropped.

This patch adds a new interface, but the subsequent patches that use 
that interface are not being backported. So it won't hurt anything, but 
it's also useless in 6.12.

Matt

> ------------------
> 
> From: Ken Raeburn <raeburn@redhat.com>
> 
> [ Upstream commit f979da512553a41a657f2c1198277e84d66f8ce3 ]
> 
> With larger-sized metadata vio pools, vdo will sometimes need to
> issue I/O with a smaller size than the allocated size. Since
> vio_reset_bio is where the bvec array and I/O size are initialized,
> this reset interface must now specify what I/O size to use.
> 
> Signed-off-by: Ken Raeburn <raeburn@redhat.com>
> Signed-off-by: Matthew Sakai <msakai@redhat.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/md/dm-vdo/io-submitter.c |  6 ++++--
>   drivers/md/dm-vdo/io-submitter.h | 18 +++++++++++++---
>   drivers/md/dm-vdo/types.h        |  3 +++
>   drivers/md/dm-vdo/vio.c          | 36 +++++++++++++++++++-------------
>   drivers/md/dm-vdo/vio.h          |  2 ++
>   5 files changed, 46 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
> index ab62abe18827b..a664be89c15d7 100644
> --- a/drivers/md/dm-vdo/io-submitter.c
> +++ b/drivers/md/dm-vdo/io-submitter.c
> @@ -327,6 +327,7 @@ void vdo_submit_data_vio(struct data_vio *data_vio)
>    * @error_handler: the handler for submission or I/O errors (may be NULL)
>    * @operation: the type of I/O to perform
>    * @data: the buffer to read or write (may be NULL)
> + * @size: the I/O amount in bytes
>    *
>    * The vio is enqueued on a vdo bio queue so that bio submission (which may block) does not block
>    * other vdo threads.
> @@ -338,7 +339,7 @@ void vdo_submit_data_vio(struct data_vio *data_vio)
>    */
>   void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
>   			   bio_end_io_t callback, vdo_action_fn error_handler,
> -			   blk_opf_t operation, char *data)
> +			   blk_opf_t operation, char *data, int size)
>   {
>   	int result;
>   	struct vdo_completion *completion = &vio->completion;
> @@ -349,7 +350,8 @@ void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
>   
>   	vdo_reset_completion(completion);
>   	completion->error_handler = error_handler;
> -	result = vio_reset_bio(vio, data, callback, operation | REQ_META, physical);
> +	result = vio_reset_bio_with_size(vio, data, size, callback, operation | REQ_META,
> +					 physical);
>   	if (result != VDO_SUCCESS) {
>   		continue_vio(vio, result);
>   		return;
> diff --git a/drivers/md/dm-vdo/io-submitter.h b/drivers/md/dm-vdo/io-submitter.h
> index 80748699496f2..3088f11055fdd 100644
> --- a/drivers/md/dm-vdo/io-submitter.h
> +++ b/drivers/md/dm-vdo/io-submitter.h
> @@ -8,6 +8,7 @@
>   
>   #include <linux/bio.h>
>   
> +#include "constants.h"
>   #include "types.h"
>   
>   struct io_submitter;
> @@ -26,14 +27,25 @@ void vdo_submit_data_vio(struct data_vio *data_vio);
>   
>   void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
>   			   bio_end_io_t callback, vdo_action_fn error_handler,
> -			   blk_opf_t operation, char *data);
> +			   blk_opf_t operation, char *data, int size);
>   
>   static inline void vdo_submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
>   					   bio_end_io_t callback, vdo_action_fn error_handler,
>   					   blk_opf_t operation)
>   {
>   	__submit_metadata_vio(vio, physical, callback, error_handler,
> -			      operation, vio->data);
> +			      operation, vio->data, vio->block_count * VDO_BLOCK_SIZE);
> +}
> +
> +static inline void vdo_submit_metadata_vio_with_size(struct vio *vio,
> +						     physical_block_number_t physical,
> +						     bio_end_io_t callback,
> +						     vdo_action_fn error_handler,
> +						     blk_opf_t operation,
> +						     int size)
> +{
> +	__submit_metadata_vio(vio, physical, callback, error_handler,
> +			      operation, vio->data, size);
>   }
>   
>   static inline void vdo_submit_flush_vio(struct vio *vio, bio_end_io_t callback,
> @@ -41,7 +53,7 @@ static inline void vdo_submit_flush_vio(struct vio *vio, bio_end_io_t callback,
>   {
>   	/* FIXME: Can we just use REQ_OP_FLUSH? */
>   	__submit_metadata_vio(vio, 0, callback, error_handler,
> -			      REQ_OP_WRITE | REQ_PREFLUSH, NULL);
> +			      REQ_OP_WRITE | REQ_PREFLUSH, NULL, 0);
>   }
>   
>   #endif /* VDO_IO_SUBMITTER_H */
> diff --git a/drivers/md/dm-vdo/types.h b/drivers/md/dm-vdo/types.h
> index dbe892b10f265..cdf36e7d77021 100644
> --- a/drivers/md/dm-vdo/types.h
> +++ b/drivers/md/dm-vdo/types.h
> @@ -376,6 +376,9 @@ struct vio {
>   	/* The size of this vio in blocks */
>   	unsigned int block_count;
>   
> +	/* The amount of data to be read or written, in bytes */
> +	unsigned int io_size;
> +
>   	/* The data being read or written. */
>   	char *data;
>   
> diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
> index b291578f726f5..7c417c1af4516 100644
> --- a/drivers/md/dm-vdo/vio.c
> +++ b/drivers/md/dm-vdo/vio.c
> @@ -188,14 +188,23 @@ void vdo_set_bio_properties(struct bio *bio, struct vio *vio, bio_end_io_t callb
>   
>   /*
>    * Prepares the bio to perform IO with the specified buffer. May only be used on a VDO-allocated
> - * bio, as it assumes the bio wraps a 4k buffer that is 4k aligned, but there does not have to be a
> - * vio associated with the bio.
> + * bio, as it assumes the bio wraps a 4k-multiple buffer that is 4k aligned, but there does not
> + * have to be a vio associated with the bio.
>    */
>   int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
>   		  blk_opf_t bi_opf, physical_block_number_t pbn)
>   {
> -	int bvec_count, offset, len, i;
> +	return vio_reset_bio_with_size(vio, data, vio->block_count * VDO_BLOCK_SIZE,
> +				       callback, bi_opf, pbn);
> +}
> +
> +int vio_reset_bio_with_size(struct vio *vio, char *data, int size, bio_end_io_t callback,
> +			    blk_opf_t bi_opf, physical_block_number_t pbn)
> +{
> +	int bvec_count, offset, i;
>   	struct bio *bio = vio->bio;
> +	int vio_size = vio->block_count * VDO_BLOCK_SIZE;
> +	int remaining;
>   
>   	bio_reset(bio, bio->bi_bdev, bi_opf);
>   	vdo_set_bio_properties(bio, vio, callback, bi_opf, pbn);
> @@ -204,22 +213,21 @@ int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
>   
>   	bio->bi_io_vec = bio->bi_inline_vecs;
>   	bio->bi_max_vecs = vio->block_count + 1;
> -	len = VDO_BLOCK_SIZE * vio->block_count;
> +	if (VDO_ASSERT(size <= vio_size, "specified size %d is not greater than allocated %d",
> +		       size, vio_size) != VDO_SUCCESS)
> +		size = vio_size;
> +	vio->io_size = size;
>   	offset = offset_in_page(data);
> -	bvec_count = DIV_ROUND_UP(offset + len, PAGE_SIZE);
> +	bvec_count = DIV_ROUND_UP(offset + size, PAGE_SIZE);
> +	remaining = size;
>   
> -	/*
> -	 * If we knew that data was always on one page, or contiguous pages, we wouldn't need the
> -	 * loop. But if we're using vmalloc, it's not impossible that the data is in different
> -	 * pages that can't be merged in bio_add_page...
> -	 */
> -	for (i = 0; (i < bvec_count) && (len > 0); i++) {
> +	for (i = 0; (i < bvec_count) && (remaining > 0); i++) {
>   		struct page *page;
>   		int bytes_added;
>   		int bytes = PAGE_SIZE - offset;
>   
> -		if (bytes > len)
> -			bytes = len;
> +		if (bytes > remaining)
> +			bytes = remaining;
>   
>   		page = is_vmalloc_addr(data) ? vmalloc_to_page(data) : virt_to_page(data);
>   		bytes_added = bio_add_page(bio, page, bytes, offset);
> @@ -231,7 +239,7 @@ int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
>   		}
>   
>   		data += bytes;
> -		len -= bytes;
> +		remaining -= bytes;
>   		offset = 0;
>   	}
>   
> diff --git a/drivers/md/dm-vdo/vio.h b/drivers/md/dm-vdo/vio.h
> index 3490e9f59b04a..74e8fd7c8c029 100644
> --- a/drivers/md/dm-vdo/vio.h
> +++ b/drivers/md/dm-vdo/vio.h
> @@ -123,6 +123,8 @@ void vdo_set_bio_properties(struct bio *bio, struct vio *vio, bio_end_io_t callb
>   
>   int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
>   		  blk_opf_t bi_opf, physical_block_number_t pbn);
> +int vio_reset_bio_with_size(struct vio *vio, char *data, int size, bio_end_io_t callback,
> +			    blk_opf_t bi_opf, physical_block_number_t pbn);
>   
>   void update_vio_error_stats(struct vio *vio, const char *format, ...)
>   	__printf(2, 3);

