Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84CB7E595;
	Wed, 21 Feb 2024 14:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524100; cv=none; b=BvTk8iNx/pI9CkHWWJHLGuGQIbHwwyqecY68issGUxFOSAu10h24MomqTUh7XKQSPa3pBJvLRRy62galJnDxZgaCNF/MiSGdM+pi//gr+ZBlEAGCsE99jt/x4rvDPhonLXtsrb0EguANxkXxuyzceRq38nmDh+y+zMfesD7KYKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524100; c=relaxed/simple;
	bh=+4UsmNIrZO9UjhwbY2LcYZifShIxK3ykd5Pbm2/5Qpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrD7348iQ3aLE4rOD5sM2TtXMqyCKTwl2k1OvfiJ3ub/nJkhNrqXnA+cdGNlUtx9gwWThAPY0i715XSlR/2vpvqdJuYfSHf5h8lRFOVReAUjfn0uPMbGKlQM6iC4TJSidNJHZj1I9U32ymiAm+HEF7FsXn0UIKJKqXcLK935MZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PH25fgSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PH25fgSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC17C433F1;
	Wed, 21 Feb 2024 14:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524100;
	bh=+4UsmNIrZO9UjhwbY2LcYZifShIxK3ykd5Pbm2/5Qpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PH25fgSRV+/qoTQy+qCT7I4HJadfMWIooDDhMKMXJJP0tuQ5+sGwKvgu/eo7x19bu
	 gmp5HJOLhRqQt6HiMgdkQZ6Zs7d1B81pg+0uL4DW9rGdmTKIbryxyxzU9x8rmbjwmF
	 UT7ab7BWoubIiMgfDhK0a8YvJ+DdU59GUufx6XLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/379] ARM: dts: imx7d: Fix coresight funnel ports
Date: Wed, 21 Feb 2024 14:05:23 +0100
Message-ID: <20240221125959.184937577@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 0d4ac04fa7c3f6dc263dba6f575a2ec7a2d4eca8 ]

imx7d uses two ports for 'in-ports', so the syntax port@<num> has to
be used. imx7d has both port and port@1 nodes present, raising these
error:
funnel@30041000: in-ports: More than one condition true in oneOf schema
funnel@30041000: Unevaluated properties are not allowed
('in-ports' was unexpected)

Fix this by also using port@0 for imx7s as well.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7d.dtsi | 3 ---
 arch/arm/boot/dts/imx7s.dtsi | 6 +++++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx7d.dtsi b/arch/arm/boot/dts/imx7d.dtsi
index b0bcfa9094a3..8ad3e60fd7d1 100644
--- a/arch/arm/boot/dts/imx7d.dtsi
+++ b/arch/arm/boot/dts/imx7d.dtsi
@@ -209,9 +209,6 @@
 };
 
 &ca_funnel_in_ports {
-	#address-cells = <1>;
-	#size-cells = <0>;
-
 	port@1 {
 		reg = <1>;
 		ca_funnel_in_port1: endpoint {
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 03bde2fb9bb1..622c60bd8b75 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -173,7 +173,11 @@
 			clock-names = "apb_pclk";
 
 			ca_funnel_in_ports: in-ports {
-				port {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				port@0 {
+					reg = <0>;
 					ca_funnel_in_port0: endpoint {
 						remote-endpoint = <&etm0_out_port>;
 					};
-- 
2.43.0



