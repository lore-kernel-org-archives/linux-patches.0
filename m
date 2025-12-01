Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AD63081D0;
	Mon,  1 Dec 2025 11:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588501; cv=none; b=FfTNebvnK40OIFt06q7uvCPpmgA44q9k6s+1GJ9J9GHtyYzbzaCfCUIhOsZ9dLjaIwpZqiL8gNuMb5/TFw1JsFFRI5rawoEHfmaghdxRVgOGsoaiFJkYOx2uRAIhZE1+/MgqzMDkA+8rA3jZx4Ctf9NOa+Zk2/+ZExi6WQi9gGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588501; c=relaxed/simple;
	bh=uq0yTrGr7aOQf0EMnt6EB8mZEIH7d6nuxkB5/hrRQP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUSgjGEIZ9sLalu7lKRXcDPdyyjpgK/kUZ+bUsxUC+RcfYaPCPuz6CBa/TdgUzYdKA/WDKlRa5TlUJQ5pWgx+keLNdtSlV9+JFSfPxn7GCYF4eqUzNIsypJx61KPMzjhLc++ep2WtIYSbX+IJI6gn4eimYulSYsUbk89reXY2kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1/3DLvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1/3DLvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FA0C4CEF1;
	Mon,  1 Dec 2025 11:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588501;
	bh=uq0yTrGr7aOQf0EMnt6EB8mZEIH7d6nuxkB5/hrRQP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1/3DLvKeAYnUztrkSzZy9jlQVqS2LmDFJ2C6i3QhT8CYBv6TfrLy8C1fvyLh4xlO
	 jphvyL7NHvSiGVk0Mz/MLFFcUkFFGfXyLA5NmHMjM9nBJoEutXQSnAIWN6zC8fZz5O
	 zOBni3UpUDHXmTrrXQnWVfvE5VqEABDx+iAjmCkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/187] mips: lantiq: danube: add missing device_type in pci node
Date: Mon,  1 Dec 2025 12:22:58 +0100
Message-ID: <20251201112243.766795983@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



