Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653FC1DF269;
	Wed, 19 Feb 2025 09:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957247; cv=none; b=tdo21VQvAP7o4ms8j9fToPSTZbpMV+d4jezeP/TyYToPES+7OQDOHiJmFnCZWOUZmRfFJtbXFl6rY1FZWaVeSCF9jgHVcdXgCyCybMAKI2rkJNmrzN7EaGVQg7jToErfmZDAt/JPkWRWLBTMAEg+sO5QGeoJE5h9aPxC5Peed58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957247; c=relaxed/simple;
	bh=QG8GCVCSGoRWd11pxvIhC0J6b3M/gko+mWKgt3U5jqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qday/9XzfNYjJdN3T38+VRaQo41VGKKECL0gYY9+3OmTl+QX7rFPjcfd7hgDcsN2E+gi1jDvAtembUsnM3gbP3lanzhSBCFltanNwsPwem/2mHyYcNbaWdEzfE5lvEQLDv74ADcd9Z1HnaJvNX1rcbg17ha2LdKGGJL6ZjSLb9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVhfmanl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVhfmanl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81294C4CED1;
	Wed, 19 Feb 2025 09:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957246;
	bh=QG8GCVCSGoRWd11pxvIhC0J6b3M/gko+mWKgt3U5jqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVhfmanlZtZRLwtfl8FiRuDKs7mPTiF5bEF3XMltQX7d9F2Fkc3Qypavl9Mvmxpt7
	 upmT3DYmlSZZP4JmsK0PIS1+rzFrGi0ZwcS/YdInpnbMQOoUm7mSlkqaqMe61odAC1
	 oelK1F0ccOS74pTEuuCrIFy0E56l0T43s3qYsczM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>
Subject: [PATCH 6.1 460/578] Revert "btrfs: avoid monopolizing a core when activating a swap file"
Date: Wed, 19 Feb 2025 09:27:44 +0100
Message-ID: <20250219082711.102107447@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Koichiro Den <koichiro.den@canonical.com>

This reverts commit bb8e287f596b62fac18ed84cc03a9f1752f6b3b8.

The backport for linux-6.1.y, commit bb8e287f596b ("btrfs: avoid
monopolizing a core when activating a swap file"), inserted
cond_resched() in the wrong location.

Revert it now; a subsequent commit will re-backport the original patch.

Fixes: bb8e287f596b ("btrfs: avoid monopolizing a core when activating a swap file") # linux-6.1.y
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7387,8 +7387,6 @@ noinline int can_nocow_extent(struct ino
 			ret = -EAGAIN;
 			goto out;
 		}
-
-		cond_resched();
 	}
 
 	if (orig_start)


