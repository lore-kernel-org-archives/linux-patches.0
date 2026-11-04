Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829422;
	b=EAlAZSjEyKgOMFbMsmFnkMxbWFOjjCgwtpm9qcCrwd882U+aNys5FEcV8cvaZIA5rAt6
	 nDtM3NgxcjaqZQCk/arnGhx/Y+3mjkkn2fSkAAhZQv1JeVqP3U6+C4qyFPyJarWHXfA5p
	 uRbIjOVy3aLbPfhwfOy/e3yJTO4LCYZKZMUyBFp2Qy0/U2SgVmQqid2dZTM5yVz3gDGZy
	 PCxGc0FtI7W7oF9bZ2KOIjSlr6+60aPanbJ9tPPMyF1Unv8Tc7rMjb6fvQuTyBVbYW8ie
	 NfGG8UJHcYX6zvapnHtV/5pnDPg4aajMRkn8baIERcFxABYRbbs8b/cU8pjMMBZ1zug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p4yXFIfuuRoTOe4paTH5moylNGP07WFFrQRHG2crOQQ=;
	b=ES5YcKIuTneLGlW2cD+LdvfmyojK5zMgiTDNj+lGXJZ5Vy3rT9ZDBlcegLTPh1iB6l+i
	 fdMtjFySTioD4V+EPwlvl2IQWHgBSS+hxhOenaCCEYLwdFufi8jidFjkVpMdJMqdyYAIG
	 WUzgtPRXFckIRlemPnT57FhIiJu5TDVnM6mDhwZdU/BwUJycxiyPap/+DYAsjsJ/5deFg
	 X2GiBEfHYinHb577DTAUKM9xNAmCVKfmdDJVixmhCWzB32yo2b36LSChNrz+201EvR/VH
	 aNPS323J4KXCU4eA5obG3g650ayQuRxabPjdzpw2qFOqCgttRE9GFiqTShS50R15f2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PgZ+9JhD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA8A60877C2;
	Wed,  4 Nov 2026 21:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PgZ+9JhD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A911F00A1B;
	Wed,  4 Nov 2026 21:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829421;
	bh=p4yXFIfuuRoTOe4paTH5moylNGP07WFFrQRHG2crOQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PgZ+9JhDmjhVKEqmAdpA2KT/vmTlcEC/im1sMJwCnjsI5zxACDlACARNqUI4l81Yc
	 aMLnNhSCKOiv+XEzkgvvFDSUfz3EsFsSvbMsnN3YDeCz8rvB9vz9qKwG4SRb+4H2F2
	 0hSAA4keY2IsDMQ4nDuLThX62JWbA29Kz2kNqPP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0116/1005] nvme: dont reference NS after unlocking in nvme_ns_head_ctrl_ioctl()
Date: Wed,  4 Nov 2026 15:57:29 -0500
Message-ID: <20261104211046.907441008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 77c57daf98a2ad95ec9ac1371caeff8939cc1f58 ]

In nvme_ns_head_ctrl_ioctl(), once we drop the SRCU read lock we should
not reference the NS to lookup the controller, so use the available
controller pointer directly.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index fb8533127116a..b3e58de6f5cc5 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -727,7 +727,7 @@ static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 
 	nvme_get_ctrl(ns->ctrl);
 	srcu_read_unlock(&head->srcu, srcu_idx);
-	ret = nvme_ctrl_ioctl(ns->ctrl, cmd, argp, open_for_write);
+	ret = nvme_ctrl_ioctl(ctrl, cmd, argp, open_for_write);
 
 	nvme_put_ctrl(ctrl);
 	return ret;
-- 
2.53.0



