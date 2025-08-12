Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB0C2FD1A4;
	Tue, 12 Aug 2025 18:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024276; cv=none; b=aFNLm5p2JQLGxzxw4HcADUkJKqhO26NIaE4DNJS9cTIRqVKgNZ06O3y9pa0oG8CLmJljIPtswargptB7lxqn6KBHojuI3jugu1LDfDlX7sGv92m2mBlaLJEDY0Q7hqVrNHksk5WeCzYkYkf4bkML1SdTREs9Dk8y90PbyZf31Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024276; c=relaxed/simple;
	bh=8VkicDYJKB9IxIU9Wa573aeisnqQRQL3DOkEZfauy6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fuz6ItOrrTLjOAySqBzilQqSzsviCoz3PIRtoZfCaxHvLaTT6Xu/En05KnxsWktmxmYwrj53mW8RjJfkzq6vV4JoL/lvA0mJK5YtnAS2UowKt4auleM9PsS6+496MkAgMoUzJc+g5BupuxvmpufSO3Br+TVGvEmhi+NkZFeOeRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ha9ZiGQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ha9ZiGQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B39C4CEF0;
	Tue, 12 Aug 2025 18:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024276;
	bh=8VkicDYJKB9IxIU9Wa573aeisnqQRQL3DOkEZfauy6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ha9ZiGQ5IycSSVlCyWXcFkAaRsmJxocS6BtIn1Srd+z2MA98ahRE64o7xozWh8HMn
	 2rORRuXvJZCEEA6FammgjDuqyNOiFj5qzyRB1uihkZT8Q54TtqAcLBTsa4D3+wKPr2
	 mut3994Z8J9RPlbNLg7/UDoQSFAKlhTUlnFsvJ3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 326/627] PCI: endpoint: pci-epf-vntb: Return -ENOENT if pci_epc_get_next_free_bar() fails
Date: Tue, 12 Aug 2025 19:30:21 +0200
Message-ID: <20250812173431.695599599@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 7ea488cce73263231662e426639dd3e836537068 ]

According the function documentation of epf_ntb_init_epc_bar(), the
function should return an error code on error. However, it returns -1 when
no BAR is available i.e., when pci_epc_get_next_free_bar() fails.

Return -ENOENT instead.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
[mani: changed err code to -ENOENT]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250603-pci-vntb-bar-mapping-v2-1-fc685a22ad28@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index e4da3fdb0007..30c6c563335a 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -680,7 +680,7 @@ static int epf_ntb_init_epc_bar(struct epf_ntb *ntb)
 		barno = pci_epc_get_next_free_bar(epc_features, barno);
 		if (barno < 0) {
 			dev_err(dev, "Fail to get NTB function BAR\n");
-			return barno;
+			return -ENOENT;
 		}
 		ntb->epf_ntb_bar[bar] = barno;
 	}
-- 
2.39.5



