Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1B243B6EE;
	Tue, 21 Jul 2026 22:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674364; cv=none; b=qQrMXuw56miS6ZNQytUQsGKet0wIxoOx9JKH8t6IbEXwx4kfOrB3TFzAgLvmW7sPQbVwInxBjo3rvZtLwXW2ULPwsfx/VAnewOf38n2ScsaQxy0zDh2HvZJ6bsEVnp3H0Xn2KyALtys3glZmTNSp69LZ/9c/vxekGzkjQGTpbr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674364; c=relaxed/simple;
	bh=lpYeLozf6OjZFmuhRGxY6uCjBVVBTz0DnOhEKZ4JtXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdzHRfv2BZ8zJvJyRGQj9NsRYvMDyl8ev3oaiV2QpkGWdg0KsBgiRPqXMifobigohmBbiHK5VtMkOw9s5ScIgVFb9UiWS6I+CdA6T6ldVsCE4gCM1BPfZ+1wsB1gjWX9r+LojmnFm9Kbkof4Y7xmk7oE3xFZi8SEYk6Isd0KBRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxgFZg81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxgFZg81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C221B1F000E9;
	Tue, 21 Jul 2026 22:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674363;
	bh=kCEFeoJ1yGjhybp+higTM1o5ACkDLnolYSHriPCZvd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxgFZg81jwkGVp08Qv6A/cDwentf5mbJjcs8G43Ianln/9a5tmNvKKXaXoMLsCjly
	 cFIrhLpJ3CdKcsjPMDLcFm23KScaCr+jf6LahvDX3s1A2YBXTU9vm822h+2xl3KOPD
	 Qi0MJUd/lCtIDJ8HGxXRCDuyJ0dEAXDIdZE37/kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 514/699] dm-verity: increase sprintf buffer size
Date: Tue, 21 Jul 2026 17:24:33 +0200
Message-ID: <20260721152407.289080566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -21,7 +21,7 @@
 
 #define DM_MSG_PREFIX			"verity"
 
-#define DM_VERITY_ENV_LENGTH		42
+#define DM_VERITY_ENV_LENGTH		46
 #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
 
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144


