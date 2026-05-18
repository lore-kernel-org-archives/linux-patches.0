Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166102DC767
	for <patches@lists.linux.dev>; Mon, 18 May 2026 19:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779132447; cv=none; b=X2D1wMMtcoOV+Ng0iOJSaYlBctWsJ+N28uwaQxxfOcVmehJd6IWnjvbQtoTwwuFUayy3BZGRBTFOQ7klmzmWRk/oNSU704cBrj/bQtyNFMQEPpRn1rzZhllkTB5MsJIBs+68loqJylNc5DrIDXdzK733EHdJTSv10tA5HbeYg54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779132447; c=relaxed/simple;
	bh=YRihdkqnvxmS51AeFJSpM1nEEVHb4XlF/fcLdZbrTQA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=f4bjl5/HewdFtgd+yHUqGldhpQ5LSR+vxfCY4HTkcrFZQIY8m1hTA2E4rU5Ku3LjtD+hks4pSMTpSvWV2WI7Z81DGta0owQbzmN//x2MQ9Meh9mEnUXS79EXtradLAzXlLGsQCAaqNEcUaP/Xyu3kcw7dcScOEk4Lwqs/Hga+yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Received: from mop.sam.mop (1.5.5.2.4.d.e.f.f.f.5.f.9.d.6.0.a.5.c.d.c.d.9.1.0.b.8.0.1.0.0.2.ip6.arpa [IPv6:2001:8b0:19dc:dc5a:6d9:f5ff:fed4:2551])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sam)
	by smtp.gentoo.org (Postfix) with ESMTPSA id 6BD74342496;
	Mon, 18 May 2026 19:27:24 +0000 (UTC)
From: Sam James <sam@gentoo.org>
To: Sasha Levin <sashal@kernel.org>
Cc: gregkh@linuxfoundation.org,  brauner@kernel.org,
  patches@lists.linux.dev,  stable@vger.kernel.org,  kernel@gentoo.org,
  dist-kernel@gentoo.org
Subject: Re: [PATCH 6.18 160/188] papr-hvpipe: convert
 papr_hvpipe_dev_create_handle() to FD_PREPARE()
In-Reply-To: <20260518155236.reply-0002@kernel.org>
Organization: Gentoo
References: <87cxyuq6oa.fsf@gentoo.org> <20260518155236.reply-0002@kernel.org>
User-Agent: mu4e 1.14.1; emacs 31.0.60
Date: Mon, 18 May 2026 20:27:21 +0100
Message-ID: <87tss4bjs6.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

Sasha Levin <sashal@kernel.org> writes:

> On Sun, May 17, 2026, Sam James wrote:
>> FD_PREPARE doesn't exist in 6.18, it's from:
>>
>> commit 011703a9acd76edc7c85d80dbccb6e50dba53aad
>> Author:     Christian Brauner <brauner@kernel.org>
>>     file: add FD_{ADD,PREPARE}()
>
> Thanks Sam. Backporting the FD_PREPARE/fd_publish primitives to 6.18 is
> too invasive for stable, so I've reverted both papr-hvpipe commits from
> pending-6.18:
>
>   - 09c15bbbed533 ("papr-hvpipe: convert papr_hvpipe_dev_create_handle()
>     to FD_PREPARE()")
>   - 6542e180fa6e1 ("pseries/papr-hvpipe: Fix race with interrupt handler")
>
> The race fix can be reworked later without depending on FD_PREPARE if
> the maintainers want it in 6.18.

Thanks!

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEBBAEWCgCpFiEEJaa7iN2bdkxrVUHCc4QJ9SDfkZAFAmoLaBkbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25z
Lm9wZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXQyNUE2QkI4OEREOUI3NjRDNkI1NTQx
QzI3Mzg0MDlGNTIwREY5MTkwDxxzYW1AZ2VudG9vLm9yZwAKCRBzhAn1IN+RkOiU
AQCVt4yaakLOHZVqq9FFq/dZQw+qhME6JSVmSFD4e5pnKQD/Rm1gg1V670cYU22x
UpGYe2rrRpfzLuThfUtcdJy0YwQ=
=qL7m
-----END PGP SIGNATURE-----
--=-=-=--
