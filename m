Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040830;
	b=Cr2irKGpjlGmqrh92ssmMpK9pHVRibRIm5YaTotedJs4/3cCUvqn3IY45c0pJ/nPgpMj
	 7I44aWXWhdoCn1un9YY1Bwf7FmA1JVdXNYbtafy5O2qx3hBASCfM5MlFa4E2kqQ1eyWbd
	 RqXWKuFitikx1gaEgdG86V6xXxt53jeeiuAwR1RsTogsO/q7NHOYF9heeZfXeTn8PkAgQ
	 X4Ayc7NcoUfZXP9oVAr7Ppc1Mhm+mxMFVFPUDmI96JKKd0zKFx/D8dXqE5MdGBiClOQ4G
	 DELPv8zPd7I198ftYMK8UhDYvOuTV5A9X7bh1eQJz1fkgs1An1N19YLhNcPtJs5jH6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+h1NnF2ax8M37SqxIs+lCl+tyrVt8Mbx5kPCclKYYuI=;
	b=uMxt01WZD4HBiAkTtQn5rtSuLFOCVVA/bCsjZ8Sxq8SfxSl8QdQ2Fijwdedh1+1HbYqK
	 d0LWjLSJe2QFmzTLxxfET2oNlo8avkwjEefi3nFTALvUIYRUs+tZaF2aFQqyNn1aewxxF
	 4oflkZgKtkNtlFgr1sB4bxU0E/2kvFx6P+Wy8vK6P+KxD0lQ6C9RFfJDHGY6K1FXZ024m
	 weEOj9MjkusK5R1YrnATYOdXxciVHNkM2ru8jDDxpLoMaCL+sJ26jF6/OvgcTbwjdJUgM
	 b7jxPkJjnSahPgIvvLws8cf8EzCTWVKDPfWs78MzLEfAF3DXZo7s3yxmiZP3jJwUkgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VZbXHrd5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19A0606A31C;
	Wed, 18 Nov 2026 22:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VZbXHrd5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139E01F000C4;
	Wed, 18 Nov 2026 22:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040830;
	bh=+h1NnF2ax8M37SqxIs+lCl+tyrVt8Mbx5kPCclKYYuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZbXHrd58eupTNAhIPqx/rqKbz+WZOAXxyRCGK6FZ2U3lAsPeG9MarPMYW+ulocLE
	 bag1Mc58jUkKA7OOCyxa9nllnXiD0Ql6uytWr7xqZIKJeK2lRYAIW/hKElk2HDN24L
	 t0ZO6vnYBfA7gwFiWdghlexQbsJFhXuPIAwWkgos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2598/3318] floppy: unregister platform device on add_disk failure
Date: Wed, 18 Nov 2026 15:53:40 +0100
Message-ID: <20261118150439.106419540@linuxfoundation.org>
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
index aaf346bdf408f..18a83e992aea5 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4733,8 +4733,11 @@ static int __init do_floppy_init(void)
 
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



