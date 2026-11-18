Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018684;
	b=bLP4JiBy1PhD9dbNJYF7ucGK+AaEu+2Ra7ZQJkeLhf9EDi6PiJzB+C6/zPTLfILT2WFA
	 oD/M5lLzRBZtgGocwQShcc99KgXey/OImphGxow7itgOFIDLD583JB9CfYOlfHBnc1vaM
	 lFx2Ld6SU2jtNmdbaVq0MWdmfiW/FZfcmkvPICpBlpjiEn/4FbX5zbdLj8aVZBwKPTXvM
	 JjUm8G68Wc1eWp82O2y8rgh7Sxqn82TwIDKRaRBLL/yqGST7zu3ai550n6ZfwBJB0z2n6
	 pO6Pfcn8YXjlWDKF80Tx5aXZihv4le5svvObHBkYpJh71RIUc5Id43d1eZt/AA9Gh8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pyEw1hFYLvP8qJEJTgfQIdKiNnfQzFc1wqN/DUGjlcU=;
	b=Yp0Zi/UZoNzjuJcxmSGSVLh/vI8xso3wxxtSsI4ZZgFqDNoAOCNu1y7ShBDAShxhL1pi
	 Y6Jib1ZZ7WHP3EmlnECTylnUSdK16Q1j5Cg8EP82gqL9+r5nZ6WEqDgibdRkq8aUatq4X
	 UPE5TtaghB1CLqzt+w0SZYd7ZdOmj+zoH/rQF8ZlJXZzwWNSur0ZIXULLUH0ZhlApprx5
	 PMyCDPlPHhdAGcz/WRtNVOytIYDlutL2N3L5vITgq46CU4RyZxtCNTnSrvsShzyomRI0F
	 2NDeYxnn+l27HHkgb8/QH1Q6F66+iG1jNXUPdwvYFbg23g4T3ADcIsD9gseMJ3YC3Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mViylsCo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9C7606A31C;
	Wed, 18 Nov 2026 16:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mViylsCo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34501F000C4;
	Wed, 18 Nov 2026 16:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018683;
	bh=pyEw1hFYLvP8qJEJTgfQIdKiNnfQzFc1wqN/DUGjlcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mViylsCojEhwWQScmcJgr6FcqauVNRpBSq5er3C/bE2wIhASEKKOwejAHtWpGaxqw
	 c6GmLJzn7nrRowLGxqUV4v99NaBUYkLJ4bpruujg4V1M88cHJ++r7DzDXhYjf+IHRa
	 r21QPEnixk2+vOaNejJa3FKJO6N6kH8kkbX6kDYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1327/2651] floppy: unregister platform device on add_disk failure
Date: Wed, 18 Nov 2026 15:42:47 +0100
Message-ID: <20261118150335.773233471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit f1e72d80ad4ac5ff3573796d07bd1a1e74909f94 ]

The change referenced by the Fixes tag reverted a previous fix because
that fix added incorrect cleanup for the platform_device_register()
failure path.

However, reverting the whole change also removed the cleanup for a later
failure path. If platform_device_register() succeeds but device_add_disk()
fails, the current floppy platform device has already been registered and
registered[drive] has been set.

The common out_remove_drives path uses while (drive--), so it starts from
the previous drive and does not unregister the current one. As a result,
the platform device registered for the failing drive is leaked.

Unregister the current platform device directly on the device_add_disk()
failure path, where platform_device_register() is known to have
succeeded. Leave the platform_device_register() failure path unchanged.

Fixes: 895a9b37917d ("Revert "floppy: fix reference leak on platform_device_register() failure"")
Fixes: 47d34aa2d211 ("floppy: add error handling support for add_disk()")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260708105703.747262-1-lgs201920130244@gmail.com
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index d245f6120098b..166451c910667 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4732,8 +4732,11 @@ static int __init do_floppy_init(void)
 
 		err = device_add_disk(&floppy_device[drive].dev,
 				      disks[drive][0], NULL);
-		if (err)
+		if (err) {
+			platform_device_unregister(&floppy_device[drive]);
+			registered[drive] = false;
 			goto out_remove_drives;
+		}
 	}
 
 	return 0;
-- 
2.53.0



