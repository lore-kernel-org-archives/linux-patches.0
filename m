Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CE91F5FA;
	Thu, 11 Apr 2024 10:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830149; cv=none; b=VSM5e/PNExgZcmoWxIOQyi0tMjO7PdsYdfM/M++ScoIEQtL4ILbbOZcAS3AnpUkAtmvnk4qcdpqTPRiu+HsqGS2ulebUwFKYGhSe7WWbSHLZp8qzJiwV/56/i4QnU5pFjd0axRhBgkDRud1JlpLwmAFc81l1lH+8e61a4xwVz5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830149; c=relaxed/simple;
	bh=1nK4DLRJz96xlUlyIDAoHvAoU92devbINLKH2z0iugI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NngqrOTKy3GZU0InOFbvbx3Q7N1xMaQvVW6QClwt4ZJ2pBUmzYIJvJKkPEVIYGs09twj7SZyJ5bU0NT2GrBLEkSXfoZalx1d/xCI4A9t9AdA/48U/cUhNlFl9S/rd4JXuELXbfxsJ6aZoz0vfoejHM/1yM2dSb4jL8zBOltni5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zh73towJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zh73towJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F27C433C7;
	Thu, 11 Apr 2024 10:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830149;
	bh=1nK4DLRJz96xlUlyIDAoHvAoU92devbINLKH2z0iugI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zh73towJ7yE8++tzU5D+v0LnlT8pYZTcYyI5ZRxQ7oQsMU5Yri3Wq50tqRwSPg/Nk
	 ykv4dhaG4JD482xn60ISaPp6Bm5ITpEW9RmPn9LWvfcjtnaIo1OXSuUwmU0YrD+Au8
	 IvVTTFh/rYtOKdKQeKL30TVLXXRPFG41T1+vXj1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 014/143] arm64: dts: qcom: qrb2210-rb1: disable cluster power domains
Date: Thu, 11 Apr 2024 11:54:42 +0200
Message-ID: <20240411095421.340186865@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 7f492d48f08207e4ee23edc926b11de9f720aa61 ]

If cluster domain idle state is enabled on the RB1, the board becomes
significantly less responsive. Under certain circumstances (if some of
the devices are disabled in kernel config) the board can even lock up.

It seems this is caused by the MPM not updating wakeup timer during CPU
idle (in the same way the RPMh updates it when cluster idle state is
entered).

Disable cluster domain idle for the RB1 board until MPM driver is fixed
to cooperate with the CPU idle states.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240130-rb1-suspend-cluster-v2-1-5bc1109b0869@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb2210-rb1.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
index 64b2ab2862793..6e9dd0312adc5 100644
--- a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
+++ b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
@@ -177,6 +177,24 @@ vph_pwr: regulator-vph-pwr {
 	};
 };
 
+&CPU_PD0 {
+	/delete-property/ power-domains;
+};
+
+&CPU_PD1 {
+	/delete-property/ power-domains;
+};
+
+&CPU_PD2 {
+	/delete-property/ power-domains;
+};
+
+&CPU_PD3 {
+	/delete-property/ power-domains;
+};
+
+/delete-node/ &CLUSTER_PD;
+
 &gpi_dma0 {
 	status = "okay";
 };
-- 
2.43.0



