Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065076;
	b=h9v2+J/6YYNbX8BmMo18CnVl81tmYSdQEail2MKIzCFC92y7BK7za6Tf0wyizmdq3y0E
	 bPe2zygYXuXF8X9gHWkau1Yh7p2zK06DubKkUvUkFpG0vUAsUl2sJdTGOw4wnwsng1qz1
	 d9MKev2CJCeiXMUpFx4f92XlNIrlUaktoR5zRkDc8vzdY7BrhiFXWrueLZEIPPRLWc4VG
	 zWrpXNugIwcZHHQOejsAAaq66V14LRv3jDivzkUvHFehyOg0o0GiqX9t00fx1ykhbPJLq
	 0+DOJaHsgUjxT9iMTXWpJxOxrzB6JUfO+UrnfsHT9CBTCn/ek/QgRAJZGj19/qYi2nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ChM8rJ2L70LWbuavS++3jwuEc5DMp+8kd+IvJIFfLKw=;
	b=UWUbc4+PedkLTjsjU+t6gemdoS0apxnfDLliEb1B8LJKFanbLAxI9yGkMDOigLs/SJlN
	 qKvgwzr08FXPjnOAHF8cA2TwmmTjhQv1pXLf9cT6jfx6hs7VjfS2fTs7o+lLosuUM6o8D
	 HUxZtqjU0SMqjg3rbWkwGhhzWj4te0GCN446u8XETzqocQ+7hCmSSlFF6bd6NSmSR23ae
	 SQKTrO4KUAX+3daqkyGrB5+VR6XJv00WS75CSBQhu7uEeU0tyEDtfcZrVc17o7o7vxiR+
	 C00BbwRcuEWbJJb0f+C9ApI4QjmjR6KMucyV9JY/ZO71wjTIiy0wkwBjisowGyL693Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p5wKItNL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC96F606A330;
	Sat,  7 Nov 2026 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p5wKItNL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8FC1F0089F;
	Sat,  7 Nov 2026 15:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065075;
	bh=ChM8rJ2L70LWbuavS++3jwuEc5DMp+8kd+IvJIFfLKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p5wKItNLbr66FBk1Ii6eC38l+17hXf4rJAczTMY0F2VPJvoPhSGD66O17uCuN1yMb
	 Bol1UTBGuh4JameilSCPzhQvWXu/ZCfCkNEB9SeosBJsNaX0/la1mdrOGmc8SuY6PC
	 sFLBy2yqf4Cjqtu2QcEJne5rto4vfYX8mR8c6NN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0914/1257] ntfs: wait for attribute folio writeback before update
Date: Sat,  7 Nov 2026 08:53:30 -0500
Message-ID: <20261107135004.591873867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 418452b43d722b3c1e9a711c9f49f3dbe2afaf34 ]

ntfs_inode_attr_pwrite() locks an attribute folio before copying a new
attribute image into it, but taking the folio lock does not wait for an
already-running writeback BIO to complete. The writeback path can unlock
the folio while PG_writeback remains set and the BIO still references the
folio memory.

Fixes: 115380f9a2f9 ("ntfs: update mft operations")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index a777de8a80c72..b3c5219c7b770 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -3739,6 +3739,8 @@ static s64 __ntfs_inode_non_resident_attr_pwrite(struct inode *vi,
 			folio_lock(folio);
 		}
 
+		folio_wait_writeback(folio);
+
 		if (count == PAGE_SIZE) {
 			offset = 0;
 			attr_len = count;
-- 
2.53.0



