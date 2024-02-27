Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFD713AA55;
	Tue, 27 Feb 2024 13:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042182; cv=none; b=jXIUyoLFK+4av/kd8yfhYtE+ZiGU2AziKKd3qr7MExI3vP0Mz7v+WyncVvoEreGblQ+OOFsNioBVMz3LVFUKOY+ZrVQCj6SVcJXlPF6R0C1kxj9WliiXqM4fNx1mXHCRU/fzcmyCsKmX+30X+fGyghmpiu7w8RO7yemvmn8dUPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042182; c=relaxed/simple;
	bh=zj8JRLqeV6P5gI5bCGMmtJu9X1Lph9IWBrJmS61e/Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPwNxuj681tuD/j0wV6lC1/kLY1NQjJkv9D4LuUwKBeulhscJVVXzk4bMWLUM8dkECI07JReYsrEx5FNjLAbRdJTFPHuUAoOpuNO9O+5eHk6bcKFcBi+OX5o1NNMohyk6SE0T8UdJV0VaCfmhJslDqg03oLvGBN98gcM1yA3mX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXSMM/pd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXSMM/pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB81C43390;
	Tue, 27 Feb 2024 13:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042182;
	bh=zj8JRLqeV6P5gI5bCGMmtJu9X1Lph9IWBrJmS61e/Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXSMM/pd09mFYMxnVJAOBcwhcf4orfCXNPead+QASkx/EKsETkq4/s5UVutIMOz4i
	 11Gzw1lmNUCkc6IGfJdNkdHOVgZ601nhJ+SAj7rXJpIjIfvMwV64BMiN458JrKMaOW
	 oHtfqHS3ZspHIy+U1TCb0YlLPLouyH+LfZzWPOcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Sohaib Nadeem <sohaib.nadeem@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.6 208/299] Revert "drm/amd/display: increased min_dcfclk_mhz and min_fclk_mhz"
Date: Tue, 27 Feb 2024 14:25:19 +0100
Message-ID: <20240227131632.489952804@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Sohaib Nadeem <sohaib.nadeem@amd.com>

commit a538dabf772c169641e151834e161e241802ab33 upstream.

[why]:
This reverts commit 2ff33c759a4247c84ec0b7815f1f223e155ba82a.

The commit caused corruption when running some applications in fullscreen

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Sohaib Nadeem <sohaib.nadeem@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -2452,7 +2452,7 @@ static int build_synthetic_soc_states(bo
 	struct _vcs_dpi_voltage_scaling_st entry = {0};
 	struct clk_limit_table_entry max_clk_data = {0};
 
-	unsigned int min_dcfclk_mhz = 399, min_fclk_mhz = 599;
+	unsigned int min_dcfclk_mhz = 199, min_fclk_mhz = 299;
 
 	static const unsigned int num_dcfclk_stas = 5;
 	unsigned int dcfclk_sta_targets[DC__VOLTAGE_STATES] = {199, 615, 906, 1324, 1564};


