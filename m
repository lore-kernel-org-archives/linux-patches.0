Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C62E3C3C;
	Fri, 27 Sep 2024 12:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440353; cv=none; b=UpKeJHBu4WLVVGeiGrpT6yMoIfwV+HeFPCObG0JhMkmnW94Qwt8LDkh6SkC4d7fHZrfOv3qL8b68Cs5CPRGLb9D/6PmsQ2ApVpXRYq2GXb/mf01GY2nrUmCezA8csdVOahN5eMgoZlPfAUv/a7xZpw9DA0xpOWspl+e4e9yGrlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440353; c=relaxed/simple;
	bh=vAqqDKQQxKZepyAOgRXtwXFv7AJHu/AWooGjIiPW3fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfxVTEuNasnwz7BDkHH5eAg5wdLWqW2ffpEx55xfMvT9sGJbNDo+fxuGUG1u+RYYEViYAq4S0imx8P9fP7ML7EF/WPqEQw0IVmJH0x4BjzTY5OIBRHnZs30T1+fWd/8OVgHCA9Gp7UUIBkzbPwmAzyCSdzezSExg3CqKTt4MY4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgBDfYrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgBDfYrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3DBC4CEC4;
	Fri, 27 Sep 2024 12:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440353;
	bh=vAqqDKQQxKZepyAOgRXtwXFv7AJHu/AWooGjIiPW3fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgBDfYrS6+5x/vNwjHjbTiZ8N45B74g1P27L9OCzbrxpbnAXPbFWYLzL+1S11HWKM
	 pzzptFgk8j6CJu7CR+hwP4bBuEdqPF7HrlX93WrvbDPPAsfF+VZySwzqWODU8gtc+f
	 2mrXgd1ZqdeXearbDxoFp225pqHPX+XrpI+71UzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wengang Wang <wen.gang.wang@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 34/73] xfs: fix extent busy updating
Date: Fri, 27 Sep 2024 14:23:45 +0200
Message-ID: <20240927121721.287970961@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wengang Wang <wen.gang.wang@oracle.com>

[ Upstream commit 601a27ea09a317d0fe2895df7d875381fb393041 ]

In xfs_extent_busy_update_extent() case 6 and 7, whenever bno is modified on
extent busy, the relavent length has to be modified accordingly.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_extent_busy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -236,6 +236,7 @@ xfs_extent_busy_update_extent(
 		 *
 		 */
 		busyp->bno = fend;
+		busyp->length = bend - fend;
 	} else if (bbno < fbno) {
 		/*
 		 * Case 8:


