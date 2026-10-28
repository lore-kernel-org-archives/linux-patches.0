Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212609;
	b=wlhkThlp0LklSN60BWGVl/RNhcelINPp/JhHThhDdMaq8erkjq+QUzt7PiJqZypVdBqL
	 XfZHSuHz0Lw1oRsMO14notZzuHEblqappMTbQBVppa31vZ+4UDWbCRI8zSClxa/B2HH80
	 x5K/h/8J9v2x5r8v3VYkd/SlrjtB6Sepw8DA+be4gIO4+24bKj2d/lcPG/EiQu88phc/k
	 Jk+eZXP2p8txkqJZcyP+QcQeWsEHXJlBQ0l3C/0nFy2IjiHxGyE8SrqctSFcGYOQwL6vl
	 9GH2jWE1VnA3AtGrYdQauooNcFTkpr2H0uEg5+B4qgKiNMdhqPIel0YVqLz+z27bUxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qcDGkHjVYKpCexLXSsf3M5In5HXFLZeBzbBn8Y5RcMI=;
	b=xChh7Xe22RGJaBN3hThybt7ijeoKxpheOqM+wPg44UHnevMcokgO0w6pBwFbdVq5sarE
	 fEAErbEdA1unqAAOLFTb3HogAU/w4WHZydoyFQIkIkXRXMTwXSkL77m+BipEYmLj30fUB
	 OLEi1aounTHsddxMtA8X3wa1QpEVPld4ZzyS0qY+Zk+raJx2MV3hP788ab0zxS3rSDqag
	 EUtRNsLThyzM+zVw8PZ6VHkgc6reI5HeRXqOWnEAZ3V2WfW0xtCO/2nDoKgr3BEUG3tKW
	 S67o4SGZvY0Wfid7dsGUe3D4eHG4Yb4ofH+JI6AcySQNcYj3+VZyFd19LJA+F3DDL/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BHHDBHaw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81830606A31A;
	Wed, 28 Oct 2026 18:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BHHDBHaw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FE21F01825;
	Wed, 28 Oct 2026 18:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212609;
	bh=qcDGkHjVYKpCexLXSsf3M5In5HXFLZeBzbBn8Y5RcMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHHDBHawNGpKjTFDs++/tP6rWd3H6p0D6PgkBzHrTbehtcm+LQiQjMD+8SHZO08p9
	 G9hZeVDzNg4xuIPDWb0nZ9hvBy+YBkwA6ARMdWkTXIVax0qRUMMnq8eF1/3c9W5Wgx
	 n5qz91p8cSUWswagOPx+bpzEsfephh6muj5UE5x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0215/1887] mtd: core: call _get_device() with the master MTD
Date: Wed, 28 Oct 2026 17:38:31 +0100
Message-ID: <20261028170504.126009353@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 12b31d1acd20b3185bb5f0748db0cf6874c8e9d1 ]

__get_mtd_device() calls the master's _get_device() callback with mtd,
which may be a partition. __put_mtd_device() passes the master.

This breaks gluebi partitions because gluebi_get_device() uses
container_of() and therefore requires the master MTD. Pass the master
to _get_device(), matching _put_device().

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index ebe53a4f5d580..649c79f755e69 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1210,7 +1210,7 @@ int __get_mtd_device(struct mtd_info *mtd)
 	int err;
 
 	if (master->_get_device) {
-		err = master->_get_device(mtd);
+		err = master->_get_device(master);
 		if (err)
 			return err;
 	}
-- 
2.53.0



