Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036519;
	b=z3C3+fTFqZXPaFAzvJ9qmewz1clpXq94Q+HWJ6AB0Vw8L3gjZurUpEu6+NT4jow7TYu4
	 lagJDdbLdTG1XK0CYlWF33xuZGgks3Coide82onLEv4MVna1T+l2zvlTCXDBvv8qmxIZA
	 Mi8cei8FDBUqErrlK8zKqxUXSt5FGlogxMLTFAmug17kjjvxpN+3U4g6raKWR5/yWrF09
	 03fqYYu71fR+UxSvsCZnQ03OiJ04oTMdhHK+3VRn8rT7KJlOWUM7w5emKgVSnnYAv4W/P
	 KXyXXmbOnRSG2Co2znE1boz4VM1BBWNWptsixhtUeG0AovrJD0Ud6LGg8eotXib6qjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lNFrIBd55zWZ4sxZe/C4IVpZ9Ul8+sNnZ4oZi2FCQW8=;
	b=zAXn12BEaysxblmscwzfxvey0fX9+vmhBQMJ5gInCVfRUXm4nn4pGrAf+wmlhx0U5CN6
	 gYeEVuS36SUYz1xSUBCsiEVLLbm5VkE7ydFD1EgQeMdt/J6/SuYg8ezO/2n+lbLAYCRrj
	 tjU9LHlBNbsNoxgFpsCP1rwAXwf4mdr9q8HPdl45ZKDLuiUXLQYTYWdBuvF61x2rweqd6
	 Gpyk1W8m7iVLNz7Q1GK6R7iOBA6NIlEDXtm5KhATBPas3OQ5ll2P5aTpJJ+3Rbkk8cGpD
	 ZG9vuleM85/rQG/pHobNobxpVz0NncQxtCHznhjQvxO4SY+2FC1ow2U07r44HboH9JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zdVBRdhs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EFA60A2609;
	Wed, 18 Nov 2026 21:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zdVBRdhs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B2E1F000C9;
	Wed, 18 Nov 2026 21:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036519;
	bh=lNFrIBd55zWZ4sxZe/C4IVpZ9Ul8+sNnZ4oZi2FCQW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zdVBRdhsQmOYq4gqTcplOzeKz8JhRJBIgMagRvq+gJsFQ3onqRlHTbL6ZUy7eOBQZ
	 KpNX+J4D0AFz5UBWUgKQNaF0lkxruV4Pqh4s3oX3q0kl0PKUD4k9OAotnrVOUi60LM
	 3itS3VFNW8gJ0U/akD1avT8tL8c4C2gJsOnJCdMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1089/3318] clk: qcom: ipq5018: add 24MHz rate for USB UTMI clock
Date: Wed, 18 Nov 2026 15:28:31 +0100
Message-ID: <20261118150352.647610163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

[ Upstream commit 75e893169fc5c9ec28d5f9dffde40ce29b59a5de ]

The USB UTMI reference clock must operate at 24 MHz, as recommended
by the hardware team, for reliable USB operation.

Validation showed that USB 3.2 hub enumeration with USB 2.0 devices
fails when the UTMI reference clock is not configured to the required
24 MHz rate. Configuring the UTMI reference clock to 24 MHz to resolve
the enumeration failure and ensure successful device detection.

Cc: stable@vger.kernel.org
Fixes: e3fdbef1bab8 ("clk: qcom: Add Global Clock controller (GCC) driver for IPQ5018")
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-ipq_clk_changes-v1-1-d242e3d49648@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5018.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-ipq5018.c b/drivers/clk/qcom/gcc-ipq5018.c
index 6ab9c3f1f818a..34c2be0b9df3a 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -1269,6 +1269,7 @@ static struct clk_rcg2 usb0_master_clk_src = {
 };
 
 static const struct freq_tbl ftbl_usb0_mock_utmi_clk_src[] = {
+	F(24000000, P_XO, 1, 0, 0),
 	F(60000000, P_GPLL4, 10, 1, 2),
 	{ }
 };
-- 
2.53.0



