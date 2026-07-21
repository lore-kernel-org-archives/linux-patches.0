Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6096435C6B3;
	Tue, 21 Jul 2026 21:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670662; cv=none; b=r/ABd6CUf8ug1kdHdYJGAZaYmpp3AH+zITqpzMf9NnrNXXGjn3ot98IHWRNiqwNUg6R5ZTGtfQbiWqePv0ctP6sGYj80+YJrAzntlZrv5q4UKWI2N/P9ZQ/Nsa/xj6huuym4ey8nitFgf0v1GybWdgrVe4lE4tlxniyv4xc5+O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670662; c=relaxed/simple;
	bh=IFxlyKXLxnWBDP9Q7TG1ZODwhTT9LViL0zyWTpScLv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnHlxfzp2dSKmmdHdZUXqPGAGmSFwEoAyGDTCqt5PS7O0Zpcy8OScZ2UDbGTq4sDL8d0y+arLXv32dGJqrMKEa2Z6dldkJHwT8PdZqsQP/Cdw7QMWehnDhnHRWgDDGw3hTGAHAe6rQQOeYClVQ27O7p2sQdGlfkrL4d43sd6mc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmMuVbd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmMuVbd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C491F000E9;
	Tue, 21 Jul 2026 21:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670661;
	bh=IiKvC5DBStazgKxnbedQLGbWJ3CtBducvvtk8X2evvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmMuVbd4LscRS5GSN0/DE29imhzqGTHk74DRMQMbyi1WOJ42bgRBrsjYcgycp9+BX
	 QUePp6N5x42AmQMHb1q5fnc322JTBmUjNWxfs4SCgTl3uaOJ7MONvX05h9o2zsykHZ
	 QBdAw9NL6M4eLOv0CskXwqYh5SRY7rQwhw2eIN34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <john@metanate.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0980/1067] mm: shrinkers: fix debugfs file permissions
Date: Tue, 21 Jul 2026 17:26:21 +0200
Message-ID: <20260721152446.475751181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <john@metanate.com>

[ Upstream commit 2124f79de6a909630d1a62b01ecc32db9f967181 ]

The permissions for the files here are swapped as "count" is read-only and
"scan" is write-only.  While this doesn't really matter as these
permissions don't stop the files being opened for reading/writing as
appropriate, they are shown by "ls -l" and are confusing.

Link: https://lkml.kernel.org/r/20230418101906.3131303-1-john@metanate.com
Signed-off-by: John Keeping <john@metanate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: e30453c61e18 ("mm: shrinker: fix NULL pointer dereference in debugfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shrinker_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -180,9 +180,9 @@ int shrinker_debugfs_add(struct shrinker
 	}
 	shrinker->debugfs_entry = entry;
 
-	debugfs_create_file("count", 0220, entry, shrinker,
+	debugfs_create_file("count", 0440, entry, shrinker,
 			    &shrinker_debugfs_count_fops);
-	debugfs_create_file("scan", 0440, entry, shrinker,
+	debugfs_create_file("scan", 0220, entry, shrinker,
 			    &shrinker_debugfs_scan_fops);
 	return 0;
 }


