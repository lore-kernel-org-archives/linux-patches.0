Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E11DDAB;
	Tue, 11 Nov 2025 01:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824828; cv=none; b=YmSBoebNJuAO2mYLMyPXvDIAhWgLk0s30Lc8V8xB2029P314ILwJ/gk6LVBw3yWL1eXTup96XT7OBsD0qyFYSEUimGKMv565XcL9H8JEnrSgEgxHqtuV1RFdtuxt4H0NZfC809r10O3wpihiDNwZuIxNUrE54d5XuZKQm8HTfCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824828; c=relaxed/simple;
	bh=ch8CckVD0t5TrJnm2bNxgtlrRBq1e2Rtd9EVgon/PoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paiFY12uNOY+vcuq0Djt1EmnHDIUBrDoSG4+Ki4ULYcN37KYg8wIPfJSs9NWS36JVluwoXcLUIcfczqbTV4rGnDahEbHPro3O2XEnMw1y8NI2f1iIZ/7EAVI7Ro2exNbzPklkwhHzgbQGVUo2Zzg60sl+scuuJhdyFZg9vRVtI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fobXoLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fobXoLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A496CC116B1;
	Tue, 11 Nov 2025 01:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824827;
	bh=ch8CckVD0t5TrJnm2bNxgtlrRBq1e2Rtd9EVgon/PoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fobXoLfLmXFtYPc6SIngtx6cDtdTsHWzV9BaaG/83UhH0IAV0drslvDFdqpSLK4W
	 r9iQtjG58PmZYcfFojG6PBuYe3cjN4gk+sM6U28hbgqVbBk5meqXtkaZoDpodLbfb+
	 OLwCvt3UW37baHW1AF5TvwvRR1hfir6o33OuqtHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sammy Hsu <sammy.hsu@wnc.com.tw>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 488/565] net: wwan: t7xx: add support for HP DRMR-H01
Date: Tue, 11 Nov 2025 09:45:44 +0900
Message-ID: <20251111004537.908668752@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Sammy Hsu <zelda3121@gmail.com>

[ Upstream commit 370e98728bda92b1bdffb448d1acdcbe19dadb4c ]

add support for HP DRMR-H01 (0x03f0, 0x09c8)

Signed-off-by: Sammy Hsu <sammy.hsu@wnc.com.tw>
Link: https://patch.msgid.link/20251002024841.5979-1-sammy.hsu@wnc.com.tw
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index e556e5bd49abc..c7020d107903a 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -885,6 +885,7 @@ static void t7xx_pci_remove(struct pci_dev *pdev)
 
 static const struct pci_device_id t7xx_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x4d75) },
+	{ PCI_DEVICE(0x03f0, 0x09c8) }, // HP DRMR-H01
 	{ PCI_DEVICE(0x14c0, 0x4d75) }, // Dell DW5933e
 	{ }
 };
-- 
2.51.0



