Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403F23EAC8F;
	Wed, 20 May 2026 16:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295389; cv=none; b=ID3SFLL6LZ12V1YmoyQBEg0RQ7lRq6RdoEqpVoDyH4V/d7Y2rvaMlkk28e2M+7ST8rGvtWtm2y1EYE0Buk3NG5OPPrb9Vhnxue0rQ2cgqxjqnPTM9wjlyv3xkCCYkJI4pW26IQ695hjsD1ViI8Fjba+Qcd0NYmItwY0MKGh9hkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295389; c=relaxed/simple;
	bh=kXsg/TxVIxsAY8OysjPnBq054QTeU6jKoEB93GVLnTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzdMg2eitgF5eOiEG+8gN1UC3Z9bz97gbAlESoopGjKq3ZpG1ERedudvSvdBOvEJCeQMNa4Z2Ay/nkDGd6kmoyYPmS/h6AS+DFdEz9wVxj6eyMqSMYfkPU6Cu5q8yUAWtNgaCS5US4x6AD7oJuw8+SUFOdFf2wAhXHqzfQ8TBCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvKrm1Os; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvKrm1Os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1740F1F00893;
	Wed, 20 May 2026 16:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295387;
	bh=cgk5rWaI3a40sDr45r9iuwxvhKTPp1UpjddN3bMSIyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvKrm1OsyVdzKpQlV1uMZajscY9C/eO2VMSvt4UWo27R2PEbHCpKqeHflc0rs5ApC
	 oDzBA2NXGzB+YgCHeIfgLT92Cn5p5W1c0YcxjQbh8Oh2gmqqpWkvJ5DvU4k38Ylm/7
	 LxBBmc9c0CtXrPYgO748AiOqfxzP/Q4LuO5Rprpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	wang lian <lianux.mm@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0401/1146] Docs/mm/damon/index: fix typo: autoamted -> automated
Date: Wed, 20 May 2026 18:10:51 +0200
Message-ID: <20260520162157.277004172@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

[ Upstream commit a4e82de81fe59d5bfcc9450145e8e108561f2e07 ]

There is an obvious typo.  Fix it (s/autoamted/automated/).

Link: https://lkml.kernel.org/r/20260307195356.203753-8-sj@kernel.org
Fixes: 32d11b320897 ("Docs/mm/damon/index: simplify the intro")
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: wang lian <lianux.mm@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/mm/damon/index.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/index.rst b/Documentation/mm/damon/index.rst
index 82f6c5eea49a7..318f6a7bfea47 100644
--- a/Documentation/mm/damon/index.rst
+++ b/Documentation/mm/damon/index.rst
@@ -12,7 +12,7 @@ DAMON is a Linux kernel subsystem for efficient :ref:`data access monitoring
  - *light-weight* (for production online usages),
  - *scalable* (in terms of memory size),
  - *tunable* (for flexible usages), and
- - *autoamted* (for production operation without manual tunings).
+ - *automated* (for production operation without manual tunings).
 
 .. toctree::
    :maxdepth: 2
-- 
2.53.0



