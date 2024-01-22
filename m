Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB4012A17F;
	Tue, 23 Jan 2024 00:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968893; cv=none; b=Jta9/XD6ty8acJi/hmLIiMZdfFCQFX80kvEy3LyvOo2BpN8uXZTlU8SgEGJmJNUZtVExJiFgczk616xpeelD/OONSnXi6bCGGWIwEpPLHGkYk2IWiP2pjarnhlJ/8SgS8LhMxgCbGkrAL+8s+nta1WRrwlRLUXu9tOQfunMjDkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968893; c=relaxed/simple;
	bh=AIoWjsXY4BiejFO0aEnvOEbu9cu2VhXT+CuWIV9DHBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqGSwYCe9/Uzq584PoOXAY0D1zph+5YcI7/Iw+ZB0apZvuHlF0D3Qm3FC+CSmYObX9xhpvix4y+jLx6IzrP0FZ6x26UmYnGjE8mMCojJ4ubrLAHP9rCNuKGjLja61JFz3GPWbCQxj0qWGD2QVDBq7iIy7ScmK2/LMJ7mmeTh7sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcnmLiPF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcnmLiPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC3EC43390;
	Tue, 23 Jan 2024 00:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968893;
	bh=AIoWjsXY4BiejFO0aEnvOEbu9cu2VhXT+CuWIV9DHBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcnmLiPFge8sU50LpXXxTDt02JXzcqUtYJM/cQD8dtRCTh5QvZzBepULomfTvlga7
	 LbeOR7A87TOlUTp3XFuWaSAN+cTmCkVWkhUG/UCKfvbnFbtRqjaaueLZJZHPE9fL69
	 Bni77iVAdXTSbfAi8NaTx/NrghxeIOQgCS6aJjQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhaskar Chowdhury <unixbhaskar@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/194] ncsi: internal.h: Fix a spello
Date: Mon, 22 Jan 2024 15:56:54 -0800
Message-ID: <20240122235722.854472442@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ad3fd7f1da75..9b2bfb87c289 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -83,7 +83,7 @@ enum {
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



