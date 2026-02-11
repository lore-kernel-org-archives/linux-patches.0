Received: from mail-lf1-f65.google.com (mail-lf1-f65.google.com [209.85.167.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C81A288C20
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 07:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770796215; cv=none; b=BcQgGC54hZWIQVpjQBmKpEElFFIT9Q1+5v9aKlGrRccdJDDk6JPqzekHgf+o2vCVbcI5EJbYX7DT7ZhsNAvYaIKKEseuqf12UNPYc0nyBsbqniZTPt1qTBFNZUCYU0tIBwzx0Ah7ofonejNEHFYn001G34mXYfJAQDr/2YX0ypE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770796215; c=relaxed/simple;
	bh=poS7wtUXZKVO9JV8Myn0C3IHm6VCTEiwzprYNzu27ps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SMsOKlMFiDNvFfu9n0wZ09byVsTtBOwiwR9QKLQ0yOw1pHYzLPRofqmJ0loYVSNNAjrQiywda2IYnoeUKUdZo874UG6K3RPoMZTeWtC1PkxY/cuV8wlN8Uhe7MTEV2fzYQNKPfw5l5MvLrdoXTMrG+G+ShStonjbmacy0/DTAz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=remarkable.no; spf=pass smtp.mailfrom=remarkable.no; dkim=pass (2048-bit key) header.d=remarkable.no header.i=@remarkable.no header.b=JxNgRFmA; arc=none smtp.client-ip=209.85.167.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=remarkable.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=remarkable.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=remarkable.no header.i=@remarkable.no header.b="JxNgRFmA"
Received: by mail-lf1-f65.google.com with SMTP id 2adb3069b0e04-59e57973dbfso515704e87.1
        for <patches@lists.linux.dev>; Tue, 10 Feb 2026 23:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=remarkable.no; s=google; t=1770796212; x=1771401012; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kUTtGjAikYq+wRHxOhgjwOIEsGPvZljU1lZ4mdDDCZE=;
        b=JxNgRFmAuyRfKMbnaAD8xCrh5M7nj9Tfsx4F8WbnidPeVVbigbFtCG1UIZ3MAoD4N7
         lMXbQXI2a4Pf+GKPkosjAEka2USKJdvsCEyXdF7yZJgKX7540Xjfv2fTHKmBWEvLGv8c
         TR5uQbAv07N0cN1slbqa9BLcuzorjEPN/I60i8yeiIR1xhX79qB5AYXgIvFLDo5KQYmM
         WkJD/+CBuf3TKWt1DOz+rUoDb+34Xp+0dTxN26GdcUcnpHM5LnCbBFbDgSsBNRmYt/b7
         46dfByy8diGBYtqzJZYNcPelDCsKvacHhEiYtFe7JEDUPzGumxSb7YgTtXKgCj5oKauu
         owow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770796212; x=1771401012;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kUTtGjAikYq+wRHxOhgjwOIEsGPvZljU1lZ4mdDDCZE=;
        b=urlSkBegYoW4t0sQu9Wsnv07Fqtm9syIcJrK+HJko6PG5v0wVOCbZewxTldiRdruXP
         yg1WCFS114iVbgkqT4MsXMuxIh7zHzNR+jvD72VEyxsXeISt7z9XBgD6KjYmo0k8jeKL
         kjjAblOVErxi9TG4UsTehJglCLj+ukEYV+l0M8Bx6RAPi6LAy1wobgm99Vm6UT2bh2cp
         /mdSKVh6m/T9bd4KxZhJnvtsUWIirQLupW/5gVIuB4C8b8tCKURon/R1DXe1XKZIZZsC
         ILqug4jHgpvlJCyWH0qvHxS9svZuQ28ulv/oa+u6FousNj1BMZpCOGx+yXGCugXYV5c/
         +kZA==
X-Gm-Message-State: AOJu0YwB3EuFokQxFBwczNBTVAiKJfBDR5SCWO3OPf5Zz1/CQ6XECxuF
	HQqGKOVUwx2TUaC2gNNYeHqdfuAHhVjiKpOuHR/rMnH/nyM3Jz7UzpuEB3G/ZpvU0g==
X-Gm-Gg: AZuq6aI1PuGFJI5IyPH0aTIrRBG8HSaW2DOGKjfND8mceO/e6gEZO8kRsdw5ZHA7/Jk
	h9QEwd24o4Wl5K/GUsM6TKSVc41ihPGTdmq6XqsWgJzGJGiccAIjXSn3GWTXOnO6YiVhtrIpRXP
	+iLMQfUoRvPPTBiJryiP7w+Pgof2oMnCttx4PfnAIBhll712MOSuXACFr6f/qnLUOj5gDw8zsn7
	zhjpS+vycNA4OUO+A8nJmQJNIDgGiiV4AP6yoWbquGcO4uKkCDmu6aaRXVESfsniOeYKZEEns/W
	6AZ6SpeXPzWYX24eAK8KkRFnQIUcETADnNbDeE6mr9C53nkiOs3cQxX7n6Q+0HMrzzjSL+VsIvL
	FwS91pGMNbxq5r/lJdBztyKnclXBycMuUacgc2ozwr5fdF/RoKB5zFo7T25MLaXnKxi9XyeXP7E
	JCl35rEYjZDo46cNrswzMqFLFkdetA/4XecScHlXCCzN+7WRV7Mw9rKN2oswln984zD5fb8VkAT
	yg6Gf+nK1xPUWs7pDfHYbW1iSeRefoKvapUQKGoJ9SzEoOLBHd8sIRi6Sn73eLeN8D40GFaREWk
	oe3riExTJ2CLR2U=
X-Received: by 2002:a05:6512:31d6:b0:59e:49bc:b9fa with SMTP id 2adb3069b0e04-59e556d8bb8mr1987545e87.11.1770796212451;
        Tue, 10 Feb 2026 23:50:12 -0800 (PST)
Received: from ?IPV6:2001:4643:2b9c:0:64dc:7ba4:ffb0:37f7? ([2001:4643:2b9c:0:64dc:7ba4:ffb0:37f7])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f5b21f7sm172469e87.78.2026.02.10.23.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 23:50:12 -0800 (PST)
Message-ID: <61627e8a-6998-4138-a174-d7fd257db93e@remarkable.no>
Date: Wed, 11 Feb 2026 08:50:11 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 094/169] vsock/test: fix seqpacket message bounds
 test
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Stefano Garzarella <sgarzare@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Paolo Abeni <pabeni@redhat.com>,
 Sasha Levin <sashal@kernel.org>
References: <20260128145334.006287341@linuxfoundation.org>
 <20260128145337.388867288@linuxfoundation.org>
Content-Language: en-US
From: Johan Korsnes <johan.korsnes@remarkable.no>
In-Reply-To: <20260128145337.388867288@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/01/2026 16:22, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Stefano Garzarella <sgarzare@redhat.com>
> 
> [ Upstream commit 0a98de80136968bab7db37b16282b37f044694d3 ]
> 
> The test requires the sender (client) to send all messages before waking
> up the receiver (server).
> Since virtio-vsock had a bug and did not respect the size of the TX
> buffer, this test worked, but now that we are going to fix the bug, the
> test hangs because the sender would fill the TX buffer before waking up
> the receiver.
> 
> Set the buffer size in the sender (client) as well, as we already do for
> the receiver (server).
> 
> Fixes: 5c338112e48a ("test/vsock: rework message bounds test")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> Link: https://patch.msgid.link/20260121093628.9941-3-sgarzare@redhat.com
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/testing/vsock/vsock_test.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> index 0c22ff7a8de2a..79ef11c0ab14f 100644
> --- a/tools/testing/vsock/vsock_test.c
> +++ b/tools/testing/vsock/vsock_test.c
> @@ -359,6 +359,7 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
>  
>  static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>  {
> +	unsigned long long sock_buf_size;
>  	unsigned long curr_hash;
>  	size_t max_msg_size;
>  	int page_size;
> @@ -371,6 +372,16 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>  		exit(EXIT_FAILURE);
>  	}
>  
> +	sock_buf_size = SOCK_BUF_SIZE;
> +
> +	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
> +			     sock_buf_size,
> +			     "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");

Hi Greg,

This patch causes build failure as the setsockopt_ull_check() function
does not seem to be defined in the 6.12 tree.

Kind regards,
Johan Korsnes


> +
> +	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
> +			     sock_buf_size,
> +			     "setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
> +
>  	/* Wait, until receiver sets buffer size. */
>  	control_expectln("SRVREADY");
>  

