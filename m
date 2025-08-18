Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A54D25F79A;
	Mon, 18 Aug 2025 13:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522735; cv=none; b=rmDlOCqMZkY+lAzK0J9QW2dpXWuMWz890uOP734n7VGFsxDgSPwSdZLwpr/TE4KFXM1BUYZBWllOUuD8P4QWyrH9tRPo5wvTEu+wZU4J3EPcxzOn0RX4zjn6LAjcn5za2w6f1UhXPEGlxHwVluCYBRqkJotIRonpYG4Tup7O53Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522735; c=relaxed/simple;
	bh=b/YD3S1rn9wx/Vy6Ov80cOd/4WS9xvq8n9K8XxQhb9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3gd70jr8iCh/jv9IZ7urJV/kKedxBUzacnzvVkjhpLo2YnXzWX3PrPSLEb0MI9jUUbSXIJY35AXauYWM9Yr9eX156wljEhmz7oaI/pc1KZZBB/+oTowzsR/oUYBMV1itI/trzYFKV2ZLpdlvCbbB6NLg1MN1Isbw731U8aXkRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQgb7mFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQgb7mFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3271C4CEEB;
	Mon, 18 Aug 2025 13:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522735;
	bh=b/YD3S1rn9wx/Vy6Ov80cOd/4WS9xvq8n9K8XxQhb9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQgb7mFem2gjPSM5vsP+NsRhz/J8igec8qXuT5VJKNRSQjwgM3Y9dMA9jHDftteXU
	 5FBn9JCf4qrrpsDiqveN1ezrRbY2gDUZdFO2cHeSu9Eo/+BBKh4oqSi5NtsDoooiPT
	 jsI6YHy01UvbubLKTN4DFfR/39twC5HLy04W95gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 406/444] xfs: fix scrub trace with null pointer in quotacheck
Date: Mon, 18 Aug 2025 14:47:12 +0200
Message-ID: <20250818124504.153417879@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Albershteyn <aalbersh@redhat.com>

commit 5d94b19f066480addfcdcb5efde66152ad5a7c0e upstream.

The quotacheck doesn't initialize sc->ip.

Cc: stable@vger.kernel.org # v6.8
Fixes: 21d7500929c8a0 ("xfs: improve dquot iteration for scrub")
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -467,7 +467,7 @@ DECLARE_EVENT_CLASS(xchk_dqiter_class,
 		__field(xfs_exntst_t, state)
 	),
 	TP_fast_assign(
-		__entry->dev = cursor->sc->ip->i_mount->m_super->s_dev;
+		__entry->dev = cursor->sc->mp->m_super->s_dev;
 		__entry->dqtype = cursor->dqtype;
 		__entry->ino = cursor->quota_ip->i_ino;
 		__entry->cur_id = cursor->id;


