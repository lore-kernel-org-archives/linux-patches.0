Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D9D3B1EFC;
	Tue, 21 Jul 2026 20:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667014; cv=none; b=FIndrmdHajom0GZ6rtkxnlGWvoMT1zFLfId9FksHZymJbwGPCoQ/KIhAw9MYH4QNMl+wOW83HvwcsXc1bzBnN3SdKcizR1tOOtcTHexgPKwcBcrtjz9Xpa+hkcdDoYfVq+z9q8G4caLG+gOpQbYPawJJcekEaFg+SH06V2fj/qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667014; c=relaxed/simple;
	bh=TzgIMbNPH5LeB40XjRc5/WeCZXqat1QeocTJfWCgKX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9PjB0VU835dtNhEmPB+FZxWTNskBxuKAgUAUpIyS2lSwsvTgIKJBxMcNXsXu7ZGgqXENoMkjmA4SDA6MCHAxEPB3GgwvQkS9nglIO03r/IKnIFZ2pe4hC6wch3E/FCaRumP0nw7r+cFT0TSp4p4tl0dsPzZ5enWjIfK8K340ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w16qNoi5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w16qNoi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8821F000E9;
	Tue, 21 Jul 2026 20:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667012;
	bh=i9JeRyhSXK1252/XaGSGNUsaKNFrbxWJ5BWnZ5DencQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w16qNoi5ouBni87dJ1cWhTnwOjCBQ68D31UMqJV8HVA4GGl1AvNtpjSs93qFjafwa
	 dqf+lhH0IvJAb05qvo17cGA3F+4TmpRmFHoqdUeRjNyrszhlmTgI9MY6iq3+cxlXBq
	 GvfD+BONCdh1I7bT4DZTS1fWYx16i6KR1dYYgtn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Nickolay Goppen <setotau@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 0900/1266] arm64: dts: qcom: sdm630: describe adsp_mem region properly
Date: Tue, 21 Jul 2026 17:22:17 +0200
Message-ID: <20260721152501.987016403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolay Goppen <setotau@mainlining.org>

commit ce414263e9ebe5080381a50cbdf9065c29816202 upstream.

Downstream [1] this region is marked as shared, reusable and dynamic so
describe it that way.

[1]: https://github.com/xiaomi-sdm660/android_kernel_xiaomi_sdm660/blob/11-EAS/arch/arm/boot/dts/qcom/sdm660.dtsi#L448

Fixes: b190fb010664 ("arm64: dts: qcom: sdm630: Add sdm630 dts file")
Cc: stable@vger.kernel.org
Reviewed-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Nickolay Goppen <setotau@mainlining.org>
Link: https://lore.kernel.org/r/20260429-qcom-sdm660-cdsp-adsp-fastrpc-dts-fix-v5-4-16bc82e622ad@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -491,9 +491,12 @@
 			no-map;
 		};
 
-		adsp_mem: adsp-region@f6000000 {
-			reg = <0x0 0xf6000000 0x0 0x800000>;
-			no-map;
+		adsp_mem: adsp-region {
+			compatible = "shared-dma-pool";
+			alloc-ranges = <0x0 0x80000000 0x0 0x80000000>;
+			alignment = <0x0 0x400000>;
+			size = <0x0 0x800000>;
+			reusable;
 		};
 
 		qseecom_mem: qseecom-region@f6800000 {


