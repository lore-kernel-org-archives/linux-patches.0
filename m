Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2472264AB;
	Tue, 30 Sep 2025 15:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245993; cv=none; b=fyqtjcIIDaRGwJcd76UkvSx0+auiqgepPDw6JoaAwmgMy5hFeImBWMYnljRdZeRaIs/XILSxTk+uu5zbqpscZ2TbLhsmzwMlMT6xswFkLO6uDI/RRwNx/wr8i0prOk0hTlmU6nYMswfqxYTQ8j+gWmiZLE/3B0AuSJZfYmEgVys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245993; c=relaxed/simple;
	bh=5kXv3iE7Hb/IIhtFe4TS0rgwRDvyhDVsjoAlKW3EZ18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIh8ARYz64KzxFzdoJE2REbCOS3hYbsEhW9CS3L3N5s0lcG2TF+NJ3QP84vgy6NJ9z6Cu9gzEeRMnWgjTG5UUOhu9lKnKF+wELcVfQ8UeZmk1Z6zRypdpJtIqluHqwMp/s8Rbkx6E1puCgHA8FVi6Q/v4EQEN03yKsMPqCR5G2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7FEDJUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7FEDJUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9930C4CEF0;
	Tue, 30 Sep 2025 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245993;
	bh=5kXv3iE7Hb/IIhtFe4TS0rgwRDvyhDVsjoAlKW3EZ18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7FEDJUi75iJHiMcAiW77Oito/L+OGc91tnsyJ8hvkDpf6RDXjq94N/EjEkXeVQLi
	 CG7JkMV72NVQYD8E0E23zSjqmakXsWMsd/LHtjXFI1PMiIEEE6sASbg02+ZKIxcXNZ
	 7Uv2LuCVEUWS0LcGNac1/2eLfe68C8GD/tMehsso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 02/89] firewire: core: fix overlooked update of subsystem ABI version
Date: Tue, 30 Sep 2025 16:47:16 +0200
Message-ID: <20250930143821.964180779@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 853a57ba263adfecf4430b936d6862bc475b4bb5 ]

In kernel v6.5, several functions were added to the cdev layer. This
required updating the default version of subsystem ABI up to 6, but
this requirement was overlooked.

This commit updates the version accordingly.

Fixes: 6add87e9764d ("firewire: cdev: add new version of ABI to notify time stamp at request/response subaction of transaction#")
Link: https://lore.kernel.org/r/20250920025148.163402-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/core-cdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index b360dca2c69e8..cc9731c3616c1 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -41,7 +41,7 @@
 /*
  * ABI version history is documented in linux/firewire-cdev.h.
  */
-#define FW_CDEV_KERNEL_VERSION			5
+#define FW_CDEV_KERNEL_VERSION			6
 #define FW_CDEV_VERSION_EVENT_REQUEST2		4
 #define FW_CDEV_VERSION_ALLOCATE_REGION_END	4
 #define FW_CDEV_VERSION_AUTO_FLUSH_ISO_OVERFLOW	5
-- 
2.51.0



