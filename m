Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064179;
	b=JYyyrDiq20ksh6Dst0v53+aIQODs/ZM1RjFIo1V4VEs+l5riSFw4z5pSXeYJO05brsms
	 AeOYIPvGDxhjFd0BOUErK26W8AaXHmxP0Lkhtq8vZV+iSCuR+EHOH5Qkd1Q8Lj9aoT/cZ
	 yMshpi6k9+OiXNQ2GCoFO8xQ3bAxXoTWcEhFnwXfKuTrQyJLUI5MDMj9/w1S2U+f46hmx
	 6ir9YUgzUlpaJPPwpwzH49AziHCeMjGcu0J3rrxU66zvgBRS/LSNPbmXCH7jOYAtk7m7u
	 sI4y21CimSdbBl2OENLcHtSavL6C+2VS+MW6zZ4tfNc3BlzDhFzyXaaSayOXNdVd1aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nORMp5L4Dj+4AbYj95g+3oAlCgBi/m2BOv940Nwh7tc=;
	b=orNjhniNuS2m7Uv2Tz65KaHO27RU3oUExb8tNJYuaTXAvmHlOyoP8oxS5H7GnpaqHpmg
	 s+N2P1w7t2gGZxzmz7+y1yu1JaEgnqpX8E2pWMcd1rjNq6sQSfd1aYemfRRf3NJYZN7rM
	 dffAcE0ISzsMd+OGJor7/C4JEd9inAPdDTXXJ0AysIRJxOe6sZ0YyXdZLfwXK5Uqjdo5e
	 mcRwWDrD+gOPLqRxsNDQK5KtyQD6XS9likheqpXYnjvYmZ2MGcsg49snh76yjHVVwHk61
	 MXf9cTGY5b5z/6I0aMRQ/TnYG4ZJs7WqqPJlYvaqsfXqpoX+P7E2AAAHHXFDDZb7h+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xf5pAtlE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E161606D809;
	Sat,  7 Nov 2026 15:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xf5pAtlE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F130C1F0089F;
	Sat,  7 Nov 2026 15:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064179;
	bh=nORMp5L4Dj+4AbYj95g+3oAlCgBi/m2BOv940Nwh7tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xf5pAtlE7iA5eG0UxPaM1U1EG9yzdI6rGEVvF9gXuS9B6XrUDAQs6FVYj5bc1CJ+/
	 1T4J3EkINFm5qXuRinDLaI67efDaOQVAnRJAkJYk4HN40wlpLtquYlZ+rrgTheRO0B
	 cC293Cy6to9HSYr8d9V27Ry2FphmkbBcEEusHXus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0322/1257] arm64: dts: qcom: sdm845-xiaomi-beryllium: Extend the xbl_mem region
Date: Sat,  7 Nov 2026 08:43:38 -0500
Message-ID: <20261107134948.318170388@linuxfoundation.org>
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

[ Upstream commit 511c4fea32708a065e03503c0e4d44f48990c530 ]

Xiaomi's Oreo-era tree still had the CAF 1 MiB region, the 2 MiB version
arrived with the Pie import. This isn't a board-layout quirk, it tracks
the firmware. The later XBL wants one extra MiB below the old region.

Cc: stable@vger.kernel.org
Fixes: 77809cf74a8c ("arm64: dts: qcom: Add support for Xiaomi Poco F1 (Beryllium)")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-sdm845-xbl-mem-v1-1-6e3c88507997@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
index 080f5294988d3..35babe8c5f757 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
@@ -27,6 +27,7 @@
 /delete-node/ &slpi_mem;
 /delete-node/ &spss_mem;
 /delete-node/ &rmtfs_mem;
+/delete-node/ &xbl_mem;
 
 / {
 	chassis-type = "handset";
@@ -71,6 +72,11 @@ key-vol-up {
 
 	/* Reserved memory changes from downstream */
 	reserved-memory {
+		xbl-mem@85d00000 {
+			reg = <0 0x85d00000 0 0x200000>;
+			no-map;
+		};
+
 		tz_mem: memory@86200000 {
 			reg = <0 0x86200000 0 0x4900000>;
 			no-map;
-- 
2.53.0



