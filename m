Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390761B6CFA;
	Wed, 19 Feb 2025 09:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956246; cv=none; b=He9J4L8QCshM4Z4whbSYVK4/m+JnouCtUsZCWBXzLg7EA7lGHU/JUa5I5oJa1dtvIjIovPau5GCSVSRXysYh3Yib3zudQT5A0CbegpHBxUaz6VIV2PiKkcznuwp0doIioNH65hl95gRP+6EzUDi7YRLTMI0cRy/6H7ttU1zrgtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956246; c=relaxed/simple;
	bh=I4L2RDEHQhvcs5NxForC15/SdPmUIs19WP93zxHG0BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJx9pZohaHi9jEUPh7edJIY1hwKlJv2aKZGYoSE1JkKNkfQ5cZ3Z1z3XPtPIUK4MKphyuy4NibmaxRD9MNrOpA3OtA7I+A9srJvk9sHZrgdTpQBQC0VsJZrZAQ1fCizhNQzeQ3oxSW1OfO27zKN1QiGYQ1XyEXtVg6/CElyeCP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YgS2AE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YgS2AE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A31C4CED1;
	Wed, 19 Feb 2025 09:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956246;
	bh=I4L2RDEHQhvcs5NxForC15/SdPmUIs19WP93zxHG0BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2YgS2AE2k+RyM007pKFj3R1fVj+fRZTNTy173DZPUnaEH/oCIjOU2r6W94uIDowli
	 fb1OMJtr1P7wu3JZJsHKqKO9bK6osGl+GeJFmosCNo8CRBGPtBxoMVOApry6Ryt+ae
	 ySsdA6TIKJGm7vAF/iCSiUahbkEPMbf6qW4M4X8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/578] mfd: syscon: Remove extern from function prototypes
Date: Wed, 19 Feb 2025 09:21:17 +0100
Message-ID: <20250219082655.758933165@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit 0db017f8edd9b9af818bc1d68ba578df1b4c4628 ]

The kernel coding style does not require 'extern' in function prototypes
in .h files, so remove them as they are not needed.

To avoid checkpatch warnings such as
CHECK: Lines should not end with a '('
+struct regmap *syscon_regmap_lookup_by_phandle(

The indentation is also updated. No functional changes in this patch.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20240220115012.471689-3-peter.griffin@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 805f7aaf7fee ("mfd: syscon: Fix race in device_node_get_regmap()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mfd/syscon.h | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
index fecc2fa2a3647..c315903f6dab3 100644
--- a/include/linux/mfd/syscon.h
+++ b/include/linux/mfd/syscon.h
@@ -17,20 +17,17 @@
 struct device_node;
 
 #ifdef CONFIG_MFD_SYSCON
-extern struct regmap *device_node_to_regmap(struct device_node *np);
-extern struct regmap *syscon_node_to_regmap(struct device_node *np);
-extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
-extern struct regmap *syscon_regmap_lookup_by_phandle(
-					struct device_node *np,
-					const char *property);
-extern struct regmap *syscon_regmap_lookup_by_phandle_args(
-					struct device_node *np,
-					const char *property,
-					int arg_count,
-					unsigned int *out_args);
-extern struct regmap *syscon_regmap_lookup_by_phandle_optional(
-					struct device_node *np,
-					const char *property);
+struct regmap *device_node_to_regmap(struct device_node *np);
+struct regmap *syscon_node_to_regmap(struct device_node *np);
+struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
+struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
+					       const char *property);
+struct regmap *syscon_regmap_lookup_by_phandle_args(struct device_node *np,
+						    const char *property,
+						    int arg_count,
+						    unsigned int *out_args);
+struct regmap *syscon_regmap_lookup_by_phandle_optional(struct device_node *np,
+							const char *property);
 #else
 static inline struct regmap *device_node_to_regmap(struct device_node *np)
 {
-- 
2.39.5



