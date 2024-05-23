Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6F314A604;
	Thu, 23 May 2024 13:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470556; cv=none; b=BvokTQp8xjWepnj/DX7TnuE4sWKeHriv8kuSvZjMeV1e0foG6/CITiVFhR6X8559D92OxJoD/XL8N7V6I2PxIBJecqVCNQZ32z9yBbN21tPtJCVv0QBFJZAlXTsVSpejtx5AWaCg1U9Y+vkPgRretYRuRmi5xg8LPGTDoorBCQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470556; c=relaxed/simple;
	bh=I3R7vARVYB5kqTBQPVvE32O0tYXyoX2CLAGlQ2IACWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcZmo53Y6HsU9oCswVKE6KFy2sJgbwK7UoWn+9IJJCiO237Ec+8WJCL/FGCoyNMxmmjFTJPWWCDBgF3Qd/HDu1KhwFWnAcAfChEP3CDN7kPIPqnKO1dtqjtk0fbjRZYHqWJMQc0gCiGj/I0fODSAvcOg7zjHgjcs+VQkLgGtMms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+HTWUlk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+HTWUlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B46FC2BD10;
	Thu, 23 May 2024 13:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470555;
	bh=I3R7vARVYB5kqTBQPVvE32O0tYXyoX2CLAGlQ2IACWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+HTWUlkBQOXUMfDxkXoVtO7f1XWUHbyFDWJKeN7S6YH3x/v50yVpX6/AW6DrPlCs
	 zRu9b8V++KDeg77dzVCk7FdqJaGKJWQshGA81tI77GswAl2ZQE8PEgmOJ5lcmcNN8B
	 3WNDAydN+d2e9pTQ4OzHy9m9yXleWSEo/DtMqByQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 21/23] Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file
Date: Thu, 23 May 2024 15:13:48 +0200
Message-ID: <20240523130330.550688541@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
References: <20240523130329.745905823@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit da2a061888883e067e8e649d086df35c92c760a7 upstream.

The example usage of DAMOS filter sysfs files, specifically the part of
'matching' file writing for memcg type filter, is wrong.  The intention is
to exclude pages of a memcg that already getting enough care from a given
scheme, but the example is setting the filter to apply the scheme to only
the pages of the memcg.  Fix it.

Link: https://lkml.kernel.org/r/20240503180318.72798-7-sj@kernel.org
Fixes: 9b7f9322a530 ("Docs/admin-guide/mm/damon/usage: document DAMOS filters of sysfs")
Closes: https://lore.kernel.org/r/20240317191358.97578-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.3.x]
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -450,7 +450,7 @@ pages of all memory cgroups except ``/ha
     # # further filter out all cgroups except one at '/having_care_already'
     echo memcg > 1/type
     echo /having_care_already > 1/memcg_path
-    echo N > 1/matching
+    echo Y > 1/matching
 
 Note that ``anon`` and ``memcg`` filters are currently supported only when
 ``paddr`` :ref:`implementation <sysfs_context>` is being used.


