Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795140565;
	b=G8NZp9KIhImB5lqp3NJeuciit+p2ge/3m8s41fsPJuPOPbFFiWx1ES8JLKfd33d/AI9+
	 G67v5E8uLNf1AdbtaVn3iBltuSBYHrqjoGbMMZG2UV/8JPp3+I1OdMIJo1X0G3beMvnHH
	 jUhchmGxyaQqbjuLlIO7FlK+9Y6Cfs1ydhRyJ7+/U6HVd2MmEtpcXSMo4hegupT+xQQi7
	 mQaKe30DmVFRjKkiAKIz3KWK9ADqNr3KexL5/8CjJLt4ZlpWXGzjHuk5QvETdZzkcBH8C
	 wiiPTWd7Pemf/gTT07yR9y15+TH1JLhWLIBEae151zNswZro1JQEEYt5oFq+1GQ4rCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795140565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=k9mf9kp/ztzdtwNyY6F2Of7TRSCeQdigol2FqO2J41o=;
	b=BB9ujuZRG0feI4FcelYD7vZcdLdL6+zcrgAwXIyPffDlU5gYc1/LiZy7F4pyV2qNSOJ9
	 A1T0BPtkTLjqzLOpFxXx0ph6KNOV6a4fWSZvak1WuHw6o3d50k9ilAjaLaH2YXzjFOuDF
	 693jwbfypT7csNCZuKjYqwZZfYEdcxp4bC58dGCM1V1M3RURJVLOL9DcYr9nfwFSmBOqe
	 b3LdlaJct31ImmlnbQtSe1SUJ/MqKMak8J3ru6NNOZMcqXX+ptTZ6QM5LOLeSmLYzlpKK
	 2r6eL7ZKdgbu9EB5Eat+J0qXtrP58Si2BFAfxvj42w+lqEAea37SjiQZ9sYzdRq423g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AzBenF0b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4208B606A333;
	Fri, 20 Nov 2026 02:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AzBenF0b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794F41F000D2;
	Fri, 20 Nov 2026 02:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795140564;
	bh=k9mf9kp/ztzdtwNyY6F2Of7TRSCeQdigol2FqO2J41o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AzBenF0bXWAEeXZRA45RxgbxRIa/NRq0QMOYy9PET1anYBA17ju0ey/41OcJSrbwi
	 GlphR2hU4DSn0EkpsT4llPsKZRAy9LmNwMlUA07BxbRu5+KbDYABGI6cmZmwM2fl8U
	 V01eHc3jQFPS+Mokh0cIu2zQErdy/T+OJBlc+5oBoL3g2jjFS3wU2enwHTCNRPmVeu
	 K9LZsFc+xHRafOAA2bzEOwXKoYHmtzEZCkZpl0iABCAS99fXoyYB5rpOjytpK3OEGV
	 OfepbGHFFWx9PZo8CdQ83zCtEk93/HrJhrtx44/jzGuwdJ0VhQ0pHWcXBYD0xvHRLo
	 8CRvvB1GOjK0w==
From: Sasha Levin <sashal@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
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
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>,
	"Barry K. Nathan" <barryn@pobox.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [PATCH 5.10 0000/1848] 5.10.275-rc1 review
Date: Thu, 19 Nov 2026 21:09:04 -0500
Message-ID: <20261120020908.2320910-7-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2cc4e958-33bc-45f7-bbd9-c6763fa3a8d0@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org> <2cc4e958-33bc-45f7-bbd9-c6763fa3a8d0@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Nov 18, 2026 at 06:02:21PM -0700, Shuah Khan wrote:
> net/core/filter.c:5867:26: error: implicit declaration of function ‘seg6_get_srh
> ’ [-Werror=implicit-function-declaration]

This is e8b084646b94 ("bpf: Validate the SRH which End.DT6 uncovers in
End.BPF"), which calls seg6_get_srh(); 5.10 does not have that function.
It is dropped from the 5.10 queue together with 434324c611a9 ("bpf: Pull
the inner header for End.DT6 in End.BPF"), which relies on it.
427e751a231a ("bpf: Update the SRH state if End.B6 fails late") stays.

-- 
Thanks,
Sasha
