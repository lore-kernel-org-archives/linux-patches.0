Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7700F24C07D;
	Tue, 27 May 2025 17:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367443; cv=none; b=m8QuMQ+7upJeUTEwzzZ5pqhrF1RTLfRNv30FxP8MeQPgjg+j5OieQPzHYD4XApxcFrUHvI8Bk+SlfCvq65C8aFt4UAl1O1aG9saq0Ll7Flp4XZx1YOhx+3l9sMHpMTFbi1YQFfhV041rDbRkTWqNQlfWnIma6dNACX0AmrjsbKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367443; c=relaxed/simple;
	bh=rpV6EPyZJ3XMtvK1C21yPppn5ns2786/bnkA5z4GRAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PasvWVqdZZRoPaL7pq+j9CcGbVnpLQlFi8MtTEY2Cu8SsvGM8A+Tn3Qk45i3TtS16T+j9C6uI5ElYEcN3CHgwf6mO31f5RalShFCSSOOWLE0MmQsbq1Ji2VWcss7ztGOfii0iG+mAAIaVykXQnsYZOvSVVYhY1rHuWY4Yq/FnuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrV4G4fx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrV4G4fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851A3C4CEE9;
	Tue, 27 May 2025 17:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367442;
	bh=rpV6EPyZJ3XMtvK1C21yPppn5ns2786/bnkA5z4GRAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrV4G4fxyekK2f/0vi9+XqYYP6d40Am0Nak2rpGCmMa2GB5BlHWjuvs5nYk18Fyzj
	 Qq+2eHo5zbwXlE+cyWp2uwSs95O4H8UyCPhV7X73xts3Ix6MIUDDrXt/UinTeZuNbl
	 e5pmEAtzAc05rEZR2ToMsCwcWbjMHjfwzdsK3UOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mrinmay Sarkar <quic_msarkar@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 390/783] PCI: epf-mhi: Update device ID for SA8775P
Date: Tue, 27 May 2025 18:23:07 +0200
Message-ID: <20250527162528.976133965@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mrinmay Sarkar <quic_msarkar@quicinc.com>

[ Upstream commit 4f13dd9e2b1d2b317bb36704f8a7bd1d3017f7a2 ]

Update device ID for the Qcom SA8775P SoC.

Signed-off-by: Mrinmay Sarkar <quic_msarkar@quicinc.com>
Link: https://lore.kernel.org/r/20241205065422.2515086-3-quic_msarkar@quicinc.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-mhi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-mhi.c b/drivers/pci/endpoint/functions/pci-epf-mhi.c
index 54286a40bdfbf..6643a88c7a0ce 100644
--- a/drivers/pci/endpoint/functions/pci-epf-mhi.c
+++ b/drivers/pci/endpoint/functions/pci-epf-mhi.c
@@ -125,7 +125,7 @@ static const struct pci_epf_mhi_ep_info sm8450_info = {
 
 static struct pci_epf_header sa8775p_header = {
 	.vendorid = PCI_VENDOR_ID_QCOM,
-	.deviceid = 0x0306,               /* FIXME: Update deviceid for sa8775p EP */
+	.deviceid = 0x0116,
 	.baseclass_code = PCI_CLASS_OTHERS,
 	.interrupt_pin = PCI_INTERRUPT_INTA,
 };
-- 
2.39.5



