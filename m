Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D28F343D77;
	Tue, 16 Dec 2025 11:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884886; cv=none; b=HrsXlLkNjD1kb69CLETSHSTq9tDwRMweh+WENjr/uQrIW6wlaN04rqgmwV0V4sDJ6yRyhvdg7ly5GMk+25Tbh1a33p7OMYSh5oKG3Rk7QGQ0ArMDN2F5bX8VHC0JmiNWa5EGgfiyfsMAwmJKrhhtXEFAnIgaytKriGvVDgmf4Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884886; c=relaxed/simple;
	bh=ZLysyEpGGiL94v1UgxY8U18rXPp20TTeJd/YP0jB8b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fsd+krZKKQQQkZdBZDfJAvhkjkzb2Naf/wSaaJu9AJNbW8Q6/Fo5x+qdTClSIbNpWoA+kStpv05P+O6PI+fkaXIFNOvUnTR0EoN3jQc4VDxAxr+OP56qIVz/vzIS00XRmLRwROHgmrJhDRonwK+OOWgB026cvulv0lM/FZlBUdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztqofUyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztqofUyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F25BC4CEF1;
	Tue, 16 Dec 2025 11:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884886;
	bh=ZLysyEpGGiL94v1UgxY8U18rXPp20TTeJd/YP0jB8b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ztqofUyM8alK1n2XUaRZXQnc9BQrM7dlc7Uc1417ZwPCbQMFMyAM1uUa/YXkB3T9E
	 SUt93K3gZ/4bXOS5bUdJL1NLd/XSDAkdwnxX7MooQpoMIFeEcgFS35/cPA2q3Ru+gV
	 m3SX4+eoSNQWBNt5VealSrkJqCaSeL/F/1AfCSQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathara Sasikumar <katharasasikumar007@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 329/354] docs: hwmon: fix link to g762 devicetree binding
Date: Tue, 16 Dec 2025 12:14:56 +0100
Message-ID: <20251216111332.829111773@linuxfoundation.org>
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

From: Kathara Sasikumar <katharasasikumar007@gmail.com>

[ Upstream commit 08bfcf4ff9d39228150a757803fc02dffce84ab0 ]

The devicetree binding for g762 was converted to YAML to match vendor
prefix conventions. Update the reference accordingly.

Signed-off-by: Kathara Sasikumar <katharasasikumar007@gmail.com>
Link: https://lore.kernel.org/r/20251205215835.783273-1-katharasasikumar007@gmail.com
Fixes: 3d8e25372417 ("dt-bindings: hwmon: g762: Convert to yaml schema")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/g762.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/hwmon/g762.rst b/Documentation/hwmon/g762.rst
index 0371b3365c48c..f224552a2d3cc 100644
--- a/Documentation/hwmon/g762.rst
+++ b/Documentation/hwmon/g762.rst
@@ -17,7 +17,7 @@ done via a userland daemon like fancontrol.
 Note that those entries do not provide ways to setup the specific
 hardware characteristics of the system (reference clock, pulses per
 fan revolution, ...); Those can be modified via devicetree bindings
-documented in Documentation/devicetree/bindings/hwmon/g762.txt or
+documented in Documentation/devicetree/bindings/hwmon/gmt,g762.yaml or
 using a specific platform_data structure in board initialization
 file (see include/linux/platform_data/g762.h).
 
-- 
2.51.0



