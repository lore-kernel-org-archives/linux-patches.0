Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FA443C7B5;
	Tue, 21 Jul 2026 21:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670220; cv=none; b=gXWsJz5Jj7DE+hFAVemfNBAnBsJEpyBG47RppalUDO49kMp5EG0TnGlkDDPBe4/TjWU63tU58KxYP5ywiQOhFK01r0PB3KZAjbqIW9ls908GHwr/CNyLiLCFQRsiI6Us1rPsAjMoGtPAPdGm9DsYjnHSCHV3VQNbHaWuVqCma4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670220; c=relaxed/simple;
	bh=iEjbL6kRTMHk7xEqtKV7Zf/aMafL9xx53bJ3EUed2FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8/kXozqqdAzoJeTmkw4ZlDSA5HnoDPwWN2uKSHx9EtNB8qCxODkt4aNlBqFWy1V+TXiNuc7vRhGMvztyqsIvxN7BPXNuq5niT3mBi1CDTzX+NieJ/9n5fU9K0Lk2w9HWmjbQSwIcnpG2TFoqwUC8vHPKWQHgWYQ4WHh7u2tWtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vH1Hrvbr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vH1Hrvbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75DA1F000E9;
	Tue, 21 Jul 2026 21:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670219;
	bh=c3hMONwqcOwtwH18I1u6uFS62hiqaNc5qfVG8NVN/sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vH1HrvbrVQKa+92zs9c/wzvUpczlxQBMOEWUsV/pX5jEnlXh+8i8pldQs8A1rRXJB
	 nKic4TGVtZgO4mn6cb07y65XZr26dICuYbEBxUaV6frXpmry/sN+sxG6l/Pqs4eU9a
	 0/bgbV/f3a0nxoWFc3TtqF8a19NCMMPJYvPa1j6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0851/1067] dm-verity: increase sprintf buffer size
Date: Tue, 21 Jul 2026 17:24:12 +0200
Message-ID: <20260721152443.580963914@linuxfoundation.org>
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
@@ -24,7 +24,7 @@
 
 #define DM_MSG_PREFIX			"verity"
 
-#define DM_VERITY_ENV_LENGTH		42
+#define DM_VERITY_ENV_LENGTH		46
 #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
 
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144


