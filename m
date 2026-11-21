Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795274881;
	b=IoAQoazfigGV9bghsMomuDwtBHf6cr3Z3DNQC6l+ylXrbX61G1ECPPFdsEwqNbKJeaIt
	 H5kIf4PYaNgT1nnnOZgSU2ME2W4U3wOpp24nDkhvPJqu+6dM7AHGWIhYt1p1pvDbQnDwc
	 GaU59FOxAKOLXMXk/x+ZXN1RVwNuN8Fea5mLVRWkd3qTz6JEu/zbzvrYBqZyzrZqxYb3u
	 BLcjCFyxiq1DMNY9WixK/beo8fX41vhJoeEu1gly0Cp1dxOTigaOgjPT9W4z19xH08Xil
	 ILwszVq2KWRFhl1CCaTXgy1y+5pCpIym12uQWUBlPL81m55gihjveC78KYM1Xyi09zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795274881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=n/SnBd6RYQp2xNRuiFPBj8CiqpkqxXgkkDx8ukARjWk=;
	b=gUYHVLbAKnOPNaDMWbNzt1L/VbKh4jKXlT7NAjGmNNo/MxaN43ByuiR0eYmM4ONGZtW4
	 ni12f6QxmtOcEQCGNQXQ8rRoHvVf56gEueczIohQJqx2EYlaMrN7dkXMZdq1s4AEIeaM8
	 rTNrGmFDLUHVWRVbi6zvNPFoQo/ksibvbih/qwexj+XrZ8hSzNX6GmcnQfSA23iokLdmj
	 SSC1oYWN/+fQSTppg3rIZivh+z2MFyF9AY+Nbd7o4r1HH/d47LU28+63BiFtGykxuTLFo
	 CK2zH7Ob/AOXpVweqPRLjYYZ+c9iIShtenong+6Gw8y6IzmrvNUnlsG6h3NvhGzlOSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gWVVzWrZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D40D606A320;
	Sat, 21 Nov 2026 15:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gWVVzWrZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994A61F000C6;
	Sat, 21 Nov 2026 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795274881;
	bh=n/SnBd6RYQp2xNRuiFPBj8CiqpkqxXgkkDx8ukARjWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWVVzWrZuvwVBYQ9OFBt2TcfIofnw2BXjowoeEPn+LRoow6f/dw4V1GGpXeS8LF2W
	 jqF2R7HSkSLvimcTajT6pNoo5DgeeYJ5619OcK+iZI37WsQiq7YHRREhmHv8OeLCOo
	 wNZTYyn0an0JN79Q+mowN8CdOnW7aAj9PW46TeGPYQbdSAJ0e5UpmMuuLbsn797x3a
	 c2TDppVLqzWHACjy1jI1/EcJIxUSbdRQ2y7s8mEvKhXtzhztTgwCKG91fsrrBStGtr
	 zK3MKbVnigCx7jz1d7mRATN3/b3HOOXsgBz3RIp9tqxKEDd9O9+tr8Gwm3hiHZNe3E
	 EET1Ggg9fC0HQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 0043/2214] drm/amd/pm: Validate Vega hwmgr PowerPlay table bounds
Date: Sat, 21 Nov 2026 10:27:41 -0500
Message-ID: <2026-11-21-1-daily-reply-0013@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ad2d0077-bfb7-4c43-8266-673b3bc92117@oracle.com>
References: <ad2d0077-bfb7-4c43-8266-673b3bc92117@oracle.com>
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

> With states[1], struct_size() adds the requested entries on top of
> that first state. The result is 14 bytes too large.
>
> Let us drop this ?

I've queued the missing prerequisite instead, 49afe91370b8 ("drm/amd: Fix UBSAN
array-index-out-of-bounds for Powerplay headers"), ahead of it for 6.6, 6.1,
5.15 and 5.10, so the header has states[] as in mainline. Thanks!

-- 
Thanks,
Sasha
