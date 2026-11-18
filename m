Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036142;
	b=v9Dls8GmLybjtxQ+SDGG3k+rIdrgR1hZgNu2z7Q83dslUFd/TEEAPxLrcgJ9jOwlVSiq
	 lAiNwO3TkiAiMd+fAyX1bn6Ecmc6lc/C0IW5aYk7UBVfNIygXOUtRElyIfy9RLOF+QeQu
	 JnzCR1RfiPn7nl5iEAeZIlqkipFOe1rhJYCmwVZ36PQJAxd1d0W4ni+2Z1pAEmLC+5xGe
	 ktWGux197AlF/pdmq10CmCBhaqVOZA4lTq5RTiBQfDvD2gjV9vfb2n5BwYfR+TAwj3T4c
	 gqSBlKxzaOi/6TV8IChfNpPJ6XzF4I5CyUnSZAJNloqNaqZTMQPfXyPZWwq3meFq9JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zHLxLFfHCSqY4FNihow+PBmA5wxpfljHGl7aZEpA0eA=;
	b=tNm695R0zIIYZi6cAlgRRi9i/hIxwoys6UXGqHYoBvI1KgtamSED7mrSrCe5s9WMUdS1
	 qYpICx6aWuKdltdkt6ivtRFTvX9zTcqaSxAMGyrPtRj/Q9DMuJ9TTCnjFohQAEi9zi9Ji
	 tkgOrAaNwOxGdCDXUuXSmrTvluSdK4Zu5hxSImPAKOUcJSxM5I81LdE1bJHcRg4FgpnlU
	 74Dg+x9a8rsxvDf87gXJgrFQZ6AEniwkiKoahHRojPIb6ngB8bkleYO7XKRyjDo5xAbVv
	 nyRrHtcM3gch54mSP8bs2HO7MJpBlpqK7i52CAlEcvNbM0kj3qOVD5Nj9mVDJ/SUUjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1rPo1d9I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F76606A31C;
	Wed, 18 Nov 2026 21:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1rPo1d9I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083171F000C6;
	Wed, 18 Nov 2026 21:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036142;
	bh=zHLxLFfHCSqY4FNihow+PBmA5wxpfljHGl7aZEpA0eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rPo1d9I55/CQ14VUpv+6ANRV4+ZGhcH7CddQr6H2NXnDU6c+BoqxkCFpoRP/TouH
	 sCe40zJgRipC1q/vT85UuiBa4ok586D4WhroDS+7YC+1dEUHI9KPRbu5kaoQtJqIbc
	 Bu6qyXWx5Imu2q40x+RA45ysC6tPnyp7yyGMQ2hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0953/3318] arm64: dts: qcom: sdm845-xiaomi-polaris: Extend the xbl_mem region
Date: Wed, 18 Nov 2026 15:26:15 +0100
Message-ID: <20261118150348.211010587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 38458f12419f456b16385c118bcacd76899d99b9 ]

Xiaomi's Oreo-era tree still had the CAF 1 MiB region, the 2 MiB version
arrived with the Pie import. This isn't a board-layout quirk, it tracks
the firmware. The later XBL wants one extra MiB below the old region.

Cc: stable@vger.kernel.org
Fixes: be497abe19bf ("arm64: dts: qcom: Add support for Xiaomi Mi Mix2s")

Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260916-sdm845-xbl-mem-v1-2-6e3c88507997@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
index 6db12abaa88d1..727b05cc7030c 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -31,6 +31,7 @@
 /delete-node/ &mba_region;
 /delete-node/ &slpi_mem;
 /delete-node/ &spss_mem;
+/delete-node/ &xbl_mem;
 
 / {
 	model = "Xiaomi Mi MIX 2S";
@@ -62,6 +63,11 @@ key-vol-up {
 	};
 
 	reserved-memory {
+		xbl-mem@85d00000 {
+			reg = <0 0x85d00000 0 0x200000>;
+			no-map;
+		};
+
 		adsp_mem: memory@8c500000 {
 			reg = <0 0x8c500000 0 0x1e00000>;
 			no-map;
-- 
2.53.0



