Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443354;
	b=lpUwsnZaz95M5hi6YOUUK8+L2u7HtnMuumZmTaBnGMBKHUCy24AUxStgpSlqwSkyoaKv
	 LCwhujXRh7VPs7wbVWF01/r6ycLDSBzI7YwQxa7kH5wYdSTgWZSVmxevYYLDxvAK847YV
	 Wss7m271U0tq38JvuvN9kPGEMsw1Z0sRag3n4TUJ77F3eX0tngU1GiIexv8CNboZnGaoN
	 VzBxPqaK0W6vEkavioSWimyQbsX6jt9GIvibe26spg/TeO2PJbqoRzgLFjuQcIQB9KxgM
	 htwQfcc4ae04spjzD+R04AsQr1ZiswdBq0y7+DdbirFWNDiXmlQVNCc3g/SUI3OnhxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=v6EEXAUpl0iY8KsWeaGrKRmoh1OyE5K7fp4U2mkmmSA=;
	b=o+AdLThx7CFszvFVvTTQYO5DZYYY+PmBCatI0pgD7qsoX7ZjeAedC7If7moFI6/wPL/E
	 /6p01l2icylQpObxtS4a0vYSL+7F4+QsrL8dF/gEwQM2w0MuMLnNWUiyZerbylEv15heV
	 spFqcIP5ZzghH959YbPa0XucNl4IebagMflqBmjF1DfZJYhIa4ifQ+YIHpDueot3q54kl
	 8tsxZX7O2JSVbJvdnQR9uA7RxcrmblIgiXjNm2aFo6i1UQgnzQQZDgKnHBxmqkCslS9Qz
	 yYEWqs0ZfLt5H/vVja1FZAbSrAM7e0/wEX2ndDvLVcScDMQCKN0ld3Iz42IpLU0ZxPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gh1YipFh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13054606A324;
	Mon, 19 Oct 2026 20:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gh1YipFh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B201F000C8;
	Mon, 19 Oct 2026 20:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792443353;
	bh=v6EEXAUpl0iY8KsWeaGrKRmoh1OyE5K7fp4U2mkmmSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gh1YipFhXiEvuXeViXj4GfVyFdJjal1FpY0Ewi3s2NxzIoqT29GrfXRMMSWIe78FI
	 QQ6hSinl70bMqmtomSIN6Q/5PNSaCTAyz+PhKI/Fsd0vdS+4PaoBLxTyBd3HE8arKB
	 Q70Su1J2kJRDiUOk0L2PQrwDwwVOxppvJ/CLVJfp0Yk0b+we1+7SaBQ4TMhCj8vXgY
	 fDZEqRSOa1nW/zODn2LBLk+Bu9Orf4P0ytAintCtOiYzmg+1VpwF/sqXACOCiSy6DF
	 GXAToC7IVNGTDsKMMGqOnFW8UIOlrzUs8MG7dSzGQSvdJhb57UAlyXv9z3+sfP7MEY
	 thVO6O0i5GK9g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Wolfgang Walter <linux@stwm.de>
Subject: Re: regression 6.18.57: acpi power button vanished in machines running in qemu
Date: Mon, 19 Oct 2026 16:55:30 -0400
Message-ID: <2026-10-19-1-daily-reply-0004-acpi-fixed-button-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <5fe757e7aa54c38df3525d313598db99@stwm.de>
References: <5fe757e7aa54c38df3525d313598db99@stwm.de>
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

> since 6.18.57 there is no acpi power button any more in virtual qemu
> based machines (as far as I can see model doesn't matter).

Queued the fix for 6.18, thanks for the report and the testing.

-- 
Thanks,
Sasha
