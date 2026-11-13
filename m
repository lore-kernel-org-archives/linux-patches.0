Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590125;
	b=JlEg37zw/x+TUvaMrpz8BRYl1XRPy3XWaZfe9Z2ckBydpi3zhQGueF8ih+gNQlSogrNA
	 pcg682qsQuA4Mo73CwVX7EIkFcwpalmiL3kCruTiaz7tbqnEstxGjwcwqrtwRBTbxuIxd
	 EV8KVF4H9VxBVap9tHAGSa9ydR2bGBF2KfMJt1QxP5FanKsHPlVSxmRA5oaixsVXmODYG
	 IqBYTSSPN62XG82a8ZtCVWXAmLJ6Q55NVnvnhVsIPYov8Xv+PWKkTFzrylLj1PYw5POje
	 ipxXvNsylwWcuA9MmEX//Hgxa6RYZc8lqxBjfJpvKS2eYjZxyenv6tfrZDv4FXOFsVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9FIXyzGchlwDlhluiELbzOCT1GPtFfS7qzB4bzSdMjE=;
	b=jcs62uFwkZpvFDe4XaX1G+g/Y3qJrZHvhBZCYbsUTTI5qks8Enp++Ys72PXL9XdpytuW
	 NfaPzfizRf3ZYAfKiDgLNnKcb2Y8HFdcE6u/u4uO34iaScI97cuVqXeyGyjB8wRTmBr7q
	 OtzDJM+eD0bqcLJTkXUFDWxEAIzcPMmPZcwfOn1o7aeNjrVTGX9ZrxvtMaVL8VngYhYjk
	 y/oCC/i5AwZjKLDHuwteJSZInoogAaXNkxjMMPMYv5Rl5490IrognAfpH3M0zXZVs/RD+
	 9O1Jl1GT1ii8gS9lnz8HeD3EvIzrFOEtXc+VL0mqtmSxbW6lXdsd/VLO8rFMlki8r6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KtzZVHEi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865F7606B23B;
	Fri, 13 Nov 2026 17:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KtzZVHEi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C7C1F000C4;
	Fri, 13 Nov 2026 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590125;
	bh=9FIXyzGchlwDlhluiELbzOCT1GPtFfS7qzB4bzSdMjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtzZVHEiDB7omjj4KmLJ3T/T4ZHfZyIUDAfI9cE/P8UbcBlAp8Tow4D5GajGfBRhu
	 sN7JRv1CNdddBCI/UU9R4Mn/PnDQsYVjlK4qlC+MRH46PNVfHAY4TyHVt+klaP4Yaw
	 ID4pDYPebKiUYFibtc287V+4Nu4NZ0Da09w4Ii8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Simon Liebold <simonlie@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 146/686] devtmpfs: make devtmpfs_context_ops static
Date: Fri, 13 Nov 2026 10:44:39 -0500
Message-ID: <20261113153825.751787190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 99aa03f98ce56804f2e8936f9dabf8c4f117a661 ]

The 'devtmpfs_context_ops' object is not exported outside the
devtmpfs.c file nor defined anywhere for use outside. Make this
static to remove the following sparse warning:

drivers/base/devtmpfs.c:88:30: warning: symbol 'devtmpfs_context_ops' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Link: https://patch.msgid.link/20260116150745.1330145-1-ben.dooks@codethink.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1c7df6fa838a ("devtmpfs: restore mount option reconfiguration on get_tree")
Signed-off-by: Simon Liebold <simonlie@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devtmpfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 9d4e46ad83522..0bf3232b3ec14 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -85,7 +85,7 @@ static int devtmpfs_get_tree(struct fs_context *fc)
 }
 
 /* Ops are filled in during init depending on underlying shmem or ramfs type */
-struct fs_context_operations devtmpfs_context_ops = {};
+static struct fs_context_operations devtmpfs_context_ops = {};
 
 /* Call the underlying initialization and set to our ops */
 static int devtmpfs_init_fs_context(struct fs_context *fc)
-- 
2.53.0



