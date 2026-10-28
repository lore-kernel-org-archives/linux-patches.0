Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213974;
	b=1mTp1H0CkLaiL/YKU58o6WunaPhQukd6XzD3PfRswAiaDz0jox7vynlFxaZ7S8jrP6K1
	 4IsSNx7fb9Wocw0019d1bRjvX+znRm1zZqr7aAwSFHKER6N6JNDuCCS5SfYwt+GTYBEnB
	 zeLjBORJcatdZV+ginP2/jGVjicD1yf0CnCdLYyQIh1IoOuODSRgk6Mmh3HCWjM/CxgAy
	 lqodgPYufnTwcYNk/zTZVxHfhcIZUpRwY+cjDW+f7lL8+bEiBsH5uECSqkDna4DB2bJ1v
	 ZWJpb8UKiYf0G+ttGVIn/gPhqU6yn28gqmHVhZ3r2upGlsj3cwePq7+XckZd5HutQ5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RLzwGyba4lqmrGKWPigc8hYC8Mb6ryUT7M8A1jv3ZXs=;
	b=4qYq8XpM2WZnbsHGGU/dxGFyWRGIFmBH6jn7tMN+I6tcgVGvTM3cLEilC5z7r6RtAD+h
	 atVs9LwI6KrpwEWV0HEOKPW3xZUpwOynnRNuiMRr2fijt4OuYmsclyWqxqGkU7zGVuRe7
	 q+v7j4RwHdJV4bXZtqWblGaBaHUNvNZ08M0kv8wGD9y/FAvYKBu3foFwknQKFKxxWq+0U
	 m6d21PV9ntm6nyIN1VeSjXZM1Sb/qzT7xdv6L8NZ1SKRroa8XnvPPXMZ2sq8ySSDbnf2/
	 1lID36Y36Lu2YB42DAhzAbvNLhhr8gUSovhCGU9NeujtSl1dlh/pjyBj61+Ps7uo+zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ahVxiyws;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8E1606A31D;
	Wed, 28 Oct 2026 18:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ahVxiyws
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465081F01829;
	Wed, 28 Oct 2026 18:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213973;
	bh=RLzwGyba4lqmrGKWPigc8hYC8Mb6ryUT7M8A1jv3ZXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ahVxiywsMvjnYj9ZUcUtdvUp+Biqz6802UPpThkk+hHr0sz3+30Xlite/OL3i/pbg
	 zhgFP24qob87PApUesYaF1q5JHQC7pXP0Wwkr7JSn2yY/SWeK2Y8QiapqprXlD82u6
	 2EZaM2k1RT3KOvu2MO6sxBgOeV91aX+BXoLg2Pt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0695/1887] exfat: fix out-of-bounds access of directory entries
Date: Wed, 28 Oct 2026 17:46:31 +0100
Message-ID: <20261028170515.227880955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 184fa506e392eb78364d9283c961217ff2c0617b ]

In the case of the directory size is greater than or equal to
the cluster size, if start_clu becomes an EOF cluster(an invalid
cluster) due to file system corruption, then the directory entry
where ei->hint_femp.eidx hint is outside the directory, resulting
in an out-of-bounds access, which may cause further file system
corruption.

This commit adds a check for start_clu, if it is an invalid cluster,
the file or directory will be treated as empty.

Cc: stable@vger.kernel.org
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Co-developed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 51743ea617333..ae36930408e6b 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -656,14 +656,19 @@ static int exfat_find(struct inode *dir, struct qstr *qname,
 	info->type = exfat_get_entry_type(ep);
 	info->attr = le16_to_cpu(ep->dentry.file.attr);
 	info->size = le64_to_cpu(ep2->dentry.stream.valid_size);
+
+	info->start_clu = le32_to_cpu(ep2->dentry.stream.start_clu);
+	if (!is_valid_cluster(sbi, info->start_clu) && info->size) {
+		exfat_warn(sb, "start_clu is invalid cluster(0x%x)",
+				info->start_clu);
+		info->size = 0;
+	}
+
 	if (info->size == 0) {
 		info->flags = ALLOC_NO_FAT_CHAIN;
 		info->start_clu = EXFAT_EOF_CLUSTER;
-	} else {
+	} else
 		info->flags = ep2->dentry.stream.flags;
-		info->start_clu =
-			le32_to_cpu(ep2->dentry.stream.start_clu);
-	}
 
 	exfat_get_entry_time(sbi, &info->crtime,
 			     ep->dentry.file.create_tz,
-- 
2.53.0



