Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE361A2C19;
	Thu, 15 Aug 2024 13:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728914; cv=none; b=u1K4OSazGGtarC+fmVhN+hYmgWM1wPODSsEhKAVLMAoVURwWCTtJ+61gUDmHgt6Dienl/Q24nR/gaiKkktsuEvisVraJBN8vZM45CUDgaEJ/nvBwt2chDJLaTPShsV+DMxjydll4e/gHGtOFtjpIQXvsLyIa4p2oisDdaQK+fkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728914; c=relaxed/simple;
	bh=oo0a5N2zyRRQPH5VqvJ56g7pc5S98cBLwADy5LoeubM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgNZ9Y9Jee/QbGGEwdmANMWZvc3YYLrkPieVQQio91HmeAchINeLGDkE5s+XN4dUTZY5PUcGDsvVFQcsBOmYu/okS5wKivslg10e/9cWHqT7okUYQyNKG5N6XexK9wzlMImbf+xYqYpohRHzaBbHtH5LQKCSTj8OtkUdwTNfed4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hZCpRKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hZCpRKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22162C32786;
	Thu, 15 Aug 2024 13:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728913;
	bh=oo0a5N2zyRRQPH5VqvJ56g7pc5S98cBLwADy5LoeubM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hZCpRKRHiNQfodOSmJRnTBtMu9bqswJVzqgSdc4QCCcQao8o5T1gTjXvR6BQjn3N
	 IxGncgvTwzkc4n/1yQSUonT5nPSlU4avQlW6riLv192AXRfTp4UwPdhtJMRXiGH5S1
	 hZONB9k5OL3+Rr7qbXViCYMCDpLnv/C1wpr0yhVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 109/196] parport: parport_pc: Mark expected switch fall-through
Date: Thu, 15 Aug 2024 15:23:46 +0200
Message-ID: <20240815131856.250975469@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

[ Upstream commit aa1f0fa374ed23528b915a693a11b0f275a299c0 ]

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 114730 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ab11dac93d2d ("dev/parport: fix the array out-of-bounds risk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parport/parport_pc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index c34ad5dd62e3d..1f9908b1d9d6c 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -1667,7 +1667,7 @@ static int parport_ECP_supported(struct parport *pb)
 	default:
 		printk(KERN_WARNING "0x%lx: Unknown implementation ID\n",
 			pb->base);
-		/* Assume 1 */
+		/* Fall through - Assume 1 */
 	case 1:
 		pword = 1;
 	}
-- 
2.43.0



