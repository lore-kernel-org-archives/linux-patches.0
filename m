Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030098;
	b=h4BBYdfV2AlfXdQYHb93osnX6Qua7Wf5/1JTVQ/WCYKpV/F2W2sW0dCh5NyeaLd1/hFr
	 Kv3vgC/SX5AXJySbRmiEmQ0ZnpUxaxxzBt4USLBYRHVfw/1zccyc0rz59/fk6fM/3vn83
	 qcvJoaFXxlW7mRJjmhuux6rmjxgHJK/o3DwMYIGX41vIrB6MpQ0+FxyUh2do0AiPoKSR4
	 z9Pfscp5Tg9zyiG78GqMPZTvCN2SE1Mw+Zos3AQuGoEdsHwi+1NiraaPO6IXyF4HPY2qD
	 sTFxQFC0ZJkQUKNFmAg4NipOvPksDEOA1i9u6N26XfIxidjY8Xxujl26BXXChh9zpww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yCoe8WjtN+VFQRyXrExp7zfEKQFxYJ4ScmxMW+mEDwo=;
	b=X5+UJZxSohJ9UoGQwIzo3rB4o1q8Y7CyPrjYHPjXvmPnUNpnv2qz2a67VpjMuKbxECx3
	 vNSGyVqIRHChL7iD27r/Q6yd5CosBycqTUqQN80mRDpoGU6BSOLifXa8WJv7sxeNs5yXv
	 vYLq+diuDuWLk2h6uFO6GLKta15723GeC/myakTwM6E4vSu/rlArvklNvP7VdlaY+9GWI
	 aY/Ak4WsPw1JA6HNA2Y3Z33+5vPcn+KTkwgizeS28YQvVwh1KD5OCsU488Uv3Ap3n2BPT
	 eN7JdkJ7WrctXqTobnH3VqffQF89OcPguenv/rHjjxJSLELNSIa0ISJENXMlBKAu6Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tT+akkfp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3473606F528;
	Wed, 18 Nov 2026 19:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tT+akkfp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2A51F000C5;
	Wed, 18 Nov 2026 19:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030098;
	bh=yCoe8WjtN+VFQRyXrExp7zfEKQFxYJ4ScmxMW+mEDwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tT+akkfpZC2cH0OFd1K/AhVg/8necGYKEmxfvAbQGXp09cbjnXbzMVVWhPZglKvEA
	 r9FYGcl8Ij4di27ckCRZoUoUt/JRRIIwotBtHfNZrUSem+e0/8i0YE0vDaqAWQFbTT
	 hu2bg2AfultGY20EPC4kGqs27JaiU6GVllhZj2Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0584/1756] arm64: dts: qcom: x1e80100-yoga-slim7x: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:45:11 +0100
Message-ID: <20261118150032.274057270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit a92ac66d35dfd8438b6e40bfb956ff69365798ac ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: 45247fe17db2 ("arm64: dts: qcom: x1e80100: add Lenovo Thinkpad Yoga slim 7x devicetree")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-6-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
index 07c2fdfe7ce13..cdd3f7b09e223 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
@@ -795,6 +795,7 @@ right_tweeter: speaker@0,1 {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	edp_reg_en: edp-reg-en-state {
-- 
2.53.0



