Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4026B13B7AE;
	Thu, 23 May 2024 13:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470280; cv=none; b=RnFKijapBPU6vesmUf8AQkzFONt2GzpTIhlme1gGkqMbkovAY6lymk3hEcfq2aX41JCiCinIK9MzP/EDS5hd6puzszg+yue5sj7WQ1mGLGiL3KE3M3P+G47S9rTAM68yMs9mmOA8+N7iZMpDbIESj7gR9O842gyU7h91CsVk+6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470280; c=relaxed/simple;
	bh=1IDhpaEKD2zqJ4fJ2bWGcr9uglXWbY0V7pnmp4ueZg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cq0hY/hjnpSTqrI2RqovWFyE9ZUoqWgVbYnV3wez+aw6afdb9sTAHCFF5WVWEBNBcUUHbbWKps0OKsQdQWklcujUK/+wNPi08LXigMBUT3jpF1twUJAwulI6CzeL8zpfD7Vgm8hXSYE4SWAL8SZ5jDSi1hY3ma0P+t7zIeKIyKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1y0OT2T7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1y0OT2T7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD700C2BD10;
	Thu, 23 May 2024 13:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470280;
	bh=1IDhpaEKD2zqJ4fJ2bWGcr9uglXWbY0V7pnmp4ueZg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1y0OT2T7sWsYJNPeBvVvycWoPNZTCF73kOQiuZbeCxL3akCVnHSMM70Zt92K9AzV+
	 0RTEqpFwYQDfSsQ+moPHlZpzE3qHe9Dup9fwMwyEMKjZDAzseMBznLuMLiOPSGzp6B
	 CnMGiDoAgiB8372Y0t3rhFKqorvG3EqgLz7CfdbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 22/25] Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file
Date: Thu, 23 May 2024 15:13:07 +0200
Message-ID: <20240523130331.217812248@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -434,7 +434,7 @@ pages of all memory cgroups except ``/ha
     # # further filter out all cgroups except one at '/having_care_already'
     echo memcg > 1/type
     echo /having_care_already > 1/memcg_path
-    echo N > 1/matching
+    echo Y > 1/matching
 
 Note that ``anon`` and ``memcg`` filters are currently supported only when
 ``paddr`` :ref:`implementation <sysfs_context>` is being used.


