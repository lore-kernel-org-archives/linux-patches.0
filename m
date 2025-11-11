Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B90125A334;
	Tue, 11 Nov 2025 01:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823565; cv=none; b=CfzaSLhZZi6H3npG2jrkZTuiVy10zQM+m63Y+Oa1XJgNQRVg407vWOZRPmQm4fMzZuuYIZ3nwc/mC2qXO1xcPjQkDWTzkp2Q8K/8RluS1WeanKl55+W/QvMQnFLquoH8Of+XnleyUXsMdQeDeTtxSkIjS08gYWSk4HS6eBWhpK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823565; c=relaxed/simple;
	bh=fr9mKxSLBjhwUtZeRq/2ibhFgCeNMc7ryoMaLMDLHN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdnGBm7+IRc8y2sHoYnrSYeJYCZF+TBkSIVKE+fgUNVTTpD/lXrtZyzuvWLWKXwLRF/en1kTqtt0NGK3Gr2fAdaDVwg6JIDtLqkY93uiomz4aLVxOJokGnjseJKTxtFxjBmm9rFUq2JlQmE57eqgb0j8pUvJREJuO61LJJTupz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6m2ErDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6m2ErDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8116C4CEF5;
	Tue, 11 Nov 2025 01:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823565;
	bh=fr9mKxSLBjhwUtZeRq/2ibhFgCeNMc7ryoMaLMDLHN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6m2ErDPnaE61I7Zhoo2etFFMjUt+NqIuYVL9uZBOwScPm6Yi8iILc2o+lv+SG6wy
	 6Zrt771dxi7tZ2hPPT/TR/0Drokswilor/ewlxDj50Cu6Ra8hRnH6uXnPFH4hzAstW
	 OPxV5hmFyZESVerjc5R+SXUHWQAHjcxB/YuPl4Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 271/565] mips: lantiq: danube: add missing device_type in pci node
Date: Tue, 11 Nov 2025 09:42:07 +0900
Message-ID: <20251111004532.983178555@linuxfoundation.org>
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



