Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19751DA4C;
	Tue, 10 Sep 2024 10:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963667; cv=none; b=MHW0N04tjufoLASe9QOc89l4Gl59aBg4eMza+if8T793WHiZzqV8d8s+yDO3X8Plogem2JFHEeQxBCJwvNNtWaJwqdN//RRYgqlxOqnYCco5khQY8mcAuR+u/a8KTkaUTrIyROEigHu/2r/slHrkgzoT20vZX0CLxgfwTPORcBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963667; c=relaxed/simple;
	bh=xiTh985ezUFuMp7vWkt3J36snwULRLNtyowAbwXmWBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qCicugpfWCmNYNUYdMzgd2h6h22TC3qWQQChdMB78WSUMJEITLeAWGq0kTPOo6MatatRfwdWhu7vEvVTZhFy7/NqzuiET5YkZ0YjrwVV5xh9eJM4thB0r0loFOGADS4ZbtzkhQyf3jw9EDMWFGQXEIiiZ5OcIKHmB4GBJlBify4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DReyJ7yO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DReyJ7yO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C13C4CEC3;
	Tue, 10 Sep 2024 10:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963667;
	bh=xiTh985ezUFuMp7vWkt3J36snwULRLNtyowAbwXmWBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DReyJ7yOyysP30W9uWCyPYsfwQxb10lztI076GZR77zhlqjktLLCaxfwDuOOQRzon
	 HDoaiTSYeIYTr+akBebBDmU+oIB99FnciuiYqy0dylzX/qXQqkA3BjWS82oQmVvuor
	 X+K31KV2IcpvbG2/9g6chqa/F7feoD1QRRcu85pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/214] ASoC: topology: Properly initialize soc_enum values
Date: Tue, 10 Sep 2024 11:32:37 +0200
Message-ID: <20240910092604.283622859@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 8ec2a2643544ce352f012ad3d248163199d05dfc ]

soc_tplg_denum_create_values() should properly set its values field.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://patch.msgid.link/20240627101850.2191513-4-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 55b69e3c6718..765024564e2b 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -913,6 +913,8 @@ static int soc_tplg_denum_create_values(struct soc_tplg *tplg, struct soc_enum *
 		se->dobj.control.dvalues[i] = le32_to_cpu(ec->values[i]);
 	}
 
+	se->items = le32_to_cpu(ec->items);
+	se->values = (const unsigned int *)se->dobj.control.dvalues;
 	return 0;
 }
 
-- 
2.43.0



