Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795140567;
	b=pRf20R+NfmViauXBcPKV3zjgdCePqGntmQVRthehm7aNkFjPrro2LgGgefCvAtelN0Zz
	 6RMLOyVIxByuwflwQEzFxoh0noVft8ftuR8+lUfpZCo0rRSOC132MxXY3Baq7oFMGmYBW
	 3g2rOugr/8dz82u81ZHyQ9cBKSiinqNJEZlUCvjZuUjguGF9vIbYAKv+I9lkVIzQ5PxRc
	 dpuaN1zTce2mfYAn6VnR7n6bwavOINBNaY0Xyj2u4gtVmy3pbqszVtr3RFxcf1e/PR4jA
	 V9n+lj1dE4ZL6GIr04RRa9jdduW0IPLVjYEO3IYZcb3l+DGE53F8WqLeXe0qtj/PcrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795140567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=f8mTRn/3X3uZEq0um71/dlAedACVCps+ka1nHFg/T/Y=;
	b=K+AFAZUYoGHWJAnuqnV6v2PQxFc6J7Z/sb8cH3RQYiK1rLeEDL/ImPNZYFbDtHcsnuC5
	 JQ1byRjdGUS+GygkbgSuo2BQHv9y05iVPtCjMk+PLAMFitionOztRfwq3503iDrtAiJkl
	 pqLOqkII+s/rF3Qkb8a+qiUE9kgZxgegVVyK8sU7m/u8HOdm6ebM3YOxBWwaLx66cn08N
	 roz0r4JWC0dNWeemiOvGdf28xR76YQ1bykN5aIPKTMoVyyTo9PNG6j3XuEKVN6WtfzShb
	 En6nceiq+DbX+06Q/OVovuijBskS2TRviHlL3kJciiWTf6ZIfL3AOeXlRzN36nyNQww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RjDIxibh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE9D60A2609;
	Fri, 20 Nov 2026 02:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RjDIxibh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434B81F000D2;
	Fri, 20 Nov 2026 02:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795140567;
	bh=f8mTRn/3X3uZEq0um71/dlAedACVCps+ka1nHFg/T/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RjDIxibhEvzAlmEJz9HG0Qvro2AAMtg8tsedwX8IlxdTKheBfBiyw1hO44ShNjzV1
	 Dcr7nuxGOWDH0ii9AB79Virf6op7Ml8EK2QTYMVVxJbA8UISERLkHHuTHAbhx20xyl
	 +unQJ3Celdwe3bM/eJn44fjYxVquTj4nARySmzV5OUbpQLj8sSkQS3uYkw61vz9uQr
	 rIGKkk7wwS3zPYpJGPyf+iprjVe2cwsl3ecm/ctcp+zoiodL6Vzco0Kl7JNtmrxDNO
	 vk3lbTwBjvXCI6HuvLzxFr5A41EhIEjxHMNf18M/5qzqFquzwVEeesKkZes38XNkV+
	 9tN1QzXG5mDNw==
From: Sasha Levin <sashal@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	axboe@kernel.dk,
	hch@lst.de,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	linux-block@vger.kernel.org,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 6.12 0534/1756] block: remove BLK_MQ_F_SHOULD_MERGE
Date: Thu, 19 Nov 2026 21:09:06 -0500
Message-ID: <20261120020908.2320910-9-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119140830.15616-1-ojeda@kernel.org>
References: <20261118150030.389817521@linuxfoundation.org> <20261119140830.15616-1-ojeda@kernel.org>
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

On Thu, Nov 19, 2026 at 03:08:30PM +0100, Miguel Ojeda wrote:
>     error[E0425]: cannot find value `BLK_MQ_F_SHOULD_MERGE` in crate `bindings`

Dropped cc76ace465d6 ("block: remove BLK_MQ_F_SHOULD_MERGE") from the 6.12
queue, along with the swim patches it was queued for: 92353a047637 ("swim:
Convert to blocking queue") and the swim patches after it (04cb277e6841,
b736189c93c9, abae04f5bed9 and bbcd3e38a4f3), plus b9c109504853 ("swim: Add
track zero recalibration delay"). Thanks for the pointer to 31d813a3b8cb.

-- 
Thanks,
Sasha
