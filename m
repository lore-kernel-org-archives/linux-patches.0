Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED2B3B95E0;
	Tue, 21 Jul 2026 20:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667428; cv=none; b=lGUDsb2mFiQ69etR2SLGA8q/SfESjOhYmd9pTEio4t6QrNcg6n8Mxnq7JplD7uX98SuglpFx2QL0bVT9imqZSb9k9XLxHdB2ua/1b60i3CdGK6VUEH/FIFbtSf+58CdGZip3caO5fv5jqRZyMKnppHbh6qC4IsxakbJofbU7t3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667428; c=relaxed/simple;
	bh=IBR/S8M9q84mk4IIT65bt3shfoQRu/9nJBa86A/6IiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eg4Q/Jfh3tXl/95XVfHXgJcFntfy/PTS02ZlAO20KKvw7OvisPnBqPS4eqiTiSI+dAaWBWCf9GcOn3eJD1ux+QzPNdUXoyV/LtP3flIeK717FFv5Aq7vvEOtH+9St9ToS+gu1+08MycllkX00hcmXOGHiU7ESlvdoqkZ3HhzMNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E19gTr6V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E19gTr6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7AB1F000E9;
	Tue, 21 Jul 2026 20:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667427;
	bh=J/04QJUIOp8i1RnwLjc6cZ/r5F9z9mxck7iYNJgEUr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E19gTr6VXqOc5deuoZ2FlfWXtwd+c2p8tzWAEh/bqEKKVoMH8XB5jTEbwvj1rjo2l
	 eozjWVsseAN+o/4bfM+ZP/hu3HXq52CtlvKHWjpu5c223rTjqe76HBybAGaXbJqc3E
	 nSVU0cIJEcfaC7J6xSc8piaOUHbsRL/OYFhXb0ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 1055/1266] dm-verity: increase sprintf buffer size
Date: Tue, 21 Jul 2026 17:24:52 +0200
Message-ID: <20260721152505.425848063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 88dd117c92a142253fb7a17e791773902b3babc6 upstream.

The prefix "DM_VERITY_ERR_BLOCK_NR" is 22 chars. Add '=', one digit for
type, ',', up to 20 digits for a u64 block number, and a NUL terminator:
that's 46 bytes. The buffer is 42 bytes. For block numbers >= 16 decimal
digits (devices larger than ~16 EB with 4K blocks), snprintf silently
truncates the uevent environment variable.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 65ff5b7ddf05 ("dm verity: add error handling modes for corrupted blocks")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -25,7 +25,7 @@
 
 #define DM_MSG_PREFIX			"verity"
 
-#define DM_VERITY_ENV_LENGTH		42
+#define DM_VERITY_ENV_LENGTH		46
 #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
 
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144


