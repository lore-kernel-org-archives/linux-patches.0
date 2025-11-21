Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5113A291;
	Fri, 21 Nov 2025 13:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732684; cv=none; b=AA09FE/n/nBVFXn+jLegBZ2OqjWlNEestA+96QHTIB0rByFsq2tqsYqr3PmeTLto3eRNPvMpiLIX9tXvCtw/ytQgshn6pf7tPGVD3FFxTnWGi1XLx12o2vl8hko/ETyRl45bqq+a+QXuQMFYVtg21OPSKDKav/3KHrdrrFMc7PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732684; c=relaxed/simple;
	bh=563dIynpa1KoKmTxMr8B9yvfiW9bgTaLL/v0OdsAbds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+hGZ/GKjuDmIOK4vLj+/kKQ54duPdr/8Or+nseKAK0Ack5nwtcNb92Z3zSdOaUgzKMK9Ds6QEW+RSpuVNlftO3jobp5qCagYJ2/QpDnxhRVnXhgegLY2qasTlu9O7CNTpKO71nriPiPejr6nFNpp+lkCVh43K8EaYpqwiagXao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2Vh/kY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2Vh/kY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A42C4CEF1;
	Fri, 21 Nov 2025 13:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732684;
	bh=563dIynpa1KoKmTxMr8B9yvfiW9bgTaLL/v0OdsAbds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2Vh/kY/16Zy6aqQi11bF1dcCRcNJOlhuLOIkxVFMSyyC3UPPIo8tqZCdcPqRjm0c
	 +DiI25ezJqGdozDaj7iipfVNVmR/nq6cb1vvY4GnA6OJSLhZoe93TuoWrddUWo9Cia
	 7WcZ4gBtRy1XwUgvF4GRAuPb7hdfRnPpZrjpa0c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/529] mips: lantiq: danube: add missing device_type in pci node
Date: Fri, 21 Nov 2025 14:07:52 +0100
Message-ID: <20251121130237.174523807@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit d66949a1875352d2ddd52b144333288952a9e36f ]

This fixes the following warning:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: pci@e105400 (lantiq,pci-xway): 'device_type' is a required property
	from schema $id: http://devicetree.org/schemas/pci/pci-bus-common.yaml#

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/lantiq/danube.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/boot/dts/lantiq/danube.dtsi b/arch/mips/boot/dts/lantiq/danube.dtsi
index 0a942bc091436..650400bd5725f 100644
--- a/arch/mips/boot/dts/lantiq/danube.dtsi
+++ b/arch/mips/boot/dts/lantiq/danube.dtsi
@@ -104,6 +104,8 @@
 				  0x1000000 0 0x00000000 0xae00000 0 0x200000>; /* io space */
 			reg = <0x7000000 0x8000		/* config space */
 				0xe105400 0x400>;	/* pci bridge */
+
+			device_type = "pci";
 		};
 	};
 };
-- 
2.51.0



