Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017314;
	b=Nc0RRF+YJZT8u2ZRqv0sO6Tf48wPS78ihDU86ZNJ62kfthxrlL2QnN1Avq1YcG7LQ+5F
	 MpUDywJLmF4twcqo0jKP8ZVSbqaesmg4SZqlPrUMxE/+OFwA8humEVLy+T+Pu7zGucd7+
	 DRAu3nuIvgDK0m88dF325/mhgPxGv3bfvLh4ZCkTMawMpE6SOtp0XnUqX06q9VdMbpVt+
	 y6ke+SLXkHO0GH7SlM85PI1GNJDdz2PIrdtjJjYULbrNDu3Z0KuIZgz5foWfBsUx4/t65
	 WoE9pDORw5HEq3J8IWf5DCHhxCzT00+Zqg/STWeqIREyUefXB6s7q4T69Y17lX3YQeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7a9SLv+ReWnUXuqCIcsP/m/5NnF8ZEkA2orwtZmpBGs=;
	b=x/bcHeB+C2alE+8P1o4nGZcXxoG6o6vM+FeVUmFzETV+p26o2+JqGqqn/AFT0pO9z2hv
	 1PHLIhQ+eJ+rghLJtYHfdifF5X651CHd/h1O+s0RVrd0/uzvWD10irEA9vdV3tl0cK+rA
	 n9YsDjDglCD1Y+F7cpGDZ2TrbpRFJtqWgzY/vJwpyIfPbfZZoHwqpTXp2+44TG9PvPqWJ
	 opb1PQmkrFj7mMzSsx8rDRWBukbw+93D4O/um5w41VHs4Xp3Dy1vFTkwf4En9ho7I56xJ
	 cf7m77AI9vDEyNQzUnjhbRtvhOOZ0OClm39sPTC9mCcbh/oPkYUnJo3IJNAqt94DT8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHcGSscU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BC6606A31C;
	Wed, 18 Nov 2026 15:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHcGSscU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590E31F000C4;
	Wed, 18 Nov 2026 15:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017313;
	bh=7a9SLv+ReWnUXuqCIcsP/m/5NnF8ZEkA2orwtZmpBGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHcGSscUW3WGDHGlcd6tjIAxKuzn5qi5azJ/S9E6eHxL8nqDKtsJeu9EpjJV9OrSz
	 L4IoenP3PSBu3IJ2a8ubUcPch0EomO0owUJbIHG0m6pkHLkbuWAlvYtNo/shxiImsu
	 5MfDlSs5O2D9DcTP69n2rOy1PnYdRQH40LhwBeOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0841/2651] arm64: dts: qcom: x1-asus-zenbook-a14: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:34:41 +0100
Message-ID: <20261118150318.152969394@linuxfoundation.org>
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

[ Upstream commit 48213677c9173680de328785768ea56315bfdd53 ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: 6516961352a1 ("arm64: dts: qcom: Add support for X1-based Asus Zenbook A14")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-10-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi b/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi
index 59cbbfbce4905..8eb4c045b58a2 100644
--- a/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi
@@ -1274,6 +1274,7 @@ wcd_tx: codec@0,3 {
 
 &tlmm {
 	gpio-reserved-ranges = <44 4>,  /* SPI11, TZ Protected */
+			       <65 1>,  /* EC reset */
 			       <90 1>;	/* Unknown, TZ Protected */
 
 	cam_indicator_en: cam-indicator-en-state {
-- 
2.53.0



