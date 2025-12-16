Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7342E348453;
	Tue, 16 Dec 2025 11:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886348; cv=none; b=s7KKNYTM/zWYjNmCP9CE8l4rb8/fPngC7+qhqxDG3nSl/wLixGYtGkDb2h7zdAnomtojVu9/koOqfPP1pMl3av3MccV5NzQPp2G0QzEhVkA9SYY8UWDVl8febFNr7+bS3eXk/q7H8Kqwt/p+UyDEZK+yqeY680aUR9uHMJVfacU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886348; c=relaxed/simple;
	bh=gRujAbBlBzk8yHD3ErC2r4d25eiLbiIj2liNBTisVeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KgR9KgSuVdiBCOG87XRNZU9pw8LeAHKvIm6AcQPLHLLqcKzTClYG+qFr8n70O59D9bRUJU4drSzQG1Yv8+C9DYKoXJ/+bPTTbtUhmsChJajKGa/rBUKU5nJWy8OIOTJvCyiDOqQbGMnMTa0a+qDQrYovb59PfBxWfHMdjsE58L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+4a2H8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+4a2H8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFBCC16AAE;
	Tue, 16 Dec 2025 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886348;
	bh=gRujAbBlBzk8yHD3ErC2r4d25eiLbiIj2liNBTisVeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+4a2H8u6ZaM6M10UfQwIKblYRqYhbIN+1KDGmJYoOeWZe00peISfM/eMMSdnJCrQ
	 e/8bRNROuOoJ8R+wZ0k3uDFv5bqd7KdW4kzvpetJ5RM/3o2USHgjT9YNV09fD1gvhb
	 G+1bNr4ugkY6OumIcl76K7iC/H3ENLRdeiRTTPo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 410/507] net: dsa: b53: fix extracting VID from entry for BCM5325/65
Date: Tue, 16 Dec 2025 12:14:11 +0100
Message-ID: <20251216111400.316806419@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 9316012dd01952f75e37035360138ccc786ef727 ]

BCM5325/65's Entry register uses the highest three bits for
VALID/STATIC/AGE, so shifting by 53 only will add these to
b53_arl_entry::vid.

So make sure to mask the vid value as well, to not get invalid VIDs.

Fixes: c45655386e53 ("net: dsa: b53: add support for FDB operations on 5325/5365")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Álvaro Fernández Rojas <noltari@gmail.com>
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20251128080625.27181-3-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_priv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 458775f951643..2f44b3b6a0d9f 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -338,7 +338,7 @@ static inline void b53_arl_to_entry_25(struct b53_arl_entry *ent,
 	ent->is_age = !!(mac_vid & ARLTBL_AGE_25);
 	ent->is_static = !!(mac_vid & ARLTBL_STATIC_25);
 	u64_to_ether_addr(mac_vid, ent->mac);
-	ent->vid = mac_vid >> ARLTBL_VID_S_65;
+	ent->vid = (mac_vid >> ARLTBL_VID_S_65) & ARLTBL_VID_MASK_25;
 }
 
 static inline void b53_arl_from_entry(u64 *mac_vid, u32 *fwd_entry,
-- 
2.51.0



