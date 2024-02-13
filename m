Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9EE5FEFE;
	Tue, 13 Feb 2024 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845319; cv=none; b=Qy2LXm7/Qq6ICYCITjpkDAhjElJ8ov6GXUP33ZvyR6/12wYYTFns/SYs3piRE7A4uYHyaVueA6PvxA0gxErpyq+MSleR47VESnFmIH6N6QBzGcXefr/RYXRbSeUVVChzlkUTtYHVCnkD1OugCJu7L5UJWrQl3sZKc4b41EszRK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845319; c=relaxed/simple;
	bh=xrNYXVv1mFQK7bH4jAANWwYkQIQfo8rDQP62tzH28F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvLL/xe0BJBfECEf2O8JzzoUeUdG6qq2f6s8Jiq9kVJRTZlbznnojw014FDBQJO+IXw+iGgH/TAzWkvIAK/8OH9ooIQrLrqPwSpxCfArXodfRyqTNAj0c/CH9SJTqVdkWNuBmrL29OQ6lYscoMO4VvN2kok/hM94B+vf4uVrN0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXAakjtL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXAakjtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8539C43390;
	Tue, 13 Feb 2024 17:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845319;
	bh=xrNYXVv1mFQK7bH4jAANWwYkQIQfo8rDQP62tzH28F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXAakjtL+d0x2yW+QOGhkT7cAuuPIe8Z76E2BMHNDUTwhB3D6C7HApeLh+6PXSW99
	 +Y3tuA8bbCMTEtx+9WieSbnCZC9h5Rrc6mG2R3xdRKM3op4Vin+GS+hmcZgkDFfDzT
	 N0etl9oGxQUuK0ZlFvu6Gq1Q42ELtdb2tsPKOafM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/121] MAINTAINERS: add Catherine as xfs maintainer for 6.6.y
Date: Tue, 13 Feb 2024 18:20:26 +0100
Message-ID: <20240213171853.473953498@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

From: Catherine Hoang <catherine.hoang@oracle.com>

This is an attempt to direct the bots and humans that are testing
LTS 6.6.y towards the maintainer of xfs in the 6.6.y tree.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index dd5de540ec0b..40312bb550f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23630,6 +23630,7 @@ F:	include/xen/arm/swiotlb-xen.h
 F:	include/xen/swiotlb-xen.h
 
 XFS FILESYSTEM
+M:	Catherine Hoang <catherine.hoang@oracle.com>
 M:	Chandan Babu R <chandan.babu@oracle.com>
 R:	Darrick J. Wong <djwong@kernel.org>
 L:	linux-xfs@vger.kernel.org
-- 
2.43.0



