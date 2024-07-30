Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEB6188013;
	Tue, 30 Jul 2024 16:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358303; cv=none; b=NuAcrqOHpHCUst7UPJSK8CaBt92rJB5leQ5sTRXfmB5JlMbjuaR0V2Y3fd6hFuj6dpzS9oKpc4HFFJrI4J6P/deJ0dtX+kjNv8yWRUQrlhM2n+NwQuI3aWQy/v1Y/lqNzD6S+iIyXMcmRtPUXcp9vPPr9A4gLNX/TK58iAsZreI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358303; c=relaxed/simple;
	bh=XzMxX4KHPiKblPE1P5I5lvIrZ4c8y9B5CXp3XerSrxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEVhbrlNpMMXyB5ZMOB3iWgd/2EzYk5fIEioLesz3gMYs0eXvoM1wImlB92BA6InsONPBBuY1oJgD8P+sNrTiYczxStKmmaC4tfLWvRmDQLTMsg2BR2O5lkgX5qxSf2VOld+DkInZjO/RDE5jOKK5SrJxJBIEBOcsM4R6ACtxug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7Zo8vrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7Zo8vrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5318C32782;
	Tue, 30 Jul 2024 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358303;
	bh=XzMxX4KHPiKblPE1P5I5lvIrZ4c8y9B5CXp3XerSrxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7Zo8vrN9tak+zFcaGqmnq9K4yxtxuHfx7nCQ5EXYHY2obmWhEe6UEgNrWeFsI9Vx
	 qnXFa+Mp8jrG/R7ByLR3Bnkf1IdXR0nn5K5pgTso7gwrpx1h0bpZOEFJxAq2YRBCVv
	 YoGXY45dkkV2K3du9pOWifq7bXwYWy+q+2ETAhj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 349/568] fs/ntfs3: Fix the format of the "nocase" mount option
Date: Tue, 30 Jul 2024 17:47:36 +0200
Message-ID: <20240730151653.510189557@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit d392e85fd1e8d58e460c17ca7d0d5c157848d9c1 ]

The 'nocase' option was mistakenly added as fsparam_flag_no
with the 'no' prefix, causing the case-insensitive mode to require
the 'nonocase' option to be enabled.

Fixes: a3a956c78efa ("fs/ntfs3: Add option "nocase"")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 79ebe62f00017..d47cfa215a367 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -276,7 +276,7 @@ static const struct fs_parameter_spec ntfs_fs_parameters[] = {
 	fsparam_flag_no("acl",			Opt_acl),
 	fsparam_string("iocharset",		Opt_iocharset),
 	fsparam_flag_no("prealloc",		Opt_prealloc),
-	fsparam_flag_no("nocase",		Opt_nocase),
+	fsparam_flag_no("case",		Opt_nocase),
 	{}
 };
 // clang-format on
-- 
2.43.0



