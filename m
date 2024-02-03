Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356731079D;
	Sat,  3 Feb 2024 04:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933524; cv=none; b=pKPXyoO7/vx/5k9MYqSm4rWQ+k2r0U3sXRHPYpyBPeuJe1ZCBggHYklKAec6un9uBHn7WaeBNsMO9ru418M7Nnceg1/aIROtD7VoEnZvkLgcZ89dAszflodXsr7lLlJKD0e4kV8wqJxvB1lYcJmQRHEkb/XwRi4WcDxWqV0Q6kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933524; c=relaxed/simple;
	bh=f98+fcH1FEwRECtkrrA/U+vXIWCedQpV8HE4aGThKXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFs2TX/HcGi7CY9G+K+zPexwoLZ3xsd73s+XFAKvmYCJGTbzwXvURc/WEzSJgi1UgYQuKhq/Ke9uvS085wkLncy1pgbA0ya6U/wCSOymEiT0Y3JDZ1zAEVRBpA9QmtmBvm2ScS1C2QBzamFm9EZrnjR/hOK7qAvVK1sLVPjVlcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dR7Jz08V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dR7Jz08V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF4CC433A6;
	Sat,  3 Feb 2024 04:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933524;
	bh=f98+fcH1FEwRECtkrrA/U+vXIWCedQpV8HE4aGThKXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dR7Jz08VMGzMZWP+EvnOqLzaINW1j1DG+coq5dLlQYmovxwRNAw7ha8NcAQzyc65B
	 wcfjF0ETQ5TxqEzwq9PKU6aUrhg+PTPJYeFNPE0qJqNKb5Ilha1uPNfefoZGKYAwxi
	 xBgfZz2ZIqJHx5rLNBbXnmANGFGPzlbZl8fa0abw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/322] wifi: rt2x00: correct wrong BBP register in RxDCOC calibration
Date: Fri,  2 Feb 2024 20:02:41 -0800
Message-ID: <20240203035401.206354266@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit 50da74e1e8b682853d1e07fc8bbe3a0774ae5e09 ]

Refer to Mediatek vendor driver RxDCOC_Calibration() function, when
performing gainfreeze calibration, we should write register 140
instead of 141. This fix can reduce the total calibration time from
6 seconds to 1 second.

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/TYAP286MB0315B13B89DF57B6B27BB854BCAFA@TYAP286MB0315.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index e65cc00fa17c..c13ae87f94f4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -8695,7 +8695,7 @@ static void rt2800_rxdcoc_calibration(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write_bank(rt2x00dev, 5, 4, saverfb5r4);
 	rt2800_rfcsr_write_bank(rt2x00dev, 7, 4, saverfb7r4);
 
-	rt2800_bbp_write(rt2x00dev, 158, 141);
+	rt2800_bbp_write(rt2x00dev, 158, 140);
 	bbpreg = rt2800_bbp_read(rt2x00dev, 159);
 	bbpreg = bbpreg & (~0x40);
 	rt2800_bbp_write(rt2x00dev, 159, bbpreg);
-- 
2.43.0



