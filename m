Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018427;
	b=JOr7Ij8piXbDouJ2Ut7SPyAf8VjOBcs9DZVAlqKM7A66XyMP7CG8sFcAtTaD2NH4amBW
	 D7y9bOoKTcEPZDKTuaq7iHNtE0dx/wRBbiZ9nXrILH9ROKTeSS+MTueCWvH3jxeZmVp6V
	 z7WsyHMAAIME68z4E1avd4a+Nk9nt7prarvjiy7Rl2HkxrGWPuFDsZjSqkXERtHDSQwFl
	 qPzmxuQn77BJGvZOkXlVdNO2hL+w6pSdPJVfQLKHjNf4zWvX29Lg45KqiREwNfwKs9Xdd
	 5IBiaI9w5d4ap0IgToZZEItd7O3IFdkLXs8zp5XFmQvJo6kubH6TD4pd5DDjX9+ZZ6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZptnTwkrrpj841T0FryLG1QOqste24Xbwdt+sWHcWso=;
	b=SF/BsfaXeqxsCbo0Ef5z6MNdHWQKGJcXsQ6Gbhm+stJWqqVVj8HCPI9a3WR2wYsIjLmI
	 Q2qifP0fuTa4EnXXOghtsfsvQA3/3n/PBf0LqCgyVQ7ywt73SAnuT64LdEgqdcP2TlKE1
	 /I64lOdl77iRtKyXd83U1y1RdLyc6t/4rtyr9Aj2/4D1cr+6TnX8GC49BHJI1t/FUWIbD
	 Kvu+TSuKX8LXqi6kVyKJnN4NHR9sZwgUyrqalX6QujsO21M8HmihnzqDuNUvs2Elu0/FW
	 w8hAeJDdHGf8087eaGTGo2/VBR+3hqpvSFAugAustwoLdblu3uTTMqyS3vvsC4pSnuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CywJsG4v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF49606A31C;
	Wed, 18 Nov 2026 16:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CywJsG4v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283841F000C4;
	Wed, 18 Nov 2026 16:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018426;
	bh=ZptnTwkrrpj841T0FryLG1QOqste24Xbwdt+sWHcWso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CywJsG4vTezQsJ3+sU/RTJEIa/FIiKJvbicOSCc1YMH/igFU8jPLe4d1P+JDiq1za
	 m/LnAJaHZDc7UACueBOck8twZz7kPDGr0zstbtmM3fFwKP8qS/HBCOqtYlGWxCKf29
	 RXBHPZS6go+7TO1l8U+22wNKapYXxlAxaxD9aLDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1236/2651] phy: qcom: qmp-pcie: Check clock-output-names count in the multi-PHY driver
Date: Wed, 18 Nov 2026 15:41:16 +0100
Message-ID: <20261118150332.502836908@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit fb0f0e0e9e5dace7a6d9cde289537980ad35db3d ]

of_property_count_strings() returns a negative errno when the property
is missing or malformed. The value was passed straight to
devm_kcalloc(), whose overflow check rejected it, turning a device tree
problem into a bogus -ENOMEM with no diagnostic.

Fixes: 1781be3c8a5d ("phy: qcom: qmp-pcie: Add QMP PCIe Multi-PHY driver")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260825225729.230493-2-devnexen@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie-multiphy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie-multiphy.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie-multiphy.c
index befca9b78ce92..b4bcb199e1286 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie-multiphy.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie-multiphy.c
@@ -538,7 +538,8 @@ static int qmp_pcie_multiphy_register_clocks(struct device *dev,
 
 	num_pipe_outputs = of_property_count_strings(np, "clock-output-names");
 	if (num_pipe_outputs < 0)
-		return num_pipe_outputs;
+		return dev_err_probe(dev, num_pipe_outputs,
+				     "failed to read clock-output-names\n");
 
 	qmp_data->num_pipe_outputs = num_pipe_outputs;
 	qmp_data->pipe_out_clks = devm_kcalloc(dev, num_pipe_outputs,
-- 
2.53.0



