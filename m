Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82F9191F7E;
	Wed,  3 Jul 2024 10:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004237; cv=none; b=WWT9qTCQurtx3QVrenFnAlNEKo21p8rgTdDM2X+Nb8oAfnJnAyZa24SUI2ec0ErdhCNCpIrl8Fm6MtdR3RzMLIgvEs/pAHKuXaHEovxbhGQE+pv3YybCN6BrbdKJ7VZaQb2san+46449znjfh2ivn+7DDpnRNBDkYhuTQhBW6e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004237; c=relaxed/simple;
	bh=iuCdST0O5AN9ApqG9wn9KWbplOY137wM8xi0lxVwOFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OimeJ/qJgbV6gGe/M88XHZFGL9CQyr96Rf74D0rSyHx+EJ/KlX5i2FYXz0bKlS6UuLS6HDQA72SgbJYIDfwtBZnTUQU8wCZfWMgerwvbuo910XJyk5WNNfEuTpk5SPlPtMwr77Kloju6xcz2s87lZQMGO7olRnWgB1cmEloTAyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x00B8Pu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x00B8Pu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519BEC2BD10;
	Wed,  3 Jul 2024 10:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004237;
	bh=iuCdST0O5AN9ApqG9wn9KWbplOY137wM8xi0lxVwOFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x00B8Pu7lRloHu7lOd7v6fa9jvaC+UhkabxD53ATQGQepC0RbBrFdVN8lwgFVYMg/
	 fmgEvKBwRqDuh4CwqcuzhaBhsSNvoTSUd+lR8BB5RQEh77yQOHyJf3cJDCxiv6Wl1+
	 +yeNFryiu0RJVdmjob9YDColVEeBW9pzVj5eaqzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/189] arm64: dts: qcom: qcs404: fix bluetooth device address
Date: Wed,  3 Jul 2024 12:39:44 +0200
Message-ID: <20240703102846.137217319@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit f5f390a77f18eaeb2c93211a1b7c5e66b5acd423 ]

The 'local-bd-address' property is used to pass a unique Bluetooth
device address from the boot firmware to the kernel and should otherwise
be left unset so that the OS can prevent the controller from being used
until a valid address has been provided through some other means (e.g.
using btmgmt).

Fixes: 60f77ae7d1c1 ("arm64: dts: qcom: qcs404-evb: Enable uart3 and add Bluetooth")
Cc: stable@vger.kernel.org	# 5.10
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20240501075201.4732-1-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi b/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
index 522d3ef72df5e..03244871474e2 100644
--- a/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
@@ -43,7 +43,7 @@ bluetooth {
 		vddrf-supply = <&vreg_l1_1p3>;
 		vddch0-supply = <&vdd_ch0_3p3>;
 
-		local-bd-address = [ 02 00 00 00 5a ad ];
+		local-bd-address = [ 00 00 00 00 00 00 ];
 
 		max-speed = <3200000>;
 	};
-- 
2.43.0



