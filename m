Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0634F3910;
	Thu, 17 Sep 2026 15:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660613; cv=none; b=VUwhVcGHCyxRY7Ia8WUX9EdB25Q/DCMpfeqIRsy+NsNaIHDBi0rBDZuefGuyUBjw5uEeuGB4GhoJqBrGSDmiAEXgelqQgpP+fRwYdQZ2376oNKNKWsl5ycpC6UgJO6MaVz6rHrzSQK+JrYps8Qy4A+RryJdK+GO76RJkSWm9cXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660613; c=relaxed/simple;
	bh=WseZd6LOzVetxjnokncuwt8To4aBIPt+U6ou4IQ9DgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKO8KU/3hYZtZM7hNUHIjchQnxVAra2/FtgEfraK66fodSXm0FWTmk1P1juP7AkzIMa3Mxf3MQOUH6j8TeoHtNVMwr8JHH9b0B5cTsFw5+WiHkEvXf2DOru6XTfFe/+JbY4wLho7l0568s79Zy5Vp4CpnkXxZtx7l6v9y0/MreY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUoJ+zUL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUoJ+zUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A5B1F000FF;
	Thu, 17 Sep 2026 15:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660611;
	bh=Ioh2rmMAocdIwovwQjHHJY0BinSNl894NfRKSgMnLbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MUoJ+zULi8PffKH3dVppXPYXR5jdsvlYwek1Hwa1oR2AYy44XXfvWkNlUxmwPGF1w
	 8OLx2hTrKckYYAvSHZems1ECH4My6Oy66TKmLx0PW9CQyBs17CYRYbqHpwa8A1QL4X
	 kTqJI3p4rMlPVRmvLYV9fHQyF4mG69jYmBJxXK5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 649/733] xfs: report healthy filesystem events in scrub stats
Date: Thu, 17 Sep 2026 16:15:57 +0100
Message-ID: <20260917151408.790715427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


