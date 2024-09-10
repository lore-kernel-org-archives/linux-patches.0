Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC0118B498;
	Tue, 10 Sep 2024 10:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962541; cv=none; b=C2RqHYcyEGZsW5dV8T8wHz2JjuVxjVJz5Sl1XmLVMkpvf+KTjtl5qJLbol1fKPQEwUqNm1SpRO4Y6/p+554QmxI9fhCSUqtRXg2aVUeo0yDgOgosve3TxN6lB3RpxNDJqIO7t1KExN/GVSWXIYfPOXxKAvzj9qdes1JZsaogUMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962541; c=relaxed/simple;
	bh=XqQ9Nf0oT6eYRxyBEFXF+QXggDE4OVFPJKjoHnwzhIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PLLwYtBkPBm/5emsNpHOG5R5FG6GBWYhd2AQ9pXNC72+cOGcDxbtyu9pO5q6dA4y15RvkmnqmmJGSU0ISDYb8CWjVlFBYvIdS24xaN4j7mfRV5zclV0iwBsxvocJyEOkbJlPiERm4mussZ4b9RwhowOftUa7QYBxQ4mKk3SRaQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDVYKjRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDVYKjRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F03C4CECD;
	Tue, 10 Sep 2024 10:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962541;
	bh=XqQ9Nf0oT6eYRxyBEFXF+QXggDE4OVFPJKjoHnwzhIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDVYKjRTBw36FZzrBTTR7Ru74wn9w/0zFfC0+PAJostfRg98BWUlNQ44fTU5k6iXP
	 5V25Vou8Eiwh+wSAgUrJBq8BDrWVexFNGVDUvP4iiY5/A4qHhYuo2BH3UjS/ceLDla
	 1rI8rZCjtLpUkScpje+WgWhpphn2PlcOoE0TIN3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/121] ASoC: topology: Properly initialize soc_enum values
Date: Tue, 10 Sep 2024 11:32:24 +0200
Message-ID: <20240910092549.151839675@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 870b00229353..df8a1cd09193 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -993,6 +993,8 @@ static int soc_tplg_denum_create_values(struct soc_enum *se,
 		se->dobj.control.dvalues[i] = le32_to_cpu(ec->values[i]);
 	}
 
+	se->items = le32_to_cpu(ec->items);
+	se->values = (const unsigned int *)se->dobj.control.dvalues;
 	return 0;
 }
 
-- 
2.43.0



