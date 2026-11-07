Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063011;
	b=r0htAw1+PupEqNUvx+tcfg9c1/ModnXrCAGLzFLotMj0Iexub2cKH4Pa2N0W+iBctN78
	 aiAOzDAJEVng8ryxadThh+4itLTq5zE0R5xB5DqOuZirAduItpN/mMSetJwDmh+4KgNWo
	 qgLwg4knTsh4Oe2ERERvGce1CDZy0ya/ZGZZtYFixALFtm2Huu6dspT5gUxt6a/7Sbwfv
	 vk6yk2yKAkpKoqKyYKmLMNXJZs2d30IGv6aTtoR/GQh52grjD7uuf8i4eoSQRrYtDWhK6
	 6gqOCCDeDYTLDbTNbzuXVvErt13pWF5p30f6Ww2xzEqC34/kG43mHLWyt8t5rlk1ubg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/XOZUhaskGV0VcW8X22wi8qmOdutGQvTmczBqIjR5KA=;
	b=3uGQmcwSpCTPBF9hMCMEnZkzga13kjbb45ugVFvKoeTxmp+kdHt1dKPu3L2gDxlg33IA
	 6/hkvG8l/EaACPyQWH84PL/3reYPc24pUjzNwFy6vxMxkjjExmA+25zrWMs9i/Oe3fj3M
	 l2HKrGGGJhxfMpVhXXtcBvPtLGFUoi4At9cm16vBB1D3TrOLYcETDKCHfRq75Tth1ZM/m
	 nIN6rBFKDmWMjobmKMBPpYU9BZ0snsiDpjpXLcV7ovHjTHTXim2RuUNX/IS+hmvEirlVp
	 fko25QOu/L8Yg/IEpALVWPGGIAtgNbumtl1IoI+BCdqbFjWdunOik1R4mHhnzXo1apA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1CrwZaEE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AF0606D801;
	Sat,  7 Nov 2026 14:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1CrwZaEE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617211F008A1;
	Sat,  7 Nov 2026 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063010;
	bh=/XOZUhaskGV0VcW8X22wi8qmOdutGQvTmczBqIjR5KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1CrwZaEEu8KnLh+dNcfxwrk1zdMwZYqcc4dyFia79TGtMeGJwKadUVIoEqef66Kty
	 jyBhUZzUEt/bmmHH1pPrgCzBVNpRJ4Tt11+4St+YpmBoNLT+jBKIyDMsgH1AiMDuDt
	 5XVeCDHV1p0O7ueSESvvbhEMfpRgpeffzqt1BVbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 262/869] arm64: dts: qcom: sdm845-xiaomi-polaris: Extend the xbl_mem region
Date: Sat,  7 Nov 2026 08:49:04 -0500
Message-ID: <20261107134900.626755932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1c50a0563bc47..8fc7cbc087ed1 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -32,6 +32,7 @@
 /delete-node/ &mba_region;
 /delete-node/ &slpi_mem;
 /delete-node/ &spss_mem;
+/delete-node/ &xbl_mem;
 
 / {
 	model = "Xiaomi Mi MIX 2S";
@@ -63,6 +64,11 @@ key-vol-up {
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



