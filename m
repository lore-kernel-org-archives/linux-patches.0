Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BEB3491E8;
	Tue, 16 Dec 2025 12:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887613; cv=none; b=fyjBrLP0ZL5+RsbjtDjNO+iloUgMG659CuX10mx7DqjBfIVBCQCw/jCRAw3QPjovrdjBlOjolDtBY6y1mkLibqSJHY0iB1vR6lvM4AWLuIt6UWrBfL+9vDMXwvMVc9GWsJq0HknUnuqx3VfGpRV0AsPOfqb2i79T/zZN0zUN6BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887613; c=relaxed/simple;
	bh=kZvw99Sk4PyskrjGBmMuwytjlLlvQDBKhA1fswpPaBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GD07pKgkx2nv3WhGfRXE1dfSyiJM6ffWmnZXv6ToKKRFY1J/RILzGeDAVtweq1n2IDkCPZ156nbn7NgGjRU+MZoERs+YHkVQC4kuv6RnGLHYKPio9QXPJ9QpbbA40C2EJ2ixC11MiDxD4bMtJ2FeXMhrmZg97YRDNUHHQsM6n6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPbZKKb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPbZKKb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE6BC4CEF1;
	Tue, 16 Dec 2025 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887613;
	bh=kZvw99Sk4PyskrjGBmMuwytjlLlvQDBKhA1fswpPaBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPbZKKb4qHmOjBQfNhUu0PyxI25DZfKZhYVl7arG36e/3wtrp3InqddoneKF6ST3K
	 hZJkQZKImR+YhGEqwQhLztfdSv09M8JUZsh/h6CzC9ojdPBOn4efmYgKzIE2wXW+qY
	 Jcm0GNZ2ySCDlKp9H6qO/n7NM1QoV3UEghPAzUkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 285/614] arm64: dts: qcom: qrb2210-rb1: Fix UART3 wakeup IRQ storm
Date: Tue, 16 Dec 2025 12:10:52 +0100
Message-ID: <20251216111411.698102848@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

[ Upstream commit 9c92d36b0b1ea8b2a19dbe0416434f3491dbfaaf ]

For BT use cases, pins are configured with pull-up state in sleep state
to avoid noise. If IRQ type is configured as level high and the GPIO line
is also in a high state, it causes continuous interrupt assertions leading
to an IRQ storm when wakeup irq enables at system suspend/runtime suspend.

Switching to edge-triggered interrupt (IRQ_TYPE_EDGE_FALLING) resolves
this by only triggering on state transitions (high-to-low) rather than
maintaining sensitivity to the static level state, effectively preventing
the continuous interrupt condition and eliminating the wakeup IRQ storm.

Fixes: 9380e0a1d449 ("arm64: dts: qcom: qrb2210-rb1: add Bluetooth support")
Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251110101043.2108414-2-praveen.talari@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb2210-rb1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
index 67ba508e92ba1..3eedfb2cf4799 100644
--- a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
+++ b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
@@ -649,7 +649,7 @@ key_volp_n: key-volp-n-state {
 &uart3 {
 	/delete-property/ interrupts;
 	interrupts-extended = <&intc GIC_SPI 330 IRQ_TYPE_LEVEL_HIGH>,
-			      <&tlmm 11 IRQ_TYPE_LEVEL_HIGH>;
+			      <&tlmm 11 IRQ_TYPE_EDGE_FALLING>;
 	pinctrl-0 = <&uart3_default>;
 	pinctrl-1 = <&uart3_sleep>;
 	pinctrl-names = "default", "sleep";
-- 
2.51.0



