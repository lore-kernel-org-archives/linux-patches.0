Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C044273809
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 08:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770798663; cv=none; b=GZVzewg8E1WD59XSoMp4g7n+c5LeXt0gHFXGJaqsP+9WmgQapULQGvzp6CevT17qXSYpAIduF6ZBNAvLj5j2hxwft2HEbjE0miTl05wG5Yv3SLDODDkeFKIt0+gY1P/A4/CSRU2gRMA3Ke/KJoaZpuFLoeEMcLVquLtwF7zXVrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770798663; c=relaxed/simple;
	bh=L+RzPB2XgZkwHXOiETeRI5QKRu4DkbYwNWRldGc4q0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=j+Xa/RrzCeqgWoPg6lGWK4VeUBvtX0V7RsoLlmn3IS5R+11uOuHEdFU+LYIxzSwNOZ9TnC/6SB9VvrVRgAlqtPV8XGYpXJrVaop+89xBay/aOlk7zt1KpjdiakFxjwUbWCU9IrRUC3MK8YesPtNm/u0L6aWOhWRv9K2yA9xP45Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SlmnxdCG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SlmnxdCG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770798661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gjJtZqFQZ1VGaFIFZH95XeOOE6KaDU1AzjXSlUCybq4=;
	b=SlmnxdCGDHrGJQF+pGdQWjrurxS5z8/u3O06SP9b8jol+nA2jlg71CXt6m8dQ1gg5k41Bk
	8bmwM44k/2TmfJ3txIsdRFFYBjMUicXBy4H9w1byfK4VByaMu8RxJg62iLShuJpcPvXGPz
	1N9glOX4ooX8RyMTGsEGsrl2Yg11zBc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-6XxyNJP5OLSshLkC9xRcIA-1; Wed, 11 Feb 2026 03:30:59 -0500
X-MC-Unique: 6XxyNJP5OLSshLkC9xRcIA-1
X-Mimecast-MFC-AGG-ID: 6XxyNJP5OLSshLkC9xRcIA_1770798658
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4831192e66aso56924645e9.2
        for <patches@lists.linux.dev>; Wed, 11 Feb 2026 00:30:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770798658; x=1771403458;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gjJtZqFQZ1VGaFIFZH95XeOOE6KaDU1AzjXSlUCybq4=;
        b=LlCzt/KTlE2yAxBDc3WTy3Y1ISA6LgMWyNThBwwr7Xnryr/kWuVs9Q9yf/521kM7JZ
         VMZJQhGbIBY5uwPbOLnUXglR6xPfaKRFGxEYIwdQdIR6pFujrDK+T4RYRix4mXli8oS8
         RXnf1b0awo8rzDfsM3jhVuelLISEr98JFblyCMgbFEOHdzA/OoGfXY3hGgGmhknz29XB
         3HlFWYpyRDItZD1oyepZzhBnCCNbbcKJmgvaty4VLf8XURBJGiE9/OGpBqqBzWLBIvgp
         cB2cKz0LeuKELxajmNrxU6kCoO5Jnn19bsA5VVyEs8zTBENQAj3C8rOkCGbvlZ4iFYw8
         XpJw==
X-Forwarded-Encrypted: i=1; AJvYcCWmvs/muiJ+DYY0L6wW/fbuIM2ptjJfw/Dp3gEJ3z625IQ2U8dtedUvUKqgbgMxU25B0f9F/cHl@lists.linux.dev
X-Gm-Message-State: AOJu0YxYAF++dV5I0MaBuG5s1kmeD9+mBg6ciES6le1u0vCvU4wpio3g
	8nDb1DR3A3FA90fq2Tpkkx1n/eC0IvVQ+ZtF2Ohg3MizkkX7W2bp8rNOmUpQS/Vqv/SNgOoLsJ7
	wXmjzmgsaiKU4xvq4iM6npkxT3mQ6YrRmiklxWhaCmlWgeD+MW7HsCRH6PHw=
