Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318767;
	b=gidpPlEDN9srKqrKRdnXfAnmbDWtDtIXJf9/LtvowSEf1bc9oqH00AbZRpeWYVWYK7lX
	 91eOqVs5pOD+7QSWwDM4aGE3nHrbx9HZ7rUfogirSorbSUyf7c9Rx+j8V8/5t/mZFoTqe
	 Ghpe9cpG1/PahdBWEkwnKO3g0EE48TKL21sVSE2xskp0xnwTwnNsB2rB1XQrdNjFpnUV3
	 6qT/7RKQ48ecZOC2zBAQNjNAru4FTSiUxdP4Le9GgcHQmpg5X+AsEqhcOlpOJm03pUWpc
	 DVvBAkRXQE/IDfaQ5XkK6aUh3CZhdoupJc+Cm+kb+mHbG+1/qk6O0N3njFgbaGX8Ubg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DjVCtvDJYr0KQoM5KiKptmREvZy0Q1oPOWGfFKXwl4A=;
	b=ZbD2B51Mord/dhOGX3GwtyJHED89Rtlll0E6jAhCXyKpV7sDRQ39Bp/Jmk9n8pG82fAm
	 wrPEtaIaX37x6cAcG69DNkDP9O5K9iuDDKRP0r9AOHd7cscHdS69buc2vCNKI6w2rGbr8
	 DJ9cRqI49QnVQ9nB5v0xu1mT4hbM70ULIiMHxtT3QB1Nm3tKsn1IFEzhc2bDVTzVXAoaS
	 9muDZzY5wsxVopNJnWMq6f76hvElzjgU0soIGFsyAcC+vzHMRi6u14ETRXcc2yqpUgfwp
	 DkuAnc8tsCPpmNmVxd5u5f4V6cAfKWKd9G2Pt88Ivn4q4MCwx04CP8UrEYR7+55UtCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UkEHoDdh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3CA606A32A;
	Sun, 22 Nov 2026 03:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UkEHoDdh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357451F000C0;
	Sun, 22 Nov 2026 03:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318767;
	bh=DjVCtvDJYr0KQoM5KiKptmREvZy0Q1oPOWGfFKXwl4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkEHoDdh4xkU6wHhYvKUJjX4cuQ7WU91TXHrE56KQl2mJ9dEgz8LgfirgwEQfnBMO
	 0F1Rk0UeYhbC7c3nos8/b0fHteV7Gdi/QSxPXpEHecWRqFudON8EYZTEYCrQUBd3EF
	 zi/DSQXc6YkB0CnT3DBqc/O/HJsMqDRjN6DPYW99NCo9VkkIIKbVvUjaMZj+CYzo9a
	 QwgDuscYucTKOSSP+F50SRZeC/AaaSZfBmwFdHlDFhvgEkx+AUwgtE7cYkcNTyWQzp
	 RMWXxlFD0nI9w95Wx6Mu07aoJPc/XtTp4A2+kQGTEwJvbE8wxmSUyeGxw/V6cHjFu6
	 PXueuRl5egDYw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 2025/2214] bpf: Dont take an extension for an iterator program
Date: Sat, 21 Nov 2026 22:38:52 -0500
Message-ID: <2026-11-21-2-daily-reply-0009@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <3ed06a31-d1c9-4a14-82e1-c66df4acc3c7@oracle.com>
References: <3ed06a31-d1c9-4a14-82e1-c66df4acc3c7@oracle.com>
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

> I suggest: Return false for this rejection while the helper and caller
> retain the boolean convention.

Fixed in the queue: both patches now return false there on 6.12, 6.6,
6.1, 5.15 and 5.10. Thanks!

-- 
Thanks,
Sasha
