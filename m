Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6447335FF47;
	Wed,  3 Dec 2025 16:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779280; cv=none; b=EVkZ8vQdscbmN3aBlPh4be9jN838BBxzs9BbRoC3LUNq5P2LT4DsQ2XGKaQAq18B4c0nb0KCI2rocB+k7bMrMEmO+8aK4/1NI+GkvvAuwKzVYDN+jW3M5VhEnNFhD77lzw/hlLsmxNL+5nUvk06cgqtFrb6SA8Wllfn3PEtKTRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779280; c=relaxed/simple;
	bh=A9roOKi9hZc9zXgk5zO8tW610PCSaJiXOSWwdafdYJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/tQ7OGAhOTX25+LkTK3j+6RFT1zOkwQDSY00GiSZG8ov1sgxsfq+pWAsFdEAEI8/mPvZtqZnUO2kHmwz+UJpwz5eKc3EsZYvBdKYW4WsJ/5JRjnDO+dcg4Zd6YIlkC5dtaaybxVA7NrSKFbZ3q64mJ9NBnNKDTJa4F14xcSQHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rM2Dr4/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rM2Dr4/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4634C4CEF5;
	Wed,  3 Dec 2025 16:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779280;
	bh=A9roOKi9hZc9zXgk5zO8tW610PCSaJiXOSWwdafdYJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rM2Dr4/bzPgzQpxmYVsqbnyYfI0d2ILfRpP3meQffwf4Vafc/GRSM191HFAcnzRj+
	 mdWapJer5oykNKYfJjOjusryPsF84A1j4hkgw8paBbKWUgUwlXe6rgk+FQ8cMLTEOO
	 MAkmLoyYiHXPV5TvFhuQzzaQRNzFV+oJ1ReKE6sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/568] mips: lantiq: danube: add model to EASY50712 dts
Date: Wed,  3 Dec 2025 16:22:59 +0100
Message-ID: <20251203152447.214076668@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit cb96fd880ef78500b34d10fa76ddd3fa070287d6 ]

This fixes the following warning:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: / (lantiq,xway): 'model' is a required property
	from schema $id: http://devicetree.org/schemas/root-node.yaml#

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/lantiq/danube_easy50712.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/boot/dts/lantiq/danube_easy50712.dts b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
index c4d7aa5753b04..ab70028dbefcf 100644
--- a/arch/mips/boot/dts/lantiq/danube_easy50712.dts
+++ b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
@@ -4,6 +4,8 @@
 /include/ "danube.dtsi"
 
 / {
+	model = "Intel EASY50712";
+
 	chosen {
 		bootargs = "console=ttyLTQ0,115200 init=/etc/preinit";
 	};
-- 
2.51.0



