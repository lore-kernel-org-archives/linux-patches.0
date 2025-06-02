Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A6C23184A;
	Mon,  2 Jun 2025 14:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875502; cv=none; b=Kh1RrsVMttUvnhpOOFlxfq016+E34/S5r1YhuDx5GhGuA/Cad59zPgqqy1kMHO00ihsPpwv9rnv8xsgaacAmjn6q1LOSvaGBSJpR5BtOjJ8eTXPmB/7KLTRKJN4d+IoaI+g1yvt1VU2x8DiUPAUq5kAsidjfudOGrPKGE/R+Np8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875502; c=relaxed/simple;
	bh=K0hwO6lk8IsvL+qrfjJrQJhaesRUy8W4bEP7/0N0rX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLBCX7qP3lyPaHzACmK/sRlARYzNobq3DgGjjqYOPE1FWmzwCwYVzUuFS5kEINKyI1VJ3tAkjFBtmk2UnO3xEwE/5IO4G0EWtUfqOiTB6gphJGprYGRjJchUfTmXeJAk2tgsIUuGYlS4be9NmG2bahhIdMF6oi+IlxF8GjP/+X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBuG3cAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBuG3cAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB69C4CEEB;
	Mon,  2 Jun 2025 14:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875501;
	bh=K0hwO6lk8IsvL+qrfjJrQJhaesRUy8W4bEP7/0N0rX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBuG3cAP10j/2+HANHbgOO/wmu1OpzETkfJ499baJqPTEDODeKgvn2tWjjvzlC4fs
	 7rZ0hf0gORwl9Zy3UGI8Xh2t4RbpyT0DDI6pnlL3nm82V8WRKhX0/LvvbEFay/0Hf0
	 N0IIhWc/RyYlYK2LA+KsmhTXy67QtWSCwU+9PT3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/270] arm64: tegra: p2597: Fix gpio for vdd-1v8-dis regulator
Date: Mon,  2 Jun 2025 15:47:19 +0200
Message-ID: <20250602134313.513745188@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>

[ Upstream commit f34621f31e3be81456c903287f7e4c0609829e29 ]

According to the board schematics the enable pin of this regulator is
connected to gpio line #9 of the first instance of the TCA9539
GPIO expander, so adjust it.

Signed-off-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Link: https://lore.kernel.org/r/20250224-diogo-gpio_exp-v1-1-80fb84ac48c6@tecnico.ulisboa.pt
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
index a9caaf7c0d67e..c04772a9740ec 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
@@ -1638,7 +1638,7 @@ vdd_1v8_dis: regulator@7 {
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
 		regulator-always-on;
-		gpio = <&exp1 14 GPIO_ACTIVE_HIGH>;
+		gpio = <&exp1 9 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 		vin-supply = <&vdd_1v8>;
 	};
-- 
2.39.5



