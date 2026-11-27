Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798928;
	b=oqFeycllHg7nZL7xy9huDxbNFe8Nwv7SDtiv4KZ2dWSHtR7+GqMrjVZ81jwIN0fs6G/h
	 67SVyMiRyLiIo+4no7f2FXx1fqd8g53OSTDKkli+dZga9dw+jAk+05qBCmsebF0ivNyqP
	 MU7VUR2uCXqOcKaA5IJ6to68LR1yWEKp4i0Sw7C/oRQRP70fx0zP6UBOim0wxkv3bAGIG
	 FZkD8gblJpj2nE8SJAFQyCpjLVde54mPMzE1UrnCv99XuzuylgeSig5DxyPzuB97GJfiY
	 AWd9IOnUfhXh3GO7IzrNSg4xWVoBr5VfrjJk+QLfC6SGzrAZU13tSejJEj/W6VET5dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/LGARDRlCQR5YMbXvrXQVY0jCQlxcPo9K7YPb7MYHRY=;
	b=X9sS+g6gXarsArNOO7v9aXupZtB4T3m7gYrKyOF+7DT8IkrPtVRQ2sFe5Cg8fUrVa4GE
	 kvPVxUQfz74lnvZcunMyG3+DKXQ7DXrpZjNjvzq49aY0WtOU+qE5dYHvHw9BC87k3gIwd
	 o+5ewz31s1uP2A7+aTDWSM0aFSZlcxQcCAYdaHAlZTHSdKZ1BT7gqCv6RWQ7BsAdFwcGg
	 s1ZhpY5x/YhKdWRkcEd1zCKQqmIfzUAZy0Nq0VjpdLrV/xsRtAsWtfwWjZ5uIOwTj00Ka
	 nD9a7/QoPSI0ksA73ijKLFZs+ImbpA5MHSCrxGbq86aFJaLziXJhE5RgKu7GZjCMbBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X6YkAm9j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD2F606A32A;
	Fri, 27 Nov 2026 17:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X6YkAm9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCEE1F00924;
	Fri, 27 Nov 2026 17:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795798927;
	bh=/LGARDRlCQR5YMbXvrXQVY0jCQlxcPo9K7YPb7MYHRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6YkAm9jQ9CAmkNODzphRN0HUZFzXYEjEJF9aBsfRuWfOQ4Ni0sOPXI4+jzTo4qy3
	 iXH0BUHJId/oncqRS7Yt/Eksnh3Q5yUmnEHewLW1MDlzmBwv0pqUKGKlDyywhvPedx
	 iA4TMADB6cOAFddmSuWjnzJNQb5OdvuIJ3cb3CzowJr7udPUqFRfI4YmP1tA1iGg1X
	 lFbwonCS1gB/gQTTq4jfV6p9QoB527YwNCXOGYY53i9Y7wTsUxJgDsRwz3tkFVxp5R
	 Jxzntwgj8jw/74EXmHtqx2A6rIXkIRsHrspapd/RBKx8LYLkGgX0QERx090IkCjY9b
	 fxQeVJc9drzJA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	sungbyeongchan <tjdqudcks0424@naver.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Nishanth Menon <nm@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Francesco Dolcini <francesco@dolcini.it>
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc1 review
Date: Fri, 27 Nov 2026 12:01:08 -0500
Message-ID: <2026-11-26-1-daily-reply-0020@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261126173920.GA180459@francesco-nb>
References: <20261126173920.GA180459@francesco-nb>
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

> According to claude the issue is
>
> commit e498eb93f961 ("virtio_ring: use shadow flags when detaching split descriptors")
>
> and those commits should be dropped

Right, I've dropped all three from the 6.18 queue.

6.18 lacks 03f05c4eeb7b ("virtio_ring: determine descriptor flags at one
time"), so the desc_extra shadow flags of the last descriptor in a direct
chain keep VRING_DESC_F_NEXT unless its buffer needs unmapping. With the
shadow flags as the loop condition, detach_buf_split() then walks past
the end of the chain into the free list. 7.3 has 03f05c4eeb7b and keeps
the patch.

-- 
Thanks,
Sasha
