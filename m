Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCC233F378;
	Tue, 16 Dec 2025 11:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884043; cv=none; b=aTTJco55F1Q9+FvxiLPDxKKxHQb1S6Cqh+ovTFnNUsz8/Jh2W9TCev1ww2YGI7/6/vHRoLGJ8SGc/tRINdqqz+TXCBC0dszexwA3U+xLaZ551j6QOIXPbC/RWH0Qd037OZIJDyL+Oazlp/2vxBy2mmxwNUAqO+Ku2p7o2JXk/jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884043; c=relaxed/simple;
	bh=KaUDvvOQPE/y6YRuphB4hRBEwWmSMiL0e1pF8ckZq/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLiAcYQ/smKn1JmnDOTRCIqjDmHXw8d3EpP/gqk9m0eGuI9nQWVjM6uD+OUSE9TZQmhva8ciaEl9JbZd78aW+9ntJoSg5KoUDzv38SpCyjz3QUR3hDe4NmReXVod6eddMyAgeNRp2KpNzMfQzwUfLPCBI2zm1u0KfBGk6aI+iLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYTOkk7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYTOkk7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFC4C4CEF1;
	Tue, 16 Dec 2025 11:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884043;
	bh=KaUDvvOQPE/y6YRuphB4hRBEwWmSMiL0e1pF8ckZq/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYTOkk7KvyUEOOVE6lgwjh0VHb7SaNjP37nIWC4iOPyDYujayjmnw41iaVsvX2s6R
	 uqRheAetBabHxld+Ba/snBKn0OHlm1V4JCj3t4PEBjsqvSnlBNTMhQVAtJqgnLqn5Y
	 4gJWYDVP16YYbNr9yLwcW1LRXm/a8Zzd8DCrJHQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Martinz <amartinz@shiftphones.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/354] arm64: dts: qcom: qcm6490-shift-otter: Add missing reserved-memory
Date: Tue, 16 Dec 2025 12:10:43 +0100
Message-ID: <20251216111323.677571180@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Martinz <amartinz@shiftphones.com>

[ Upstream commit f404fdcb50021fdad6bc734d69468cc777901a80 ]

It seems we also need to reserve a region of 81 MiB called "removed_mem"
otherwise we can easily hit memory errors with higher RAM usage.

Fixes: 249666e34c24 ("arm64: dts: qcom: add QCM6490 SHIFTphone 8")
Signed-off-by: Alexander Martinz <amartinz@shiftphones.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251009-otter-further-bringup-v2-3-5bb2f4a02cea@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts b/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
index 75930f9576966..ce5cd758e28b4 100644
--- a/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
+++ b/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
@@ -118,6 +118,11 @@ cdsp_mem: cdsp@88f00000 {
 			no-map;
 		};
 
+		removed_mem: removed@c0000000 {
+			reg = <0x0 0xc0000000 0x0 0x5100000>;
+			no-map;
+		};
+
 		rmtfs_mem: rmtfs@f8500000 {
 			compatible = "qcom,rmtfs-mem";
 			reg = <0x0 0xf8500000 0x0 0x600000>;
-- 
2.51.0



