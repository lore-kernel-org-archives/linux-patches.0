Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79CA34C137;
	Wed,  3 Dec 2025 16:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777714; cv=none; b=oJTebh5yCuIENzLupJaEwa1yL7rnPnvv5gyc3BomdOzw31XPXRi/UqdDXJgoThBTWa6XPQUFREc6kNaqvH0WD5bS6YQwK3fPw7JZZKnJJxQyOENl3NwWIAZYS0Wo7Mn3aRkRSF0N36mtUZ8JK1cW6/js/O9MmEw+5NxZj933Lrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777714; c=relaxed/simple;
	bh=6mtGF67V1S0g/D8jXWuRGStYaAULneKRdT9vGdARZJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFsV8wdipMQ3PzxHmY52PT2gPX79Dp/NItb59/TrM27VckMamW9061sapQgYi8X+WdIG51Hk4f72Zxqr3soUNSaYyveGLA0RnMe5GgtpMKWb03z8VPsUBOM9vcfLFPolBzV5sxOkNZARSGEogBr+CDjyZLws5oDtZa4CIBQjb7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gT9UpKwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gT9UpKwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55312C4CEF5;
	Wed,  3 Dec 2025 16:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777714;
	bh=6mtGF67V1S0g/D8jXWuRGStYaAULneKRdT9vGdARZJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gT9UpKwRlrHudQirkCvFuvQUM/934UQ+h8WBFXqWc7uGaXWbRO0A4FiF7jze8HQTM
	 OapKJ/FFmyq/tq3F7JkVkiSz+jlKCFgtBsDnaNV3fPAGlQTAPUpUAAAnbQ1RAGTgZ+
	 pcM3U3BVM9vD1ZTcsodtZJHPiXT3TL4HKpwiNjhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/392] mips: lantiq: danube: add missing device_type in pci node
Date: Wed,  3 Dec 2025 16:24:33 +0100
Message-ID: <20251203152418.619231452@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ff6ff9568e1bc..1a5f4faa0831f 100644
--- a/arch/mips/boot/dts/lantiq/danube.dtsi
+++ b/arch/mips/boot/dts/lantiq/danube.dtsi
@@ -105,6 +105,8 @@
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



