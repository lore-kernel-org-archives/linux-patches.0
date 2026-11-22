Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318775;
	b=cH3bEGPIllWzypMSuEmydQ7zi+F6ECMUR9GrcPftcmetUPmPAYe+qkloZckjGSV1m6Oz
	 Pg/0Z/gyKGnKelW/uBrGouh9vDpEbgeN89EVMct+17eetf/wtdMLuQLqUE6ciXIuiTNXa
	 o8ZNiQGYreWLef+IH1EFj8YdGmcoYvNDd8ndh1M6Vi/wlxvQTfP/9sgNylr2gPijUhLz+
	 dv/7XFWGp6mS5ZVAqbt4BqoHzuzBDeZqpeWlYub8/+OZgP0ck0zydTZbWLvIKGEfmCCx8
	 Q48KLOHN7o1mCnumvM/johu/sWGowTeZc3NJ2oxhPqvPr8wladqPfBFRwgEb/MJ8OuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jqOF4VMqq79QszXbzfvJWzTWdMt3ROa73c6SgEJ7QIg=;
	b=km0izSY7su6FRg3/3uSVPBHgcg8g2XRK7aCO3BtEyu0nsekYzSkamA1CNEBKlqd9DZZo
	 5beXeW8eFGJCUezUYBZVkWrtNwSJ4/9gTOWeU84/j3jqy5lvWKLVnuVNGJyZGqRBUxoJy
	 jFzH7qygoGJ8Sc4BzFPbv46Tp/ZdGlRJ5YPuuM9VJTt5Jzu3GnPDBwTCjTWuNDh1P+KC1
	 nH9WmMPdYZhM/vJKZfslVVRzbqtN+7WuRG8Mi8iyh9EK3ZgwWIA7oBqd10Imhl9cOkHa8
	 okt16jQhudGyF7L4BNyF+WpjR6U4WRIo6VF7FnmH3VU04iRNkQnx5rcGpkLLDyK3bng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KEgVcufG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FB3606A33F;
	Sun, 22 Nov 2026 03:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KEgVcufG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07281F000CF;
	Sun, 22 Nov 2026 03:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318775;
	bh=jqOF4VMqq79QszXbzfvJWzTWdMt3ROa73c6SgEJ7QIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEgVcufGIo07HOrpPM5pnU2Gw6OrUfzx0PS5dRmR3fSq1cPvLIKJvlJHtHQ1pG7Z0
	 l+/Xo9EwGuR9Z1o6V5VoSehkwPLiAO+IzKtvSEtTMBAlnB+1F/+BLRB4Js6g/4M/66
	 bWQblFhbOyHanUH2QHrQ85Of/OofeZfUgvLu/4T5uicoy/A2hpx9GLZQyzPMnmxVHf
	 fU5dHfDnC+ebHuyaKlJppTGnzZHuEebtJagruJG6rP5yl7KTD7wHH/XtoMkCVR3ONw
	 FEj0DkRSM+ljFDwLf4OPmbuX39zqJpDxeIvJ+BmP3pP2BBKH4bEJ47wnFk/hDGi2dE
	 VDRC+ACCme6Jw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Luigi Lauro <luigi.lauro@gmail.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 0674/2214] drm/amdgpu: require _PR3 for BOCO
Date: Sat, 21 Nov 2026 22:39:01 -0500
Message-ID: <2026-11-21-2-daily-reply-0018@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <7917cf01-8390-42da-9110-b0ac64ed01c6@oracle.com>
References: <7917cf01-8390-42da-9110-b0ac64ed01c6@oracle.com>
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

> If _PR3 is present on the link partner but absent on the root port, 5.15
> leaves has_pr3 false. Such a GPU previously passed through the
> hybrid-ATPX fallback. Removing that fallback now rejects BOCO and can
> also disable runtime power management.

Dropped from 6.6, 6.1 and 5.15, thanks.

-- 
Thanks,
Sasha
