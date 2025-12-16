Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDFE355027;
	Tue, 16 Dec 2025 11:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885824; cv=none; b=oyWJpv3dd9hoU8IuSzrWb+hGMZGJdmaVdy5uirm4aXsCTCwPrMez9T0Xdgfp6/6vGUUEmw1HbjJKawr9CcpKDliJuMj5Vm1jAlHFMXfJRfGdsXE/3jcQ/spm7hiS3nB2h5XXZyUXxWrM0KLve+J/+gezIqooqkZRzaC/f5zLlnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885824; c=relaxed/simple;
	bh=Nn2kXmRsEHFXJzKDBocS+9AFnG0DjY3nBJf8bj6tD2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6X1/FXoB9nPtv54p+zXQyt0M6+rRUOcQIAi7MBuBRZE8EWkPMu+LIwAup0Bu/wCY99uMEK3aJvbIny8Mx8+lmfToLdqp97UjA813fDVZT2Q+/ZkwBxVlm4XaiDFwlq869Xt/MG7e5M6VGw6VyHhQW5vmMNOrSHaIufJ6ZI0jqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqkOybKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqkOybKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56887C4CEF1;
	Tue, 16 Dec 2025 11:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885823;
	bh=Nn2kXmRsEHFXJzKDBocS+9AFnG0DjY3nBJf8bj6tD2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqkOybKXdyczPsVTO4LVjlIjHaQ5dIu3igQwA+mv2pusEvGnpATehvau1kNspYYGt
	 1t4BI/yngtRxMfaKbkiaOoEuTccY/xbnTQI1+C4fv9SUpj3eFhXpBr3+ISclyxQab+
	 KJiFcvmrUIG2t/tOFurp9bMs7ZhRJEVkJsOKxca0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Niebel <Markus.Niebel@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 256/507] arm64: dts: imx95-tqma9596sa: fix TPM5 pinctrl node name
Date: Tue, 16 Dec 2025 12:11:37 +0100
Message-ID: <20251216111354.764999881@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Niebel <Markus.Niebel@ew.tq-group.com>

[ Upstream commit 046cb64923e8c05a8fb656baffcd8c3fc67fb688 ]

tpm4grp will be overwritten. Fix node name

Fixes: 91d1ff322c47 ("arm64: dt: imx95: Add TQMa95xxSA")
Signed-off-by: Markus Niebel <Markus.Niebel@ew.tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi b/arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi
index 180124cc5bce1..c3bb61ea67961 100644
--- a/arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi
@@ -617,7 +617,7 @@ pinctrl_tpm4: tpm4grp {
 		fsl,pins = <IMX95_PAD_GPIO_IO05__TPM4_CH0			0x51e>;
 	};
 
-	pinctrl_tpm5: tpm4grp {
+	pinctrl_tpm5: tpm5grp {
 		fsl,pins = <IMX95_PAD_GPIO_IO06__TPM5_CH0			0x51e>;
 	};
 
-- 
2.51.0



