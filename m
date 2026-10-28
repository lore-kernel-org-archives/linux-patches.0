Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214487;
	b=OKoX2vutMvyOogzCxlFX1WeAA4yzjxbGseEjOkkXXnhUJVaH6DmF85+mBdaUgg5ItR1l
	 jVfO07+dLxNshgo43RI/ZyCQJ9GWwMnAnfGdzRTxX/lUVe9N2sxx0396LCyp7pSovcH4A
	 295ZKBaZTKelbOxodv7nZP9yszVP9Y4z1deVz0UUxQWjOwgLHo0/mAcPlaKSHI7akT77I
	 qICYiEWR1ADZA8pKdw90K4stkdq1fm9yoFwopJuvcsaM+yLDR8vm2wbIEojSp6ErXHTiG
	 u02v9RYqtSFmN47ShgvrNCneLWAzTkCwb/mjgBAEanyxffCZy1nMXmTzfFmtY3mMPDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P8GqlcwtTejnriCYOODJ4SXf6Is95xP+hyV1f09cZrY=;
	b=CJe5KclVuKgpREd53HkrT1SOj8rj+DxIqrJQT7hujd/vgxlB3Gx0uuxbrD7AHbDUqigx
	 6KSQSU+r1dhBpfNWO735vOQ7lPzVsxnqtQ/JG+T/ErjeSNq0i3AY6+hrnzBGT6hoCOZ66
	 clYLrzFjip/8lvwijWSmgdeigk1edMe6+kf1MdkZPBqb0v9kFAN5AsLCSx6nNkWQHqETZ
	 i9VU7UDcBIMvNJr4Aneq0lcSg9KJT2dtPE/0rkG6AcyoAqvIl3LaTd5FzNZ1GFvOBFNv5
	 HSc44h8EsUW6CxuLtzQZ0rUpLVFOFEs6NgkTdlLJwRkbvmFq8gWvfubQ9XODN/2Iu/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KAizl0rn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7C7606A327;
	Wed, 28 Oct 2026 19:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KAizl0rn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DDC1F031E5;
	Wed, 28 Oct 2026 19:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214487;
	bh=P8GqlcwtTejnriCYOODJ4SXf6Is95xP+hyV1f09cZrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KAizl0rnPFcIcrs+4qILPkHG6rqZ4iNyVo09w0pf2qrhqne9ekjgvhDkg3c4MH2Ly
	 E66GvIl5XWA/+VT5z5znoNwg/BMn6id2yG3LxYsp+5VRgpZF1NZ1MLtsAVpXEbnr9O
	 8dsTV/MpyFM+8mRLS1NEPL4WmDyXWFYETQhSOU3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Levinsky <ben.levinsky@amd.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0876/1887] mailbox: zynqmp: Move of_match structure closer to usage
Date: Wed, 28 Oct 2026 17:49:32 +0100
Message-ID: <20261028170519.352305628@linuxfoundation.org>
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

From: Ben Levinsky <ben.levinsky@amd.com>

[ Upstream commit 6efb495826a905814e2aaa68dc756694686e864f ]

The of_match structure zynqmp_ipi_of_match is now adjacent to where it
used in the zynqmp_ipi_driver structure for readability.

Signed-off-by: Ben Levinsky <ben.levinsky@amd.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: 0aead8197fc1 ("mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index c3953abe74b8e..6a523759efa8b 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -415,12 +415,6 @@ static struct mbox_chan *zynqmp_ipi_of_xlate(struct mbox_controller *mbox,
 	return chan;
 }
 
-static const struct of_device_id zynqmp_ipi_of_match[] = {
-	{ .compatible = "xlnx,zynqmp-ipi-mailbox" },
-	{},
-};
-MODULE_DEVICE_TABLE(of, zynqmp_ipi_of_match);
-
 /**
  * zynqmp_ipi_mbox_get_buf_res - Get buffer resource from the IPI dev node
  *
@@ -694,6 +688,12 @@ static int zynqmp_ipi_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id zynqmp_ipi_of_match[] = {
+	{ .compatible = "xlnx,zynqmp-ipi-mailbox" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, zynqmp_ipi_of_match);
+
 static struct platform_driver zynqmp_ipi_driver = {
 	.probe = zynqmp_ipi_probe,
 	.remove = zynqmp_ipi_remove,
-- 
2.53.0



