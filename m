Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049227;
	b=lFZ3+p3itGzblJ+Whp0yl5G7mi65gBHWN5QzymRthClpgQvjgrtEJHhQFysTWVSZ99u4
	 46E6cjG8EVcZs6x2kHeERr7DCM69FyVmjs+Za4l58+DD7GRqzfvTzuSIJLfyZtV5MyFIO
	 tH6Xtr/+FjM1iARefy1XUhUBByt8q6vO0bBVBrUci4l6G8a2d03eT3hLDqaJtPtQ6RJHP
	 TMiLv+eI4OfisjWfLKFIPsvHO1fphF1qR68wVyJajXPHAenbAHm00BgaZRZ6d5RBvXRKm
	 IVUEQYYX8m4IZ+rB9mU2UYEZTc+h111xnKGZ+lUmxI8rcOZZPCDCK8yh/4HFdWpb7gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P/m7fSmy+6Obu8rfy5jKumbHyvDy4n645+GtO0hCenw=;
	b=hzgPLY2t/qzxGrrL6n3eny2Yx8RU+XdTWB9Po8AEOBgmWkueUVILdq2ggSH2Ms7pE3de
	 7tDvIGaJdsv2KyegPvpQ5MEtrY+0gQnCRecqNZG2HDRmV3MTGMw7ELEM28YrlP2U5Ckfz
	 fyJ7a5uteAYwmBnZz7sCZCqElt4dqY8QuELh7ClcnNqdKuArWbQ8zOYe4B+hoa7zGvFAV
	 mDchKOk5PSy+e0eGJUGDlU4y1xTgr6u9ey8eeBpsWtqj/jbgWfs3NDxPXId66IYwnH1UH
	 pAVGUeME0RnM3rf6dAvpZFjVcHT6Lii6EUg3RxBr+kxn/sNght7rfriB2hnBmYsFdAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JJVJt/SB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90ED606A320;
	Thu, 19 Nov 2026 00:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JJVJt/SB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E851F000C4;
	Thu, 19 Nov 2026 00:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049227;
	bh=P/m7fSmy+6Obu8rfy5jKumbHyvDy4n645+GtO0hCenw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJVJt/SBeIBGoXSpdfM23fe/PVaYpnGCzZCEF3lwL9NGYUvBTx1+fSdF1RFZCPH5Y
	 8TPXT9t0FmjkvhXImDk4JjSVbmwcRiNCPRjUEVHglQqp7PfQj9dN7U8MuhovUn5hjz
	 ny0bStFziJqKotmJ95t65uz4vpsWMFNP2QYCe1Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2236/2857] wifi: b43: dont pass unterminated string to sscanf()
Date: Wed, 18 Nov 2026 15:54:30 +0100
Message-ID: <20261118150321.943233407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



