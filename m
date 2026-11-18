Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025537;
	b=34SqN3ZQ+AVuM2ImmbxjAVaQapnM+QiSIx0R8A6/4CPLEj6YHAzxgjnVWiSsUjE9AIxw
	 PbFl2g0hDrjfVD5uT1DeSbbFZriK87r9+Pi9995i8M+raWeKHCfNEA0J/wjQpGyZHxmCL
	 Pgf4oW/ThvPMUfOCiIeDpECxi+iq5R13ryK6vKpyOS7gZXKhFSpC4hchxLwJgfqiwQMU/
	 lEwyDRh/4Tcr74/9PleABc7NWEXH+73D1hf+4mfvYpJBLNZAYR+F1NIv010o13+85plYJ
	 IGn+nnX2YjZmVOYskh1zuXIRvZ/Q6q7OxvbFIQJTrhYYB5yq3GMZ0KEizR5F3GomUbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bdlnrNiCrbFVcTG8nRs6tszGpBCeGilRUbrwmbug1Zg=;
	b=EhNErGBPJdpk1X+jZ/uyj4wiOhlArgtdejjYKfU6vJqNhQTzStBtpsMCsVHnyw5EPF2b
	 +1cel3e0PZu/7v/mJROddAhM1RpwXcTkI9HYwQedR6kUdFoG7iHaaeeKDK0LwdP5SflUP
	 2z8lmasQZcMhEgjIzK6KBiMyyDLtFgoIAGSaJInwDrjmWa3ahLdoE3s4E1FUgkul0IkGm
	 ++LQzobcAXffa/ToaJDiDswVam4ddKABy8C1VmtuGVOrgqqRpJod1HxBaVjg5ZH8ZOxwD
	 6/PFMDCKNY3boHCu4L1ewPfeniUNdc/0oyOP0yEsY2m6g0NKVSfT7S5eudGrzuWHWmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X/Glp05K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1C2606A32C;
	Wed, 18 Nov 2026 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X/Glp05K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C081F000C4;
	Wed, 18 Nov 2026 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025536;
	bh=bdlnrNiCrbFVcTG8nRs6tszGpBCeGilRUbrwmbug1Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/Glp05Kd317DYLyekJdZ3KBUYck23dE5H8ZqVG67LnvaYyyJHTtRQ3FYUmdEV7Xr
	 +mAuehjPlnon0mviZLpXAwURqpD9q1aD9UpVOjPcvLCA45HOCukyybH4nTcs9NWerP
	 JDVO0NrdUmeAT4WJdFiJQf+4HyrNjEvVOjBCcVgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1107/2151] floppy: unregister platform device on add_disk failure
Date: Wed, 18 Nov 2026 15:47:22 +0100
Message-ID: <20261118150202.567785145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index f380c5a163e56..6ba9f131037b0 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4734,8 +4734,11 @@ static int __init do_floppy_init(void)
 
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



