Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064180;
	b=ixBK7t4+ivDAEzhtZp6im3ikrifLlMEy1rtBAq04pRRATlZBFwUV7g74MndQYxoIbHHu
	 lfLZZpnlFJ5H3/6mCr0DeJcaR9NBWKFaObrXfoQTOAuVBgl0in2XrJzeNcCqcPCbK8jy+
	 C5PvJlJwWhAIoofsGpK5uBz91m8Z+qFv116EDF+WP0AE0+9JS1unBmupy2hyW4+nWuLpQ
	 kPP+MUF+RFwPVUGKLcWGbe6Zwd8KH105yZSoiSBQgjAz9b1fP3SiTyHCZiZOi7hd14kMj
	 0P6F6HZuX1aK9q5c6XGTv7Zyhj1SSy1ZyjCcNIcCpDvVzpmxG4vmHQ4Qianzb5zrS2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HLwXwKdBjfNM+C+wwX09tYXM0qXl6MGlPFROwY2lq2M=;
	b=h9CIQQjJW76YVp/5y4WTVsMJ2dyN1V29f4Q9S3dSIKpBKC+hzrH8JF3/KYpsyOS4ZVHv
	 lUVxJH80o7IBUNXOAmS9r3zK7OOk0rrZieyylSHgoOhpUAIKgKDY26jGGAKnxjEhFCEds
	 KAFTdUvj8QLrKBlnXaxJJ9xPz1js2kFviLxlGhXN5V9XhGxcP6HLXPsl3sOn9NbUa4+VW
	 K1WDbO2wmwwv/y1FzhXg+1Y1ti4OksrD/DC4fRsWbm4VQX4oDpxDEY4gPfGl46Z89Jo5O
	 MdQATDmmFEaRkrdV6h5TL/akMANN6vpXHdEFYcBhhFwun3ZFdhOnP4N15ikkfkoVXGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ovLKQGjQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8686D606D809;
	Sat,  7 Nov 2026 15:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ovLKQGjQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342501F0089F;
	Sat,  7 Nov 2026 15:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064180;
	bh=HLwXwKdBjfNM+C+wwX09tYXM0qXl6MGlPFROwY2lq2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ovLKQGjQFQG+dtQQGwt0bReJy9Vpnf4tI+cC4ZZNuigEFspAuaty8t8eikZ+laPyO
	 C7QFS5EAEeMd+0sIt4npQAY77TVwDKKIl3gy2ARWI6QjnhT1Dp93kE7uBd4HhAdLfU
	 eAYFJG/ZFBjzHYnrNArx7rTTuhOmC5M486fS4OVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0323/1257] arm64: dts: qcom: sdm845-xiaomi-polaris: Extend the xbl_mem region
Date: Sat,  7 Nov 2026 08:43:39 -0500
Message-ID: <20261107134948.344702264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index d3162e4444532..a782023d0dcb3 100644
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



