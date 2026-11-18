Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023493;
	b=0M9S7Xm6WPKYimFHA4pItDeOsB+M3VJ7Mv7M4UYKtfBlSu+chmb8V+VgZDiRocxtnCDU
	 0ozeUM2hemKZPESF8MXWd4mBP+KEdOw1KdyUGX55nf4I7dRpxDTM49qJlEHJTZJ8NJTQl
	 uNxIrO4sDCZBTUnyLpdUc0uxgZXKAwka5AOQX9pxQEk+cu6R0gejd9ehUibe5CGLmr49v
	 e2/NuEvfAnthtqYiIm63IqjCAwLueOmQEyQkMsOGec1eezdyXwecAgRR6aNEp9+bBGqqQ
	 04AYdOK1tvOWxPkLdn7yNIYFvoByhd9Nu7seKO02ZHXnf/2nQw2ayBItD4b1JxYBvLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G/faNS9kehSFxrIBZMklUjS9rmVc7/OUG66t+ehjPDU=;
	b=hOI9DO0/ZolQRviRdf2NjMp0e7aaQlaxJ0rH1jz+Ho6Ek7OG82vCM3BotiEWp3AQXcWz
	 FLERCXQhAvvbSaKRdUFPPnRubIDZVKzJ0mFIEVlBqQuxivnXGMrfFxLt0VWMN8NSvbXpT
	 kHk3DR/9rX3zFtWIEgocfwbkegs7i2V+v5ZSpKdn6+zv5KXMJmjKhBwViyde1NGeemhnr
	 PxStppgv5M8lF7MYSvmZRLtyfTTYQ9Ip8xPwTmISBYn4psoqnYT0QY3luJ9SSEOd9Esxg
	 0vazI1u4h+rb18kX5bBq9Ngv4F/qZJzKyXqQsCAXyUiZHRydeOzWku+hjkHmTDY4UEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n23BLw7D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CC0606A31C;
	Wed, 18 Nov 2026 17:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n23BLw7D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF221F000C4;
	Wed, 18 Nov 2026 17:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023493;
	bh=G/faNS9kehSFxrIBZMklUjS9rmVc7/OUG66t+ehjPDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n23BLw7DDYSPCT8tHMFKx8FNGVjH82uXxZwjpR9apgrY0dlMUyvTeQEu2DzWj7BOI
	 X3OHIC2ejj4gIssD15ytIQXBDo3zzyGN9S3h69ySeZ1Q8EhajOSnbbn3Pr0Nc1olh9
	 KlK/29xikdUxjj0IxxjDH3wMCCDlOlSu1XUSSlQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0338/2151] scsi: mpi3mr: Fix out-of-bounds phy array access on link change
Date: Wed, 18 Nov 2026 15:34:33 +0100
Message-ID: <20261118150134.321148094@linuxfoundation.org>
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

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit f67caaa2521a3c8f931d1e679d831ba5ca654794 ]

The phy number that comes with a link change is used to index the node's
phy array without being compared against the number of phys allocated for
that node.

Check it first.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-13-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index a34b0f2e1f5b2..1de996ac5b5c9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1091,6 +1091,13 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
 		return;
 	}
 
+	if (phy_number >= mr_sas_node->num_phys) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		ioc_err(mrioc, "%s: phy_number(%d) >= num_phys(%d)\n",
+			__func__, phy_number, mr_sas_node->num_phys);
+		return;
+	}
+
 	mr_sas_phy = &mr_sas_node->phy[phy_number];
 	mr_sas_phy->attached_handle = handle;
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
-- 
2.53.0



