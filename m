Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187671D545;
	Thu, 23 May 2024 13:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470821; cv=none; b=TVwR7C6VFIvrDdGb178bgdH73ZXgivGmT11pvikfUryBpv9n5eO6gj+p4pGcMZKplOzmYC8JS8pbyZnWWuFN8PpO5WGR3IpzzaOC7EL/ROHEZCLUaV2/k4ml7NQQomSseZDPALpqxOimAR+zvtCzPV+mqW9Qcp9knOf+Cn8CwU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470821; c=relaxed/simple;
	bh=OQo2IV4D4p4ok02UsP7WEzEt7oeNlbMqw28NKxmUyJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKVBNuD+BkYECQV9wlB1E8TIFr5Yqf8Yt00mZfSTfPCBRIkpL6sJTeqOTs8gT6T20hMVack9CicUv0rvF2ZS9OvnwGBrEEUxJ0Wi2jyMEbwZv8cM1obxcsDMYZokWBN6lq3ohkx1RKtjN8IjMwZKP2g6uUVhCZnlKZfMkhCfx50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=os4SWUHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="os4SWUHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE53C2BD10;
	Thu, 23 May 2024 13:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470820;
	bh=OQo2IV4D4p4ok02UsP7WEzEt7oeNlbMqw28NKxmUyJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=os4SWUHn9gAQCOsuGZ0u9kIwto9cxF0uppZJ0iC9VYy83nK/QLg2n7xzaYyMmzOV9
	 oconFyCHEza6nvP2qw+uYv9PBF6jloe5kTpWEMBUrbYkYnVSl/2izYQDL55U8D0jwL
	 pkeERUfTEMMeZmJXGznQTuku3HyutabWHrBv9x7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 100/102] Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file
Date: Thu, 23 May 2024 15:14:05 +0200
Message-ID: <20240523130346.245418042@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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
@@ -389,7 +389,7 @@ pages of all memory cgroups except ``/ha
     # # further filter out all cgroups except one at '/having_care_already'
     echo memcg > 1/type
     echo /having_care_already > 1/memcg_path
-    echo N > 1/matching
+    echo Y > 1/matching
 
 Note that ``anon`` and ``memcg`` filters are currently supported only when
 ``paddr`` `implementation <sysfs_contexts>` is being used.