X-Gm-Gg: AZuq6aLSjhtx/R/Ja6KX8fKJ//eJ8uz1fUWkYjvHsBAgWFwQABt2cpimIKbGOUhCv6K
	28U4jAnGeryuELF6SWLU2WTIIyvsgkowuZvO19Vnb+pbIYcHhxA2Ew7gcbqg985YHlVx8WqJx1v
	b7Dc5tUkXC7b3gYNbEvq9v5cpdV9AL+whkAi6GfJbhAX8C8nWo72j3ESj4w7EmJpogVVjBwLsLc
	698QwzYx5X79vO4wQxsPnVdmRmLskJ0C336pGeZCPwPUnU/9Y6gtIn5aVM3LlK6pEAPPqItvjmB
	ySXOB2ud74QkHteZdbpqEsliBzeDmXLckAMrJ3hdakYpJbWFZtdrWEcXLbaqg8qybE0Iza04kV0
	EN+P8te0PhtOJ0L7tE8IfFxGF3w5AnZOD46BQ3OTJl/5/kYSfPDtUtaHR4GruEO3MoSwHh8A=
X-Received: by 2002:a05:600c:1384:b0:47e:e8de:7420 with SMTP id 5b1f17b1804b1-4835dfcf9a0mr11195765e9.22.1770798658427;
        Wed, 11 Feb 2026 00:30:58 -0800 (PST)
X-Received: by 2002:a05:600c:1384:b0:47e:e8de:7420 with SMTP id 5b1f17b1804b1-4835dfcf9a0mr11195405e9.22.1770798657800;
        Wed, 11 Feb 2026 00:30:57 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783e5be13sm2956514f8f.35.2026.02.11.00.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 00:30:57 -0800 (PST)
Date: Wed, 11 Feb 2026 09:30:49 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Johan Korsnes <johan.korsnes@remarkable.no>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, "Michael S. Tsirkin" <mst@redhat.com>, 
	Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 094/169] vsock/test: fix seqpacket message bounds
 test
Message-ID: <aYw9N_Ido_FZzblw@sgarzare-redhat>
References: <20260128145334.006287341@linuxfoundation.org>
 <20260128145337.388867288@linuxfoundation.org>
 <61627e8a-6998-4138-a174-d7fd257db93e@remarkable.no>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <61627e8a-6998-4138-a174-d7fd257db93e@remarkable.no>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RS2zDlwJzxJP7Gehx955_2zQnHE1Wlcr1jqAraxysPo_1770798658
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Wed, Feb 11, 2026 at 08:50:11AM +0100, Johan Korsnes wrote:
>On 28/01/2026 16:22, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Stefano Garzarella <sgarzare@redhat.com>
>>
>> [ Upstream commit 0a98de80136968bab7db37b16282b37f044694d3 ]
>>
>> The test requires the sender (client) to send all messages before waking
>> up the receiver (server).
>> Since virtio-vsock had a bug and did not respect the size of the TX
>> buffer, this test worked, but now that we are going to fix the bug, the
>> test hangs because the sender would fill the TX buffer before waking up
>> the receiver.
>>
>> Set the buffer size in the sender (client) as well, as we already do for
>> the receiver (server).
>>
>> Fixes: 5c338112e48a ("test/vsock: rework message bounds test")
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> Link: https://patch.msgid.link/20260121093628.9941-3-sgarzare@redhat.com
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  tools/testing/vsock/vsock_test.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>> index 0c22ff7a8de2a..79ef11c0ab14f 100644
>> --- a/tools/testing/vsock/vsock_test.c
>> +++ b/tools/testing/vsock/vsock_test.c
>> @@ -359,6 +359,7 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
>>
>>  static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>>  {
>> +	unsigned long long sock_buf_size;
>>  	unsigned long curr_hash;
>>  	size_t max_msg_size;
>>  	int page_size;
>> @@ -371,6 +372,16 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>>  		exit(EXIT_FAILURE);
>>  	}
>>
>> +	sock_buf_size = SOCK_BUF_SIZE;
>> +
>> +	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
>> +			     sock_buf_size,
>> +			     "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
>
>Hi Greg,
>
>This patch causes build failure as the setsockopt_ull_check() function
>does not seem to be defined in the 6.12 tree.

I guess just when you build vsock_test, right?

BTW to fix that we should backport commit 86814d8ffd55 ("vsock/test: 
verify socket options after setting them").

I tried to cherry-pick it on current linux-6.12.y and apply clean.

Greg, let me know if I should send a proper patch for 6.12.

Thanks,
Stefano

