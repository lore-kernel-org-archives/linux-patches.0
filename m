Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017317;
	b=5grnoFmBR6xEAPh4IHQOeZUeNu4L7OL/E5yXZ8hYiRFmtHvFpMSHhUiK+aeT2ZX/P6CT
	 t7MyKCKiXIviX10v1FU7+eiJASElJV2NVqIHvnUXPOT4fSuo7EA8uRPEAiGzherU9xnx7
	 LFw+krNgmCh02m2eHbDqIcFPGt/flkKccoVtQn6NALQHQUg91xKP4v9Oc7bLD3z7293le
	 Dkl01BmVtC4EAEuOQPcYAEUz91HabLuyS76CQmJnL9qKzLa9Wp93gsUbVTs0pGyLP6AqT
	 1ASjMXtyJoUVjEaEbx21dsSqokfRcqMTQH71NdF+teHiKhh+xIbH/GK3XCkv5wmiR9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IquqQu+q5UlOSMwkq6hSi99Cjhd89mBD5+GkHNpHecM=;
	b=QdgzL+6/UQbd6EO0pwQ/j28hEZEb9Wb2UlDwDbK+Qf9x0ggVuppRwX/pdgVfIjovA9o2
	 2/rz6N9z6OUZ9clhBOSwYmUYoj6a2WdSj2+Yq9btBuCn7iVLFDFuDkL6YYpTOAiYJ0qcX
	 K6denZNMKx5BzEb+FGPhFuC4NXr13pHATR/EaItsiwQ/7du5tqmddBrdF32gJlinBbRH4
	 6e/XaH59Qm+E15j8742svI6oK4yp0U8bZWVwqCsa+dKILrR5UtL+JAi6FupuyI/S2LuQd
	 fHiv3cz4jTdMF+Jk8phWGDX3mvwm3l/8vcr3fm56yzuzMt4IcvesEKaS/wMHSW8L9kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EKBnXN2W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B42606A335;
	Wed, 18 Nov 2026 15:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EKBnXN2W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176A91F000C4;
	Wed, 18 Nov 2026 15:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017316;
	bh=IquqQu+q5UlOSMwkq6hSi99Cjhd89mBD5+GkHNpHecM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EKBnXN2WzWJY9XEqgyrObH9G5YkAnrcFOR56tbvydhlXqPI4jUxbB5pEkkHjHNmaq
	 qGw9NsJMeSKy4vmTbMbhlYreBjOZcAhEId1v/ZyoUwgyBYBVcxsEkCCDlOuG9NcpT+
	 ohEIlDPw5iiiHFgBahitRGgf2kST7+/dF0sKbXA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0842/2651] arm64: dts: qcom: x1-dell-thena: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:34:42 +0100
Message-ID: <20261118150318.189771715@linuxfoundation.org>
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

[ Upstream commit 2c376a1b675075018c77d040ba1595db896a75f6 ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: e7733b42111c ("arm64: dts: qcom: Add support for Dell Inspiron 7441 / Latitude 7455")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-11-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi b/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
index 4cda708455d84..b367eef085aea 100644
--- a/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
@@ -1303,6 +1303,7 @@ right_tweeter: speaker@0,1 {
 
 &tlmm {
 	gpio-reserved-ranges = <44 4>,  /* SPI11 (TPM) */
+			       <65 1>,  /* EC reset */
 			       <76 4>,  /* SPI19 (TZ Protected) */
 			       <80 2>,  /* I2C20 (Battery SMBus) */
 			       <238 1>; /* UFS Reset */
-- 
2.53.0



