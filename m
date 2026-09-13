Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632E438CFE7
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 21:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789336460; cv=none; b=lBYyImrDp2B28Ggef42OTDmfiWQK+cCFzDAs7jtg++Z51DQTMstiB9GZ0uz52pMeq4S9qGFsC712w/GJ7McZiBsgf/JLpMSfwPFovDnwCl026JYJXAN4sXHKa5blEeM0kHJARte0Z4wB3pvN5ey4KCiw0kCB/b6nzyx9Eb8fSKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789336460; c=relaxed/simple;
	bh=/6yRs6phWpHS9WKXgR+JCwbaMv92lsqYofJsXkDL7d8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BOHfiwofiljBCvMq1QLJrzpa7bcF8dFrrPNyUrNMi25l1tVInbBuQ2IKrbmM7uDJLKvPH1Vmtc2vqyNFfIch2rQY3VXpUdOiftZDEB0z2WH6Db1wkMzdltITtxuvL5fX0PuNfGwek3zd/tUYlxtVBqADmqjqqEu0NfYJ3eGysKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PSlpnwZw; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PSlpnwZw"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b965f447cso9446665e9.3
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 14:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789336456; x=1789941256; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/6yRs6phWpHS9WKXgR+JCwbaMv92lsqYofJsXkDL7d8=;
        b=PSlpnwZwPZmu3LkSQ9l76DfoRvDmmwHxB/2vYK8F3+27MVs0StI3R+bcAheUkPDiQo
         xFbAwSZcTjWe9KzmQOvL/ultGUcQxtUJleHmF1jzhC7VpCokwNpdWN5D1cephlKquJVC
         SJ9ul3DbqHXKrd+nuUkvlO+HnOMwB5kTFb+fdcv5nzGHlwALlPhFQflTfj4L1cgDetbU
         sgVN7ZAM60XEGvI2Y0IqyJ1ReLPPB+LTwRRotnXL3SI7A/zwRxUDuFXnADS/57Z6LAIu
         iuS8dqZH6I+1hb4jl8UGUfT4f6hNlC7Qhrh7GFuLm93Nm18WWfFL1R86yxsNhENNo0Dg
         IoZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789336456; x=1789941256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/6yRs6phWpHS9WKXgR+JCwbaMv92lsqYofJsXkDL7d8=;
        b=PsPNLDc+vNYpKO0oEpSeOTr3Xalnfq/8CaXc8L+yyzBEZBK41lp0pPTWeyqSkrYTpa
         02MyCdTUzL5mhrxAroy21hIXlAjkXcjix5R09T6MlhvvSQxqLzIF0PBEZEHepdnSCvbL
         UjmUNx8Fo0KMpmUUz3byifl6B/uDTWF7GLpunGgQp253Qwtg47JLCArcZp00tbnyxNcj
         jeVC2Td5yEpCji97LDv0w3kJbjIBlDMO+1w3YH41jO245GIwKefQuo8hcB5LHHaqdKkE
         koYYAdDwE1EycPPBT3cgrhnRCJpcGFUFYeIf1wdHRd5BECalVtI2sgQJA1fWkXpwdHN0
         OEzg==
X-Forwarded-Encrypted: i=1; AKwUvBz3VeGnHmwLy1Fpi9ICi5x2mOuOOxn0mQchJovZN4A+dSA/2co8Npt7HtrhNSb3IIQyjg64sAql@lists.linux.dev
X-Gm-Message-State: AFuF++lhGEDT8+MN0uN11+NnuUMSFq9TAwslsoE8nrc/N4dn4OeocICT
	YyzLUcfI8Gu41JST6fQEdtXK9T6MsvS0jIGMpKK+H1CNUvJXOBsIVP3B
X-Gm-Gg: AYBFou3gbGhUB76XEIhGH9aHH8F9KaSVTMp8neAp++YrH+pCGMdl7kfVYnTNvzww0hb
	InPnafgBAU8YTf8Vgmhi/q6hnZCyfIiyMqE9Vhh6bz7WMEOsJmdX1wnNBMa2tluTLYXttrrxLUr
	7B7Xmgv5n7f9N0rAn/otozBENVL8Yh5kyazyjIpsdfvSrykbdpDhgKQEZeQ9jReaLFi/yknq8t9
	SESqWL6gFU22rlkOxY93B46CawNKx8UZqltBIccPYdFI13cjsVE4o29ni1wPXaKKvK9Mdix8/AI
	eF3DnqCURVN9mXdq2nlvLIHvlCgZsvRpfl/trbIUVRbs2TsTcd/bHR999cwATp66Bn1a/C9X+Nz
	kIR8stM3YjjAi35xucR9RcOEXaD0/u86KY+6h6xaFODNGmXhfjndnXxjfd4slGIPZbc/piM4Qou
	sc/mqfDi7tTaBY1WzIs4wOvIggJ9tthOW960VRLnO3TP5Fa9lOtAbV1u2UxFhIecvWomhfunN24
	7nt17aWHaV1bHWpqqJh6L7qOpw7MtA1zG3udA/zQvQ2fpe67rGxWYDN7CQ+JE8iuwSHK4X4ET7t
	qJf6pIAuy6yj75lPmuZ0OYSs0wRKiPbRM3GjCMKBXZnPmy+53A+aS5coSWalXT7LiKd3dO+Pz9p
	a/e0=
X-Received: by 2002:a05:600c:8b72:b0:49e:6a76:77bf with SMTP id 5b1f17b1804b1-49e6cad489emr77938265e9.15.1789336456197;
        Sun, 13 Sep 2026 14:54:16 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0e6-2301-7846-2cfb-35f5-6359.310.pool.telefonica.de. [2a02:3100:a0e6:2301:7846:2cfb:35f5:6359])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e6fc9c027sm156932495e9.1.2026.09.13.14.54.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 14:54:15 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Meng Yu <yumeng18@huawei.com>,
	Zaibo Xu <xuzaibo@huawei.com>,
	kernel test robot <lkp@intel.com>,
	Hui Tang <tanghui20@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 369/798] crypto: ecdh - move curve_id of ECDH from the key to algorithm name
Date: Sun, 13 Sep 2026 23:54:12 +0200
Message-Id: <20260913215412.5975-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260912065525.614310014@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org> <20260912065525.614310014@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please hold this patch unless 5.10 backports of upstream commits
8fd28fa5046b ("crypto: ecdh - fix 'ecdh_init'") and 6889fc2104e5
("crypto: ecdh - fix ecdh-nist-p192's entry in testmgr") can also be
included.

This backport can leave P-192 registered after a failed module load, with
the crypto registry pointing into freed module memory. It also lets P-192
register without its known-answer test and be used in FIPS mode.

I reproduced both issues on the exact 5.10.270-rc1 tip
f69aa74a82509ee94a2aac2822b4189496f267a8 in QEMU.

For the unwind case, a test module pre-registered the P-256 driver name to
make its registration fail after P-192 had registered. The ecdh module was
then freed, and a P-192 lookup hit the stale registry entry and panicked in
__crypto_alg_lookup() under KASAN. With both fixes applied, P-192 was
unregistered and the same lookup returned -ENOENT.

With fips=1, the unmodified rc1 registered P-192 and a lookup succeeded.
With both fixes applied, P-192 was rejected and the lookup returned
-ELIBBAD.

Thanks,
Karl
