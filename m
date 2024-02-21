Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE3669953;
	Wed, 21 Feb 2024 13:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522623; cv=none; b=dqgeVf8ktg/yC8u66xBGrrxq5ynEwJTqrd/iJCub/HGH61J1qYgWr2jZ24xFATitd2cs0W6z287LAG/cl+KJWpTjIhX16LlmKRlKCrl8XeBtvaNHbyNVBPxMUyDTUwQV5ulAUI9435ZCzGsQbgA4U09MtHxkezrTSURaE8hzSsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522623; c=relaxed/simple;
	bh=8gzjpF/FkWUwdWuAMxXVEFaBL0uWDJTKwmC6dPsNnzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ey+i59ABAEyMUU8XN1kFaTSlOdRCd0o/2IuaHjlrp4hpY6RE3v53AlakbZ4orDmwEr9h/zgQf7zXH/u0NQKL9hzwLtM2vVbEsBfQ91uv3quv8uLNn6TVsWo+T5WVOnw25gZOKA14cYGGhy+s2fAe7+h5MW9cdlsNu8ur4RN+4b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZw5UYEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZw5UYEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9B5C433F1;
	Wed, 21 Feb 2024 13:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522622;
	bh=8gzjpF/FkWUwdWuAMxXVEFaBL0uWDJTKwmC6dPsNnzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZw5UYEIQQS081T24Eu3osuFtfPDsmcqbUNFqA523XJXC4sMnrXtQtPZQNJnlXdds
	 ZEhPOM7w5IO/72gAjK1n8bEk/MsKS9WSghh7OJY9e1qCmYcEVSQrWootS56TTVwUXm
	 f3abrgPJya5c9SLBJn8wj7dbyQAAoc44Zl3vpGCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/476] ARM: dts: imx27: Fix sram node
Date: Wed, 21 Feb 2024 14:03:55 +0100
Message-ID: <20240221130014.681972509@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 2fb7b2a2f06bb3f8321cf26c33e4e820c5b238b6 ]

Per sram.yaml, address-cells, size-cells and ranges are mandatory.

Pass them to fix the following dt-schema warnings:

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx27.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx27.dtsi b/arch/arm/boot/dts/imx27.dtsi
index fd525c3b16fa..247617d6d41e 100644
--- a/arch/arm/boot/dts/imx27.dtsi
+++ b/arch/arm/boot/dts/imx27.dtsi
@@ -588,6 +588,9 @@
 		iram: sram@ffff4c00 {
 			compatible = "mmio-sram";
 			reg = <0xffff4c00 0xb400>;
+			ranges = <0 0xffff4c00 0xb400>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 		};
 	};
 };
-- 
2.43.0



