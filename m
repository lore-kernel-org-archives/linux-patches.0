Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795140570;
	b=szFRmcN7kJXXQh1WwmWRjQfiCnCGlCjSQhfJ9I8HAaVow/CpEM0VWQZ5ev/1xyUhlmNb
	 G4/3KuId9ktC/8J45T0w+pX/UY0EACvrz8Mmh+CR9uEslIlsPty/7abrRprHp1aT5BNRm
	 cLe0lmA3zWoNU88Du7JwQgn2ttBxQEw9ddWa5i07HpLAHRin43xZjMyuqNq94ikVGFP9V
	 +pJnQzIR3eg6sFZlgz/TiZ7B8ZmL7yn8It/ldwNTpoFflej5q/NCZaxDUYSctEejMkmIx
	 qrlPxl4wZIUwSNLXYfB8qKoLjqUzae7EblAxqn1cihcdc4DYpXZXyXrvSIc56di+KOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795140570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=H22hd88t0S0qNnIQH1JWdpVPsC/ZXcsrJtl+PbwAaOE=;
	b=Yp8hGjuKPIz53IOe7WHDjyeS3iWjicXKGxdnbOjx1E03JqiqDATOI++acbZZx3ACLsSY
	 FWle4RQooyIK+yTcRnWhfoKKgV6qvB6BMjWJ0xIU1ZXhtkHTH+95NenfyjBVDkZtNsNam
	 zbcK03xuxL/FDNfvP8HQ95jvFCPsLAfZOhqZJUVStwFKleCJmKg5vo7KfoWqcjC06+WHd
	 IvHqKUlROQ43lnGBt+FcMwgus0s7HF9yj9H+K2bFiFVQ40+GkVRpL+BQedlmk/nx5ildj
	 2ekQX1bF4U5gOH2yVljwpHH4oVaMNmwzVPK6mBHUftCYr+GB7LFLmpcGE3KCG0DrkLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J5IuIL8T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A748606A32C;
	Fri, 20 Nov 2026 02:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J5IuIL8T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4AA1F00A19;
	Fri, 20 Nov 2026 02:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795140569;
	bh=H22hd88t0S0qNnIQH1JWdpVPsC/ZXcsrJtl+PbwAaOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5IuIL8TwG/d4JE851Ks236J1XCGkkHX+4z/BY+UhP4DNnIJ6nLIouPce4T915iwy
	 Uo27v2UakhpLUNYboHDp9GwQcitNd43T0nmPxoVg0rePuF7TPwCmmASc1qfJL/wU+d
	 PjuyvkN4T2P6839eC+GdKx4hUP75vBErRVZgJzMuo6byyyfESaBhHjaOGSAQQs9tj6
	 kFhsA69itTtI0W3+UHXtsGDPntBjmspPDuDErf87nw423qtju5YK86HIiA8Lajbqc5
	 GXz/2d8JS3RgYdyYFsb1Gbe7aH5VkDzAANNPI6gRwBiFAmSkTZ2e5YlfYKTf8nVjBR
	 Bgqprwwt9zW+g==
From: Sasha Levin <sashal@kernel.org>
To: Joungmin Lee <leejm516@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 0000/2151] 6.18.65-rc1 review
Date: Thu, 19 Nov 2026 21:09:07 -0500
Message-ID: <20261120020908.2320910-10-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <088f8590-0ee5-41e8-9a2c-48566d6ced82@gmail.com>
References: <20261118150121.603863898@linuxfoundation.org> <088f8590-0ee5-41e8-9a2c-48566d6ced82@gmail.com>
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

On Thu, Nov 19, 2026 at 03:49:39PM +0900, Joungmin Lee wrote:
> [    3.060808] genirq: Setting trigger mode 3 for irq 87 failed
> (amd_gpio_irq_set_type+0x0/0x180)

That line comes from 44c232e80adc ("pinctrl: amd: add timeout to irq-enable
readback"): with it amd_gpio_irq_set_type() gives up after 1 ms and returns
-ETIMEDOUT. It is dropped from the 7.3, 6.18, 6.12, 6.6 and 6.1 queues.

-- 
Thanks,
Sasha
