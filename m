Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016134;
	b=Izza2jFswY3gLFJxNwJ5LKK5ZfJnck4f6oZcKora9iYEUvHF40JYE5p+Ozk7BphBwwuO
	 iF6z11gnWi5CT+ao5h+/V+MoNv6weXFtA7OMlV1Ekqy6M4AlDbY1gc42Nng7kjYR7Edv8
	 ZAHD3zsbMOxZL7nP1FgmDf71qcGhxCHOIOgmow9aKCS3PuNioceIK6P2eqRji7Id+sFKl
	 SXqRF9+RgUFK017sj4rWqjuQeLBfqBJXTdP4+bKphaUqVD3q7c9qW4ZcMBSOmC1mww6wK
	 WoBmN9BHIK2NUPWTi4vB4K9qTdwpU3SEqvJ+TKzEKnWEriBgIDUS7PW9bchU3ekFRWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aTdzMmpql2L7bDupJuDZxUGYUTT4bh+xaCkWzOigmrc=;
	b=30q5IJa3eVvi+msqTlPigqtrjUSizAQcN56A36Saf0nvZ38eobE1msMhBwOrzBYCLLS9
	 v8fX6/ADE6t+DBG1JUbxgSbm+4F/CUSZeHq0KfXoxbK5fWDOeebA363l9AvigzFgq3Vfg
	 VND4/sInzziwmcpVdrvVka9469I/T3JFp8A39ndaXA6x82g5rK11vxl/LcVNvPzoAfNXq
	 /1QjrE8O7Fz0K523xK5N570sthA7jOJge9XT36dJ+3ZlXjfhKfBWA6ino8bgrk9rdxHqM
	 VVRw+iFLzmaiiMClKjL1pSzhpJBdC8EtIbrjao3kvVqRMJI9u90f+KJABAM09zcnPxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hMxUgMR+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42D4606A31C;
	Wed, 18 Nov 2026 15:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hMxUgMR+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A681F000C4;
	Wed, 18 Nov 2026 15:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016134;
	bh=aTdzMmpql2L7bDupJuDZxUGYUTT4bh+xaCkWzOigmrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMxUgMR+crWgZ+8d5hLk7wwgpIgVSab6mn7lkEKLnBAMTCPGkExHCLhjqUwAcdCRh
	 PGJD/dYDUM6jUwABAVdJksuA8DRKifyiCM3GH8w0Q+woDOZjGZ1Bl7qI2+KUGpOWas
	 ttKfrplC4S8MeFvOqej8tFHCr57NDiqWMToJnCoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0384/2651] arm64: dts: qcom: sm7225-fairphone-fp4: Disable PMK8350 PON
Date: Wed, 18 Nov 2026 15:27:04 +0100
Message-ID: <20261118150301.658867335@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 5c088a33e3a9bb236c475b7230df275fc1e51eda ]

Two PMICs on this phone have a PON block, the PM6350 and PMK8350. Only
one should be enabled at one time, so disable PMK8350 PON and keep the
PM6350 PON.

Fixes: 582e7c1026fa ("arm64: dts: qcom: sm7225-fairphone-fp4: Add pmk8350 PMIC")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260901-fp4-pmk8350-pon-v1-1-e05937e9c860@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 5d20ad93b0c54..773304b4759e6 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -992,6 +992,10 @@ xo-therm@0 {
 	};
 };
 
+&pmk8350_pon {
+	status = "disabled";
+};
+
 &pmk8350_rtc {
 	status = "okay";
 };
-- 
2.53.0



