Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5771313E27;
	Wed,  3 Dec 2025 15:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776179; cv=none; b=GtuHZzJzmblqcBbe37NM2l6XHX/csKggWU/Fsr/xsne/pGvmFN8C3U6NmHbCARRg5PHlv2gAwsXDeaLtKdlFF9BuFdaa2CeMg1Q+hj9DG5IByAtzdb70pX0mfde2kvjUOnHrYDGs+jEohFL9cJjG1/2spKYUPrxT2BZ321WKb3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776179; c=relaxed/simple;
	bh=iAI3SD3TJfgIdDLancSUxQa5pPoEc8+moahMVNepOZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghWrPqddZodm0MEtg1QwiyNESW9vIPKeT+FWSBKwlJp4T4VMojH1wA9dOqmTjn0C4Kq1XmNBftN5/n1uLvYpObu9XUSWYtY+Mic3uHQ09yc6WuNRpTGS8HjL50YU3LKb0Mdn+K9sOLqm4x5lDheDnxE0NJ0DTBMaHmciYR/6U08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18X3pGju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18X3pGju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3507EC116C6;
	Wed,  3 Dec 2025 15:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776179;
	bh=iAI3SD3TJfgIdDLancSUxQa5pPoEc8+moahMVNepOZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18X3pGjuxe3akLgWM1vYrAkKCGMc9IT6Le7XrI5ipScxd5z2ASE28BqIrEmO9SWsN
	 HQyyjt+qMLUrTlphwHgOLF9omgB0PCpoN+Ew5tkn83PHfPRJY7VRVu1a1gLkmY2ojy
	 teXtUL/7+iSyfBwaVOD8hd+LlAmjTHS6M/273PpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/300] mips: lantiq: danube: add missing device_type in pci node
Date: Wed,  3 Dec 2025 16:25:01 +0100
Message-ID: <20251203152404.217018422@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



