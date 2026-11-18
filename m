Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030927;
	b=0KXMEVJV+/ZZH+QBbDo6X1R4sLLPVMJ2JbpoFEl2bNgYjMUi4jEIH4mhzzvq9QdHJWvD
	 F4mW96TLS41yIF80/0V/L16hNl+BQF3qMlgnSeWMkm54GVv0eZ386pmzZYTvKokEjeXZr
	 GhZ1+ENSYFrdRwo8VvU1eBPCeVWINR4GtDaKR81zsnfoZe1NXcZJvYnqhQiFBs+70x0xM
	 Cz3t1+wJ/TwJJH9MA/2+STYAbbn0h3TxMP3fNpn8o7/7gvccL8oad3O/qDRcsDeLme/8N
	 ApEonN2MyfWAEqaQ8vKrscgytcFJSkQPVNat+w9ltOnJ508PeYizBjfRQaKCv3hxmmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vMp4REo40BlHPHyjFb+2aMDQysM3ouKTcjSihrRqxr4=;
	b=38UeKLZe1aMeGgjZPTHMr14f0wCMMbrA0c3BXgtZ2CBYPkVYRar6BdXsKhHJ6+PIv+F3
	 HW8NpJ1CC+0eEtt25ebf6O6S3DdopK12laqU7bDxgG3r36T7251W+Y4tC4/XzUANiEIrQ
	 FK2i5EN2NHpnyaxkzkBnCs+ktEweUVxfb3D/7hfm9cuuT8PflJjLjSMvrKN8hDzqjARLQ
	 6XP7lfVUXeBlDyBw3I2SvqarKGI+wk7oxMIZt+xvAqP65M6+ruLM50rV+zaxemnpcTxEN
	 uh1NaoJIUQ+T2aLaxdynCXMpecvsY6588c52dnM3GbmEGYdMCSAZwiKn+dH2AMcCiRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pfwyu8iV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3771606A7E6;
	Wed, 18 Nov 2026 19:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pfwyu8iV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162351F000C4;
	Wed, 18 Nov 2026 19:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030927;
	bh=vMp4REo40BlHPHyjFb+2aMDQysM3ouKTcjSihrRqxr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pfwyu8iVkkhVhX0Y+X3fuUei9T28vJDVzoPSw6KeYKbHUvM2MazVhsmMRAo1XehWl
	 Dt3/s3UF9MiFc1mtHD8w/RpGecfa0w4IirxuADC1crzfUwEyb2YJjWW97qqWtVz0Bv
	 GQMYPdlQBRbcuMamW5a6AB5m3rJkBqnJyAN3XqnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0875/1756] floppy: unregister platform device on add_disk failure
Date: Wed, 18 Nov 2026 15:50:02 +0100
Message-ID: <20261118150044.231161688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c38082f192a1f..4ca47544dbbcb 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4739,8 +4739,11 @@ static int __init do_floppy_init(void)
 
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



