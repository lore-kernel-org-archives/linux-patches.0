Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033937;
	b=3BQSZRWjyOPP/ThrEofjTrgrdYnMXlpfgmJs5/v34Tchy7duCsuc0gRD733X9OZUXtHJ
	 ekGrfMG2StZuyCiCc7NVPBNQ70O4+4HuhizoIUgpMDGbZdrVu4oN0sRTFuE1e6eZ+YOdK
	 0xmS3apypthdPuzrjdxkwfQo9182ofBnXZLF2WCdXD1QA/ihaLb7nc25VT+n/R4rJQGRS
	 70QegYoTiQ/jX/eRphQzkewVpwqhMi2h8A6E97Y8PYH50krc1rXihUxZz5eRSe/gpKPO+
	 BedIzrlZaee+f3WkpWxB2AN97N6uWZ/OVKqUynwKTUYvR/za9AzO5vW+i54yK1O54Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Daf0PefXR7AkBWVOW1JHh+UcZhvmY2g1fNoWbojf2mA=;
	b=c6N0QX4H+AjXwfaVW0mo3amYoJDjpE6ti2cW5sHS5Kip9WE8YHxq3fD9MVcEYTNdJ/xu
	 7VP1g/Odhpsvm8+aydjTtjq/issV/8Qqgyzhaa6R19s/VR0L6I8MRhilWDSQWnIP43RhH
	 DGALSJR44cXezB4TcjLV/ZgkaDTjJ48OhLPrNjMd6tNZ/m9S8Whfz7B0zQlw/23b28fSl
	 tHOFHFgSeypf7EnQfJOQJKbfAczA8GulfJi3cOPhs3+mbA1xRHzVZNzElytc1kCagmPY1
	 JGOR7wQkoZMnBkCfMecpllZekt+DCjwXtLUx5OYr81kKn3gljGMlMn09h379wzLsQRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UqlLv2zI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FAB606A320;
	Wed, 18 Nov 2026 20:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UqlLv2zI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BBB1F000C5;
	Wed, 18 Nov 2026 20:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033937;
	bh=Daf0PefXR7AkBWVOW1JHh+UcZhvmY2g1fNoWbojf2mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqlLv2zIeiPNSbsZkkQDftGStG03jLQqE3bwBRVkmqVmy3f6LMk/ao120gr33l72f
	 1BgE4L/GBdJ1czT7qVbIVUFBWoOB6PWtrXp16uVxXGkS0dqVsND6K/2WvPF7Exl4UT
	 zn8wxey+wVMoU7UTrYOO5zTZJ65PRvbmZ/PZa/5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0191/3318] exfat: free new directory cluster if zeroing fails
Date: Wed, 18 Nov 2026 15:13:33 +0100
Message-ID: <20261118150320.527751917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d39324b00ecb9..0f36d3edc5e68 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -329,7 +329,13 @@ int exfat_alloc_new_dir(struct inode *inode, struct exfat_chain *clu)
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



