Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C0B31A7F5;
	Tue, 16 Dec 2025 12:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887080; cv=none; b=AmHwgQafjLUU3aZuEj49F8iknK+Aubxw0LiFwUxobc+/V/STupkit32Urxj8+B6T1mlZWMbbj3QN9okwh7shCUuy6jR0NGKe3a2INDMLKN0cu6Tr9o2M2Hc2S0HwAR1M4c62ul1g2a401ua3xexqEi1nkP4XBRiyx7GFZHQj/m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887080; c=relaxed/simple;
	bh=9qFuTWcXBcBrvO1q8B1q75pZZKBq9yeLSgGD7ku8v2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkbmB1AmBqu4xasDsHKrFFGYtkGrteSzFfxJYcmIrWuPKQJ2cG/GoTTRrcoK435jFfq+qhNoVvBUVYkR6Xmx943gEyFZJrJO7GB7N8TPl26BPO2tlkSLi0kmBfdvBXK9e8OsOwxWDFa+9oG8qQNNHQuj7OsSdpdfNeY3AO5aTaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uVNHFtC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uVNHFtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98449C4CEF1;
	Tue, 16 Dec 2025 12:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887080;
	bh=9qFuTWcXBcBrvO1q8B1q75pZZKBq9yeLSgGD7ku8v2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uVNHFtCl/eoad66/4T6MoGMGtXqxHXTyvsdHrv6vwAWO+rWqaOduLi9vPGr5ZEER
	 CCiSnMJeCibf+YZvSgXmVBVeFtQmBOyoDUuEmc8DXLnquQ3ZZ8D61BnGUaEkd7gMLS
	 /k88o/rQavjkFFVAohHn9LV9N7+u3UHDWIgMNJGg=
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
Subject: [PATCH 6.18 120/614] arm64: dts: qcom: qcm6490-shift-otter: Add missing reserved-memory
Date: Tue, 16 Dec 2025 12:08:07 +0100
Message-ID: <20251216111405.684307349@linuxfoundation.org>
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
index eb8efba1b9dda..cc99925798873 100644
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



