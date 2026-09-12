Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CFD27AC31;
	Sat, 12 Sep 2026 07:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199989; cv=none; b=HIcQsNtBbjImnsD2+zyg7I1MX72CJhf7z2QYcbPaMqN9ogQg65LDWD1kVTNzyPZEXhtG8vFaysFCngcVzzKYReejEnUDV7Q5UqPBn/h9VZtmiIDFV16b3FIouS1Gx16OeGrUb9llQqmA06GBWx8phwr3ynAUqOhNzL09buaZsXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199989; c=relaxed/simple;
	bh=Fl9GhjtLEALptbHchMqfQnyt9xU3xQlRwgpt1Yiin5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnE+GuEvLObjKXt+zrq1Z4E8aAtgryxsekQPxlOQa2H1cc6LJc6b7oUHwxKK9qYgLIuwomRHlIuAV6NDDkV+Ki09k5ib5T2EPQRVTYWOrHkwAGmk8KumvKHs9e0AUL5aehiTZ9LqwrpWg8PCQ1ouPPl+2TN8lrgH6oCCjW4lUnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVg+PiiH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVg+PiiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAA11F000FF;
	Sat, 12 Sep 2026 07:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199988;
	bh=hjUd513TKKIeMwbdO2ZnCQIlEiScarCJjaOeuKBAepU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVg+PiiHfAMOCyrbwTYL7dsiDd65YBA+8srQ6J3M0wd3Exs0tVO1S76K7I6EUPurM
	 GjYeYxIrd8MAyhRieq6yIbEs5EMs8n0Sy3kksID6uLH45Mz20379KxFcSbgF/9alIL
	 Qc9hXuW3ti8R+orvUfGLTUx2piyGrIka/9Ev6FME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ananthu C V <ananthu.cv@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0699/1815] arm64: dts: qcom: glymur: fix SoCCP memory mappings
Date: Sat, 12 Sep 2026 08:40:49 +0200
Message-ID: <20260912065705.299848587@linuxfoundation.org>
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

From: Ananthu C V <ananthu.cv@oss.qualcomm.com>

[ Upstream commit 61e5b39e96aadeafa884ab96c1477b781dccf145 ]

The currently listed SoCCP and SoCCP DTB reserved memory regions
don't align with the memory requested by the SoCCP Firmware. Fix
this by updating the SoCCP/SoCCP DTB memory regions to reflect the
memory region requirements of the SoCCP firmware, as described in
the Glymur v21 memory map release.

Fixes: 41b6e8db400c ("arm64: dts: qcom: Introduce Glymur base dtsi")
Signed-off-by: Ananthu C V <ananthu.cv@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260709-glymur-soccp-v6-3-16f70227547d@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 009424594c947..55a5055b138b9 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -602,13 +602,13 @@ spss_region_mem: spss@88a00000 {
 			no-map;
 		};
 
-		soccpdtb_mem: soccpdtb@892e0000 {
-			reg = <0x0 0x892e0000 0x0 0x20000>;
+		soccp_mem: soccp@88e00000 {
+			reg = <0x0 0x88e00000 0x0 0x400000>;
 			no-map;
 		};
 
-		soccp_mem: soccp@89300000 {
-			reg = <0x0 0x89300000 0x0 0x400000>;
+		soccpdtb_mem: soccpdtb@89200000 {
+			reg = <0x0 0x89200000 0x0 0x20000>;
 			no-map;
 		};
 
-- 
2.53.0



