Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AF03307B;
	Sat,  3 Feb 2024 04:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933589; cv=none; b=jQdPoqD42P6ueV8rlRnXp2RGFhZCbagcm24QaCsRJlQtCmKJOR0PH94N7gCWYmw28L3SXfp8Beoh+6GaFFlWn2MiXwWTarz98pyzs6qDlj7DKruz9Av6DqEzWH7SX4ZfK4MBXCt8J+PdlQOnN+jOmyx5dy8gb7DD4/SpDuy5Kmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933589; c=relaxed/simple;
	bh=SDqJAN0zCobHD5SOl+fqFHWFK5pKQAgqAeSdOw4oJpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pG/J6PXFYI8MWtr76eG3GigiLsNUAQZfsx6oKRs0xG4QDz5rqBg7K485nuTjgfeQqgmfoSjM+P/2wvZxEbwGs7LMHwCT+t4mfO8bwdISqEFRtpe2YdiIaNyEbyHGiqcIPz4h/TlnPsE1NmdRcfhd6aTaO6Z8kZe3B5jrfgaF5yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLj307y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLj307y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FE2C433F1;
	Sat,  3 Feb 2024 04:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933589;
	bh=SDqJAN0zCobHD5SOl+fqFHWFK5pKQAgqAeSdOw4oJpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLj307y7Ctal2Avv3nP+dXcWUIfmukB3ixtp0Hd2sz1namGRuyiJtQZnhJebpXkaZ
	 5rjRq0kp4HRvTnAv203GqH0WeGLuKyQes5aKBpjzGBar6H0px8YMmdwpUuAmdDD2zy
	 XZJ0SM8UDk+lITWlc4mkKv2TeQP6WxiHh/Z5inDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunyan Zhang <chunyan.zhang@unisoc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/322] arm64: dts: sprd: Change UMS512 idle-state nodename to match bindings
Date: Fri,  2 Feb 2024 20:04:09 -0800
Message-ID: <20240203035404.106011007@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit 1cff7243334f851b7dddf450abdaa6223a7a28e3 ]

Fix below dtbs_check warning:

idle-states: 'core-pd' does not match any of the regexes: '^(cpu|cluster)-', 'pinctrl-[0-9]+'

Link: https://lore.kernel.org/r/20231221092824.1169453-3-chunyan.zhang@unisoc.com
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/sprd/ums512.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/sprd/ums512.dtsi b/arch/arm64/boot/dts/sprd/ums512.dtsi
index 91c22667d40f..cc4459551e05 100644
--- a/arch/arm64/boot/dts/sprd/ums512.dtsi
+++ b/arch/arm64/boot/dts/sprd/ums512.dtsi
@@ -113,7 +113,7 @@
 
 	idle-states {
 		entry-method = "psci";
-		CORE_PD: core-pd {
+		CORE_PD: cpu-pd {
 			compatible = "arm,idle-state";
 			entry-latency-us = <4000>;
 			exit-latency-us = <4000>;
-- 
2.43.0



