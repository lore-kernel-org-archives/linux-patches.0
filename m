Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8F0350D77;
	Tue,  6 Jan 2026 18:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722532; cv=none; b=IQEd4Tbmdt7f3bUaqoeE4ERtldvxvS8PHcHWQ7MSI8ilb/1K7jUykPqX91GuoexjtUvE6QnuJdvWN6xKvyytpSnyOP8GwDbcY4R19/d/64nOn3k57OT4Ts67Q9KpsSxEP/cvwwbJLJeiRkRbB/dmTlzkyLETw58qCy92hSzLE4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722532; c=relaxed/simple;
	bh=2pp0vxH7niH6Wm4qtIEtq7/QCLHAesNdN/3jCwhK1Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K1QT0nPMqcxc9c+5AFglI2auU0oxmEiJLz24NGljGXMMbPG1e46jperQ/Aiuw/4whrhjkPkQspd8FIDzRvRvaXmLaRP5CRJRI6bCY9sSVaTEHskMFQk659ZSrst6HHiPNhfpkd2QuuL7SS718FApm/1NI7E5c3PvJPHmNflyzME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dftizWV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dftizWV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF17C16AAE;
	Tue,  6 Jan 2026 18:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722531;
	bh=2pp0vxH7niH6Wm4qtIEtq7/QCLHAesNdN/3jCwhK1Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dftizWV6QstpvBvtZvajKnQ9kBO2AeSL9YdGgcng5Br1Ysu0Eu0MW06N9BtOdi7tS
	 qt6Nzp8zl5v65hLxOfdusyNwjbMxC1EDxf5iwpHq5p5qPzwde4ReV7JynPUCG+4f1x
	 UrtcM92QXS9MLLuKOtOfb4muHeZu3x1ZvyEqaWSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.18 292/312] drm/xe/bo: Dont include the CCS metadata in the dma-buf sg-table
Date: Tue,  6 Jan 2026 18:06:06 +0100
Message-ID: <20260106170558.417965515@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit 449bcd5d45eb4ce26740f11f8601082fe734bed2 upstream.

Some Xe bos are allocated with extra backing-store for the CCS
metadata. It's never been the intention to share the CCS metadata
when exporting such bos as dma-buf. Don't include it in the
dma-buf sg-table.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20251209204920.224374-1-thomas.hellstrom@linux.intel.com
(cherry picked from commit a4ebfb9d95d78a12512b435a698ee6886d712571)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_dma_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -113,7 +113,7 @@ static struct sg_table *xe_dma_buf_map(s
 	case XE_PL_TT:
 		sgt = drm_prime_pages_to_sg(obj->dev,
 					    bo->ttm.ttm->pages,
-					    bo->ttm.ttm->num_pages);
+					    obj->size >> PAGE_SHIFT);
 		if (IS_ERR(sgt))
 			return sgt;
 


