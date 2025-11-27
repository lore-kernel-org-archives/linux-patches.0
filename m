Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF45533468A;
	Thu, 27 Nov 2025 14:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255529; cv=none; b=P1Wva43jRX8TncACCFke4WS6pn2Nzyp8+RhB7r4bVB352VdsjoXPRU5nIERhLvD7vgyaVnzoriEGq9+u5Lro0oleExJDZ7ft6gc1fenvq6mM3UU4+8g//qCaraINmqdd3VN2+0AS3e471NHrWhmFuvAmLSupAxEcl4iduF4BnE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255529; c=relaxed/simple;
	bh=atq6RA82a01jP2iI0vyq3bx7JVTcFiUAjiHmfNmDdmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efTq0TXaJmae4B3FMlpSQ3k26sFtOTW5lrOUk9ulKidDJbZjak71FKmnZYa2ku293d7oiZkuQyZ3pt86hBBPVcvHoo7rchY3xtnXmnF8C1aUUJggCGtgD+TmT/6XZc6J0fo1Ir9SdpdjVXayZvDnWVKdYcIlwnOpIVdfeIm2FMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5XKEAn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5XKEAn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6B9C4CEF8;
	Thu, 27 Nov 2025 14:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255529;
	bh=atq6RA82a01jP2iI0vyq3bx7JVTcFiUAjiHmfNmDdmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5XKEAn/7rYCS7+b/udNbcqfji0oFFu4kaBpcpuiyqqfXsWdDzm2DzalxUrORfrVi
	 LFkpt6ISerWYp3fbFphDWQDdp5I7nX6w2PyQSCRhnzyL+hadwv8rVaJPO7WvkhX4z3
	 gmelJ7lm1HWmbpR2eSh/NO0OsWAijnOJyo+VOeM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.17 003/175] arm64: dts: rockchip: Remove non-functioning CPU OPPs from RK3576
Date: Thu, 27 Nov 2025 15:44:16 +0100
Message-ID: <20251127144043.074889073@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@gmail.com>

commit 05b80cd1f37db042e074ecc7ee0d39869fed2f52 upstream.

Drop the top-frequency OPPs from both the LITTLE and big CPU clusters on
RK3576, as neither the opensource TF-A [1] nor the recent (after v1.08)
binary BL31 images provided by Rockchip expose those.

This fixes the problem [2] when the cpufreq governor tries to jump
directly to the highest-frequency OPP, which results in a failed SCMI call
leaving the system stuck at the previous OPP before the attempted change.

[1] https://github.com/ARM-software/arm-trusted-firmware/blob/master/plat/rockchip/rk3576/scmi/rk3576_clk.c#L264-L304
[2] https://lore.kernel.org/linux-rockchip/CABjd4Yz4NbqzZH4Qsed3ias56gcga9K6CmYA+BLDBxtbG915Ag@mail.gmail.com/

Fixes: 57b1ce903966 ("arm64: dts: rockchip: Add rk3576 SoC base DT")
Cc: stable@vger.kernel.org
Signed-off-by: Alexey Charkov <alchark@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3576.dtsi |   12 ------------
 1 file changed, 12 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3576.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
@@ -269,12 +269,6 @@
 			opp-microvolt = <900000 900000 950000>;
 			clock-latency-ns = <40000>;
 		};
-
-		opp-2208000000 {
-			opp-hz = /bits/ 64 <2208000000>;
-			opp-microvolt = <950000 950000 950000>;
-			clock-latency-ns = <40000>;
-		};
 	};
 
 	cluster1_opp_table: opp-table-cluster1 {
@@ -341,12 +335,6 @@
 			opp-microvolt = <925000 925000 950000>;
 			clock-latency-ns = <40000>;
 		};
-
-		opp-2304000000 {
-			opp-hz = /bits/ 64 <2304000000>;
-			opp-microvolt = <950000 950000 950000>;
-			clock-latency-ns = <40000>;
-		};
 	};
 
 	gpu_opp_table: opp-table-gpu {


