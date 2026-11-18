Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049230;
	b=rS8xuUIqTdFEnKkUcwb9G223DFiug6besyOoJb/03Wak3AFSm2rApRKg7gAYIxZn5w5a
	 yqzos3VxkATQg+a5+ShWeDaZFR1ZaBiFTu3uQ27RrzjLVdSwdKyvymVkLkL27mXlxHV/N
	 VG04FE0gdEEv/1z6BTaRexhNuQxlq/PxVTu72oRoV0oHgog/r39VCN0NFHvIXKTMOCHam
	 AjcghUXgcEw5u4F3icRIAdGwYuSeaXUPupoYxDnK5jhqBD9bdtu1I9POnFNIECSg0kY5t
	 mabk4TovhAAgjQg9iiz3w3KoJWqbh08WPn1wdXsygFmXcKU3ENj4qN9z88WPTcibamw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=thkBayrre7l5jeuulXvEiixivOnDYeYjBaC26YoW7UY=;
	b=gMMZKb5yrp7wVTKV71JTDi9RfAJEhe2bnH4FEaKeHjnRPAdAqKao6sGn3NMNxTMOgVtC
	 PVXzvVHHt1N2yMpVZaAD1ewEgTce5qfL/RWkp/ReY+OpfCEoV5QSujD+K66V09Cs7G9tq
	 f+MV6c4WRE6saxnjaWh+9/5D0zQDulGmO/gC0D7B0A+13LWdLn2F7Cm9ExZFd57HUo5FH
	 PSh8x+hGjZAPP7bpp4+kgN28IS9zt1vg+d0JL6MsK9o9VgXYsk9306ZcpnZD17L98AekN
	 Yu0WSskIZJbE1LVmQNaC24W21smF0cdh22zxDIwNLOiJv0L8QZwyDGX77KQiLFul9xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1bCw48bb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DA3606A31C;
	Thu, 19 Nov 2026 00:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1bCw48bb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9A11F000C4;
	Thu, 19 Nov 2026 00:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049230;
	bh=thkBayrre7l5jeuulXvEiixivOnDYeYjBaC26YoW7UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bCw48bb5oBSrGkbKWlqJbkoBPwuFDY2mAU9vuAh4tlePEBhlEzC3i/v/MbEVPDdR
	 CDY72zznJm8xle4d3PVsXCG/j3ioqhZMERaHb308+BB0799y08UXw9u7TF3SBuyNKx
	 M+CLXCaqR/QxZhDN8gSUx6FwJDM4dz00mto6OoI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2237/2857] wifi: b43legacy: debugfs: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:54:31 +0100
Message-ID: <20261118150321.978925410@linuxfoundation.org>
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

[ Upstream commit f94595252b318a9ae3c01d78b3bcd33b01b1c082 ]

The "buf" buffer is PAGE_SIZE and allocated with kzalloc().  We store a
string from the user in it and then pass it to sscanf() in the write
functions such as tsf_write_file().  The buffer is only used to store a
number so we never come close to filling up the whole PAGE_SIZE.  Reserve
the last character of the page for a NUL terminator.

This is debugfs so it's root only.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/909ea7a88658b5e7c183bf0fda31687a91d73818.1790839793.git.error27@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index 6b0e8d1170611..86f0c4b717c66 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -263,7 +263,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 
 	if (!count)
 		return 0;
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 	dev = file->private_data;
 	if (!dev)
-- 
2.53.0



