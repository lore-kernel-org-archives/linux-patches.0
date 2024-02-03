Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6190FF9F5;
	Sat,  3 Feb 2024 04:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933588; cv=none; b=QIWFt3c2W70+LOKKOJT4ctjPpv2mBHL9tMfBTxFXJSUwAgebBY2ZJtPICeaaEHYvANlC3XlgyLOZXUT4yj3WLkG+LaByC+UOjJL1drnGQ6ABfboDxaEhD2PAGm7R3GftkRnpDG2FxMnm4rYUvDJExWTlK87/jW8b09N8HZ+Bshg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933588; c=relaxed/simple;
	bh=feshkVubLYRW8q2+/HMSoKy/5q0zID4Btj6YWJVHgBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKlao4ZtV6/2hqGipJGwgSxtEAqvXTwzsbLVcC+EJI5DOoMhOKYdfAhBTZghpKD1D90y1BJojMOfFWwr2yINTTfH+nNou9LuJZ0BMOE9AFpVc2q0lcvOUyG+YBhIfzq+rxueqJhSAqfN844erYMxYU7rSqQOJTUOUu86dpDt7ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvjxgfsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvjxgfsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2EBC433F1;
	Sat,  3 Feb 2024 04:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933588;
	bh=feshkVubLYRW8q2+/HMSoKy/5q0zID4Btj6YWJVHgBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvjxgfsPvWcutz6z7hBwnElFzOcNDFVmFlcysXchKRpmyT07uAD1UPvEfIwnPuujH
	 SG4wss31ghwM1zVDOSgw07SZUkF0U27ULsfxxgF2LrHC9b2a1pKC39dJiYEBnmahMl
	 as5VYu8YiGg7ULixk/5GYl0pZ+h8nzqoPpO6TiSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunyan Zhang <chunyan.zhang@unisoc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/322] arm64: dts: sprd: Add clock reference for pll2 on UMS512
Date: Fri,  2 Feb 2024 20:04:08 -0800
Message-ID: <20240203035404.068179833@linuxfoundation.org>
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

[ Upstream commit 829e3e70fe72edc084fbfc4964669594ebe427ce ]

Fix below dtbs_check warning:

'clocks' is a dependency of 'clock-names'

Link: https://lore.kernel.org/r/20231221092824.1169453-2-chunyan.zhang@unisoc.com
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/sprd/ums512.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/sprd/ums512.dtsi b/arch/arm64/boot/dts/sprd/ums512.dtsi
index 97ac550af2f1..91c22667d40f 100644
--- a/arch/arm64/boot/dts/sprd/ums512.dtsi
+++ b/arch/arm64/boot/dts/sprd/ums512.dtsi
@@ -291,6 +291,7 @@
 			pll2: clock-controller@0 {
 				compatible = "sprd,ums512-gc-pll";
 				reg = <0x0 0x100>;
+				clocks = <&ext_26m>;
 				clock-names = "ext-26m";
 				#clock-cells = <1>;
 			};
-- 
2.43.0



