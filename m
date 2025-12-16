Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DB7342506;
	Tue, 16 Dec 2025 11:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885456; cv=none; b=KKwf6N6P58lGbwxKjVk9L+LJxZvPsUxj5gn1+i4g64pNIcEZKLJ2H44stmahwt2D685MVptazdcQcR4gxWY+DhnLwQqcpubfUCxZqxOzHVJzkpzD55LaWt2HwegWCjzyQ45xLu0oN1m98inKQ/y5MJniBwHT+/mptw5yW5Z0ecU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885456; c=relaxed/simple;
	bh=xndQ/YOX0plBQvNZX18nyUP/zV4L5abIeIHY55v1ERI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/gsi+V6notCiCUt0YwLMKXwlKmq/uJksfqwDXXhOv3uPuV6Glzl+RmSrJy5RQowOc42lATiLsNbOejBVxAxVNAwcQoBN8BeUYjXePCb77yHrc/Zz4xlr7aUlpGbCKrYkXIMwB7qlSxnIMr2SRhX1vBOD93S5ylJ1hsLnUa49l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2egLPxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2egLPxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97ACC4CEF1;
	Tue, 16 Dec 2025 11:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885456;
	bh=xndQ/YOX0plBQvNZX18nyUP/zV4L5abIeIHY55v1ERI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2egLPxcM55eoHZhuJUnFMcSs910Ni09R5mSMKJi1YmTp4vVMm6zhiITi+Q3CdkcO
	 j4oDQyDkRnVnMAEU5jGB4xaDz6AbzwCcLSLq0TS6VkVSg47R2ZrSYJL1gCSGmE5DtJ
	 e6bBo03bUvsNnQUs8HnSgq3sA24G2ncByYUMvU64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 145/507] arm64: dts: renesas: sparrow-hawk: Fix full-size DP connector node name and labels
Date: Tue, 16 Dec 2025 12:09:46 +0100
Message-ID: <20251216111350.780989260@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 9d22a34a016313137b9e534a918f1f9aa790aa69 ]

The DisplayPort connector on Retronix R-Car V4H Sparrow Hawk board
is a full-size DisplayPort connector. Fix the copy-paste error and
update the DT node name and labels accordingly. No functional change.

Fixes: a719915e76f2 ("arm64: dts: renesas: r8a779g3: Add Retronix R-Car V4H Sparrow Hawk board support")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251027184604.34550-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts b/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
index 2c1ab75e4d910..e5af9c056ac97 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
+++ b/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
@@ -118,13 +118,13 @@ memory@600000000 {
 	};
 
 	/* Page 27 / DSI to Display */
-	mini-dp-con {
+	dp-con {
 		compatible = "dp-connector";
 		label = "CN6";
 		type = "full-size";
 
 		port {
-			mini_dp_con_in: endpoint {
+			dp_con_in: endpoint {
 				remote-endpoint = <&sn65dsi86_out>;
 			};
 		};
@@ -371,7 +371,7 @@ sn65dsi86_in: endpoint {
 					port@1 {
 						reg = <1>;
 						sn65dsi86_out: endpoint {
-							remote-endpoint = <&mini_dp_con_in>;
+							remote-endpoint = <&dp_con_in>;
 						};
 					};
 				};
-- 
2.51.0



