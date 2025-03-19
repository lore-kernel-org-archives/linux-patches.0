Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6E41B2194;
	Wed, 19 Mar 2025 14:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395069; cv=none; b=lU+F5sj+66X0/eQmc3yh0QFaLkVYu7/U2QKUdid60p1Q3WLclDSxdhUGwbN+pG+ZiHTQjbITMoIX0uHKfJ3ZlCx8YaZfxY0jYkhu6BZ8PGzc/B4f98ism+nDnzXwpwSU8v6FzrN4nqQEHPiBJKc3PtqmVXr2A0LQpRjNDoDRhQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395069; c=relaxed/simple;
	bh=la5yIppOsrKin9x9/QgAz4T9SrWyoP63x80yvsvN+9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=az0rQl/VIg7r+lqbHDz4du0/ri0CHSePlvc3Svjw3W6QPWXHrgk65VPUNiK0aTdnPkbYSi7d783OAc+c8yvRdOdTNU7U5qT5WNmKALgLyBINDJkSaRHCMikuowsGqRhmxycXsdB0PoJGF9qCtr2reY7Atcyno5q0b87HPc3+H+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhdmCqkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhdmCqkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BC2C4CEE4;
	Wed, 19 Mar 2025 14:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395068;
	bh=la5yIppOsrKin9x9/QgAz4T9SrWyoP63x80yvsvN+9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhdmCqkQzHCuY1JLuZ//mvoZOeBZRNoln8M14kfgbqSTGWvd+wNVeMrv7dUyf371Y
	 KiBCjXy4XCa6VOHuA4t2DbdyDgUIqAPs0bRv2sXvAioKar2+UrA4NNVLWFthtKlECC
	 Sw4XZNc118V9jxRTzGpZCaHPBJNH/DRUBdcPOoEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/231] ASoC: Intel: soc-acpi-intel-mtl-match: declare adr as ull
Date: Wed, 19 Mar 2025 07:29:58 -0700
Message-ID: <20250319143029.431515205@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 20efccc53abf99fa52ea30a43dec758f6b6b9940 ]

The adr is u64.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20250204033134.92332-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-mtl-match.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-mtl-match.c b/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
index fd02c864e25ef..a3f7917656371 100644
--- a/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
@@ -297,7 +297,7 @@ static const struct snd_soc_acpi_adr_device rt1316_3_single_adr[] = {
 
 static const struct snd_soc_acpi_adr_device rt1318_1_single_adr[] = {
 	{
-		.adr = 0x000130025D131801,
+		.adr = 0x000130025D131801ull,
 		.num_endpoints = 1,
 		.endpoints = &single_endpoint,
 		.name_prefix = "rt1318-1"
-- 
2.39.5



