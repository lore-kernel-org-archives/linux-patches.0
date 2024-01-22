Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEF162806;
	Tue, 23 Jan 2024 00:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971226; cv=none; b=ME10w/V85EmfzDXHVWcPTKPdihCQ2mjVz2n5ewLkqFFbJwsTYrZiintdjtWWAgz8Nho59fK5SBTjrgamCsG5DcW4YSNRTLknkxx0pDSVPoR9TI+QXah/R2g49schhezAzOYEEZeD8puRkxgyO1xQngllIwcniD5AalmI6WyqhIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971226; c=relaxed/simple;
	bh=rSS0waQTvRC0KdiL8YBksBaKSLJq81fg7m/Xw00nMNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBQnvVx1fv3T+Q9Cs4ZL+sOlEINb60bXqalKKpKrlUHcwYXuqUidoCYVYMV+/x5qkbj8J3qt1Bge7EFM8Kg7qlhOoMi0bRadm/DNhvdfTDGGJ4mJwdbTM0u4Mt1dl+Ck1GZrXHfbGwGpm9RevF9mjyNitIFz+Ow4m/7gCZRMmEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9C7STY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9C7STY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D501EC43390;
	Tue, 23 Jan 2024 00:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971226;
	bh=rSS0waQTvRC0KdiL8YBksBaKSLJq81fg7m/Xw00nMNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9C7STY0ioR11C9kvKKYssy/BE0pk4qEsZji86zm6Ilo0UJ4yt5xTstAJY1OJ4w5J
	 3jMQJcOQSyws6/B0cHgZyM3RT6vJZGCA92Nzk9fpGEDxcHUk1ajwvZJt8zVSYN+Bd4
	 xVLrZ4OT/103DfTjNbgSqdXkaI1PUtNTZEVr3m7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhaskar Chowdhury <unixbhaskar@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/286] ncsi: internal.h: Fix a spello
Date: Mon, 22 Jan 2024 15:57:00 -0800
Message-ID: <20240122235736.495950782@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>

[ Upstream commit 195a8ec4033b4124f6864892e71dcef24ba74a5a ]

s/Firware/Firmware/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 3084b58bfd0b ("net/ncsi: Fix netlink major/minor version numbers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index e37102546be6..49031f804276 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -100,7 +100,7 @@ enum {
 struct ncsi_channel_version {
 	u32 version;		/* Supported BCD encoded NCSI version */
 	u32 alpha2;		/* Supported BCD encoded NCSI version */
-	u8  fw_name[12];	/* Firware name string                */
+	u8  fw_name[12];	/* Firmware name string                */
 	u32 fw_version;		/* Firmware version                   */
 	u16 pci_ids[4];		/* PCI identification                 */
 	u32 mf_id;		/* Manufacture ID                     */
-- 
2.43.0



