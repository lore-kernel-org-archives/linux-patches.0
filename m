Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660C71292C8;
	Tue, 30 Apr 2024 10:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474009; cv=none; b=W4W6Nh4JBzoUjZSQaKJIknmMQD5Hz50LnSAwXx3nTrpBzY+ObKK4cgOPmTLyQDBENm4+M53kApwYDhHpSuhAnVI6zzZLhzZeTeeE5Ha3Q8HZGYnTBqLQZi9mmYM86TeD5QzQkkPR5LrVp9FfHWWc6JJhDe4uxctNIy+Ll6GZRek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474009; c=relaxed/simple;
	bh=jJOcq85pZrQDvPFA9YgtdbQsF9URnvHjm9MNsVY2Vzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RdWasWem01G+5uyF3euuWunaTqa3pEjSIkZKgs2X7/FOtInh48uztP1T8Ds+eBCvn4RqS5+gB9x8fTdbf9nFdqTfRUvzE5a+ZsvlKS5uJ8yam+NwaMO66z+EmOUgxmJbZu3t9YGQlixhYh4sk2MrZW4rDP904WRSCGbHOOChD50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5mK3b7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5mK3b7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81495C2BBFC;
	Tue, 30 Apr 2024 10:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474009;
	bh=jJOcq85pZrQDvPFA9YgtdbQsF9URnvHjm9MNsVY2Vzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5mK3b7m944oDgCh6Us8uZ9tEAa8vK0p+3tu2Rhf5UAABhJBPyq4lSBr0ooA8h3w3
	 EezHeqT2ii0ZJd1Fqjo6bdji+Rf8/cEvGZRScLXuwuE5ZgsJ2vzRVsIYDqlbop/xqd
	 dECw1KbXahf2RZZgXz7tFTb0fnYITYPBLrqE1ZS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 016/228] arm64: dts: mediatek: mt8195: Add missing gce-client-reg to mutex1
Date: Tue, 30 Apr 2024 12:36:34 +0200
Message-ID: <20240430103104.283554636@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 58f126296c3c52d02bf3fad1f68c331d718c4a9b ]

Add the missing mediatek,gce-client-reg property to the mutex1 node to
allow it to use the GCE. This prevents the "can't parse gce-client-reg
property" error from being printed and should result in better
performance.

Fixes: 92d2c23dc269 ("arm64: dts: mt8195: add display node for vdosys1")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20240229-gce-client-reg-add-missing-mt8192-95-v1-4-b12c233a8a33@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 6cea6612e2feb..4dd7f755630ea 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -3305,6 +3305,7 @@
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS1>;
 			clocks = <&vdosys1 CLK_VDO1_DISP_MUTEX>;
 			clock-names = "vdo1_mutex";
+			mediatek,gce-client-reg = <&gce0 SUBSYS_1c10XXXX 0x1000 0x1000>;
 			mediatek,gce-events = <CMDQ_EVENT_VDO1_STREAM_DONE_ENG_0>;
 		};
 
-- 
2.43.0



