Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006E633F598;
	Sat,  4 Jul 2026 02:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783130734; cv=none; b=ExOB33TAIi4EqO2GFy74z32L29Ed3E4xWo26hfjElw45Lzyt5aNLhVUVXGJG6xiYp8qev8dJ/5bAl8eqnlHjZQX6pqJASQHAmn1WXpQoWniEw88TrKfOCIaZuCmCLvnYzrCZcc7x2aREN8VDHc20tIfKsF3vYwMZDCj08qKb6aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783130734; c=relaxed/simple;
	bh=nqNK8+sRJnmsAwfvDSVBEbKlllV9FI4GtBwKVg+5C6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgkET8TPLWNDMt975lZ1gtL+0rEGvT+sLSzh93swm8nUVExYagsd7ZQHvoDY8HJu8fyhex1sA2efLO2WHuVLRbyc2iMmvKhkXk3megenQSEhobivDoo70i1BoMgKd7Rg0o79ZoEJWoD9AemIlZVZak/Yma+/JhbyzjWUXruWxjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DiIaaCEu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DiIaaCEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939BC1F000E9;
	Sat,  4 Jul 2026 02:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783130732;
	bh=xZMtWPlBOm3HJrDu3uXHVJ+WXsZl9fbp9k4AnItKgZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DiIaaCEun4aEzHYuFJaGsv7re8CMpH7sVz28NYblNofWqisyvDzDhW2zkrgFaTeP1
	 fNtyyf5jTEJUyLVet2HRjkDksGW5oitVjR0z8iHoQ8X9WdWhRydo6XdZpttd7m3aHb
	 C7dZkKW90v2ozKPZfpFS6rjPgYaKsffS2UsUIk1nN7YW3KYMZU6exM9/CVEw4T7gmz
	 FFUbzcSC8hkfQMUi18RPv6SRekxyikYiKkG/89NaaJPBZbXW5Kaq7L6tHlUw5716D6
	 HioZRWGx0BNO1GQJTRMIWAmVcUnKziBjtgJrRV6hcopIZzMirRY7sTUBstst5now3c
	 3N6qxzE0tjj5w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Lee Jones <lee@kernel.org>
Subject: Re: [PATCH 5.15 009/411] nfc: llcp: Fix use-after-free race in nfc_llcp_recv_cc()
Date: Fri,  3 Jul 2026 22:04:59 -0400
Message-ID: <2026070315-stable-reply-0005@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260702143500.GQ2108533@google.com>
References: <20260702143500.GQ2108533@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Jul 02, 2026 at 03:35:00PM +0100, Lee Jones wrote:
> So it appears as though the fix made it into the Stable queue, was aimed
> at v5.15.210, but never actually appeared in Stable.

Right -- what shipped in 5.15.210 was the recv_cc fix itself
(bd08bb7443c5). a06b8044169f ("nfc: llcp: protect nfc_llcp_sock_unlink()
calls") never made it into 5.15.y because the 5.10.y backport didn't
apply there.

I've now backported it to 5.15.y (moving the unlink calls under
lock_sock() in llcp_sock_release(), matching the 5.10.y resolution) and
queued it up, thanks!

-- 
Thanks,
Sasha
