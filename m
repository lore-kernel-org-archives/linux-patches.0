Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79E41F942
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4412EC433BD;
	Fri, 21 Jul 2023 16:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956432;
	bh=Tv4MD1Rnny7inpjVfJ9J0prHhkb7tYKIfRD4KpqOuAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5bE3cm+fUyRtbwks0IY0UQlYOcrQDdFSjBoLOVFun2v8SII6kq1omGjHI1p0iHEN
	 HLfvLJWhG49MWgGrXGf8Bb3Da6B8kVCRv+8SbWXsm7Sh7GDPkR4/kp4yAd+Cxqwrc3
	 TLlFhEJCVtVWbXDx03HDPso6lKFMcvTq+WAU7HZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 6.4 163/292] arm64: dts: mt7986: use size of reserved partition for bl2
Date: Fri, 21 Jul 2023 18:04:32 +0200
Message-ID: <20230721160535.913900152@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Wunderlich <frank-w@public-files.de>

commit 7afe7b5969329175ac4f55a6b9c13ba4f6dc267e upstream.

To store uncompressed bl2 more space is required than partition is
actually defined.

There is currently no known usage of this reserved partition.
Openwrt uses same partition layout.

We added same change to u-boot with commit d7bb1099 [1].

[1] https://source.denx.de/u-boot/u-boot/-/commit/d7bb109900c1ca754a0198b9afb50e3161ffc21e

Cc: stable@vger.kernel.org
Fixes: 8e01fb15b815 ("arm64: dts: mt7986: add Bananapi R3")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/20230528113343.7649-1-linux@fw-web.de
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../boot/dts/mediatek/mt7986a-bananapi-bpi-r3-nor.dtso     | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3-nor.dtso b/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3-nor.dtso
index 84aa229e80f3..e48881be4ed6 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3-nor.dtso
+++ b/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3-nor.dtso
@@ -27,15 +27,10 @@ partitions {
 
 					partition@0 {
 						label = "bl2";
-						reg = <0x0 0x20000>;
+						reg = <0x0 0x40000>;
 						read-only;
 					};
 
-					partition@20000 {
-						label = "reserved";
-						reg = <0x20000 0x20000>;
-					};
-
 					partition@40000 {
 						label = "u-boot-env";
 						reg = <0x40000 0x40000>;
-- 
2.41.0



