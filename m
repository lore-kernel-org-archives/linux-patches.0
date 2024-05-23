Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B5614A60D;
	Thu, 23 May 2024 13:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470283; cv=none; b=bDWbhQLapnhUtvLg4O7rp7JhhdwlKEvKVmP3vXja5mgJjVDgqvSJLzmvKXnJGdCChl/GdDduVijNjr2cFjil9/frjkC73VXa3Vkrn8y7EBCRuSDyQEmsV5iHgV1ilpw7y8KTvMg3DbpGU5e/I91Ye/JzvHbahDzqqXEDqbiJpwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470283; c=relaxed/simple;
	bh=SVfX7DG2cIf09x/+bi6h0LAuxaeB4G0kZAxUsJYExXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVYTPndiEsuQeAIo4Pf0X9eDWBGfUzZaF8ZWh9/63F2EouOhUezVFyh4u/Wlytt5IJIEZhTSf0ZmDFvXwYXpZjjF8G4hbAgnkj8C7inNQB59P/FrVxz9DwjMN9lQnVAF3xEnywtOHDxLS0PPZd7NzxKg/8ILKV75/31KpEX7OHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x385M5DN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x385M5DN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E563C2BD10;
	Thu, 23 May 2024 13:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470283;
	bh=SVfX7DG2cIf09x/+bi6h0LAuxaeB4G0kZAxUsJYExXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x385M5DNbQAbGkvkV6O3dM4vhYbcPca72+x5hUR33nC+mFBJVDrNNafchsl+LFPlE
	 ctwZUV9THG335xYjrmU9ZDV0BPtFTICgSmBU6hFQH8DRbewL2/lFW1ReNKWhB5Nxcq
	 LThWkz0Y2vOdCfUZwehy2XZ+rJ+5GJbHDNgjmznU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 23/25] Docs/admin-guide/mm/damon/usage: fix wrong schemes effective quota update command
Date: Thu, 23 May 2024 15:13:08 +0200
Message-ID: <20240523130331.254667140@linuxfoundation.org>
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

commit 14e70e4660d6ecaf503c461f072949ef8758e4a1 upstream.

To update effective size quota of DAMOS schemes on DAMON sysfs file
interface, user should write 'update_schemes_effective_quotas' to the
kdamond 'state' file.  But the document is mistakenly saying the input
string as 'update_schemes_effective_bytes'.  Fix it (s/bytes/quotas/).

Link: https://lkml.kernel.org/r/20240503180318.72798-8-sj@kernel.org
Fixes: a6068d6dfa2f ("Docs/admin-guide/mm/damon/usage: document effective_bytes file")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.9.x]
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/mm/damon/usage.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -153,7 +153,7 @@ Users can write below commands for the k
 - ``clear_schemes_tried_regions``: Clear the DAMON-based operating scheme
   action tried regions directory for each DAMON-based operation scheme of the
   kdamond.
-- ``update_schemes_effective_bytes``: Update the contents of
+- ``update_schemes_effective_quotas``: Update the contents of
   ``effective_bytes`` files for each DAMON-based operation scheme of the
   kdamond.  For more details, refer to :ref:`quotas directory <sysfs_quotas>`.
 
@@ -342,7 +342,7 @@ Based on the user-specified :ref:`goal <
 effective size quota is further adjusted.  Reading ``effective_bytes`` returns
 the current effective size quota.  The file is not updated in real time, so
 users should ask DAMON sysfs interface to update the content of the file for
-the stats by writing a special keyword, ``update_schemes_effective_bytes`` to
+the stats by writing a special keyword, ``update_schemes_effective_quotas`` to
 the relevant ``kdamonds/<N>/state`` file.
 
 Under ``weights`` directory, three files (``sz_permil``,


