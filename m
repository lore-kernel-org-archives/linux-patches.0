Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456071519AA;
	Wed,  5 Feb 2025 13:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763750; cv=none; b=Bx49zdngNnmxc4om3AuShUpMhQl6XnlDmuc9ePv97MExIrbDsMSjiOV1ynF9dYtUtO+MAHtciB2h27ZAphkzeeE8lTWM0p/9a1zGKyrM1zTBbXsHANXbH8/jrXKAMVESyDmecz0/RSrnWx8oOw+O5TblilwUOGNxEPApAbQrYcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763750; c=relaxed/simple;
	bh=enCga8mZFFZurNEXXl2ZOALkF19pcwd8kdGA1v7U6Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g62a0T7930xO7RDCYJByhqW9gpQDNfJX/RWAz1tlynPkz8LDv4xytfPc+Fo96UnrNyJ8/oku6GzYsbl9ocIPGRn1Q+7A9el4DMDCHDIDe/JMGejD6g221h4P+WYmBU6BmhmdLJbLWyTLVKS9ucjznbG88h9QmE63DSzExo5kzg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0uWfvW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0uWfvW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54D2C4CED1;
	Wed,  5 Feb 2025 13:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763750;
	bh=enCga8mZFFZurNEXXl2ZOALkF19pcwd8kdGA1v7U6Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0uWfvW9cul5WS6vxLW9t0wiJLHeXzgeKLRLDhj6HgYz6UOKnoVxv8hyMiNiLvy5w
	 FxO6tdoctULS8fPKiWd/MENdZqK9yvaR3QsFDfZQybHNFtZdyc//cLM7RNZ79qSBve
	 De2L1oGB/p1i1kQ9PwvX3CDqHrF9Yzoq5DFdV2/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/393] mfd: syscon: Remove extern from function prototypes
Date: Wed,  5 Feb 2025 14:40:21 +0100
Message-ID: <20250205134424.195522842@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



