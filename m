Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061210;
	b=R6LmPH5ZkLYyBXKIqIeeVWKfCZc6TiP3ISTH1Fcd0uISLwt9eSOgOFMMD5pzJVxFoJp4
	 HCNsmElPjvUtzo6I9xVs77JXhr/s3yOVpz5Fl1gAtbNZHSTypOe1pWwlComgn/kHCRc/X
	 BO5IDyIMCfdspo6msXHZf1KeuVOQrT7Gj+gu6VXPTrimRAjEkvvhfFbVA7QXGl7RAHqvg
	 b3WKIkvq1nm0wBX0wBI7vsKxF2Ur7+VrqhSEQe8b07YkRwVCreyLemG2l46av21FWtCLX
	 4pcumMkSXlNLm5Ai8TtbrLnbaLQ/Hx9WcqezvzTlUdwwLOivC4u0lM5dNt0mqwd3Acg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9W69I1nPlgo1kouuNw5Gudw6nXPEpI+ghmswe92vNuI=;
	b=3tIoxXirBX9P1ePbJqr3AWCr1Um30IbbnX5f8a9lEVDheDav3iZYRYCC8Vm4iWLzrUYp
	 Tq/+PbWQt/8DbHfoh9U4+srXnoMpqvDXJ1I+vtstNxJWHg5436o/eFRJNZGSc1hBdQiyj
	 +Oz2JdDGBz8G5idsPal8TvTg1eXdMdW2Pevdgoa53/LnRV9nmbOPRe1DSvUS2MQEYe0NC
	 BNBCUEGgdJL81dZptDtOqGQAgQMqWtlwIOMxN1fT4SFW91DNd73nME6p7wD+M9Zk/SxCt
	 Nc42sobr6exFEVXhmGhkEe0kUYcAciu7IHItwY0/EiqOhDknGWhr6AxGSOHa8BzQ8lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n/JeIRD1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE51606A325;
	Thu, 19 Nov 2026 04:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n/JeIRD1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911431F000C4;
	Thu, 19 Nov 2026 04:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061210;
	bh=9W69I1nPlgo1kouuNw5Gudw6nXPEpI+ghmswe92vNuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/JeIRD1YhocPpCwj+knSWisF08XD80IpgSUwIA6PINN0YGuuKqmyP+s/UkIgCFKi
	 +/lDkQhX4M5PMkkbOJLm3bgApEIOjszbzQpMR7+Ajt1IVDh1y0qTYX5cfPeIHu1rko
	 T/cNzk0qMI4mDUw85MDmZZ4WjhBTrjd5N8HnnpkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1472/1848] wifi: b43: dont pass unterminated string to sscanf()
Date: Wed, 18 Nov 2026 15:58:30 +0100
Message-ID: <20261118150020.926328485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 89a25aefb327c..4c864ef3266ed 100644
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



