Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017305;
	b=FsRHb07zSLkZBxX0YaM6+F4zIvXEHStAlPoRryMg6g4Xd9pXCGfma8LYA8baZ5mY2Akg
	 dpspOi2cQZLqMsgIw1UP4/BVbfkZq732Di1qUQ4s2T+MsWzmFHAxHD2+l83SBA6o4n1DC
	 b3dDVmBJ7FnM6/MUKSp8VbaM9ZUz3DonqfR+lyhPh2OXM5Fy7vHwxet150wDqgDbpS1Pj
	 LvXLiJhM41UIRVU8FSHUR3uoT+nWEo2ZuAFQCIJBWFVlIFBNVbg0Hgs99E0AnioakpmrF
	 Z2XO4XV9vd16fBGQv9fkp/s77TvED0Lhyn/Mp66pmGw1+KFavfN8eu3j3xvjZrcAfkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VmppZEJDk7IIzAmIvWBkS+Y7MPQoLlXaPeoI2BFYBkQ=;
	b=tDuA+C/7kGYzv+L1rdGODqXTnWyNg4jS6tslSR0bpDUjaGPKrCNhduWYf52pXH0DP5lk
	 nwuRkmkPA5ri/NJ36H81SrbN3YQANnr8Itb+LaWDEKwtmVp7zABlnr7N91lXIyLT/ZIR7
	 jj1HtAzgiBUH0Pm2fSJUQLuQkzmIS3aP7s5jhR6oZiDncvUELYBDQ+6nZ++vV2ss46IzY
	 z1UkgS8O+scmmE6+W7mqWGtIK7fAYT4QznFx1iPDDxr7heykwDlCJwGAJg80qBoWdZlwr
	 yza+dMN97uQWSojqeR/qTDPZG1QvYUCLdWn80M/kSqZ7YX1e3fNmARQ64BYYj+PEEZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tQhiE/mh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2AB606A320;
	Wed, 18 Nov 2026 15:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tQhiE/mh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7FE1F000C4;
	Wed, 18 Nov 2026 15:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017305;
	bh=VmppZEJDk7IIzAmIvWBkS+Y7MPQoLlXaPeoI2BFYBkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQhiE/mhPiSFpehiyNlpuN97C5pSGn1f12gSgp8clx/VyCsm6ShQB/OP2U2bBWfMw
	 PPa5Bsyz0f+fqek8Kx6HB+nOBcFFcG9ZFDXuw+t0ZGKT/q96VCP3qjDUctuVeIhQkr
	 cI+f16NtxH/CLzSqCUUTQleJj9ts1MGR9wXQbd9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0838/2651] arm64: dts: qcom: medion-sprchrgd-14-s1: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:34:38 +0100
Message-ID: <20261118150318.047725461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit c1d21b09a46896a0bc57a5183128b6bf31d9e43e ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: 8cf65490cdb0 ("arm64: dts: qcom: Add dts for Medion SPRCHRGD 14 S1")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-7-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-medion-sprchrgd-14-s1.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-medion-sprchrgd-14-s1.dts b/arch/arm64/boot/dts/qcom/x1e80100-medion-sprchrgd-14-s1.dts
index e4a0b86847cdd..4b45f293e167e 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-medion-sprchrgd-14-s1.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-medion-sprchrgd-14-s1.dts
@@ -1251,6 +1251,7 @@ right_tweeter: speaker@0,1 {
 &tlmm {
 	gpio-reserved-ranges = <28 4>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	edp_reg_en: edp-reg-en-state {
-- 
2.53.0



