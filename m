Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D091F238E;
	Tue, 21 Jan 2025 17:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482394; cv=none; b=NO144yna4j0tXPm0kHqCB5H9P8yVjzFY1FUcsHCGI3Howxsi/woMyMo/4UrF91utHmZjencrE0kysLJN3J046XHGXRILfa73W81/DOumOTkSKRqhF47DQm3WpYAShKWqDlOSFum2+KmwMhdJvBhmf7kpYTzKT30smn/yCRkyC2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482394; c=relaxed/simple;
	bh=FEdcJLdOJ/xloKXYQnum3mihLhYuKofuxWT8LJB9A0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dw7wNLCnEIVr3/KEtXT59S8L6E028rXCJp1zwecA5NYbqD67SrHr/qqLJ/C+zCkHhokLpuJG6yoFMSFxL3Fe6jx1MAGhg6xulV4FIw2klJxqGd9T2a0DJymwVG3I3N7YEU9roG0LOV6vBOEZH2VZAR0tSA9A8ArNY+IR9ewI5jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFNxWpZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFNxWpZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C832C4CEDF;
	Tue, 21 Jan 2025 17:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482393;
	bh=FEdcJLdOJ/xloKXYQnum3mihLhYuKofuxWT8LJB9A0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFNxWpZ/7bAkMjy8M0MTHtHmPA0OFpGKBkjUOqA45F9nxVYaNtlYJiZB/rDH3SShE
	 utUOcO5tRjm4uLq5wzI+yHwPyDAPKDUI/TJ1IYq01Hwkepf9yj2+wy2wi4X7IzfnTa
	 +gtG0uip36yK8XV7bGk3zPxkNo+W5hV4mCpBHTuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/122] platform/x86/intel: power-domains: Add Clearwater Forest support
Date: Tue, 21 Jan 2025 18:51:48 +0100
Message-ID: <20250121174535.307774247@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit bee9a0838fd223823e5a6d85c055ab1691dc738e ]

Add Clearwater Forest support (INTEL_ATOM_DARKMONT_X) to tpmi_cpu_ids
to support domaid id mappings.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20250103155255.1488139-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/tpmi_power_domains.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel/tpmi_power_domains.c b/drivers/platform/x86/intel/tpmi_power_domains.c
index 0609a8320f7ec..12fb0943b5dc3 100644
--- a/drivers/platform/x86/intel/tpmi_power_domains.c
+++ b/drivers/platform/x86/intel/tpmi_power_domains.c
@@ -81,6 +81,7 @@ static const struct x86_cpu_id tpmi_cpu_ids[] = {
 	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X,	NULL),
 	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X,	NULL),
 	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_DARKMONT_X,	NULL),
 	X86_MATCH_VFM(INTEL_GRANITERAPIDS_D,	NULL),
 	X86_MATCH_VFM(INTEL_PANTHERCOVE_X,	NULL),
 	{}
-- 
2.39.5



