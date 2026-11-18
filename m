Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055754;
	b=4Lxib3h3dJJA/eUg4V3bK8uQJ9ZMCF8vrP1JP2bQzewEHNxSLnCyKok5pNbmTopjo/9e
	 JOUfTmTcD5TmMlJTXEJO1rIEnaE4KLMzVJLO4D/fSzEZDj8tTPJ1uOHdy+Pt1cMmlqAWM
	 p6wuBvr/rRKA1wihPljX+yi75k4RwP6skcFwzcP9pa904hrsvO8jifDTRPTyw6SbG4ylJ
	 dGkS3v+nd2vg6QiJgpNFoZueO2wlb54/DoXjMat0/79uFvYptclUPFXlhZvDz/1Ea8Bgk
	 C/dfDyRqE1t2E6vMa9r9h4WIWpqeDmlQFcPjQeWElEB2fX/mdFKbqFRKjtoxKEh183A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G6BuDFww1rZe03XAcQADB/vOp5eLq19437B8SLNCTk4=;
	b=NJQBbSpY/CBl0kmnOwBzqr/2K6jwbhDaJ7XngWES6bK1NxStCP5m/vgug73qyBwU64ba
	 X5WICrtrxeMg6aLC8/XB/i6geMVosTOmozuISxqUK5DERf1kPdhRxIh6HGsSp6cW4y2xr
	 n9Vq0UzX70HeEQLYpLQE0dT4FZRiBN3UNnoz/w1K/wqq9Z3cNrBSi9YwUC9bLDhlpEiJu
	 h5TKSBtM2tiB4nB8rqL3XDlNmY/ckPSmZUMh/3f752yMaIIW9Mrw0Bscp2MKzklRk8uB4
	 4m4ncPkZ3umftZj2+xp/MQw6Uoz78A+fG55bPTW9Itu/raARjHUXghymNkTx0hPhJqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jVdlH1oC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B9D606A330;
	Thu, 19 Nov 2026 02:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jVdlH1oC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714A61F000C4;
	Thu, 19 Nov 2026 02:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055754;
	bh=G6BuDFww1rZe03XAcQADB/vOp5eLq19437B8SLNCTk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jVdlH1oCuNwSR1Mek7X8u2bG+AEB6MrcYIP8GWrBlEA09idHCbUd6ZBl48yihKFD4
	 PBOAtY0tlGCZG5RLj7GUnVrim7euNrIDLQhwNGjOcaJeKDlvyYtHnX3lDbQ5JCi3CN
	 jzMi3qUCiZrvQbThwW2uxZr+/22wtC6qZ7pi0GSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1744/2214] wifi: b43: dont pass unterminated string to sscanf()
Date: Wed, 18 Nov 2026 15:57:00 +0100
Message-ID: <20261118150121.392620674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 9b6cb072f9249e2cdb7c32be2b8069774c7e01e6 ]

The "buf" buffer is a PAGE_SIZE and allocated with kzalloc().  We store
a string from the user in it and then pass it to sscanf() in the write
functions such as shm32write__write_file().  Only a few numbers are
stored in the buffer so it never comes close to filling up the whole
PAGE_SIZE.  Reserve the last character of the page for a NUL terminator.

This is debugfs so it's root only.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/b396713e697c7411b23a2157e2102c347ac900bc.1790839793.git.error27@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/debugfs.c b/drivers/net/wireless/broadcom/b43/debugfs.c
index efa98444e3fb0..3dcf830315b8f 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -561,7 +561,7 @@ static ssize_t b43_debugfs_write(struct file *file,
 
 	if (!count)
 		return 0;
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 	dev = file->private_data;
 	if (!dev)
-- 
2.53.0



