Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9192D2394;
	Wed,  9 Sep 2026 14:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964918; cv=none; b=oDnK/SYdRxFIJcPj/2maCUyjdzl24sGPQpmjgFKlFDXZTeey3uyXCoGhFnIxYeenNwDJVFxOEL/ErQ4QGLWsJU/h8CRSWrDuVwnLUrFelajYnsLiGppwcGdYGIBP9QqfFQ7gOc7GoqxjrjcsYx2+AGs+7JSz2o8d7IYI3Unm6Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964918; c=relaxed/simple;
	bh=BiNsU86CL9mAsOSrElf6Ix05lu9nbGmSuf8eKgWXUpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4s59bZb6poOlJl6jKlczNqBosuIP5Xvhb0LXOapvuTIHuvF45rdveh7jqxwB1xXtHozN7HPhKZG25yw5DsBd7emgTC9y1iIvc0J4t6axiIsaUR0kTC58z0RYip0X5O6IzpTZupatsuQIlv/TwghlFINnNIc2GQVZ69bl7ZQ4Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGZPG/+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGZPG/+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAB81F00A3A;
	Wed,  9 Sep 2026 14:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964917;
	bh=klLuZwjYfNjhMtwRXuv4LSsopkvEZbgeSVGpGBKZ+J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tGZPG/+HvQTbu3ZIAmhAevCfxiv68Y0RXd7DWVNuBT+c0rgePBy7y/rFM9qiXdI33
	 WtpEr2Fz/pxl0u1yL3plR7IiwD6ODPPdoa1w/XNG+TcwpfH2uNQatbXT35t6Xn08N4
	 I6qV6JEkC7K0sJVqxK6f2YlP/lvUzHXPAXltTnYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Hu <husong@kylinos.cn>,
	SJ Park <sj@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 563/583] Docs/ABI/damon: fix typo in intervals_goal sysfs path
Date: Wed,  9 Sep 2026 15:44:08 +0200
Message-ID: <20260909134257.177664259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Hu <husong@kylinos.cn>

commit 1b492fc82368399123413c937f13da6ed312ee4d upstream.

Patch series "Docs/ABI/damon: sysfs ABI document fixes and additions", v2.

This series fixes typos and fills in missing entries in the DAMON sysfs
ABI document (Documentation/ABI/testing/sysfs-kernel-mm-damon).

Patch 1 fixes a path typo, "intrvals_goal" -> "intervals_goal", in four
What: entries; the documented path points to a non-existent directory, so
it is Cc'ed to stable.

Patch 2 fixes two further typos ("WDate:", "manimum").

Patches 3 and 4 add ABI entries that exist in the kernel and are already
described in usage.rst but are missing from the canonical ABI document:
the 'update_tuned_intervals' state command (patch 3) and the
'tried_regions/<R>/probes/<P>/hits' file (patch 4).


This patch (of 4):

The ABI document spells the DAMON sysfs directory as "intrvals_goal"
(missing 'e') in four What: entries, but the kernel creates it as
"intervals_goal" (mm/damon/sysfs.c).  Following the documented path
therefore yields a non-existent directory.

Link: https://lore.kernel.org/20260714140117.94147-1-sj@kernel.org
Link: https://lore.kernel.org/20260714140117.94147-2-sj@kernel.org
Fixes: e2b23dc62369 ("Docs/ABI/damon: document intervals auto-tuning ABI")
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -105,7 +105,7 @@ Description:	Writing a value to this fil
 		DAMON context in microseconds as the value.  Reading this file
 		returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/access_bp
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/access_bp
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing a value to this file sets the monitoring intervals
@@ -113,7 +113,7 @@ Description:	Writing a value to this fil
 		the given time interval (aggrs in same directory), in bp
 		(1/10,000).  Reading this file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/aggrs
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/aggrs
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing a value to this file sets the time interval to achieve
@@ -121,14 +121,14 @@ Description:	Writing a value to this fil
 		access events ratio (access_bp in same directory) within.
 		Reading this file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/min_sample_us
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/min_sample_us
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing a value to this file sets the minimum value of
 		auto-tuned sampling interval in microseconds.  Reading this
 		file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/max_sample_us
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/max_sample_us
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing a value to this file sets the maximum value of


