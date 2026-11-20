Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.29
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192594;
	b=Myog4JVlP0WG2NtbxlMctmStiBAVN5xfXmpF6Duaaogh2VhH6WWTnIbHjCOdNV3DiKd9
	 xz08SMF+ZsDxQ+yl5EZkhoUYecujfVxWe4buG+BpEz0DJm5ONhEqxN4euyQnPaeEJmAUb
	 LAopEnKh+ncsmjcrnS7jS44T0I7a0C1qidSLprL+BTdGPtXvcHsSUl7cQuqqGymcougia
	 BD5IpMjpgIUWFOXz4Hr9Jgo0VroiOvXTT1xmQaPUttWYEiGQFWN24Wkn4QN8oGouZeZ94
	 CSU1NjZxixfW1monbN47c+gGGaPBAEKlPXl7oUDeiVeOqVicPoERQAaKpcNjl2DcYcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192594;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=TCHJhQ2/VbpYPCu0wGNcmFTWOl0tkhhd7T5k+lzPoW8=;
	b=gJmx9dKoW7l5dsegvnIEKhK7J3mA1Jn2r3gp9PNwHLb1GjEGuCsvu4NNRJeU+8k4rWCp
	 KssVmoFMY46eRJEas3Lg2ZuWg2toMK0KpC+7ANzdpayB8QSe8v5osBTzmfaeyJTif7afa
	 QDFNu7z4QNd7XyJEVphpleJ3CJSdpNwI0T23imuZDnE0u0VRRbhwW4sAuX4UAGVWKhFj2
	 /V77tRqlY9HT7uSQpVLCV1Fk4WCXbUPD6kuN80iYaqjTCAtr1LkcZ4C2iC08ugloQvnAu
	 2HBZuvTPNnNMpkBOM0aZZdIEJY0bpgOkoEggNKbNpuMByL/KWSwOD3KjjVy7j4Xc36A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pm.me;
	spf=pass smtp.mailfrom=pm.me;
	dkim=pass header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=nJ1+7KYb;
	arc=none smtp.remote-ip=79.135.106.29
Received: from mail-10629.protonmail.ch (mail-10629.protonmail.ch [79.135.106.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA1A606A332
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 16:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DA1A606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=nJ1+7KYb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1795192590; x=1795451790;
	bh=TCHJhQ2/VbpYPCu0wGNcmFTWOl0tkhhd7T5k+lzPoW8=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=nJ1+7KYbcB5jo+Am/FeHvLEgIATqMLXvamsY3DQL10+N9Ooy+Y7exXi7FGkc/in15
	 iaTFqTYL9/+7o4vyh1Dldn89O+oRKdmiT54r7cKgtaAyfEezFCp1XcdyR1dwfjDH7J
	 eVnFy27M8oQTD77X2zgpSqSIoqe2J5D+KsWVZdlQEX5JOiRTn/8lV1Jj5p0bVFzgnE
	 N2JZjGymPfsdbeoVEwKU77WTO+APwc2F483xiwYcCbkrth36nlPsPPQitFnmMI6VY6
	 6MQLjPPVAocSPVBBolQYyvA4tCSt+xrJj49m69Kp9X805F8ech8k+YdkIEykUGnlmJ
	 B5Lk2GCn3NgiA==
Date: Fri, 20 Nov 2026 16:36:23 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Sergey Lebedev <lsa.uz@pm.me>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
Message-ID: <20261120163615.21429-1-lsa.uz@pm.me>
Feedback-ID: 113843758:user:proton
X-Pm-Message-ID: 96ca51afebb2f71b026ceb62afe24bde01959978
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Built with Ubuntu's config (Rust off) and booted on a Surface Pro 11
(Lunar Lake, Intel BE201 Bluetooth over btintel_pcie). Ten s2idle
cycles: no suspend failures, no alive-interrupt timeouts, and Bluetooth
up and scanning after each resume.

The debugfs_create_str() warnings I reported on rc1 are gone: no
WARNING at boot, and the SoundWire firmware_file entries are created.

Tested-by: Sergey Lebedev <lsa.uz@pm.me> # Surface Pro 11, btintel_pcie s2i=
dle

