Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26B14EF129;
	Thu, 17 Sep 2026 17:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666619; cv=none; b=kNhv32ayUqkm/wLDrqWi5YX9SSW8DfOaTfWqpoBemiCJN8feghhCbPjZN3Z1sZkeFp4dSUCIxdSfkbJy7DMHpLPtRabq/UzdFFLttqm52ch7syK1jM7WoyUcxAh+qDe57FPyBmBiCctO5emCAK0ymvUZdrsDqrVwTkSJZy5hlws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666619; c=relaxed/simple;
	bh=dXc1jDzdsU7ptgn7bmJGSDIpGVP2hth5xt/srrWAcRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqeUYk8y6YnwawkmWrm9FZDJwtO2EL7w6z47ta18knPLdK51q1f5/MOBe2yasqB0Aw4HZ5VoOf6R0F/ZqMZ6BgM7nrbm1zjDJGTBPWeK6kiuXAmT1mCf+ufzBL76HRKLCAk5yEnOMoK2ozMe4EK5WhbCpIv15tPpESe1KGT8xHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUWlZSfG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUWlZSfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19FB1F00893;
	Thu, 17 Sep 2026 17:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666616;
	bh=pPjMHk79g4CfOzUQlDjBvJ0m2JLArKjd+Y+RpgPwyBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UUWlZSfGcwbQhGuTzSGt8PQoyHUM55S0SC/muxJ/sbaQpD+emkfi48nWaSoC3FZ7H
	 UEwG2qWEhHK7b+/ouVblN16jdob/6PB517Cm/oe6lZs/VH5G0S6F5iguVLajpSJzUn
	 Da+jZaeXblC5Utzu8CtDOSB4SEg2I+O2f+AMGjOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1096/1250] xfs: report healthy filesystem events in scrub stats
Date: Thu, 17 Sep 2026 16:14:51 +0100
Message-ID: <20260917151621.880706777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 0ae61c331ec552ad0c278c5c48a1c4ccb90b4bab upstream.

LOLLM also notices that I forgot to expose the "clean bill of health"
scrub stats.  Fix that.

Cc: stable@vger.kernel.org # v6.9
Fixes: a1f3e0cca41036 ("xfs: update health status if we get a clean bill of health")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/stats.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -84,6 +84,7 @@ static const char *name_map[XFS_SCRUB_TY
 	[XFS_SCRUB_TYPE_RGSUPER]	= "rgsuper",
 	[XFS_SCRUB_TYPE_RTRMAPBT]	= "rtrmapbt",
 	[XFS_SCRUB_TYPE_RTREFCBT]	= "rtrefcountbt",
+	[XFS_SCRUB_TYPE_HEALTHY]	= "healthy",
 };
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */


