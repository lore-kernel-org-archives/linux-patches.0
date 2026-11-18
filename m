Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017325;
	b=EoV+Ztbj15jaECgMlTCbVEaEjAw/2G4sNkgdTqE4vI3dh8lwO6Zh7ycT8wPSMheAtSrb
	 neAvpmCRXJEzmBtLJlDpxyzIF3mo9pSPoVOm5J0zK489xWIu96UnNungKRJPy8S8IDStn
	 jrX0Rl8EnA1GUR1Geen5IJ/tauGCQmgr11z38dXEkao+NFGU9CY0ykQyAhWuBOYS76wc/
	 lwWzzVphT5iGONbVAIFIXpynE3DhMvjh/pplYCJgnHw6sA06w1sDwu3p7pfQq5gdp/D/9
	 vPJKlxEfWIcOilaa01I4K6zl9z33gJ11Si4gYbXnwFudGwHltmxGPlitQo16HJpJrqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I9oydr7XYgtd6G3sdjt9w5dLDfShQagM1w4mXu79G68=;
	b=luxt4qwhV0t3YL8WPLN1ltWG4cl6Oc0XmgFkbFoWKhBHvio3tA9TY6DJtQqcJHSfMgj1
	 1RlB9Rdw0hKe4oao106obSZ7KtM5KnexUjcWMh/mWtQAYvrHxxUveoj229x6PDcUSq7DQ
	 e9sdlpFnlHVqZiNTo8+eLLLA+rjcwgEZSXSDDyjayR98+DaF/+KQ3hJtdTAM3AmkYrIOR
	 n21t5icOJR6B9Xwli45eeYMLtpXuKPYY0z56y7RJpzm+cNzrD4eLeTdqyJ9D3/E3lDNvK
	 RqC+zYl6E3kq0SWLna3ytWRJ5xbXqP/OGEdXoyWSb/TRtX4u9Ktfip/NEPAIrG2knrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ut+Ypo3m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C255606A320;
	Wed, 18 Nov 2026 15:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ut+Ypo3m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4EB1F000C4;
	Wed, 18 Nov 2026 15:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017325;
	bh=I9oydr7XYgtd6G3sdjt9w5dLDfShQagM1w4mXu79G68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ut+Ypo3meVWyr/hHPc1DxjTsRVDZRLEzjNK3rDISbzQf2qXn2bToq4pZvrPhIr98X
	 CTtbJSh7sKsTgykcLb36ni/4CX2Ubhj+nafjJJYvzriN085uY9cEXo11Nr1MdlQzTu
	 r0un/WjQRBJfBB96SxlGTd1oWM2cNc8r7JGeYPAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0844/2651] arm64: dts: qcom: x1p42100-thinkbook-16: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:34:44 +0100
Message-ID: <20261118150318.262175338@linuxfoundation.org>
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

[ Upstream commit d15d83967b113e43a4811164ada19909d99c93a7 ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: d3f600dc452d ("arm64: dts: qcom: Add Lenovo ThinkBook 16 G7 QOY device tree")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-13-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts b/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts
index c2f21fcb1b09f..1e295741e676d 100644
--- a/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts
+++ b/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts
@@ -1327,6 +1327,7 @@ wcd_tx: codec@0,3 {
 
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
+			       <65 1>, /* EC reset */
 			       <72 2>; /* Secure EC I2C connection (?) */
 
 	edp_hpd_default: edp-hpd-default-state {
-- 
2.53.0



