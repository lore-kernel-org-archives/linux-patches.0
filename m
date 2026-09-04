Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94060415F23;
	Fri,  4 Sep 2026 05:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499455; cv=none; b=cZ58Qxo7LGiBXrIkGJcF147dTLhG6NYb5SJHzaQZ4fuya4FRqnWmkoMpIJ7jK0/kWRq0YH3LWba6slbmL5klw9F1VLjWMy1+16XKYYa4x08QR0q2S2PfzwHh77FexTFSOW+kVNPPl9UQ6F0nucuAxtGs6OdiJ0MQ0LTFFIAzEAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499455; c=relaxed/simple;
	bh=kJQVnqYxk8yeiQhkAqb4ZEz85sKvrIIrlJI5EMjsEYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfrK20w/uTB2zRbsOg3SMkiWnPC5zMuwVAtU9qiG4rpp79W08pW1Q9X6gevUDOfwrX/JWMIOtQ31euVUKOGKl/F+K3vTUzWvPgSHnQIWF3Sd33AjUNjMfZ1mWbsE/7sSwkjP5eDFm97SOuuHpNvC0EstAvTYjaMH7UTtjqas5CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMmoXL1W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMmoXL1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04311F00A3D;
	Fri,  4 Sep 2026 05:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499454;
	bh=/XwI9gyzjqvHlAbwBevMVpvHnWn7WYmL0vxsXhAmzlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMmoXL1WDdA0sBmxxjAabtu18ivcb8DYRIf6KkYgpnDy18KywjtSvZpHT+z4mheXB
	 Uud/A04JxNZIevhh8nrSWe0pUqOvQHtpCDdTduL8vUceGhEbKRGY3C6rRcxLFt7pr9
	 4/Dmy6O3rt+tPPUChbzUeuOW9GkrOVjY2H8g2Cu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jianping Li <jianping.li@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 7.2 423/713] arm64: dts: qcom: kodiak: avoid EFI overlap for ADSP remote heap
Date: Fri,  4 Sep 2026 06:56:31 +0200
Message-ID: <20260904045813.311115849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Jianping Li <jianping.li@oss.qualcomm.com>

commit 9d7d847ff1c502802ac764120f9a1800b94ce497 upstream.

On KODIAK platforms boot can fail when the DT "adsp-rpc-remote-heap"
reserved-memory region overlaps with firmware allocations (UEFI/EFI
runtime). The kernel then reports failure to reserve the region and
subsequent EFI runtime activity may trigger aborts.

The remote heap node was described as a fixed "no-map" region, which
turns it into a hard carveout. Replace it with a "shared-dma-pool"
reserved memory region with reusable CMA-backed allocation, specifying
alignment and size.

This avoids hard carveouts and reduces the chance of conflicting with
firmware memory maps while keeping an explicit pool for ADSP remote
heap usage.

Fixes: 90a58ffa9c55 ("arm64: dts: qcom: kodiak: Add memory region for audiopd")
Cc: stable@kernel.org
Signed-off-by: Jianping Li <jianping.li@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260429073443.2027-1-jianping.li@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/kodiak.dtsi | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
index ac048ec9aeb5..7e73348fe0d0 100644
--- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
+++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
@@ -191,9 +191,12 @@ rmtfs_mem: rmtfs@9c900000 {
 			qcom,vmid = <QCOM_SCM_VMID_MSS_MSA>;
 		};
 
-		adsp_rpc_remote_heap_mem: adsp-rpc-remote-heap@9cb80000 {
-			reg = <0x0 0x9cb80000 0x0 0x800000>;
-			no-map;
+		adsp_rpc_remote_heap_mem: adsp-rpc-remote-heap {
+			compatible = "shared-dma-pool";
+			alloc-ranges = <0x0 0x80000000 0x0 0x80000000>;
+			reusable;
+			alignment = <0x0 0x400000>;
+			size = <0x0 0x800000>;
 		};
 	};
 
-- 
2.55.0



