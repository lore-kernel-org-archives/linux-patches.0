Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E74728D8E8;
	Tue, 17 Feb 2026 20:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361657; cv=none; b=J6HizG+fTwS3bNncfrjKuyaXKHj9VAJ1ip7ikYvgsn7JMCarWppdNpZdmwK+jfguIIXn+RDyRuaFN0WaYH6vjT8KNO3MxZ16YLslYr88JzWT95P3Wed4R1o1F4EcKW9ykT6bAoZom6wZTDcToYVH0TOL7uIyJQiyGvMd8FuZIrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361657; c=relaxed/simple;
	bh=NNHMNkAfdr5ZYn8XmBNLp1zsw6hVwxyg74ahtO2TIFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9UN7sJEVv5/ddtwdX54SXCa+dYZzlNbQh1ScP3kNMYFoQQnODXPG3euoCG4nWiVmgzIrOnazZwpN2sTEUguV3gDBgfiF1obbZUKbXhKSxo7uraapPSIhbenE1sE+okh4W6a2yH8rmw0q3F+iBHkKcQsgxa9E/nAPSZNPKsQaBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdA0A3ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdA0A3ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DA8C4CEF7;
	Tue, 17 Feb 2026 20:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361657;
	bh=NNHMNkAfdr5ZYn8XmBNLp1zsw6hVwxyg74ahtO2TIFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdA0A3ffNyJ+zdrzEyRhrO+bkYHmnMSKNJTuwrzJHZNeBxI1TUb8USDCEdn2R/EMb
	 9IqLTulidJJrDntxAq/y4Jx4h3kYygXlrsFImA173WbNz72qagdB9B8ufB76tuAANj
	 vnMVqnJHOCZOK9NCAENRDb9q+nGZShdql6Yg+XEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 36/42] f2fs: fix to check sysfs filename w/ gc_pin_file_thresh correctly
Date: Tue, 17 Feb 2026 21:32:27 +0100
Message-ID: <20260217200007.380776542@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 0eda086de85e140f53c6123a4c00662f4e614ee4 upstream.

Sysfs entry name is gc_pin_file_thresh instead of gc_pin_file_threshold,
fix it.

Cc: stable@kernel.org
Fixes: c521a6ab4ad7 ("f2fs: fix to limit gc_pin_file_threshold")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -732,7 +732,7 @@ out:
 		return count;
 	}
 
-	if (!strcmp(a->attr.name, "gc_pin_file_threshold")) {
+	if (!strcmp(a->attr.name, "gc_pin_file_thresh")) {
 		if (t > MAX_GC_FAILED_PINNED_FILES)
 			return -EINVAL;
 		sbi->gc_pin_file_threshold = t;


