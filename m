Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB21C12C54B;
	Tue, 30 Apr 2024 11:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475161; cv=none; b=XlTX2V57UH7hgleaxQlF070HB70w9ii8ivBy2c4jvkW/SmwVwFnLpa9uzHMxmZYhSJXwM+hXR9uQMmybFyJ4HmpnEIpvDW06Nn1Qt+yJ8d8LrmlaMTsqQ+TfcchcNtfKIaQWXw708NksPghRcJ3q54mK/nZvFNVyVf+yTR9ZvSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475161; c=relaxed/simple;
	bh=b0FyXE/J2WsXwryTu3jvLvcXt5zhwHxtQcdPMwhqSko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSN1jXCIbIM7uesXVsBot+zJ9we2qNJQ62s+5LYEfwhv3s/Qzt5zN+pfr56OpA5tM/1fGDfFK2hG1USZpqrd85BHIm0niQJ01BPlnwBPdOb/Yy3cC5JxDPfEVCVrVwUTtUF0pgi/a2cJnk4VqDdTNzyOJrifdg7U0bm/drbemno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrtCLKaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrtCLKaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D70C2BBFC;
	Tue, 30 Apr 2024 11:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475161;
	bh=b0FyXE/J2WsXwryTu3jvLvcXt5zhwHxtQcdPMwhqSko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrtCLKaJAuzB0Ved+z7eihAAjFpTIHHTxOlZLlZfCc66LvDz9qu3kVHWJkbGF4hKn
	 ymnnfPUlKS3Bs0T7orikwO3v49ESRChJdJnbb620+pI+eCdjsQcpUIkO2+x3Pv754A
	 i7cuhrc70mNkhSLKH6B2JKURYTM4PLN1nxnlrI5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/186] arm64: dts: mediatek: mt8195: Add missing gce-client-reg to vpp/vdosys
Date: Tue, 30 Apr 2024 12:37:45 +0200
Message-ID: <20240430103058.405980166@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 96b0c1528ef41fe754f5d1378b1db6c098a2e33f ]

Add the missing mediatek,gce-client-reg property to the vppsys and
vdosys nodes to allow them to use the GCE. This prevents the "can't
parse gce-client-reg property" error from being printed and should
result in better performance.

Fixes: 6aa5b46d1755 ("arm64: dts: mt8195: Add vdosys and vppsys clock nodes")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20240229-gce-client-reg-add-missing-mt8192-95-v1-2-b12c233a8a33@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 6708c4d21abf9..8fe8917daed1d 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -1963,6 +1963,7 @@
 			compatible = "mediatek,mt8195-vppsys0", "syscon";
 			reg = <0 0x14000000 0 0x1000>;
 			#clock-cells = <1>;
+			mediatek,gce-client-reg = <&gce1 SUBSYS_1400XXXX 0 0x1000>;
 		};
 
 		mutex@1400f000 {
@@ -2077,6 +2078,7 @@
 			compatible = "mediatek,mt8195-vppsys1", "syscon";
 			reg = <0 0x14f00000 0 0x1000>;
 			#clock-cells = <1>;
+			mediatek,gce-client-reg = <&gce1 SUBSYS_14f0XXXX 0 0x1000>;
 		};
 
 		mutex@14f01000 {
@@ -2623,6 +2625,7 @@
 			reg = <0 0x1c01a000 0 0x1000>;
 			mboxes = <&gce0 0 CMDQ_THR_PRIO_4>;
 			#clock-cells = <1>;
+			mediatek,gce-client-reg = <&gce0 SUBSYS_1c01XXXX 0xa000 0x1000>;
 		};
 
 
-- 
2.43.0



