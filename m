Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676622FDC25;
	Tue, 12 Aug 2025 17:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021447; cv=none; b=hPkdXvvAwGqC+rIbgZKv/PUiQz5fhBXa96fTeBnq5IqYmt4yVvNTUWI6FadIx0ABgQDP8Ncf28sjW6xj1IxlH+yGYsWazqxDmJNhcaPBaOG+Bsv6OAl6vURKoSlOtCeqSxzZJ7GC4uI7vhfi1KBMT6027ms9f+Yf7q9qpYYqKNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021447; c=relaxed/simple;
	bh=er+QQFOEpXYE/IigHGfxTkWRlm627Khqh16ko2Og3YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNEH3B37ou18oK5Io17o5kiK6zAC6nU/H7M6VNRVublL1i0CVck1ita66K+5MGgWCx8Ug3kjL3fI6JXQcYZsoS7n0ghJG3sY4QbZQUi4EH7ZXbZxAzS+FhxwLEVzRU0G5TP5HUMmaMrwrhgrR0GOvOxxHsGnsv1lFMVwBdiCVus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15a8dooQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15a8dooQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76958C4CEF0;
	Tue, 12 Aug 2025 17:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021447;
	bh=er+QQFOEpXYE/IigHGfxTkWRlm627Khqh16ko2Og3YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15a8dooQERBa8OWTm4jDiWzpC14o0jB45c02od/q7ukWP7S6AE2Ad0G2bH7bPn727
	 LoCpEbHle7y6vQZJ0bFDNkKNmkHhX/ReTO2cIpvQrJ4VT36fS3cRLxu8sk4c4OLXsh
	 F0vQh8Q+HnbrFnSTw//NvdAJl2rIK0lVM7JpBoUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/262] PCI: endpoint: pci-epf-vntb: Return -ENOENT if pci_epc_get_next_free_bar() fails
Date: Tue, 12 Aug 2025 19:28:26 +0200
Message-ID: <20250812172958.136153966@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3368f483f818..8bdd295f21cc 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -711,7 +711,7 @@ static int epf_ntb_init_epc_bar(struct epf_ntb *ntb)
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



