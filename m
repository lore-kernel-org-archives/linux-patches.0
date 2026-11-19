Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795097329;
	b=yOhhkmNxhRZHkA5raXFGntqX7vjwu5zSg7IuZWPNHkEnWPYS1kvNzxpjZ7KFo096JPrK
	 s+Ylw/KZOUkFY/0ti7LjT92H5o6yHvhz6RRGsrrfgiD6stNeZC6LBxeR4J5uuZcLKZgXB
	 osrasvGwR8SLK50juR3tNc2bqE1q/9SBaxCue0pyLc7n5wU33FmKrumDQXt58XJA+crUY
	 xtr664owg8dwG5FNxBiNAdcNgWP7qPGXf/myn/m3oPq9d8J5SagdxYKpe3KLLDuMlvwDj
	 OFaLCzwnUyq89Jn+DKUmkLBKwNI+4+AIFTaEDUjFtFd2HkSVsRFXeubWODn83KI9b3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795097329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=IkUQ/Hyn5hzUG4i31KA8ExA7XZ1o5KCxvl7XJP+wUrc=;
	b=EtTAGiuhHMt9a4+MFEWemuMjdAbwhGV8TPvI1B1GlbYyK1BivmyeBT5oU3VVLaCapb18
	 EbHnJ3wXp5BmI5flEAxwlMWCSAIWijQs/818A7zIl7Jiiw2KSqBpZOcjFW/jCFim9aluR
	 0gYzBR3HgcHZ7TFwg8pUw6N3Q4ZiBiPqXc657Dh/Fe0FuGyRb9FQlYNRDGVfh5K1rqINx
	 KKhNkeNNx/YvO0WI+MmRSVsQzhUg2lR3qVlt0sUgmRDXGQjgg6AKjzUizHYsLD0INyE0O
	 44ayv84GB9tQTJVORuki1FYK0fqJy6HbFEvbrsQg+BwYoCBxFvRWHbtRSeNAL4sXbVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iZVAzrSC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D514606A330;
	Thu, 19 Nov 2026 14:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iZVAzrSC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFCA1F000CC;
	Thu, 19 Nov 2026 14:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795097329;
	bh=IkUQ/Hyn5hzUG4i31KA8ExA7XZ1o5KCxvl7XJP+wUrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZVAzrSC/zPggAViGnqaEJtmJy7btxJmXzo/R04++vmD2qHLSgc86vEuVAfNxmZXh
	 ILkv23+8qHJSDJUyUjsINbMPGLDNua7FtGLbSztALTdavdDKbDQSITi8JshAbbo+FD
	 W4XHyd//VxD4Cnuxc7D6sQ5yDe7VI3g5FqAzDEgkKyCwfR9H7Qq4U5fKtTaixKOpoS
	 Bj4nv+w2hE1tnrM0vcq8Nz07EOwVc0Q0YMwCoSZziQpnEPrLBpUlUUn+F7s7mB5UBs
	 8V63Mhl3R1Um82PCX8r62jy7ypDwbb2ayAK9hnP0WIpTsMp+r6ocINZS95qQ9cHUhH
	 Fkdzn8f0h391Q==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: axboe@kernel.dk,
	hch@lst.de,
	patches@lists.linux.dev,
	sashal@kernel.org,
	stable@vger.kernel.org,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	linux-block@vger.kernel.org,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 6.12 0534/1756] block: remove BLK_MQ_F_SHOULD_MERGE
Date: Thu, 19 Nov 2026 15:08:30 +0100
Message-ID: <20261119140830.15616-1-ojeda@kernel.org>
In-Reply-To: <20261118150030.389817521@linuxfoundation.org>
References: <20261118150030.389817521@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 18 Nov 2026 15:44:21 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> BLK_MQ_F_SHOULD_MERGE is set for all tag_sets except those that purely
> process passthrough commands (bsg-lib, ufs tmf, various nvme admin
> queues) and thus don't even check the flag.  Remove it to simplify the
> driver interface.

>  enum {
> -	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
>  	BLK_MQ_F_TAG_QUEUE_SHARED = 1 << 1,

This causes:

    error[E0425]: cannot find value `BLK_MQ_F_SHOULD_MERGE` in crate `bindings`
      --> rust/kernel/block/mq/tag_set.rs:55:38
       |
    55 |                     flags: bindings::BLK_MQ_F_SHOULD_MERGE,
       |                                      ^^^^^^^^^^^^^^^^^^^^^ not found in `bindings`

We need:

  31d813a3b8cb ("rust: block: fix use of BLK_MQ_F_SHOULD_MERGE")

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun@kernel.org>
Cc: linux-block@vger.kernel.org
Cc: rust-for-linux@vger.kernel.org

I hope that helps!

Cheers,
Miguel
