Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0919E3B6BE5;
	Tue, 21 Jul 2026 22:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672530; cv=none; b=YGPOYfUelC6H8Lp6/2e1HP6pGQtsp3WevS0bbu7owfGucEERozuiC6Q55ZqaEtTupD4FjsAzk4gbDrqkjLsPwUlERn+hituAkDXZtZQYgvOdI/fCTL//sy1w/5DBiheX2Uwyb8lPJ1azAEDE1N4OV6CIqxi2U2cow728ROIMaDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672530; c=relaxed/simple;
	bh=SWCM5EvwZ/99b/r8gV/wWeIQgnJ2XVd6zHWXNINOUpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N33K3vwybH9PEuY5Q1Jqg+8XS3GMp5Eek6ElIuAV3QIAp+rijw3Ki8PcMxcz4f7fPf96Em60y8FPI9ccCgRAnRrXHkGAyepnLc6h4MIfK0iZCXeSqajwzl6UIHbfW54a/dF23xU5faLyhJfMqfhWE74YSoFRU2Rgt2mpRpHMOWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ni7mckaW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ni7mckaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8E51F000E9;
	Tue, 21 Jul 2026 22:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672528;
	bh=C4WedmUhkRK/TurSRHwmpfMTaLC5s3KruhsBHYNNzAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ni7mckaWT42OyllcYRM2jcQnp+7JkVF/V2aM5QbcgUVXnYbdhSYooJcfOyc9mxORf
	 2Hj6UvGb3LjV6nkyA7hQIOPZKLguOQxPCiwQJVLfHFIw/Qh1EWycs5ILuu/zyBMlEz
	 HpmRy8xocYMbQIsi4oNpf1nsAyuST3JrMET3Lcl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 659/843] dm-verity: increase sprintf buffer size
Date: Tue, 21 Jul 2026 17:24:54 +0200
Message-ID: <20260721152420.889523924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


