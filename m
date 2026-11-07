Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063330;
	b=gCE8Y/yWPnypNf9EOxixXlLwetvuo+Wmf6669cu1i5o/qmoANgjZ2SbAeUZx9XFccyTp
	 gBW09Fm6ax3Ib5zcRGkCovkQd5zgcte6F4l0c6vA3RJ2VvpNvRH3N/xRaY3AWVyy21aOL
	 aoImkYHVOmEEtfLANOYvYzLjRy+F6nNBZOe3tFf9RkHKPPcYqGH3w+zB3lsj5XzaqE2Gt
	 K7iFdvouTElsVSEShdTZSMt7Zm6e6ixRS1Xxi+v5bE252OhuLgWUtEIsIPvurHBdixxVi
	 vH6iWQdjKdHpp5IPm3K/Ku5Ukflhqp2P7IdyRCnrar0bRY+vOP7PN/fNFLh/vODXBwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=asI1emWs9ZJQGxTHilaH1px6mlvEFlBke/vMQSbNHlY=;
	b=olS+3v0vOihZVoXt+5ZnVAaxwx+f3uf1m86ahwdaN9jwNzwGAbfMA33CzrdRgTZ6oabO
	 KlTVrJR8TuPn2y1VMsGmN1crpcM/WRyakgdK4F6R1XZAruVy1dvXPaDke6UpklGfISIwQ
	 dPm4MHcXLjipaC39/fjZhcXZbfc6CaD8Qf9a0cXJxqLu0hxQoATNSXojzFMm82quzuxC+
	 rYuxBTrJa4+65lNDnknAAdTVeOP42jYau1dKE4O9ejakCZcLPVwvTA+zqVFOeKVDq6238
	 NaIHlDriP8KTqR9Y/cf04ONFmAZupvIxBkJ+RY7HN0l9kpEl7ZDhTAt/3HwkA+aZTiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSQyBtZg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E036082BD0;
	Sat,  7 Nov 2026 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSQyBtZg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55081F008A5;
	Sat,  7 Nov 2026 14:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063329;
	bh=asI1emWs9ZJQGxTHilaH1px6mlvEFlBke/vMQSbNHlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSQyBtZgUXvFwjOxPSSBw4PGciIqT8kArq9y2A25WerGuBh3IdvMlphDJPOa4P0zn
	 MphUJ7S44FE/JlM2/BEy81Yw0+IXSaNq7AukjmM5iZFHEy/G+o16S8tzBSeGvc0wU6
	 D2DInqe0/GHzGCL0+itpAhFL/3q7uSuZb60W1AFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 513/869] clk: qcom: ipq5332: add 24MHz rate for USB UTMI clock
Date: Sat,  7 Nov 2026 08:53:15 -0500
Message-ID: <20261107134910.957381418@linuxfoundation.org>
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

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

[ Upstream commit 19b62f31e15ef70dc927aab91b1576ea6c37f992 ]

The USB UTMI reference clock must operate at 24 MHz, as recommended
by the hardware team, for reliable USB operation.

Validation showed that USB 3.2 hub enumeration with USB 2.0 devices
fails when the UTMI reference clock is not configured to the required
24 MHz rate. Configuring the UTMI reference clock to 24 MHz to resolve
the enumeration failure and ensure successful device detection.

Cc: stable@vger.kernel.org
Fixes: 3d89d52970fd ("clk: qcom: add Global Clock controller (GCC) driver for IPQ5332 SoC")
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-ipq_clk_changes-v1-2-d242e3d49648@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5332.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-ipq5332.c b/drivers/clk/qcom/gcc-ipq5332.c
index 9246e97d785a1..1d02c35c67225 100644
--- a/drivers/clk/qcom/gcc-ipq5332.c
+++ b/drivers/clk/qcom/gcc-ipq5332.c
@@ -1039,6 +1039,7 @@ static struct clk_rcg2 gcc_usb0_master_clk_src = {
 };
 
 static const struct freq_tbl ftbl_gcc_usb0_mock_utmi_clk_src[] = {
+	F(24000000, P_XO, 1, 0, 0),
 	F(60000000, P_GPLL4_OUT_AUX, 10, 1, 2),
 	{ }
 };
-- 
2.53.0



