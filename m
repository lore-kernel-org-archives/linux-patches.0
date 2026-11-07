Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064162;
	b=V+t3jnFgYP7gz3gWMMSMF3jkPr73HhA4L9UVQafSvu6DE/4yFAUwiNeoQ1AzSeylPQYU
	 a6nUpF6sOdsLTdFSOhbfHWNFzqatiYWltOB/agxbjPj4S9VPcN9J2lyNjNGG5BtmdjLMn
	 0pHwcPq7oP0d51dtxXRYVEhKe8W1ftNGh+SKMoh7bKml/4qFFLJP61q11ZuV4lF5Aosq3
	 n0FT50KIFKVUdnPwJhe2pChjcNKmqHyNby+u8i58yBqBwK0UfmvUpJHtg7zJ1Pb6x/Kf8
	 R80aopic0o4m+MVcbnJGPkHD3gw2+FS1ZmUXZ/dzyGKVGz7+H9z4RHKDZiQ6sG0xT3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F/VIQFQYycz9zTjedw4H0Z68GcJWtwn3vFop5QecI00=;
	b=U6F39QMB8WLqN0SSml3rhGdHCqRYo3QIvzoFJIf5HPu2wxt9angsGL/2g3J+gVIkMHxa
	 bod09d2kRNzYMbto72mz2sLDOSPoSgKM8+MgIKpUWvx6nik9diihl7/vT5bJOLuuBN7Oa
	 CjzV1GfhEtzHOG95PUzR8DJz2fSy8uFvYl6ao3yBP/i+dYR2JJOxNPGScr0ecYMwrdTpt
	 DvnJKYxEAlXhNViZSAtqpSRzic4FROmd8NH9afz7YJ+oEFMvOd1kDhPum4/B0bUvWaOGn
	 sYzChDlAajaPDYElXncJjPOUxxpfaMIYZ/H5W6grLNCF12/vBkq2hrBnP8UxzK2WLpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tFCldsrj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA27606A32E;
	Sat,  7 Nov 2026 15:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tFCldsrj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0881D1F008A1;
	Sat,  7 Nov 2026 15:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064162;
	bh=F/VIQFQYycz9zTjedw4H0Z68GcJWtwn3vFop5QecI00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tFCldsrjAXKQVJoY/5LM/XDo8hBa7w7FoHyJYQ3qCXkGhLgYPDiW4HGWxEp1bivA2
	 uPLpQwcqi2u6muSX+EGcVE57br5zPPe4uWvWqRwmhGhXWBkBvxDCNTVhLRM65gI+WG
	 7iyHY/9kZ8asn03Ji5d5mDT72r2T6jVaOBSz158Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0310/1257] mtd: Call get_wunit() on the master partition
Date: Sat,  7 Nov 2026 08:43:26 -0500
Message-ID: <20261107134947.999075501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

[ Upstream commit 904f18430e8cce829cb9130eab7a93020e33fc89 ]

The code checks whether master has get_wunit() but still calls
it on the child. Fix this.

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Cc: stable@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 491a27d0315fa..b170c3144ca8f 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -563,7 +563,7 @@ int mtd_pairing_info_to_wunit(struct mtd_info *mtd,
 		return -EINVAL;
 
 	if (master->pairing && master->pairing->get_wunit)
-		return mtd->pairing->get_wunit(master, info);
+		return master->pairing->get_wunit(master, info);
 
 	return info->pair;
 }
-- 
2.53.0



