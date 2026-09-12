Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A852F1EB5FD;
	Sat, 12 Sep 2026 07:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197852; cv=none; b=QAR1G8Z2doDq/NujBsGE5LtiiU3us2pjjOaxuPAUT/MCj0EWRw20b4ICxYVKb1OvutA4SjTcuzPFlfl8rfkmRJFBmNQNi9bTZZBBW2xMbU1RGA52G0n7Blxv6AqmUAQTqUfpcNkN7aTekROEYU6unK1siZci0LtNcoIh3u9d49I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197852; c=relaxed/simple;
	bh=4QSWQTZqFRr4JwkacPGZAoLKA/oLQCLAufvUSu9UUKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5rKbLaTPlJryFQ8/NDjfXvSe5MTocjraXu7X7aZcdor4dC4+A6GnPE1L8VAljahdDPkIQcqsepIhJn1gDmKIQDYxjTCeckHMb4lm8Zw2fdWX+nnOvounnKek2PE5+RwUV0lt1JQBrHdS/GsvSEJJ2TBGOaeSc1H0oDx4sMJcpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLw5Jz7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLw5Jz7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2641F000FF;
	Sat, 12 Sep 2026 07:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197851;
	bh=/321AdcEgxq5G6AIDiyCtirNwoDGlI+zjrZcNeok7C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLw5Jz7jM6X6dGRyqJxniaOEIQ6LkSNk7kt1gzi0267gEi0jdgWyPjPBFsHiJ5Rq8
	 Qoy9dqMEveGJFmvMettaSliIbaKSE5xT30jZJYRnTaTTYmLIupRzXjrTn21Dxy2CaH
	 i33SchJKAjwMTDd/YfCcn7WrzXtdclwF5xQgGwZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Acayan <mailingradian@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0259/1815] arm64: dts: qcom: sdm670-google: add lpi reserved gpios
Date: Sat, 12 Sep 2026 08:33:29 +0200
Message-ID: <20260912065655.057372000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Acayan <mailingradian@gmail.com>

[ Upstream commit 71dd62dac8e2d03f952587f8985a859fce422815 ]

Add reserved GPIOs for the Pixel 3a, which blocks access to the sensor
GPIOs. The hunk in the original patch was dropped in the commit because
it depended on an unapplied patch, which is now commit fe9f4a46895d
("arm64: dts: qcom: sdm670-google: add common device tree include").

Fixes: c4b423835ee7 ("arm64: dts: qcom: sdm670: add lpi pinctrl")
Signed-off-by: Richard Acayan <mailingradian@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260602021722.30760-1-mailingradian@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm670-google-common.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm670-google-common.dtsi b/arch/arm64/boot/dts/qcom/sdm670-google-common.dtsi
index 0f57b915186b7..b4854801a5f5e 100644
--- a/arch/arm64/boot/dts/qcom/sdm670-google-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm670-google-common.dtsi
@@ -522,6 +522,11 @@ rmi4_f12: rmi4-f12@12 {
 	};
 };
 
+&lpi_tlmm {
+	/* sensor gpios are protected */
+	gpio-reserved-ranges = <0 8>, <12 6>;
+};
+
 &mdss {
 	status = "okay";
 };
-- 
2.53.0



