Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1888717B50B;
	Sun,  1 Sep 2024 16:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208482; cv=none; b=fkkAze/C1AttLDHuvgyd0G03E3dJN9yapESQ4rqUhv8gqQHGmJNCIYlFlPxWV77kv0WoOQBC/c43GrzbGjDMFwmXCvceOKf+N1ZSz0WrblBayb9Sn74atNtIxehLTi37TIxn5yemMyimCb6UrCet1bG0aNOLea2FCIBrf5tAA8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208482; c=relaxed/simple;
	bh=+z0BvOEn8XoMHDqkI975EHC4ZBfrrH+ZRmPujKDjmDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7JeQLkG4hkI6qExKMvLKoVpAsjjLjQy+uOAG1tp7HVrBDuS8QDqmFYOpZIS+NsN2hJBPcd9IKbod+BNDtvZGFQZftsQd4UCUIQ27qEUGKnsuCWixVFoqjbj2OAP5YmMnfMyVG1l0OneEE5M69HMeuM1aYryRHvC5D12DBQqas8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsKvaXhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsKvaXhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33658C4CEC3;
	Sun,  1 Sep 2024 16:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208481;
	bh=+z0BvOEn8XoMHDqkI975EHC4ZBfrrH+ZRmPujKDjmDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GsKvaXhqb1k4px+vL2zpvlM+l32QTmG8ywO8lUy8QZu+cGzStMx5J7nJ5alewMvG5
	 PHxFvCwf/QgH4Ogn4gy2XpqW8lKoOzooFmetVIC3QNsVP+D2e+/WhiBjOkYfZpWQr/
	 nzFqg/C4vBDN6dYZfPdMbKN+47AFyPl2D8ggVjPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 054/149] ASoC: amd: acp: fix module autoloading
Date: Sun,  1 Sep 2024 18:16:05 +0200
Message-ID: <20240901160819.501088680@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Liu <liuyuntao12@huawei.com>

[ Upstream commit 164199615ae230ace4519141285f06766d6d8036 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from platform_device_id table.

Fixes: 9d8a7be88b336 ("ASoC: amd: acp: Add legacy sound card support for Chrome audio")
Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
Link: https://patch.msgid.link/20240815084923.756476-1-liuyuntao12@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-legacy-mach.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/amd/acp/acp-legacy-mach.c b/sound/soc/amd/acp/acp-legacy-mach.c
index 47c3b5f167f59..0d529e32e552b 100644
--- a/sound/soc/amd/acp/acp-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-legacy-mach.c
@@ -227,6 +227,8 @@ static const struct platform_device_id board_ids[] = {
 	},
 	{ }
 };
+MODULE_DEVICE_TABLE(platform, board_ids);
+
 static struct platform_driver acp_asoc_audio = {
 	.driver = {
 		.pm = &snd_soc_pm_ops,
-- 
2.43.0



