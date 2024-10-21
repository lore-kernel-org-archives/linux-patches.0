Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10521953B9;
	Mon, 21 Oct 2024 10:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507037; cv=none; b=GfuD4Kjc+IWYmJP0279biZxoppVuQJO4ibky+fLqT/v7wr/RNM0pDaImgbPdly2uBOcAZKGovLCOuxMyxscf+g3qWQhtMSre8SD0jFEimIwGl/18cIjqYG1yrhsVPjK6yPLhJ0zZVkbDjAiBJ/XHWEPyEWsIg8O1z1XhuMCB0BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507037; c=relaxed/simple;
	bh=7V+PD/nus9FLZ/iEFbWDaJQMoAFFtME72lQQBu7ibvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WBquJmZJzXAKBZu74yCE82YKPq7mhkYeqztSrzuXgRQWdPtENppUytkRW0p3uNqN+usmRoI9oawNgs3BwrgjAZEZSws0zUIVEsfoPnwI1uT4MIhniHQhmmb/poeV2+uTO3FTOkEtFlzpNdyHOELe5+l8yPYLqgNzJLr60PUgxmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Osmw80CF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Osmw80CF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF55C4CEC7;
	Mon, 21 Oct 2024 10:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507037;
	bh=7V+PD/nus9FLZ/iEFbWDaJQMoAFFtME72lQQBu7ibvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Osmw80CFnI4XV2i0Ll+W8Pe839ggANIKwi7Ly8yPrNuUndPjU3L5+/A8yeNqEK0ZZ
	 7Eypmgx6lF8veausd6+nhoD6Ez4xFLw2CM6XKX9yBj+WmOVzLwJaXTXX9fom3fNtfa
	 HqdNl8v9GTm/JXzhLUnAp+VlK+zIEirFswbDMX4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed Anees <pvmohammedanees2003@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 069/124] drm/amdgpu: prevent BO_HANDLES error from being overwritten
Date: Mon, 21 Oct 2024 12:24:33 +0200
Message-ID: <20241021102259.402726305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammed Anees <pvmohammedanees2003@gmail.com>

commit c0ec082f10b7a1fd25e8c1e2a686440da913b7a3 upstream.

Before this patch, if multiple BO_HANDLES chunks were submitted,
the error -EINVAL would be correctly set but could be overwritten
by the return value from amdgpu_cs_p1_bo_handles(). This patch
ensures that if there are multiple BO_HANDLES, we stop.

Fixes: fec5f8e8c6bc ("drm/amdgpu: disallow multiple BO_HANDLES chunks in one submit")
Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 40f2cd98828f454bdc5006ad3d94330a5ea164b7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -265,7 +265,7 @@ static int amdgpu_cs_pass1(struct amdgpu
 
 			/* Only a single BO list is allowed to simplify handling. */
 			if (p->bo_list)
-				ret = -EINVAL;
+				goto free_partial_kdata;
 
 			ret = amdgpu_cs_p1_bo_handles(p, p->chunks[i].kdata);
 			if (ret)


