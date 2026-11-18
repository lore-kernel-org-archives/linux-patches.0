Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057440;
	b=kQIEJ75tMeVqVBVmwByvlliD8K7dIOIV9V4AMtJe6WASPHsX7PIgQSbq36jS1LE2sekI
	 oSmaSqCbWKEDt2fuJ+3WI8He5+2uqxAytmAobK+/jPBOfG6/RLqyK/3/PyhCieCj9m9Ym
	 baXvjz9nLfr/hOHoLnbRcPsBp0ipbVQUW/CeEU9rvN4okBxnBk4hzeNTE1Sl3tHSkgq8x
	 tiM/CvMH3z5Yf9VlZkV1rSz6mb4jqT1Au/kuJqHhbf4OYfGSvpfSOt/CmH1PVyJPLesjH
	 T1RkaOL18/muF3DTtCeQhM0rCZ9oHSeS6tpLenHxa8APMrz3vwhadVY45qcn3+Lhq5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fFraOSoM+DQt0dRYoRYfKDcYw1V9NFk5llT+immy74Y=;
	b=JqXve2SQ53zR2eccO0wmrpMNHuFUsbPo6nrThRnaos9EO3y+SSHCxTpyiBSDPlx4NZb2
	 laLSqzVBs8FbfSXAimXpXoeHHvuMmFTuXgBGBxl9j5CPZf31wzz6dYctNuCPKhjveF9VR
	 ZAkCjgABEkFGDWMC5/+XqjfdUpUGHqkU4GAYBnf3IVZ64mXZ1L2hadhHrwCRGHV4pQkh5
	 okZDwaibix+SU+rkYfU8gHeP/Frw/VBONIbQy2zkUus3DUoGVQomhAuDF1XTAf5ycy9wL
	 imB8PJppV62dQu2/fFUr9MzQymVD1Eno39hTHfKNw6uBAChtnUXyIJJJNxxZLUbLjMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfR8ld89;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1E860A260C;
	Thu, 19 Nov 2026 03:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfR8ld89
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5C91F000C4;
	Thu, 19 Nov 2026 03:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057440;
	bh=fFraOSoM+DQt0dRYoRYfKDcYw1V9NFk5llT+immy74Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfR8ld89hlVzRFKwVF/pECm1fYgxFRlWPm2PnDtDFZ4SfgZKJHOMK7lmUCbV25HEf
	 7wO/xeKuotrim/5d6NBqy1a82dFsSFsbGxBrBF7pR6c3xdSnaP5Cf3JLxsnbgGQliv
	 xVtffEYw9RA7IaF6H2ZfOa46efY95WYY1a1IV7Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0130/1848] exfat: free new directory cluster if zeroing fails
Date: Wed, 18 Nov 2026 15:36:08 +0100
Message-ID: <20261118145916.599934322@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit ce12a39bed483008683438962b3a605374e6f803 ]

exfat_alloc_new_dir() allocates a cluster for a new directory before
zeroing it.  If exfat_zeroed_cluster() fails, the function returns the
error but leaves the allocated cluster in use.

Free the newly allocated cluster before returning the zeroing error.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/dir.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index b1a92296a88f2..6e58af53aae7e 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -320,7 +320,13 @@ int exfat_alloc_new_dir(struct inode *inode, struct exfat_chain *clu)
 	if (ret)
 		return ret;
 
-	return exfat_zeroed_cluster(inode, clu->dir);
+	ret = exfat_zeroed_cluster(inode, clu->dir);
+	if (ret) {
+		exfat_free_cluster(inode, clu);
+		return ret;
+	}
+
+	return 0;
 }
 
 int exfat_calc_num_entries(struct exfat_uni_name *p_uniname)
-- 
2.53.0



